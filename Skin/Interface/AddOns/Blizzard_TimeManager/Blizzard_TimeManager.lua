local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.AddOns.Blizzard_TimeManager()
    _G.TimeManagerGlobe:Hide()
    _G.StopwatchFrameBackgroundLeft:Hide()
    _G.select(2, _G.StopwatchFrame:GetRegions()):Hide()
    _G.StopwatchTabFrameLeft:Hide()
    _G.StopwatchTabFrameMiddle:Hide()
    _G.StopwatchTabFrameRight:Hide()

    Skin.UICheckButtonTemplate(_G.TimeManagerStopwatchCheck)

    _G.TimeManagerFrame.AlarmTimeFrame.HourDropdown:SetWidth(80)
    _G.TimeManagerFrame.AlarmTimeFrame.MinuteDropdown:SetWidth(80)
    _G.TimeManagerFrame.AlarmTimeFrame.AMPMDropdown:SetWidth(90)

    Skin.ButtonFrameTemplate(_G.TimeManagerFrame)
    Skin.FrameTypeFrame(_G.StopwatchFrame)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.HourDropdown)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.MinuteDropdown)
    Skin.DropdownButton(_G.TimeManagerFrame.AlarmTimeFrame.AMPMDropdown)
    Skin.InputBoxTemplate(_G.TimeManagerAlarmMessageEditBox)
    Skin.UICheckButtonTemplate(_G.TimeManagerAlarmEnabledButton)
    Skin.UICheckButtonTemplate(_G.TimeManagerMilitaryTimeCheck)
    Skin.UICheckButtonTemplate(_G.TimeManagerLocalTimeCheck)
    Skin.UIPanelCloseButton(_G.StopwatchCloseButton) -- , "TOPRIGHT", _G.StopwatchFrame, "TOPRIGHT", -2, -2)
    -- FIXMELATER
    -- StopwatchPlayPauseButton
	-- StopwatchResetButton
end
