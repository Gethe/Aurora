local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

-- Track skinned state in a weak table instead of writing _auroraSkinned
-- directly onto item frames. CooldownViewer items participate in secure
-- cooldown/aura update paths — writing addon values onto the frame taints
-- the execution context and causes ADDON_ACTION_BLOCKED cascades.
local skinnedFrames = _G.setmetatable({}, { __mode = "k" })

-- Shared helper: skin a single cooldown item frame (Essential, Utility, BuffIcon, BuffBar)
local function SkinItemFrame(frame)
    if not frame or skinnedFrames[frame] then return end
    if frame.IsForbidden and frame:IsForbidden() then return end

    -- Crop the main icon texture — texture operations don't taint
    local icon = frame.Icon
    if icon then
        -- BuffBar items have a nested Icon.Icon structure
        if icon.Icon then
            Base.CropIcon(icon.Icon)
        elseif icon.SetTexCoord then
            Base.CropIcon(icon)
        end
    end

    -- Track in external weak table — NOT on the frame itself
    skinnedFrames[frame] = true
end

do --[[ AddOns\Blizzard_CooldownViewer.lua ]]
    -- Hook CooldownViewerItemMixin:OnLoad to skin each item as it initialises.
    -- This catches all item types (Essential, Utility, BuffIcon, BuffBar) since
    -- they all inherit CooldownViewerItemMixin.
    Hook.CooldownViewerItemMixin = {}
    function Hook.CooldownViewerItemMixin:OnLoad()
        SkinItemFrame(self)
    end
end

--[[ AddOns\Blizzard_CooldownViewer.xml ]]
-- Item templates are skinned dynamically via the OnLoad hook.

function private.AddOns.Blizzard_CooldownViewer()
    ------------------------------------------------
    -- Hook mixin prototypes via Util.Mixin
    ------------------------------------------------
    Util.Mixin(_G.CooldownViewerItemMixin, Hook.CooldownViewerItemMixin)

    -- NOTE: We intentionally do NOT wrap itemFramePool with
    -- Util.WrapPoolAcquire here. The CooldownViewer item frames
    -- participate in secure cooldown/aura update paths, and any
    -- addon-sourced writes on the frame (including _auroraSkinned)
    -- taint the execution context. The Util.Mixin OnLoad hook
    -- above is sufficient — it fires once per item creation and
    -- only touches textures (which don't propagate taint).

    ------------------------------------------------
    -- Skin the CooldownViewerSettings dialog (ButtonFrameTemplate).
    -- This is a standard panel, not EditMode-managed.
    ------------------------------------------------
    local settings = _G.CooldownViewerSettings
    if settings then
        Base.SetBackdrop(settings, Color.frame)

        -- Skin the Undo / Revert button
        if settings.UndoButton then
            Skin.FrameTypeButton(settings.UndoButton)
        end
    end

    ------------------------------------------------
    -- Skin the layout / import dialogs (EditMode dialog templates).
    ------------------------------------------------
    local layoutDialog = _G.CooldownViewerLayoutDialog
    if layoutDialog then
        Base.SetBackdrop(layoutDialog, Color.frame)
        if layoutDialog.AcceptButton then
            Skin.FrameTypeButton(layoutDialog.AcceptButton)
        end
        if layoutDialog.CancelButton then
            Skin.FrameTypeButton(layoutDialog.CancelButton)
        end
        local layoutCB = layoutDialog.CharacterSpecificLayoutCheckButton
        if layoutCB and layoutCB.Button then
            Skin.FrameTypeCheckButton(layoutCB.Button)
        end
    end

    local importDialog = _G.CooldownViewerImportLayoutDialog
    if importDialog then
        Base.SetBackdrop(importDialog, Color.frame)
        if importDialog.AcceptButton then
            Skin.FrameTypeButton(importDialog.AcceptButton)
        end
        if importDialog.CancelButton then
            Skin.FrameTypeButton(importDialog.CancelButton)
        end
        local importCB = importDialog.CharacterSpecificLayoutCheckButton
        if importCB and importCB.Button then
            Skin.FrameTypeCheckButton(importCB.Button)
        end
    end
end
