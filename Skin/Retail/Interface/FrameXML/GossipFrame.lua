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
        Util.Mixin(Button, Hook.GossipSharedQuestButtonMixin)

        local highlight = Button:GetHighlightTexture()
        local r, g, b = Color.highlight:GetRGB()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
    function Skin.GossipTitleActiveQuestButtonTemplate(Button)
        Skin.GossipTitleButtonTemplate(Button)
    end
    function Skin.GossipTitleAvailableQuestButtonTemplate(Button)
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
    Skin.ButtonFrameTemplate(GossipFrame)
    GossipFrame.Background:Hide()
    local bg = GossipFrame.NineSlice:GetBackdropTexture("bg")

    local GreetingPanel = GossipFrame.GreetingPanel
    Skin.GossipFramePanelTemplate(GreetingPanel)

    Skin.UIPanelButtonTemplate(GreetingPanel.GoodbyeButton)
    Skin.WowScrollBoxList(GreetingPanel.ScrollBox)
    GreetingPanel.ScrollBox:SetPoint("TOPLEFT", bg, 4, -(private.FRAME_TITLE_HEIGHT + 5))
    GreetingPanel.ScrollBox:SetPoint("BOTTOMRIGHT", bg, -23, 30)
    Util.Mixin(GreetingPanel.ScrollBox.view.poolCollection, Hook.FramePoolCollectionMixin)

    Skin.WowTrimScrollBar(GreetingPanel.ScrollBar)
end
