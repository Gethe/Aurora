local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\QuestInfo.lua ]]
    local templates = {}
    function Hook.QuestInfo_Display(template, parentFrame, acceptButton, material, mapView)
        local headerR, headerG, headerB = Color.white:GetRGB()
        local textR, textG, textB = Color.grayLight:GetRGB()

        if template.canHaveSealMaterial then
            local questFrame = parentFrame:GetParent():GetParent()
            questFrame.SealMaterialBG:Hide()
        end

        -- headers
        _G.QuestInfoTitleHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoDescriptionHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoObjectivesHeader:SetTextColor(headerR, headerG, headerB)
        _G.QuestInfoRewardsFrame.Header:SetTextColor(headerR, headerG, headerB)

        -- other text
        _G.QuestInfoDescriptionText:SetTextColor(textR, textG, textB)
        _G.QuestInfoObjectivesText:SetTextColor(textR, textG, textB)
        _G.QuestInfoGroupSize:SetTextColor(textR, textG, textB)
        _G.QuestInfoRewardText:SetTextColor(textR, textG, textB)

        -- reward frame text
        local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
        rewardsFrame.ItemChooseText:SetTextColor(textR, textG, textB)
        rewardsFrame.ItemReceiveText:SetTextColor(textR, textG, textB)
        rewardsFrame.PlayerTitleText:SetTextColor(textR, textG, textB)
        rewardsFrame.QuestSessionBonusReward:SetTextColor(textR, textG, textB)
        if not mapView then
            rewardsFrame.XPFrame.ReceiveText:SetTextColor(textR, textG, textB)
        end

        local templateElements = templates[template]
        for i = 1, #templateElements do
            templateElements[i](parentFrame)
        end
    end
    function Hook.QuestInfo_ShowObjectives()
        local numObjectives = _G.GetNumQuestLeaderBoards()
        local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives

        local shownObjs = 0
        for i = #objectivesTable, 1, -1 do
            local objective = objectivesTable[i]
            if objective:IsShown() then
                shownObjs = shownObjs + 1
                if shownObjs > numObjectives then
                    objective:SetTextColor(1, 1, 1)
                else
                    local _, _, finished = _G.GetQuestLogLeaderBoard(i)
                    if finished then
                        objective:SetTextColor(0.6, 0.6, 0.6)
                    else
                        objective:SetTextColor(0.9, 0.9, 0.9)
                    end
                end
            end
        end
    end
    function Hook.QuestInfo_ShowRewards()
        local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
        local textR, textG, textB = Color.grayLight:GetRGB()

        for obj in rewardsFrame.spellHeaderPool:EnumerateActive() do
            obj:SetVertexColor(textR, textG, textB)
        end
    end

    local rewardFrames = {}
    function Hook.QuestInfo_GetRewardButton(rewardsFrame, index)
        if not Skin[rewardsFrame.buttonTemplate] then return end

        local numRewardButtons = rewardFrames[rewardsFrame] or 0

        while numRewardButtons < #rewardsFrame.RewardButtons do
            numRewardButtons = numRewardButtons + 1
            Skin[rewardsFrame.buttonTemplate](rewardsFrame.RewardButtons[numRewardButtons])
        end

        rewardFrames[rewardsFrame] = numRewardButtons
    end

    templates = {
        [_G.QUEST_TEMPLATE_DETAIL] = {
        },
        [_G.QUEST_TEMPLATE_LOG] = {
            Hook.QuestInfo_ShowObjectives,
        },
        [_G.QUEST_TEMPLATE_REWARD] = {
        },
        [_G.QUEST_TEMPLATE_MAP_DETAILS] = {
            Hook.QuestInfo_ShowObjectives,
        },
        [_G.QUEST_TEMPLATE_MAP_REWARDS] = {
        },
    }
end

do --[[ FrameXML\QuestInfo.xml ]]
    function Skin.SmallQuestRewardItemButtonTemplate(Button)
        Skin.SmallItemButtonTemplate(Button)
    end
    function Skin.LargeQuestRewardItemButtonTemplate(Button)
        Skin.LargeItemButtonTemplate(Button)
    end
    function Skin.LargeQuestInfoRewardFollowerTemplate(Button)
        Base.SetBackdrop(Button, Color.frame)
        Button:SetBackdropOptions({
            offsets = {
                left = 41,
                right = 0,
                top = 8,
                bottom = 8,
            },
        })

        Button.BG:SetAlpha(0)
        Button.BG:SetTexture("")

        local bg = Button:GetBackdropTexture("bg")
        Button.Class:SetPoint("TOPRIGHT", bg, -1, -1)
        Button.Class:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        local GarrisonPortrait = Button.PortraitFrame
        Skin.GarrisonFollowerPortraitTemplate(GarrisonPortrait)
        GarrisonPortrait:SetScale(1)
        GarrisonPortrait:SetSize(41.6, 48)
        GarrisonPortrait:SetBackdropOptions({
            offsets = {
                left = 3,
                right = 4,
                top = 4,
                bottom = 10,
            },
        })

        local garrisonBG = GarrisonPortrait:GetBackdropTexture("bg")
        local garrisonLvlBG = GarrisonPortrait._auroraLvlBG
        garrisonLvlBG:SetPoint("TOPLEFT", garrisonBG, "BOTTOMLEFT", 0, 2)
        GarrisonPortrait.Level:SetScale(0.8)

        local AdventuresPortrait = Button.AdventuresFollowerPortraitFrame
        Skin.AdventuresLevelPortraitTemplate(AdventuresPortrait)
        AdventuresPortrait:SetScale(1)
        AdventuresPortrait:SetSize(43.2, 43.2)
        AdventuresPortrait:SetBackdropOptions({
            offsets = {
                left = 4,
                right = 6,
                top = 3,
                bottom = 7,
            },
        })

        local adventuresBG = AdventuresPortrait:GetBackdropTexture("bg")
        local adventuresLvlBG = AdventuresPortrait._auroraLvlBG
        adventuresLvlBG:SetPoint("TOPLEFT", adventuresBG, "BOTTOMLEFT", 0, 2)
        AdventuresPortrait.LevelDisplayFrame.LevelText:SetScale(0.8)
    end
    function Skin.SmallQuestInfoRewardFollowerTemplate(Button)
        Base.SetBackdrop(Button, Color.frame)
        Button:SetBackdropOptions({
            offsets = {
                left = 33,
                right = 0,
                top = -1,
                bottom = -2,
            },
        })

        Button.BG:SetAlpha(0)
        Button.BG:SetTexture("")

        local bg = Button:GetBackdropTexture("bg")
        Button.Class:SetPoint("TOPRIGHT", bg, -1, -1)
        Button.Class:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        local PortraitFrame = Button.PortraitFrame
        Skin.GarrisonFollowerPortraitTemplate(PortraitFrame)
        PortraitFrame:SetScale(1)
        PortraitFrame:SetSize(33.8, 39)
        PortraitFrame:SetBackdropOptions({
            offsets = {
                left = 1,
                right = 4,
                top = 3,
                bottom = 7,
            },
        })

        local portraitBG = PortraitFrame:GetBackdropTexture("bg")
        local lvlBG = PortraitFrame._auroraLvlBG
        lvlBG:SetPoint("TOPLEFT", portraitBG, "BOTTOMLEFT", 0, 3)
        lvlBG:SetPoint("BOTTOMRIGHT", portraitBG, 0, -6)
        PortraitFrame.Level:SetScale(0.65)
    end
    function Skin.QuestInfoSpellHeaderTemplate(FontString)
        FontString:SetTextColor(0.8, 0.8, 0.8)
    end
end

function private.FrameXML.QuestInfo()
    _G.hooksecurefunc("QuestInfo_Display", Hook.QuestInfo_Display)
    _G.hooksecurefunc("QuestInfo_GetRewardButton", Hook.QuestInfo_GetRewardButton)
    _G.hooksecurefunc("QuestInfo_ShowRewards", Hook.QuestInfo_ShowRewards)

    ------------------------------
    -- QuestInfoObjectivesFrame --
    ------------------------------
    _G.hooksecurefunc("QuestInfo_ShowObjectives", Hook.QuestInfo_ShowObjectives)

    -------------------------------------
    -- QuestInfoSpecialObjectivesFrame --
    -------------------------------------
    Skin.QuestSpellTemplate(_G.QuestInfoSpellObjectiveFrame)

    -------------------------
    -- QuestInfoTimerFrame --
    -------------------------

    ---------------------------------
    -- QuestInfoRequiredMoneyFrame --
    ---------------------------------

    ---------------------------
    -- QuestInfoRewardsFrame --
    ---------------------------
    local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
    Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame.HonorFrame)
    Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame.SkillPointFrame)
    Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame.ArtifactXPFrame)
    Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame.WarModeBonusFrame)
    Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame.HonorFrame)

    local TitleFrame = QuestInfoRewardsFrame.TitleFrame
    Base.CropIcon(TitleFrame.Icon)
    TitleFrame.FrameLeft:Hide()
    TitleFrame.FrameCenter:Hide()
    TitleFrame.FrameRight:Hide()

    local titleBG = _G.CreateFrame("Frame", nil, TitleFrame)
    titleBG:SetPoint("TOPLEFT", TitleFrame.FrameLeft, -2, 0)
    titleBG:SetPoint("BOTTOMRIGHT", TitleFrame.FrameRight, 0, -1)
    Base.SetBackdrop(titleBG, Color.frame)

    local ItemHighlight = QuestInfoRewardsFrame.ItemHighlight
    ItemHighlight:GetRegions():Hide()
    Base.SetBackdrop(ItemHighlight, Color.highlight, Color.frame.a)
    ItemHighlight:SetBackdropOption("offsets", {
        left = 7,
        right = 104,
        top = 6,
        bottom = 17,
    })

    Util.Mixin(QuestInfoRewardsFrame.spellRewardPool, Hook.ObjectPoolMixin)
    Util.Mixin(QuestInfoRewardsFrame.followerRewardPool, Hook.ObjectPoolMixin)
    Util.Mixin(QuestInfoRewardsFrame.spellHeaderPool, Hook.ObjectPoolMixin)

    ------------------------------
    -- MapQuestInfoRewardsFrame --
    ------------------------------
    local MapQuestInfoRewardsFrame = _G.MapQuestInfoRewardsFrame
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.XPFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.HonorFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.ArtifactXPFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.WarModeBonusFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.MoneyFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.SkillPointFrame)
    Skin.SmallItemButtonTemplate(MapQuestInfoRewardsFrame.TitleFrame)

    Util.Mixin(MapQuestInfoRewardsFrame.spellRewardPool, Hook.ObjectPoolMixin)
    Util.Mixin(MapQuestInfoRewardsFrame.followerRewardPool, Hook.ObjectPoolMixin)
    Util.Mixin(MapQuestInfoRewardsFrame.spellHeaderPool, Hook.ObjectPoolMixin)

    --------------------
    -- QuestInfoFrame --
    --------------------

    -- QuestInfoSealFrame --
    local mask = _G.QuestInfoSealFrame:CreateMaskTexture(nil, "BACKGROUND")
    mask:SetTexture([[Interface/SpellBook/UI-SpellbookPanel-Tab-Highlight]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetTexCoord(0, 0.5, 0, 0.5)
    mask:SetPoint("TOPLEFT", _G.QuestInfoSealFrame.Text, -44, 46)
    mask:SetPoint("BOTTOMRIGHT", _G.QuestInfoSealFrame.Text, 30, -50)

    local bg = _G.QuestInfoSealFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.25)
    bg:SetAllPoints(mask)
    bg:AddMaskTexture(mask)

    _G.QuestInfoSealFrame.Text:SetShadowColor(Color.grayDark:GetRGB())
    _G.QuestInfoSealFrame.Text:SetShadowOffset(0.6, -0.6)
end
