local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\QuestLogFrame.lua ]]
    function Hook.QuestLog_Update(Button)
        local numEntries = _G.GetNumQuestLogEntries()
        local questIndex, questLogTitle, isHeader, _

        for i = 1, _G.QUESTS_DISPLAYED do
        end
    end
    function Hook.QuestLog_UpdateQuestDetails(doNotScroll)
    end
end

do --[[ FrameXML\QuestLogFrame.xml ]]
    function Skin.QuestLogTitleButtonTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 284,
            top = 0,
            bottom = 3,
        })
    end
    function Skin.QuestLogRewardItemTemplate(Button)
        Skin.QuestItemTemplate(Button)
    end
end

function private.FrameXML.QuestLogFrame()
    _G.hooksecurefunc("QuestLog_Update", Hook.QuestLog_Update)
    _G.hooksecurefunc("QuestLog_UpdateQuestDetails", Hook.QuestLog_UpdateQuestDetails)

    --------------------------
    -- QuestLogControlPanel --
    --------------------------
    Skin.UIPanelButtonTemplate(_G.QuestLogFrameAbandonButton)
    --_G.QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", bg, 5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestLogFrameTrackButton)
    --_G.QuestFrameExitButton:SetPoint("BOTTOMRIGHT", bg, -5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestFramePushQuestButton)
    --_G.QuestFramePushQuestButton:SetPoint("LEFT", _G.QuestLogFrameAbandonButton, "RIGHT", 1, 0)
    --_G.QuestFramePushQuestButton:SetPoint("RIGHT", _G.QuestFrameExitButton, "LEFT", -1, 0)


    -------------------------
    -- QuestLogDetailFrame --
    -------------------------
    local QuestLogDetailFrame = _G.QuestLogDetailFrame
    Skin.FrameTypeFrame(QuestLogDetailFrame)
    QuestLogDetailFrame:SetBackdropOption("offsets", {
        left = 12,
        right = 1,
        top = 13,
        bottom = 4,
    })

    local portrait, topLeft, topRight, bottomLeft, bottomRight, topLeftBG, topRightBG, bottomLeftBG, bottomRightBG = QuestLogDetailFrame:GetRegions()
    portrait:Hide()
    topLeft:Hide()
    topRight:Hide()
    bottomLeft:Hide()
    bottomRight:Hide()
    topLeftBG:Hide()
    topRightBG:Hide()
    bottomLeftBG:Hide()
    bottomRightBG:Hide()

    local bg = QuestLogDetailFrame:GetBackdropTexture("bg")
    _G.QuestLogDetailTitle:ClearAllPoints()
    _G.QuestLogDetailTitle:SetPoint("TOPLEFT", bg)
    _G.QuestLogDetailTitle:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.QuestLogDetailFrameCloseButton)
    Skin.UIPanelScrollFrameTemplate(_G.QuestLogDetailScrollFrame)
    _G.QuestLogDetailScrollFrame:SetPoint("TOPLEFT", bg, 5, -(private.FRAME_TITLE_HEIGHT + 5))
    _G.QuestLogDetailScrollFrame:SetPoint("BOTTOMRIGHT", bg, -25, 30)
    _G.QuestLogDetailScrollFrameScrollBackgroundTopLeft:Hide()
    _G.QuestLogDetailScrollFrameScrollBackgroundBottomRight:Hide()

    -------------------
    -- QuestLogFrame --
    -------------------
    local QuestLogFrame = _G.QuestLogFrame
    Skin.FrameTypeFrame(QuestLogFrame)
    QuestLogFrame:SetBackdropOption("offsets", {
        left = 12,
        right = 3,
        top = 12,
        bottom = 11,
    })

    local portrait, paneLeft, paneRight = QuestLogFrame:GetRegions()
    portrait:Hide()
    paneLeft:Hide()
    paneRight:Hide()

    local bg = QuestLogFrame:GetBackdropTexture("bg")
    _G.QuestLogTitleText:ClearAllPoints()
    _G.QuestLogTitleText:SetPoint("TOPLEFT", bg)
    _G.QuestLogTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.QuestLogFrameCloseButton)
    Skin.UIPanelButtonTemplate(_G.QuestLogFrameCancelButton)

    TopLeft, TopRight, BotLeft, BotRight = _G.EmptyQuestLogFrame:GetRegions()
    portrait:Hide()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()

    _G.QuestLogCountTopRight:Hide()
    _G.QuestLogCountBottomRight:Hide()
    _G.QuestLogCountRight:Hide()
    _G.QuestLogCountTopLeft:Hide()
    _G.QuestLogCountBottomLeft:Hide()
    _G.QuestLogCountLeft:Hide()
    _G.QuestLogCountTopMiddle:Hide()
    _G.QuestLogCountMiddleMiddle:Hide()
    _G.QuestLogCountBottomMiddle:Hide()

    _G.QuestLogSkillHighlight:SetColorTexture(1, 1, 1, 0.5)

    Skin.HybridScrollBarTemplate(_G.QuestLogListScrollFrameScrollBar)
end
