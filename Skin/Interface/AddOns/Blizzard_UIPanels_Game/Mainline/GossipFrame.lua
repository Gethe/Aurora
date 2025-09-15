local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\GossipFrame.lua ]]
    Hook.GossipSharedQuestButtonMixin = {}
    function Hook.GossipSharedQuestButtonMixin:UpdateTitleForQuest(questID, titleText, isIgnored, isTrivial)
        if isIgnored then
            self:SetFormattedText(private.IGNORED_QUEST_DISPLAY, titleText)
        elseif isTrivial then
            self:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
        else
            self:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
        end
    end
end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipTitleButtonTemplate(Button)
        local highlight = Button:GetHighlightTexture()
        local r, g, b = Color.highlight:GetRGB()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
    function Skin.GossipTitleActiveQuestButtonTemplate(Button)
        Util.Mixin(Button, Hook.GossipSharedQuestButtonMixin)
        Skin.GossipTitleButtonTemplate(Button)
    end
    function Skin.GossipTitleAvailableQuestButtonTemplate(Button)
        Util.Mixin(Button, Hook.GossipSharedQuestButtonMixin)
        Skin.GossipTitleButtonTemplate(Button)
    end
    function Skin.GossipTitleOptionButtonTemplate(Button)
        Skin.GossipTitleButtonTemplate(Button)
    end
    function Skin.GossipGreetingTextTemplate(Button)
    end

    function Skin.GossipFramePanelTemplate(Frame)
        Frame:SetPoint("BOTTOMRIGHT")

        local topLeft, topRight, botLeft, botRight = Frame:GetRegions()
        topLeft:SetAlpha(0)
        topRight:SetAlpha(0)
        botLeft:SetAlpha(0)
        botRight:SetAlpha(0)
    end
end

function private.FrameXML.GossipFrame()
    -----------------
    -- GossipFrame --
    -----------------
    local GossipFrame = _G.GossipFrame
    local bg
    if private.isRetail then
        Skin.ButtonFrameTemplate(GossipFrame)
        GossipFrame.Background:Hide()
        bg = GossipFrame.NineSlice:GetBackdropTexture("bg")
    else
        Skin.FrameTypeFrame(GossipFrame)
        GossipFrame:SetBackdropOption("offsets", {
            left = 16,
            right = 30,
            top = 12,
            bottom = 5,
        })

        bg = GossipFrame:GetBackdropTexture("bg")

        if private.isWrath then
            GossipFrame.PortraitContainer.portrait:Hide()
            GossipFrame.TitleContainer.TitleText:ClearAllPoints()
            GossipFrame.TitleContainer.TitleText:SetPoint("TOPLEFT", bg)
            GossipFrame.TitleContainer.TitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

            Skin.UIPanelCloseButton(GossipFrame.CloseButton)
            GossipFrame.CloseButton:ClearAllPoints()
            GossipFrame.CloseButton:SetPoint("TOPRIGHT", bg, 8, 7)
        else
            _G.hooksecurefunc("GossipFrameOptionsUpdate", Hook.GossipFrameOptionsUpdate)
            _G.hooksecurefunc("GossipFrameAvailableQuestsUpdate", Hook.GossipFrameAvailableQuestsUpdate)
            _G.hooksecurefunc("GossipFrameActiveQuestsUpdate", Hook.GossipFrameActiveQuestsUpdate)

            _G.GossipFramePortrait:Hide()
            _G.GossipFrameNpcNameText:ClearAllPoints()
            _G.GossipFrameNpcNameText:SetPoint("TOPLEFT", bg)
            _G.GossipFrameNpcNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

            Skin.UIPanelCloseButton(_G.GossipFrameCloseButton)
            _G.GossipFrameCloseButton:ClearAllPoints()
            _G.GossipFrameCloseButton:SetPoint("TOPRIGHT", bg, 7, 6)
        end
    end

    if private.isVanilla then
        Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
        select(9, _G.GossipFrameGreetingPanel:GetRegions()):Hide() -- BotLeftPatch

        Skin.UIPanelButtonTemplate(_G.GossipFrameGreetingGoodbyeButton)
        _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)
        Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
        _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
        _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", bg, -24, 29)

        _G.GossipGreetingScrollFrameTop:Hide()
        _G.GossipGreetingScrollFrameBottom:Hide()
        _G.GossipGreetingScrollFrameMiddle:Hide()

        for i = 1, _G.NUMGOSSIPBUTTONS do
            Skin.GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
        end
    else
        local GreetingPanel = GossipFrame.GreetingPanel
        Skin.GossipFramePanelTemplate(GreetingPanel)
        if private.isWrath then
            select(9, GreetingPanel:GetRegions()):Hide() -- BotLeftPatch
        end

        Skin.UIPanelButtonTemplate(GreetingPanel.GoodbyeButton)
        GreetingPanel.GoodbyeButton:SetPoint("BOTTOMRIGHT", bg, -4, 4)
        Skin.WowScrollBoxList(GreetingPanel.ScrollBox)
        GreetingPanel.ScrollBox:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
        GreetingPanel.ScrollBox:SetPoint("BOTTOMRIGHT", bg, -23, 29)
        -- FIXLATER - PrivateMixin
        -- Util.Mixin(GreetingPanel.ScrollBox.view.poolCollection, Hook.FramePoolCollectionMixin)

        Skin.MinimalScrollBar(GreetingPanel.ScrollBar)
    end
end
