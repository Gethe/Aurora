local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

-- Track skinned state in a weak table instead of writing _auroraSkinned
-- directly onto item frames. CooldownViewer items participate in secure
-- cooldown/aura update paths — writing addon values onto the frame taints
-- the execution context and causes ADDON_ACTION_BLOCKED cascades.
local skinnedFrames = _G.setmetatable({}, { __mode = "k" })

-- Remove the XML-applied MaskTexture from an icon texture.
-- CDM items use <MaskTexture> (a separate region object) rather than
-- texture:SetMask(), so we must use RemoveMaskTexture to detach it.
-- Iterates in reverse so removal doesn't shift indices.
local function RemoveIconMask(iconTexture)
    if not iconTexture or not iconTexture.GetNumMaskTextures then return end
    for i = iconTexture:GetNumMaskTextures(), 1, -1 do
        local mask = iconTexture:GetMaskTexture(i)
        if mask then
            iconTexture:RemoveMaskTexture(mask)
            mask:Hide()
        end
    end
end

-- Hide the decorative atlas overlay ring present on all CDM icon items.
-- The overlay has no parentKey in the XML so we locate it by atlas name
-- by iterating the frame's own direct regions.
local CDM_OVERLAY_ATLAS = "UI-HUD-CoolDownManager-IconOverlay"
local function HideIconOverlay(frame)
    for _, region in ipairs({frame:GetRegions()}) do
        if region.GetAtlas and region:GetAtlas() == CDM_OVERLAY_ATLAS then
            region:Hide()
        end
    end
end

-- Skin a single cooldown item frame.
-- Handles all four item types:
--   Essential / Utility / BuffIcon  — frame.Icon is the icon Texture directly
--   BuffBar                         — frame.Icon is a child Frame; icon is frame.Icon.Icon
local function SkinItemFrame(frame)
    if not frame or skinnedFrames[frame] then return end
    if frame.IsForbidden and frame:IsForbidden() then return end

    -- ── Icon (all item types) ──────────────────────────────────────────────
    local iconFrame  -- the Frame or Texture referenced by parentKey="Icon"
    local iconTex    -- the actual Texture to crop

    iconFrame = frame.Icon
    if iconFrame then
        if iconFrame.Icon then
            -- BuffBar: frame.Icon is a child Frame containing frame.Icon.Icon texture
            iconTex = iconFrame.Icon
        elseif iconFrame.SetTexCoord then
            -- Essential / Utility / BuffIcon: frame.Icon is the texture itself
            iconTex = iconFrame
        end
    end

    if iconTex then
        RemoveIconMask(iconTex)
        Base.CropIcon(iconTex)
    end

    -- Hide the decorative overlay ring.
    -- For Essential/Utility/BuffIcon it lives at item-frame level.
    -- For BuffBar it lives inside the Icon child frame.
    HideIconOverlay(frame)
    if iconFrame and iconFrame ~= iconTex then
        -- iconFrame is the Icon child Frame (BuffBar path) — check its regions too
        HideIconOverlay(iconFrame)

        -- Shrink the icon to leave a small margin inside the bar (3 px each side).
        local h = frame:GetHeight()
        if h > 0 then
            iconFrame:ClearAllPoints()
            iconFrame:SetPoint("LEFT", frame, "LEFT", 0, 0)
            iconFrame:SetSize(h - 12, h - 12)
        end
    end

    -- ── BuffBar status bar ─────────────────────────────────────────────────
    -- The BuffBar item has a StatusBar (frame.Bar) with an atlas-based fill
    -- (orange, UI-HUD-CoolDownManager-Bar), an atlas background (BarBG),
    -- and a decorative pip (Pip). Replace with Aurora flat styling.
    --
    -- We avoid installing hooksecurefunc on bar instances (Skin.FrameTypeStatusBar
    -- would do this) because CDM refreshes bar state from secure cooldown/aura
    -- update paths. A one-time direct replacement at skin time is sufficient
    -- since CDM only calls SetValue to update the fill amount, not the texture.
    if frame.Bar then
        local bar = frame.Bar

        -- Add Aurora backdrop behind the fill.
        Base.SetBackdrop(bar, Color.button, Color.frame.a)

        -- Replace the atlas bar fill with Aurora's plain texture, tinted highlight.
        local barTex = bar:GetStatusBarTexture()
        if barTex then
            barTex:SetTexture(private.textures.plain)
            barTex:SetVertexColor(Color.highlight:GetRGB())
        end

        -- Suppress the atlas background (sits behind the fill at BACKGROUND layer).
        if bar.BarBG then
            bar.BarBG:SetTexture(nil)
            bar.BarBG:Hide()
        end

        -- Hide the decorative position pip at the right edge of the bar.
        if bar.Pip then
            bar.Pip:SetTexture(nil)
            bar.Pip:Hide()
        end
    end

    skinnedFrames[frame] = true
end

-- Skin all current children of a viewer frame.
-- Called at skin-function time (catches pre-existing items) and from OnShow
-- hooks (catches items materialised after the first display).
local function SkinViewerChildren(viewer)
    if not viewer then return end
    for _, child in next, {viewer:GetChildren()} do
        SkinItemFrame(child)
    end
end

-- One hook table shared across all four item mixin tables.
local itemHook = {}
function itemHook:OnLoad()
    SkinItemFrame(self)
end

function private.AddOns.Blizzard_CooldownViewer()
    -- CreateFromMixins copies methods by value, not by reference.
    -- Hooking the base CooldownViewerItemMixin alone does not reach
    -- frames mixed with the four specific leaf mixin tables, because
    -- each leaf mixin holds its own copy of OnLoad made before our
    -- hooksecurefunc ran. Hook all four explicitly.
    Util.Mixin(_G.CooldownViewerEssentialItemMixin, itemHook)
    Util.Mixin(_G.CooldownViewerUtilityItemMixin,   itemHook)
    Util.Mixin(_G.CooldownViewerBuffIconItemMixin,  itemHook)
    Util.Mixin(_G.CooldownViewerBuffBarItemMixin,   itemHook)

    -- Belt-and-suspenders: scan existing children now and hook OnShow so that
    -- items created or shown after this skin function runs are also caught.
    -- Item pools are lazy, so GetChildren() usually returns nothing at load
    -- time, but OnShow fires after PLAYER_ENTERING_WORLD when spells appear.
    local viewers = {
        _G.EssentialCooldownViewer,
        _G.UtilityCooldownViewer,
        _G.BuffIconCooldownViewer,
        _G.BuffBarCooldownViewer,
    }
    for _, viewer in ipairs(viewers) do
        if viewer then
            SkinViewerChildren(viewer)
            viewer:HookScript("OnShow", function(self)
                SkinViewerChildren(self)
            end)
        end
    end

    ------------------------------------------------
    -- Skin the CooldownViewerSettings dialog
    -- Inherits ButtonFrameTemplate — use the full template skin so the
    -- NineSlice, TopTileStreaks, Bg, and Inset are all properly handled.
    ------------------------------------------------
    local settings = _G.CooldownViewerSettings
    if settings then
        Skin.ButtonFrameTemplate(settings)
        if settings.UndoButton then
            Skin.FrameTypeButton(settings.UndoButton)
        end
    end

    ------------------------------------------------
    -- Skin the layout / import dialogs
    ------------------------------------------------
    local layoutDialog = _G.CooldownViewerLayoutDialog
    if layoutDialog then
        Base.SetBackdrop(layoutDialog, Color.frame)
        if layoutDialog.AcceptButton then Skin.FrameTypeButton(layoutDialog.AcceptButton) end
        if layoutDialog.CancelButton then Skin.FrameTypeButton(layoutDialog.CancelButton) end
        local layoutCB = layoutDialog.CharacterSpecificLayoutCheckButton
        if layoutCB and layoutCB.Button then Skin.FrameTypeCheckButton(layoutCB.Button) end
    end

    local importDialog = _G.CooldownViewerImportLayoutDialog
    if importDialog then
        Base.SetBackdrop(importDialog, Color.frame)
        if importDialog.AcceptButton then Skin.FrameTypeButton(importDialog.AcceptButton) end
        if importDialog.CancelButton then Skin.FrameTypeButton(importDialog.CancelButton) end
        local importCB = importDialog.CharacterSpecificLayoutCheckButton
        if importCB and importCB.Button then Skin.FrameTypeCheckButton(importCB.Button) end
    end
end
