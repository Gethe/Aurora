local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\PVPHelper.lua ]]
    function Hook.PVPReadyDialog_Display(self, index, displayName, isRated, queueType, gameType, role)
        Base.SetTexture(self.roleIcon.texture, "icon"..role)
    end
end

--do --[[ FrameXML\PVPHelper.xml ]]
--end

function private.AddOns.PVPHelper()

    --[[ PVPFramePopup ]]--

    --[[ PVPRoleCheckPopup ]]--

    --[[ PVPReadyDialog ]]--
    if private.isRetail then
        _G.hooksecurefunc("PVPReadyDialog_Display", Hook.PVPReadyDialog_Display)

        local PVPReadyDialog = _G.PVPReadyDialog
        Skin.DialogBorderTranslucentTemplate(PVPReadyDialog.Border)
        local bg = PVPReadyDialog.Border:GetBackdropTexture("bg")

        PVPReadyDialog.background:SetAlpha(0.75)
        PVPReadyDialog.background:ClearAllPoints()
        PVPReadyDialog.background:SetPoint("TOPLEFT", bg, 1, -1)
        PVPReadyDialog.background:SetPoint("BOTTOMRIGHT", bg, -1, 68)

        -- if not private.isPatch then
        --     PVPReadyDialog.filigree:Hide()
        -- end
        PVPReadyDialog.bottomArt:Hide()

        Skin.UIPanelHideButtonNoScripts(_G.PVPReadyDialogCloseButton)
        Skin.UIPanelButtonTemplate(PVPReadyDialog.enterButton)
        Skin.UIPanelButtonTemplate(PVPReadyDialog.leaveButton)
        -- Skin.UIPanelButtonTemplate(PVPReadyDialog.hideButton)

        PVPReadyDialog.roleIcon:SetSize(64, 64)
    end
end
