local _, private = ...
if private.shouldSkip() then
    return
end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.ReadyCheck()
    local ReadyCheckListenerFrame = _G.ReadyCheckListenerFrame
    Skin.NineSlicePanelTemplate(ReadyCheckListenerFrame.NineSlice)
    ReadyCheckListenerFrame.NineSlice:SetFrameLevel(1)
    _G.ReadyCheckFrameText:SetPoint("TOP", ReadyCheckListenerFrame.NineSlice, "TOP", 0, -30)
    _G.select(2, ReadyCheckListenerFrame.NineSlice:GetRegions()):Hide()
    Skin.UIPanelButtonTemplate(_G.ReadyCheckFrameYesButton)
    _G.ReadyCheckFrameYesButton:SetPoint("TOPRIGHT", -184, -55)
    Skin.UIPanelButtonTemplate(_G.ReadyCheckFrameNoButton)
    _G.ReadyCheckFrameNoButton:SetPoint("TOPLEFT", 184, -55)
end
