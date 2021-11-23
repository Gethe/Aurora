local _, private = ...
if not private.isRetail then return end

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

function private.FrameXML.PVPHelper()
    _G.hooksecurefunc("PVPReadyDialog_Display", Hook.PVPReadyDialog_Display)

    --[[ PVPFramePopup ]]--

    --[[ PVPRoleCheckPopup ]]--

    --[[ PVPReadyDialog ]]--
    local PVPReadyDialog = _G.PVPReadyDialog
    Skin.DialogBorderTemplate(PVPReadyDialog.Border)
    local bg = PVPReadyDialog.Border:GetBackdropTexture("bg")

    PVPReadyDialog.background:SetAlpha(0.75)
    PVPReadyDialog.background:ClearAllPoints()
    PVPReadyDialog.background:SetPoint("TOPLEFT", bg, 1, -1)
    PVPReadyDialog.background:SetPoint("BOTTOMRIGHT", bg, -1, 68)

    PVPReadyDialog.filigree:Hide()
    PVPReadyDialog.bottomArt:Hide()

    Skin.MinimizeButton(_G.PVPReadyDialogCloseButton)
    Skin.UIPanelButtonTemplate(PVPReadyDialog.enterButton)
    Skin.UIPanelButtonTemplate(PVPReadyDialog.leaveButton)

    PVPReadyDialog.roleIcon:SetSize(64, 64)
end
