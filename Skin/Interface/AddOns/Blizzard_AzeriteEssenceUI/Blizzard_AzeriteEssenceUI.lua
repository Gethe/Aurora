local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_AzeriteEssenceUI.lua ]]
    Hook.AzeriteEssenceListMixin = {}
    function Hook.AzeriteEssenceListMixin:Refresh()
        local essences = self:GetCachedEssences()
        local numEssences = self:GetNumViewableEssences()

        local offset = _G.HybridScrollFrame_GetOffset(self)

        for i, button in ipairs(self.buttons) do
            local index = offset + i
            if index <= numEssences then
                local essenceInfo = essences[index]
                if not essenceInfo.isHeader then
                    if essenceInfo.unlocked then
                        button:LockHighlight()
                    else
                        button:UnlockHighlight()
                    end
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_AzeriteEssenceUI.xml ]]
    function Skin.AzeriteEssenceButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Base.CropIcon(Button.Icon, Button)

        Button.Background:SetAlpha(0)
    end
end

function private.AddOns.Blizzard_AzeriteEssenceUI()
    local AzeriteEssenceUI = _G.AzeriteEssenceUI

    -- TAINT-SAFE: AzeriteEssenceUI calls protected C_AzeriteEssence.ActivateEssence()
    -- and UnlockMilestone().  Use taint-safe portrait frame skin.
    Skin.TaintSafePortraitFrameTemplate(AzeriteEssenceUI)

    AzeriteEssenceUI.PowerLevelBadgeFrame:SetPoint("TOPLEFT", 0, 0)
    AzeriteEssenceUI.PowerLevelBadgeFrame.Ring:Hide()
    AzeriteEssenceUI.PowerLevelBadgeFrame.BackgroundBlack:Hide()

    -- TAINT-SAFE: Use taint-safe inset skin instead of InsetFrameTemplate
    -- which calls NineSlicePanelTemplate (direct writes + Base.SetBackdrop).
    Skin.TaintSafeInsetFrameTemplate(AzeriteEssenceUI.LeftInset)
    Skin.TaintSafeInsetFrameTemplate(AzeriteEssenceUI.RightInset)
    AzeriteEssenceUI.RightInset.Background:Hide()

    AzeriteEssenceUI.ItemModelScene:SetPoint("TOPLEFT", AzeriteEssenceUI.LeftInset, -3, -5)
    AzeriteEssenceUI.ItemModelScene:SetPoint("BOTTOMRIGHT", AzeriteEssenceUI.LeftInset, -5, -5)

    Util.Mixin(AzeriteEssenceUI.EssenceList, Hook.AzeriteEssenceListMixin)
    Skin.HybridScrollBarTemplate(AzeriteEssenceUI.EssenceList.ScrollBar)

    local HeaderButton = AzeriteEssenceUI.EssenceList.HeaderButton
    Base.SetBackdrop(HeaderButton, Color.button)
    HeaderButton.Middle:Hide()
    HeaderButton.Left:Hide()
    HeaderButton.Right:Hide()

    AzeriteEssenceUI.OrbBackground:SetAllPoints(AzeriteEssenceUI.ItemModelScene)
    AzeriteEssenceUI.OrbRing:SetSize(483, 480)
end
