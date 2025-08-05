local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\PvpPopup.lua ]]
    local ROLE_BUTTON_BASE_XOFFSET = 15
    local ROLE_BUTTON_WIDTH = 55
    local centerOffset

    Hook.PVPReadyPopupMixin = {}
    function Hook.PVPReadyPopupMixin:GetCenterOffsetBasedOffNumRoles(roles)
        local countRoles = 0
        for _, roleInfo in ipairs(roles) do
            if(roleInfo.totalRole > 0) then
                countRoles = countRoles + 1
            end
        end

        local totalWidth = self:GetWidth()
        local widthOfRoles = ROLE_BUTTON_WIDTH * countRoles
        local usedRoleWidth = (ROLE_BUTTON_BASE_XOFFSET * (countRoles - 1)) + widthOfRoles --The total used space of the roles buttons (Including paddng in between)
        centerOffset = (totalWidth - usedRoleWidth) / (2) --Trying to get the offset for just one side.
    end

    Hook.PvpRoleButtonWithCountMixin = {}
    function Hook.PvpRoleButtonWithCountMixin:Setup(roleInfo)
        Base.SetTexture(self.Texture, "icon"..roleInfo.role)

        if not _G.PVPReadyPopup.lastRole then
            self:SetPoint("LEFT", centerOffset, 40)
        else
            self:SetPoint("LEFT", _G.PVPReadyPopup.lastRole, "RIGHT", ROLE_BUTTON_BASE_XOFFSET, 0)
        end
    end
end

do --[[ FrameXML\PvpPopup.xml ]]
    function Skin.PvpRoleStatusTemplate(Frame)
        Frame.StatusIcon:SetPoint("BOTTOMLEFT", -5, -5)
    end
    function Skin.PvpRoleButtonWithCountTemplate(Frame)
        Skin.PvpRoleStatusTemplate(Frame)
        Frame.Count:SetPoint("TOP", Frame, "BOTTOM", 0, -6)
    end
end

function private.AddOns.PvpPopup()
    ----====####$$$$%%%%$$$$####====----
    --              PvpPopup              --
    ----====####$$$$%%%%$$$$####====----
    Util.Mixin(_G.PvpRoleButtonWithCountMixin, Hook.PvpRoleButtonWithCountMixin)

    local PVPReadyPopup = _G.PVPReadyPopup
    Util.Mixin(PVPReadyPopup, Hook.PVPReadyPopupMixin)
    Util.Mixin(PVPReadyPopup.RolePool, Hook.ObjectPoolMixin)

    local ReadyStatus = _G.ReadyStatus
    Skin.DialogBorderTemplate(ReadyStatus.Border)
    Skin.MinimizeButton(ReadyStatus.CloseButton)

    -------------
    -- Section --
    -------------
end
