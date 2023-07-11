local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\QuestFrame.lua ]]
--end

do --[[ FrameXML\QuestFrameTemplates.xml ]]
    function Skin.QuestFramePanelTemplate(Frame)
        local name = Frame:GetName()

        local bg = Frame:GetParent():GetBackdropTexture("bg")
        Frame:SetAllPoints(bg)

        local tl, tr, bl, br = Frame:GetRegions()
        tl:SetAlpha(0)
        tr:SetAlpha(0)
        bl:SetAlpha(0)
        br:SetAlpha(0)

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
            left = -1,
            right = 107,
            top = -1,
            bottom = 1,
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
    end
    function Skin.QuestPlayerTitleFrameTemplate(Button)
        local icon, left, center, right = Button:GetRegions()
        Base.CropIcon(icon)
        left:Hide()
        center:Hide()
        right:Hide()

        local titleBG = _G.CreateFrame("Frame", nil, Button)
        titleBG:SetPoint("TOPLEFT", left, -2, 0)
        titleBG:SetPoint("BOTTOMRIGHT", right, 0, -1)
        Base.SetBackdrop(titleBG, Color.frame)
    end
    function Skin.QuestScrollFrameTemplate(ScrollFrame)
        Skin.UIPanelScrollFrameTemplate(ScrollFrame)
        ScrollFrame:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 2))
        ScrollFrame:SetPoint("BOTTOMRIGHT", -23, 32)

        local name = ScrollFrame:GetName()
        _G[name.."Top"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Middle"]:Hide()
    end
end

--function private.FrameXML.QuestFrame()
--end
