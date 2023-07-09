local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Color = Aurora.Color

do --[[ SharedXML\DeprecatedTemplates.lua ]]
    function Skin.OptionsBaseCheckButtonTemplate(CheckButton)
        Skin.UICheckButtonTemplate(CheckButton) -- BlizzWTF: Doesn't use the template
    end

    function Skin.InterfaceOptionsCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
        CheckButton.Text:SetPoint(CheckButton.Text:GetPoint())
    end
    function Skin.InterfaceOptionsBaseCheckButtonTemplate(CheckButton)
        Skin.OptionsBaseCheckButtonTemplate(CheckButton)
    end

    function Skin.OptionsSliderTemplate(Slider)
        Skin.HorizontalSliderTemplate(Slider)

        --[[
            Blizz resets the backdrop for these in BlizzardOptionsPanel_OnEvent, so
            we set these vars to ensure our skin remains.
        ]]
        Slider.backdropColor = Color.frame
        Slider.backdropColorAlpha = Color.frame.a
        Slider.backdropBorderColor = Color.button
    end

    function Skin.OptionsFrameTabButtonTemplate(Button)
        local name = Button:GetName()
        Button:ClearHighlightTexture()

        _G[name.."LeftDisabled"]:SetAlpha(0)
        _G[name.."MiddleDisabled"]:SetAlpha(0)
        _G[name.."RightDisabled"]:SetAlpha(0)
        _G[name.."Left"]:SetAlpha(0)
        _G[name.."Middle"]:SetAlpha(0)
        _G[name.."Right"]:SetAlpha(0)
    end

    function Skin.OptionsListButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button.toggle)
    end

    -- This is technically in SharedXML/SecureScrollTemplates, but those are deprecated too so *shrug*
    function Skin.UIPanelScrollBarTemplate(Slider)
        Slider.ScrollUpButton.direction = _G.ScrollControllerMixin.Directions.Decrease
        Slider.ScrollDownButton.direction = _G.ScrollControllerMixin.Directions.Increase
        Skin.FrameTypeScrollBar(Slider, true)
    end
end

--do --[[ SharedXML\DeprecatedTemplates.xml ]]
--end

function private.SharedXML.DeprecatedTemplates()
    ----====####$$$$%%%%$$$$####====----
    --              DeprecatedTemplates              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
