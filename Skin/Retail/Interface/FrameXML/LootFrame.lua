local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\LootFrame.lua ]]
--end

do --[[ FrameXML\LootFrame.xml ]]
    function Skin.LootButtonTemplate(Frame)
        Skin.FrameTypeItemButton(Frame)

        local name = Frame:GetName()
        _G[name.."NameFrame"]:Hide()
        local questTexture = _G[name.."IconQuestTexture"]
        questTexture:SetAllPoints(Frame)
        Base.CropIcon(questTexture)

        --local bg = F.CreateBDFrame(nameFrame, .2)
        --bg:SetPoint("TOPLEFT", Button.icon, "TOPRIGHT", 3, 1)
        --bg:SetPoint("BOTTOMRIGHT", nameFrame, -5, 11)

        local bg = Frame:GetBackdropTexture("bg")
        local nameBG = _G.CreateFrame("Frame", nil, Frame)
        nameBG:SetFrameLevel(Frame:GetFrameLevel())
        nameBG:SetPoint("TOPLEFT", bg, "TOPRIGHT", 1, 0)
        nameBG:SetPoint("RIGHT", 115, 0)
        nameBG:SetPoint("BOTTOM", bg)
        Base.SetBackdrop(nameBG, Color.frame)
        Frame._auroraNameBG = nameBG

        Frame:ClearNormalTexture()
        Frame:ClearPushedTexture()
    end

    function Skin.LootNavButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })
    end
end

function private.FrameXML.LootFrame()
    ---------------
    -- LootFrame --
    ---------------
    local LootFrame = _G.LootFrame
    Skin.ScrollingFlatPanelTemplate(LootFrame)
end
