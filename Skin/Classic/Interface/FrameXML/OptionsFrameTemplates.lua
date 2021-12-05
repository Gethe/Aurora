local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

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
        if private.hasAPI then
            Skin.TooltipBorderBackdropTemplate(Frame)
        else
            local name = Frame:GetName()
            Base.SetBackdrop(Frame, Color.frame)
            Skin.UIPanelScrollBarTemplate(_G[name.."ListScrollBar"])
        end
    end
    function Skin.OptionsListButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button.toggle)
    end
    function Skin.OptionsFrameTemplate(Frame)
        local name = Frame:GetName()

        Skin.DialogBorderTemplate(Frame)

        local header, text = Frame:GetRegions()
        header:Hide()
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT")
        text:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.OptionsFrameListTemplate(_G[name.."CategoryFrame"])
        Skin.TooltipBorderBackdropTemplate(_G[name.."PanelContainer"])
    end
end

--function private.FrameXML.OptionsFrameTemplates()
--end
