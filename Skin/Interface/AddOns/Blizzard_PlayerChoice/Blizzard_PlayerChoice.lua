local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals ipairs next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_PlayerChoice.lua ]]
    do -- Blizzard_PlayerChoice
        Hook.PlayerChoiceFrameMixin = {}
        function Hook.PlayerChoiceFrameMixin:SetupFrame()
            -- Blizzard re-textures the NineSlice each time SetupFrame runs via
            -- ApplyUniqueCornersLayout / ApplyIdenticalCornersLayout, which the
            -- Aurora NineSlice hook (BasicFrame) intercepts but only sets a
            -- backdrop — it does NOT blank the individual piece textures.
            -- Blank them explicitly here so no kit artwork bleeds through.
            local nineSlicePieces = {
                "TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner",
                "TopEdge", "BottomEdge", "LeftEdge", "RightEdge", "Center",
            }
            for _, pieceName in next, nineSlicePieces do
                local piece = self.NineSlice[pieceName]
                if piece then piece:SetTexture("") end
            end
            self.NineSlice:Show()
            self.NineSlice:SetFrameLevel(1)
            -- Hide the new single-atlas overlay introduced for kits without useOldNineSlice
            if self.BorderOverlay then
                self.BorderOverlay:SetAlpha(0)
            end
            if self.BlackBackground then
                self.BlackBackground:SetAlpha(0)
            end
            -- Blizzard re-shows Background and re-textures BackgroundTile each call;
            -- hide it and let Aurora's FrameTypeFrame backdrop show through instead.
            self.Background:Hide()
            if self.Header then
                self.Header.Texture:SetAlpha(0)
            end
            Skin.UIPanelCloseButton(self.CloseButton)
            if self.Title then
                if self.Title.Left then self.Title.Left:Hide() end
                if self.Title.Right then self.Title.Right:Hide() end
                if self.Title.Middle then self.Title.Middle:Hide() end
            end
        end

        function Hook.PlayerChoiceFrameMixin:SetupOptions()
            -- Skin the toggle buttons in the frame-level OptionButtonsContainer
            if self.OptionButtonsContainer then
                for _, toggleFrame in next, {self.OptionButtonsContainer:GetChildren()} do
                    if toggleFrame.Button and not toggleFrame.Button.__auroraStyled then
                        Skin.UIPanelButtonTemplate(toggleFrame.Button)
                        toggleFrame.Button.__auroraStyled = true
                    end
                end
            end

            -- Skin each pooled option frame; frames are created lazily so we
            -- must do this here rather than at addon load time.
            -- Map template name → the Hook mixin that holds the Setup logic,
            -- so we can invoke it immediately (Setup already ran before this hook fires).
            local templateHooks = {
                PlayerChoiceNormalOptionTemplate = Hook.PlayerChoiceNormalOptionTemplateMixin,
                PlayerChoiceCovenantChoiceOptionTemplate = Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin,
            }
            if self.optionPools and self.optionFrameTemplate then
                local hookMixin = templateHooks[self.optionFrameTemplate]
                for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
                    if not optionFrame.__auroraStyled then
                        local skinFunc = Skin[self.optionFrameTemplate]
                        if skinFunc then
                            -- Hook future Setup calls on this frame
                            skinFunc(optionFrame)
                        end
                        -- Apply the visual changes for the current display pass;
                        -- Setup already ran before our SetupOptions hook fired.
                        if hookMixin and hookMixin.Setup then
                            hookMixin.Setup(optionFrame, optionFrame.optionInfo,
                                optionFrame.frameTextureKit, optionFrame.soloOption, optionFrame.showAsList)
                        end
                        optionFrame.__auroraStyled = true
                    end
                end
            end
        end
    end
    --do -- Blizzard_PlayerChoiceToggleButton
    --end
    do -- Blizzard_PlayerChoiceOptionBase
        Hook.PlayerChoiceBaseOptionTemplateMixin = {}
        function Hook.PlayerChoiceBaseOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption, showAsList)
            -- OptionText is a PlayerChoiceBaseOptionTextTemplateMixin frame with its own
            -- SetTextColor that dispatches correctly for HTML vs plain-text mode.
            -- Note: for PlayerChoiceNormalOptionTemplate, Blizzard re-sets the color AFTER
            -- this base Setup returns, so the Normal hook overrides it again there.
            if self.OptionText then
                self.OptionText:SetTextColor(Color.white:GetRGBA())
            end
        end
    end
    do -- Blizzard_PlayerChoiceNormalOptionTemplate
        Hook.PlayerChoiceNormalOptionTemplateMixin = {}
        function Hook.PlayerChoiceNormalOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption, showAsList)
            local kit = Util.GetTextureKit(frameTextureKit)
            self.Background:SetAlpha(0)
            self.ArtworkBorder:SetAlpha(0)

            self.Header.Ribbon:SetAlpha(0)
            self.Header.Contents.Text:SetTextColor(kit.title:GetRGBA())

            --self.SubHeader.BG:SetAlpha(0)
            self.SubHeader.Text:SetTextColor(kit.title:GetRGBA())

            -- Blizzard overwrites OptionText color in this same Setup call (after base runs);
            -- override it here, after Blizzard has set it, using the mixin's own SetTextColor
            -- which correctly handles the HTML vs plain-text switch.
            if self.OptionText then
                self.OptionText:SetTextColor(Color.white:GetRGBA())
            end

            -- Skin the choice confirm buttons created by the option button pool
            if self.OptionButtonsContainer and self.OptionButtonsContainer.buttonFramePool then
                for buttonFrame in self.OptionButtonsContainer.buttonFramePool:EnumerateActive() do
                    if buttonFrame.Button and not buttonFrame.Button.__auroraStyled then
                        Skin.UIPanelButtonTemplate(buttonFrame.Button)
                        buttonFrame.Button.__auroraStyled = true
                    end
                end
            end
        end
    end
    --do -- Blizzard_PlayerChoicePowerChoiceTemplate
    --end
    --do -- Blizzard_PlayerChoiceTorghastOptionTemplate
    --end
    do -- Blizzard_PlayerChoiceCovenantChoiceOptionTemplate
        Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin = {}
        function Hook.PlayerChoiceCovenantChoiceOptionTemplateMixin:Setup(optionInfo, frameTextureKit, soloOption, showAsList)
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
        function Skin.PlayerChoiceBaseSmallerOptionButtonTemplate(Button)
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
    local PlayerChoiceFrame = _G.PlayerChoiceFrame
    Util.Mixin(PlayerChoiceFrame, Hook.PlayerChoiceFrameMixin)
    Skin.FrameTypeFrame(PlayerChoiceFrame)
    Skin.NineSlicePanelTemplate(PlayerChoiceFrame.NineSlice)
    Skin.UIPanelCloseButton(PlayerChoiceFrame.CloseButton)

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
