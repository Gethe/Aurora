local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.ReadyCheck()
    Skin.FrameTypeFrame(_G.ReadyCheckListenerFrame)
    _G.ReadyCheckPortrait:SetAlpha(0)
    _G.select(2, _G.ReadyCheckListenerFrame:GetRegions()):Hide()
    _G.ReadyCheckFrameText:SetPoint("CENTER", _G.ReadyCheckListenerFrame, "TOP", 0, -30)

    Skin.UIPanelButtonTemplate(_G.ReadyCheckFrameYesButton)
    _G.ReadyCheckFrameYesButton:SetPoint("TOPRIGHT", -184, -55)
    Skin.UIPanelButtonTemplate(_G.ReadyCheckFrameNoButton)
    _G.ReadyCheckFrameNoButton:SetPoint("TOPLEFT", 184, -55)
end
