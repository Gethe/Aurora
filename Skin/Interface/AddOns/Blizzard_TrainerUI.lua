local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ AddOns\Blizzard_TrainerUI.lua ]]
--end

do --[[ AddOns\Blizzard_TrainerUI.xml ]]
    function Skin.ClassTrainerSkillButtonTemplate(Button)
        Skin.UIServiceButtonTemplate(Button)
    end
end

function private.AddOns.Blizzard_TrainerUI()
    local ClassTrainerFrame = _G.ClassTrainerFrame
    if private.isRetail then
        Skin.ButtonFrameTemplate(ClassTrainerFrame)

        _G.ClassTrainerFrameMoneyBg:Hide()
        ClassTrainerFrame.BG:Hide()

        Skin.FrameTypeStatusBar(_G.ClassTrainerStatusBar)
        _G.ClassTrainerStatusBarLeft:Hide()
        _G.ClassTrainerStatusBarRight:Hide()
        _G.ClassTrainerStatusBarMiddle:Hide()
        _G.ClassTrainerStatusBarBackground:Hide()
        _G.ClassTrainerStatusBar:SetPoint("TOPLEFT", 8, -35)
        _G.ClassTrainerStatusBar:SetSize(192, 18)

        Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)
        Skin.MagicButtonTemplate(_G.ClassTrainerTrainButton)

        local moneyBG = _G.CreateFrame("Frame", nil, ClassTrainerFrame)
        moneyBG:SetSize(142, 18)
        moneyBG:SetPoint("BOTTOMLEFT", 8, 5)
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(Color.yellow)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerFrameMoneyFrame)
        _G.ClassTrainerFrameMoneyFrame:SetPoint("RIGHT", moneyBG, 11, 0)

        Skin.ClassTrainerSkillButtonTemplate(ClassTrainerFrame.skillStepButton)
        Skin.WowScrollBoxList(ClassTrainerFrame.ScrollBox)
        Skin.MinimalScrollBar(ClassTrainerFrame.ScrollBar)
        Skin.InsetFrameTemplate(ClassTrainerFrame.bottomInset)
    else
        _G.hooksecurefunc("ClassTrainerFrame_Update", Hook.ClassTrainerFrame_Update)
        _G.hooksecurefunc("ClassTrainer_SetSelection", Hook.ClassTrainer_SetSelection)
        _G.hooksecurefunc("ClassTrainer_SetToTradeSkillTrainer", Hook.ClassTrainer_SetToTradeSkillTrainer)
        _G.hooksecurefunc("ClassTrainer_SetToClassTrainer", Hook.ClassTrainer_SetToClassTrainer)

        Skin.FrameTypeFrame(ClassTrainerFrame)
        ClassTrainerFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local trainerBG = ClassTrainerFrame:GetBackdropTexture("bg")
        local portrait, tl, tr, bl, br = ClassTrainerFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        local titleText = _G.ClassTrainerNameText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT", trainerBG)
        titleText:SetPoint("BOTTOMRIGHT", trainerBG, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local barLeft, barRight = select(8, ClassTrainerFrame:GetRegions())
        barLeft:SetColorTexture(Color.gray:GetRGB())
        barLeft:SetPoint("TOPLEFT", trainerBG, 10, -270)
        barLeft:SetPoint("BOTTOMRIGHT", trainerBG, "TOPRIGHT", -10, -271)
        barRight:Hide()



        _G.ClassTrainerGreetingText:SetPoint("TOPLEFT", _G.ClassTrainerNameText, "BOTTOMLEFT", 30, 0)
        _G.ClassTrainerGreetingText:SetPoint("TOPRIGHT", _G.ClassTrainerNameText, "BOTTOMRIGHT", -30, 0)

        local left, middle, right = _G.ClassTrainerExpandButtonFrame:GetRegions()
        left:Hide()
        middle:Hide()
        right:Hide()

        Skin.ClassTrainerSkillButtonTemplate(_G.ClassTrainerCollapseAllButton)
        _G.ClassTrainerCollapseAllButton:SetBackdropOption("offsets", {
            left = 3,
            right = 24,
            top = 2,
            bottom = 7,
        })
        Skin.UIDropDownMenuTemplate(_G.ClassTrainerFrameFilterDropDown)

        _G.ClassTrainerSkillHighlight:SetColorTexture(1, 1, 1, 0.5)
        for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
            Skin.ClassTrainerSkillButtonTemplate(_G["ClassTrainerSkill"..i])
        end

        Skin.ClassTrainerListScrollFrameTemplate(_G.ClassTrainerListScrollFrame)

        local moneyBG = _G.CreateFrame("Frame", nil, ClassTrainerFrame)


        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        moneyBG:SetPoint("BOTTOMLEFT", trainerBG, 5, 5)
        moneyBG:SetPoint("TOPRIGHT", trainerBG, "BOTTOMLEFT", 165, 27)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerMoneyFrame)
        _G.ClassTrainerMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)

        Skin.ClassTrainerDetailScrollFrameTemplate(_G.ClassTrainerDetailScrollFrame)

        _G.ClassTrainerSkillIcon:GetRegions():Hide()
        _G.ClassTrainerSkillIcon:SetNormalTexture(private.textures.plain)
        Base.CropIcon(_G.ClassTrainerSkillIcon:GetNormalTexture(), _G.ClassTrainerSkillIcon)
        Skin.SmallMoneyFrameTemplate(_G.ClassTrainerDetailMoneyFrame)

        Skin.UIPanelButtonTemplate(_G.ClassTrainerTrainButton)
        Skin.UIPanelButtonTemplate(_G.ClassTrainerCancelButton)
        Util.PositionRelative("BOTTOMRIGHT", trainerBG, "BOTTOMRIGHT", -5, 5, 1, "Left", {
            _G.ClassTrainerCancelButton,
            _G.ClassTrainerTrainButton,
        })

        Skin.UIPanelCloseButton(_G.ClassTrainerFrameCloseButton)
    end
end
