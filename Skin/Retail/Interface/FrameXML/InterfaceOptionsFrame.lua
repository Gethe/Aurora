local _, private = ...
if private.shouldSkip() then return end
if private.isPatch then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\InterfaceOptionsFrame.lua ]]
--end

--do --[[ FrameXML\InterfaceOptionsFrame.xml ]]
--end

function private.FrameXML.InterfaceOptionsFrame()
    local InterfaceOptionsFrame = _G.InterfaceOptionsFrame
    Skin.DialogBorderTemplate(InterfaceOptionsFrame.Border)
    Skin.DialogHeaderTemplate(InterfaceOptionsFrame.Header)

    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameCancel)
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameOkay)
    Util.PositionRelative("BOTTOMRIGHT", InterfaceOptionsFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.InterfaceOptionsFrameCancel,
        _G.InterfaceOptionsFrameOkay,
    })
    Skin.UIPanelButtonTemplate(_G.InterfaceOptionsFrameDefaults)
    _G.InterfaceOptionsFrameDefaults:SetPoint("BOTTOMLEFT", 15, 15)

    Skin.OptionsFrameListTemplate(_G.InterfaceOptionsFrameCategories)
    Skin.OptionsFrameListTemplate(_G.InterfaceOptionsFrameAddOns)
    Skin.TooltipBorderBackdropTemplate(_G.InterfaceOptionsFramePanelContainer)

    Skin.OptionsFrameTabButtonTemplate(_G.InterfaceOptionsFrameTab1)
    Skin.OptionsFrameTabButtonTemplate(_G.InterfaceOptionsFrameTab2)
end
