local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_PlayerChoice.lua ]]
    do -- Blizzard_PlayerChoice
        Hook.PlayerChoiceFrameMixin = {}
        function Hook.PlayerChoiceFrameMixin:SetupFrame()
            self.NineSlice:SetFrameLevel(1)
            self.BlackBackground:Hide()
            self.Background:Hide()

            self.Title.Left:Hide()
            self.Title.Right:Hide()
            self.Title.Middle:Hide()
        end
    end
    --do -- Blizzard_PlayerChoiceToggleButton
    --end
    do -- Blizzard_PlayerChoiceOptionBase
        Hook.PlayerChoiceBaseOptionTemplateMixin = {}
        function Hook.PlayerChoiceBaseOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption)
            local kit = Util.GetTextureKit(frameTextureKit)
            self.OptionText:SetTextColor(kit.text:GetRGBA())
        end
    end
    do -- Blizzard_PlayerChoiceNormalOptionTemplate
        Hook.PlayerChoiceNormalOptionTemplateMixin = {}
        function Hook.PlayerChoiceNormalOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption)
            local kit = Util.GetTextureKit(frameTextureKit)
            self.Background:SetAlpha(0)
            self.ArtworkBorder:SetAlpha(0)

            self.Header.Ribbon:SetAlpha(0)
            self.Header.Contents.Text:SetTextColor(kit.title:GetRGBA())

            --self.SubHeader.BG:SetAlpha(0)
            self.SubHeader.Text:SetTextColor(kit.title:GetRGBA())
        end
    end
    --do -- Blizzard_PlayerChoicePowerChoiceTemplate
    --end
    --do -- Blizzard_PlayerChoiceTorghastOptionTemplate
    --end
    do -- Blizzard_PlayerChoiceCovenantChoiceOptionTemplate
        Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin = {}
        function Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption)
            self.BackgroundShadowSmall:SetAlpha(0)
            self.BackgroundShadowLarge:SetAlpha(0)
        end
    end
    --do -- Blizzard_PlayerChoiceCypherOptionTemplate
    --end
    --do -- Blizzard_PlayerChoiceTimer
    --end
end

do --[[ AddOns\Blizzard_PlayerChoice.xml ]]
    --do -- Blizzard_PlayerChoiceToggleButton
    --end
    do -- Blizzard_PlayerChoiceOptionBase
        function Skin.PlayerChoiceBaseOptionButtonTemplate(Button)
            Skin.UIPanelButtonTemplate(Button)
        end
        function Skin.PlayerChoiceSmallerOptionButtonTemplate(Button)
            Skin.PlayerChoiceBaseOptionButtonTemplate(Button)
        end
        function Skin.PlayerChoiceBaseOptionTemplate(Frame)
            Util.Mixin(Frame, Hook.PlayerChoiceBaseOptionTemplateMixin)
        end
    end
    do -- Blizzard_PlayerChoiceNormalOptionTemplate
        function Skin.PlayerChoiceNormalOptionTemplate(Frame)
            Skin.PlayerChoiceBaseOptionTemplate(Frame)
            Util.Mixin(Frame, Hook.PlayerChoiceNormalOptionTemplateMixin)
        end
    end
    --do -- Blizzard_PlayerChoicePowerChoiceTemplate
    --end
    --do -- Blizzard_PlayerChoiceTorghastOptionTemplate
    --end
    do -- Blizzard_PlayerChoiceCovenantChoiceOptionTemplate
        function Skin.PlayerChoiceCovenantChoiceOptionTemplate(Frame)
            Skin.PlayerChoiceBaseOptionTemplate(Frame)
            Util.Mixin(Frame, Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin)
        end
    end
    --do -- Blizzard_PlayerChoiceCypherOptionTemplate
    --end
    --do -- Blizzard_PlayerChoiceTimer
    --end
end

function private.AddOns.Blizzard_PlayerChoice()
    ----====####$$$$%%%%%$$$$####====----
    --      Blizzard_PlayerChoice      --
    ----====####$$$$%%%%%$$$$####====----
    -- FIXLATER
    _G.print("Blizzard_PlayerChoice is not fully implemented yet, some features may not work as expected. Report this location to the RealUI Discord server.")
    -- local PlayerChoiceFrame = _G.PlayerChoiceFrame
    -- Util.Mixin(PlayerChoiceFrame, Hook.PlayerChoiceFrameMixin)
    -- Skin.NineSlicePanelTemplate(PlayerChoiceFrame.NineSlice)
    -- PlayerChoiceFrame.BlackBackground:SetAllPoints(PlayerChoiceFrame.NineSlice)
    -- -- Skin.UIPanelCloseButton(PlayerChoiceFrame.CloseButton)


    ----====####$$$$%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceToggleButton --
    ----====####$$$$%%%%%%%$$$$####====----


    ----====####$$$$%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceOptionBase --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.PlayerChoiceBaseOptionTemplateMixin, Hook.PlayerChoiceBaseOptionTemplateMixin)


    ----====####$$$$%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceNormalOptionTemplate --
    ----====####$$$$%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoicePowerChoiceTemplate --
    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceTorghastOptionTemplate --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceCovenantChoiceOptionTemplate --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_PlayerChoiceCypherOptionTemplate --
    ----====####$$$$%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%$$$$####====----
    --   Blizzard_PlayerChoiceTimer   --
    ----====####$$$$%%%%$$$$####====----
end
