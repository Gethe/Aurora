local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_CompactRaidFrames.lua ]]
    do --[[ Blizzard_CompactRaidFrameManager ]]
        function Hook.CompactRaidFrameManager_Toggle(self)
            if self.collapsed then
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowRight")
            else
                Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowLeft")
            end
         end
    end
end

do --[[ AddOns\Blizzard_CompactRaidFrames.xml ]]
    function Skin.CRFManagerFilterButtonTemplate(Button)
        Skin.UIMenuButtonStretchTemplate(Button)
        local bg = Button:GetBackdropTexture("bg")
        Button.selectedHighlight:SetColorTexture(1, 1, 0, 0.3)
        Button.selectedHighlight:SetPoint("TOPLEFT", bg, 1, -1)
        Button.selectedHighlight:SetPoint("BOTTOMRIGHT", bg, -1, 1)
    end
    Skin.CRFManagerFilterRoleButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    Skin.CRFManagerFilterGroupButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    function Skin.CRFManagerRaidIconButtonTemplate(Button)
        Button:SetSize(24, 24)
        Button:SetPoint(Button:GetPoint())

        Button:GetNormalTexture():SetSize(24, 24)
    end
end

do --[[ AddOns\Blizzard_CompactRaidFrames.lua ]]
    Hook.CRFManagerFilterRoleButtonMixin = {}
    -- function Hook.CRFManagerFilterRoleButtonMixin:Init()
    --     _G.print("CRFManagerFilterRoleButtonMixin:Init - ", self:GetName())
    -- end
    function Hook.CRFManagerFilterRoleButtonMixin:OnEnter()
       -- _G.print("CRFManagerFilterRoleButtonMixin:OnEnter - ", self:GetName())

        -- if not button._auroraSkinned then
        --     button._auroraSkinned = true
        -- end
    end
    Hook.CRFManagerRaidIconButtonMixin = {}
    -- function Hook.CRFManagerRaidIconButtonMixin:Init()
    --     _G.print("CRFManagerRaidIconButtonMixin:Init - ", self:GetName())
    -- end
end

function private.AddOns.Blizzard_CompactRaidFrames()
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameReservationManager --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameContainer --
    ----====####$$$$%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameManager --
    ----====####$$$$%%%%%%$$$$####====----
    -- FIXLATER - disable for now
    -- if private.isRetail then return end
    _G.hooksecurefunc("CompactRaidFrameManager_Toggle", Hook.CompactRaidFrameManager_Toggle)

    local CompactRaidFrameManager = _G.CompactRaidFrameManager
    CompactRaidFrameManager:DisableDrawLayer("ARTWORK")
    Skin.FrameTypeFrame(CompactRaidFrameManager)

    local toggleButtonForward = CompactRaidFrameManager.toggleButtonForward
    toggleButtonForward:SetPoint("RIGHT", -1, 0)
    toggleButtonForward:SetScript("OnMouseDown", private.nop)
    toggleButtonForward:SetScript("OnMouseUp", private.nop)

    local arrowForward = toggleButtonForward:GetNormalTexture()
    arrowForward:ClearAllPoints()
    arrowForward:SetPoint("TOPLEFT", 3, -5)
    arrowForward:SetPoint("BOTTOMRIGHT", -3, 5)
    Base.SetTexture(arrowForward, "arrowRight")


    local toggleButtonBack = CompactRaidFrameManager.toggleButtonBack
    toggleButtonBack:SetPoint("RIGHT", -1, 0)
    toggleButtonBack:SetScript("OnMouseDown", private.nop)
    toggleButtonBack:SetScript("OnMouseUp", private.nop)

    local arrowBack = toggleButtonBack:GetNormalTexture()
    arrowBack:ClearAllPoints()
    arrowBack:SetPoint("TOPLEFT", 3, -5)
    arrowBack:SetPoint("BOTTOMRIGHT", -3, 5)
    Base.SetTexture(arrowBack, "arrowLeft")

    local displayFrame = CompactRaidFrameManager.displayFrame
    local displayFrameName = displayFrame:GetName()
    displayFrame:GetRegions():Hide()
    local optionsButton = _G[displayFrameName.."OptionsButton"]
    -- CompactRaidFrameManagerDisplayFrameOptionsButton
    Skin.UIPanelInfoButton(optionsButton)

    -- FIXLATER     
    Util.Mixin(_G.CRFManagerFilterRoleButtonMixin, Hook.CRFManagerFilterRoleButtonMixin)
    Util.Mixin(_G.CRFManagerRaidIconButtonMixin, Hook.CRFManagerRaidIconButtonMixin)
    -- CRFManagerRoleMarkerCheckMixin
    -- CRFManagerFilterGroupButtonMixin
    -- FIXLATER - disable for now
    -- local filterOptions = displayFrame.filterOptions
    -- Skin.CRFManagerFilterRoleButtonTemplate(filterOptions["filterRoleTank"])
    -- Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleHealer)
    -- Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleDamager)
    -- for i = 1, 8 do
    --     Skin.CRFManagerFilterRoleButtonTemplate(filterOptions["filterGroup"..i])
    -- end

    -- Skin.UIMenuButtonStretchTemplate(displayFrame.editMode)
    -- Skin.UIMenuButtonStretchTemplate(displayFrame.hiddenModeToggle) -> RaidFrameHiddenModeToggleMixin = CreateFromMixins(CRFManagerTooltipButtonMixin);
    -- Skin.UIMenuButtonStretchTemplate(displayFrame.convertToRaid)

    -- local icons = {displayFrame.raidMarkers:GetChildren()}
    -- for i, icon in next, icons do
    --     Skin.CRFManagerRaidIconButtonTemplate(icon)
    -- end

    -- local leaderOptions = displayFrame.leaderOptions
    -- Skin.UIMenuButtonStretchTemplate(leaderOptions.rolePollButton) -> displayFrame.rolePollButton:Enable();
    -- Skin.UIMenuButtonStretchTemplate(leaderOptions.readyCheckButton) -> displayFrame.readyCheckButton
    -- Skin.UIMenuButtonStretchTemplate(_G[leaderOptions:GetName().."RaidWorldMarkerButton"]) -- removewd
    -- Skin.UICheckButtonTemplate(displayFrame.everyoneIsAssistButton) -> <CheckButton name="$parentEveryoneIsAssistButton" parentKey="everyoneIsAssistButton" hidden="true" mixin="RaidFrameEveryoneIsAssistMixin">
end
