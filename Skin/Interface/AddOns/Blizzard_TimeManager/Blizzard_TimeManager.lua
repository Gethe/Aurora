local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

-- FIXME -- move to others..
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_TimeManager()
    _G.TimeManagerGlobe:Hide()
    _G.StopwatchFrameBackgroundLeft:Hide()
    _G.select(2, _G.StopwatchFrame:GetRegions()):Hide()
    _G.StopwatchTabFrameLeft:Hide()
    _G.StopwatchTabFrameMiddle:Hide()
    _G.StopwatchTabFrameRight:Hide()

    _G.TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
    _G.TimeManagerStopwatchCheck:SetCheckedTexture(C.media.checked)
    F.CreateBG(_G.TimeManagerStopwatchCheck)

    _G.TimeManagerFrame.AlarmTimeFrame.HourDropdown:SetWidth(80)
    _G.TimeManagerFrame.AlarmTimeFrame.MinuteDropdown:SetWidth(80)
    _G.TimeManagerFrame.AlarmTimeFrame.AMPMDropdown:SetWidth(90)

    F.ReskinPortraitFrame(_G.TimeManagerFrame, true)
    F.CreateBD(_G.StopwatchFrame)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.HourDropdown)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.MinuteDropdown)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.AMPMDropdown)
    Skin.InputBoxTemplate(_G.TimeManagerAlarmMessageEditBox)
    Skin.UICheckButtonTemplate(_G.TimeManagerAlarmEnabledButton)
    Skin.UICheckButtonTemplate(_G.TimeManagerMilitaryTimeCheck)
    Skin.UICheckButtonTemplate(_G.TimeManagerLocalTimeCheck)
    Skin.UIPanelCloseButton(_G.StopwatchCloseButton) -- , "TOPRIGHT", _G.StopwatchFrame, "TOPRIGHT", -2, -2)
    -- FIXMELATER
end
