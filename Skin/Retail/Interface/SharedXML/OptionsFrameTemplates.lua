local _, private = ...
if private.shouldSkip() then return end
if private.isPatch then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\OptionsFrameTemplates.lua ]]
--end

do --[[ FrameXML\OptionsFrameTemplates.xml ]]
    function Skin.OptionsFrameListTemplate(Frame)
        local name = Frame:GetName()
        Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.UIPanelScrollBarTemplate(_G[name.."ListScrollBar"])
    end
    function Skin.OptionsFrameTemplate(Frame)
        local name = Frame:GetName()
        Skin.DialogBorderTemplate(Frame.Border)
        Skin.DialogHeaderTemplate(Frame.Header)

        Skin.OptionsFrameListTemplate(_G[name.."CategoryFrame"])
        Skin.TooltipBorderBackdropTemplate(_G[name.."PanelContainer"])
    end
end

--function private.FrameXML.OptionsFrameTemplates()
--end
