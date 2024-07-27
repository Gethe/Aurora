local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GroupLootFrame.lua ]]
    function Hook.BonusRollFrame_OnShow(self)
        self.PromptFrame.Timer:SetFrameLevel(self:GetFrameLevel())
    end
end

do --[[ FrameXML\GroupLootFrame.xml ]]
    function Skin.BonusRollFrameTemplate(Frame)
        Frame:HookScript("OnShow", Hook.BonusRollFrame_OnShow)

        Skin.FrameTypeFrame(Frame)
        Frame:SetSize(270, 60)

        Frame.Background:SetAlpha(0)
        Frame.LootSpinnerBG:SetPoint("TOPLEFT", 4, -4)
        Frame.IconBorder:Hide()

        Base.CropIcon(Frame.SpecIcon, Frame)
        Frame.SpecIcon:SetSize(18, 18)
        Frame.SpecIcon:SetPoint("TOPLEFT", -9, 9)
        Frame.SpecRing:SetAlpha(0)

        local textFrame = _G.CreateFrame("Frame", nil, Frame)
        Base.SetBackdrop(textFrame, Color.frame)
        textFrame:SetFrameLevel(Frame:GetFrameLevel())

        local rollingFrame = Frame.RollingFrame
        rollingFrame.Label:SetAllPoints(textFrame)
        rollingFrame.LootSpinnerFinalText:SetAllPoints(textFrame)
        rollingFrame.DieIcon:SetPoint("TOPRIGHT", -40, -10)
        rollingFrame.DieIcon:SetSize(32, 32)

        local promptFrame = Frame.PromptFrame
        Base.CropIcon(promptFrame.Icon, promptFrame)
        promptFrame.Icon:SetAllPoints(Frame.LootSpinnerBG)

        promptFrame.InfoFrame:SetPoint("TOPLEFT", textFrame, 4, 0)
        promptFrame.InfoFrame:SetPoint("BOTTOMRIGHT", textFrame)

        Skin.FrameTypeStatusBar(promptFrame.Timer)
        promptFrame.Timer:SetHeight(6)
        promptFrame.Timer:SetPoint("BOTTOMLEFT", 4, 4)
        promptFrame.RollButton:SetPoint("TOPRIGHT", -40, -10)

        Frame.BlackBackgroundHoist:Hide()

        textFrame:SetPoint("TOPLEFT", promptFrame.Icon, "TOPRIGHT", 4, 1)
        textFrame:SetPoint("BOTTOMRIGHT", promptFrame.Timer, "TOPRIGHT", 1, 3)

        Frame.CurrentCountFrame:SetPoint("BOTTOMRIGHT", -2, 0)
    end
end

function private.FrameXML.GroupLootFrame()
    ---------------
    -- GroupLoot --
    ---------------

    --------------------
    -- BonusRollFrame --
    --------------------
    Skin.BonusRollFrameTemplate(_G.BonusRollFrame)
end

