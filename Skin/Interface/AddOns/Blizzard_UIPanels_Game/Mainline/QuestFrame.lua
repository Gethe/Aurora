local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\QuestFrame.lua ]]
    function Hook.QuestFrameProgressItems_Update()
        local numRequiredItems = _G.GetNumQuestItems()
        local numRequiredCurrencies = _G.GetNumQuestCurrencies()
        local moneyToGet = _G.GetQuestMoneyToGet()
        if numRequiredItems > 0 or moneyToGet > 0 or numRequiredCurrencies > 0 then
            -- If there's money required then anchor and display it
            if moneyToGet > 0 then
                if moneyToGet > _G.GetMoney() then
                    -- Not enough money
                    _G.QuestProgressRequiredMoneyText:SetTextColor(Color.grayLight:GetRGB())
                else
                    _G.QuestProgressRequiredMoneyText:SetTextColor(Color.white:GetRGB())
                end
            end
        end
    end
    function Hook.QuestFrameGreetingPanel_OnShow()
        local id, title, lastTitleButton
        for questTitleButton in _G.QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
            id = questTitleButton:GetID()
            if questTitleButton.isActive == 1 then
                title = _G.GetActiveTitle(id)
                if _G.IsActiveQuestTrivial(id) then
                    questTitleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, title)
                else
                    questTitleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, title)
                end
                lastTitleButton = questTitleButton
            elseif questTitleButton.isActive == 0 then
                title = _G.GetAvailableTitle(id)
                if _G.GetAvailableQuestInfo(id) then
                    questTitleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, title)
                else
                    questTitleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, title)
                end
            end
        end

        if _G.GetNumAvailableQuests() > 0 and _G.GetNumActiveQuests() > 0 then
            _G.QuestGreetingFrameHorizontalBreak:SetPoint("TOPLEFT", lastTitleButton, "BOTTOMLEFT", 22, -10)
            _G.AvailableQuestsText:SetPoint("TOPLEFT", "QuestGreetingFrameHorizontalBreak", "BOTTOMLEFT", -12, -10)
        end
    end
    function Hook.QuestFrame_UpdatePortraitText(text)
        if text and text ~= "" then
            _G.QuestNPCModelText:SetWidth(191)
            local textHeight = _G.QuestNPCModelText:GetHeight()
            local scrollHeight = _G.QuestNPCModelTextScrollFrame:GetHeight()
            if textHeight > scrollHeight then
                _G.QuestNPCModelTextScrollChildFrame:SetHeight(textHeight + 10)
                _G.QuestNPCModelText:SetWidth(176)
            else
                _G.QuestNPCModelTextScrollChildFrame:SetHeight(textHeight)
            end
        end
    end
    function Hook.QuestFrame_ShowQuestPortrait(parentFrame, portraitDisplayID, mountPortraitDisplayID, modelSceneID, text, name, x, y)
        if parentFrame == _G.WorldMapFrame then
            x = x + 2
        else
            x = x + 5
        end
        _G.QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
    end
    function Hook.QuestFrame_SetTitleTextColor(fontString, material)
        fontString:SetTextColor(Color.white:GetRGB())
    end
    function Hook.QuestFrame_SetTextColor(fontString, material)
        fontString:SetTextColor(Color.white:GetRGB())
    end
end

do --[[ FrameXML\QuestFrameTemplates.xml ]]
    function Skin.QuestFramePanelTemplate(Frame)
        local name = Frame:GetName()

        Frame:SetAllPoints()
        Frame.Bg:Hide()
        _G[name.."MaterialTopLeft"]:SetAlpha(0)
        _G[name.."MaterialTopRight"]:SetAlpha(0)
        _G[name.."MaterialBotLeft"]:SetAlpha(0)
        _G[name.."MaterialBotRight"]:SetAlpha(0)
    end
    function Skin.QuestItemTemplate(Button)
        Skin.LargeItemButtonTemplate(Button)
    end
    function Skin.QuestSpellTemplate(Button)
        Base.SetBackdrop(Button, Color.black, Color.frame.a)
        Button:SetBackdropOption("offsets", {
            left = 9,
            right = 107,
            top = 1,
            bottom = 14,
        })
        Button._auroraIconBorder = Button
        Base.CropIcon(Button.Icon)

        Button.NameFrame:SetAlpha(0)

        local bg = Button:GetBackdropTexture("bg")
        local nameBG = _G.CreateFrame("Frame", nil, Button)
        nameBG:SetFrameLevel(Button:GetFrameLevel())
        nameBG:SetPoint("TOPLEFT", bg, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("RIGHT", -3, 0)
        nameBG:SetPoint("BOTTOM", bg)
        Base.SetBackdrop(nameBG, Color.frame)
        Button._auroraNameBG = nameBG

        local _, _, spellBorder = Button:GetRegions()
        spellBorder:Hide()
    end
    function Skin.QuestTitleButtonTemplate(Button)
    end
    function Skin.QuestScrollFrameTemplate(ScrollFrame)
        Skin.ScrollFrameTemplate(ScrollFrame)
        ScrollFrame:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 5))
        ScrollFrame:SetPoint("BOTTOMRIGHT", -23, 32)
    end
end

function private.FrameXML.QuestFrame()
    _G.hooksecurefunc("QuestFrameProgressItems_Update", Hook.QuestFrameProgressItems_Update)
    _G.hooksecurefunc("QuestFrameGreetingPanel_OnShow", Hook.QuestFrameGreetingPanel_OnShow)
    _G.QuestFrameGreetingPanel:HookScript("OnShow", Hook.QuestFrameGreetingPanel_OnShow)
    _G.hooksecurefunc("QuestFrame_UpdatePortraitText", Hook.QuestFrame_UpdatePortraitText)
    _G.hooksecurefunc("QuestFrame_ShowQuestPortrait", Hook.QuestFrame_ShowQuestPortrait)
    _G.hooksecurefunc("QuestFrame_SetTitleTextColor", Hook.QuestFrame_SetTitleTextColor)
    _G.hooksecurefunc("QuestFrame_SetTextColor", Hook.QuestFrame_SetTextColor)

    ----------------
    -- QuestFrame --
    ----------------
    Skin.ButtonFrameTemplate(_G.QuestFrame)
    Skin.QuestFramePanelTemplate(_G.QuestFrameRewardPanel)
    Skin.UIPanelButtonTemplate(_G.QuestFrameCompleteQuestButton)
    _G.QuestFrameCompleteQuestButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.QuestScrollFrameTemplate(_G.QuestRewardScrollFrame)

    Skin.QuestFramePanelTemplate(_G.QuestFrameProgressPanel)
    Skin.UIPanelButtonTemplate(_G.QuestFrameGoodbyeButton)
    _G.QuestFrameGoodbyeButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestFrameCompleteButton)
    _G.QuestFrameCompleteButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.QuestScrollFrameTemplate(_G.QuestProgressScrollFrame)
    for i = 1, _G.MAX_REQUIRED_ITEMS do
        Skin.QuestItemTemplate(_G["QuestProgressItem"..i])
    end

    Skin.QuestFramePanelTemplate(_G.QuestFrameDetailPanel)
    Skin.UIPanelButtonTemplate(_G.QuestFrameDeclineButton)
    _G.QuestFrameDeclineButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.UIPanelButtonTemplate(_G.QuestFrameAcceptButton)
    _G.QuestFrameAcceptButton:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.QuestScrollFrameTemplate(_G.QuestFrameDetailPanel.ScrollFrame)

    Skin.QuestFramePanelTemplate(_G.QuestFrameGreetingPanel)
    Skin.UIPanelButtonTemplate(_G.QuestFrameGreetingGoodbyeButton)
    _G.QuestFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -5, 5)
    Skin.QuestScrollFrameTemplate(_G.QuestGreetingScrollFrame)
    _G.QuestGreetingFrameHorizontalBreak:SetColorTexture(1, 1, 1, .2)
    _G.QuestGreetingFrameHorizontalBreak:SetSize(256, 1)
    -------------------
    -- QuestNPCModel --
    -------------------
    local QuestModel = _G.QuestModelScene

    local modelBackground = _G.CreateFrame("Frame", nil, QuestModel)
    local ModelTextFrame =  _G.CreateFrame("Frame", nil, _G.QuestModelScene.ModelTextFrame)

    modelBackground:SetPoint("TOPLEFT", -1, 1)
    modelBackground:SetPoint("BOTTOMRIGHT", 1, -2)
    modelBackground:SetFrameLevel(0)
    Skin.FrameTypeFrame(modelBackground)
    -- FIXLATER
    QuestModel.TopBarBg:Hide()
    QuestModel.ModelBackground:Hide()
    QuestModel.Border:Hide()

    modelBackground.TopLeftCorner:Hide()
    modelBackground.TopRightCorner:Hide()
    modelBackground.BottomLeftCorner:Hide()
    modelBackground.BottomRightCorner:Hide()
    modelBackground.RightEdge:Hide()
    modelBackground.LeftEdge:Hide()
    modelBackground.BottomEdge:Hide()


    local QuestNPCModelNameTooltipFrame = _G.QuestNPCModelNameTooltipFrame
    QuestNPCModelNameTooltipFrame:SetPoint("TOPLEFT", _G.QuestNPCModelNameText, 0, 1)
    QuestNPCModelNameTooltipFrame:SetPoint("BOTTOMRIGHT", _G.QuestNPCModelNameText, 0, -1)
    QuestNPCModelNameTooltipFrame:SetFrameLevel(0)
    Skin.FrameTypeFrame(QuestNPCModelNameTooltipFrame)
    QuestNPCModelNameTooltipFrame:SetAlpha(0)
    QuestNPCModelNameTooltipFrame.TopLeftCorner:Hide()
    QuestNPCModelNameTooltipFrame.TopRightCorner:Hide()
    QuestNPCModelNameTooltipFrame.BottomLeftCorner:Hide()
    QuestNPCModelNameTooltipFrame.BottomRightCorner:Hide()
    QuestNPCModelNameTooltipFrame.RightEdge:Hide()
    QuestNPCModelNameTooltipFrame.LeftEdge:Hide()
    QuestNPCModelNameTooltipFrame.BottomEdge:Hide()

    Skin.FrameTypeFrame(ModelTextFrame)
    ModelTextFrame:SetPoint("TOPLEFT",QuestNPCModelNameTooltipFrame, "BOTTOMLEFT", -1, 12)
    ModelTextFrame:SetWidth(200)

    ModelTextFrame.TopLeftCorner:Hide()
    ModelTextFrame.TopRightCorner:Hide()
    ModelTextFrame.BottomLeftCorner:Hide()
    ModelTextFrame.BottomRightCorner:Hide()
    ModelTextFrame.RightEdge:Hide()
    ModelTextFrame.LeftEdge:Hide()
    ModelTextFrame.BottomEdge:Hide()

    local npcModelScroll = _G.QuestNPCModelTextScrollFrame
    Skin.ScrollFrameTemplate(npcModelScroll)
    npcModelScroll:SetPoint("TOPLEFT", 4, -4)
    npcModelScroll:SetPoint("BOTTOMRIGHT", -4, 4)
end
