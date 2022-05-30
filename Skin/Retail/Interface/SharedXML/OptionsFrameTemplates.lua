local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\OptionsFrameTemplates.lua ]]
--end

do --[[ FrameXML\OptionsFrameTemplates.xml ]]
    function Skin.OptionsFrameTabButtonTemplate(Button)
        local name = Button:GetName()
        Button:SetHighlightTexture("")

        _G[name.."LeftDisabled"]:SetAlpha(0)
        _G[name.."MiddleDisabled"]:SetAlpha(0)
        _G[name.."RightDisabled"]:SetAlpha(0)
        _G[name.."Left"]:SetAlpha(0)
        _G[name.."Middle"]:SetAlpha(0)
        _G[name.."Right"]:SetAlpha(0)
    end
    function Skin.OptionsFrameListTemplate(Frame)
        local name = Frame:GetName()
        Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.UIPanelScrollBarTemplate(_G[name.."ListScrollBar"])
    end
    function Skin.OptionsListButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button.toggle)
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
