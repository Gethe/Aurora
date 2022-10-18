local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\LootFrame.lua ]]
    function Hook.LootFrame_UpdateButton(index)
        local LootFrame = _G.LootFrame
        local numLootItems = LootFrame.numLootItems
        --Logic to determine how many items to show per page
        local numLootToShow = _G.LOOTFRAME_NUMBUTTONS
        if LootFrame.AutoLootTable then
            numLootItems = #LootFrame.AutoLootTable
        end
        if numLootItems > _G.LOOTFRAME_NUMBUTTONS then
            numLootToShow = numLootToShow - 1 -- make space for the page buttons
        end

        local button = _G["LootButton"..index]
        local slot = (numLootToShow * (LootFrame.page - 1)) + index

        if slot <= numLootItems then
            local _, isQuestItem
            if LootFrame.AutoLootTable then
                local entry = LootFrame.AutoLootTable[slot]
                if not entry.hide then
                    isQuestItem = entry.isQuestItem
                end
            else
                _, _, _, _, _, _, isQuestItem = _G.GetLootSlotInfo(slot)
            end

            if isQuestItem then
                button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
            end
        end
    end
    function Hook.BonusRollFrame_OnShow(self)
        self.PromptFrame.Timer:SetFrameLevel(self:GetFrameLevel())
    end
end

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

        Frame:SetNormalTexture("")
        Frame:SetPushedTexture("")
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
    if not private.isPatch then
        _G.hooksecurefunc("LootFrame_UpdateButton", Hook.LootFrame_UpdateButton)
    end

    ---------------
    -- LootFrame --
    ---------------
    local LootFrame = _G.LootFrame
    if private.isPatch then
        Skin.ScrollingFlatPanelTemplate(LootFrame)
    else
        Skin.ButtonFrameTemplate(LootFrame)
        _G.LootFramePortraitOverlay:Hide()
        select(7, LootFrame:GetRegions()):SetAllPoints(LootFrame.TitleText) -- Items text

        for index = 1, 4 do
            Skin.LootButtonTemplate(_G["LootButton"..index])
        end
        Util.PositionRelative("TOPLEFT", LootFrame, "TOPLEFT", 9, -(private.FRAME_TITLE_HEIGHT + 5), 17, "Down", {
            _G.LootButton1,
            _G.LootButton2,
            _G.LootButton3,
            _G.LootButton4,
        })

        do -- LootFrameUpButton
            Skin.LootNavButton(_G.LootFrameUpButton)
            _G.LootFrameUpButton:SetPoint("BOTTOMLEFT", 10, 10)

            local bg = _G.LootFrameUpButton:GetBackdropTexture("bg")
            local arrow = _G.LootFrameUpButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 5, -8)
            arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
            Base.SetTexture(arrow, "arrowUp")
            _G.LootFramePrev:ClearAllPoints()
            _G.LootFramePrev:SetPoint("LEFT", _G.LootFrameUpButton, "RIGHT", 4, 0)
        end
        do -- LootFrameDownButton
            Skin.LootNavButton(_G.LootFrameDownButton)
            _G.LootFrameDownButton:ClearAllPoints()
            _G.LootFrameDownButton:SetPoint("BOTTOMRIGHT", -10, 10)

            local bg = _G.LootFrameDownButton:GetBackdropTexture("bg")
            local arrow = _G.LootFrameDownButton:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 5, -8)
            arrow:SetPoint("BOTTOMRIGHT", bg, -5, 8)
            Base.SetTexture(arrow, "arrowDown")
            _G.LootFrameNext:ClearAllPoints()
            _G.LootFrameNext:SetPoint("RIGHT", _G.LootFrameDownButton, "LEFT", -4, 0)
        end
    end
end
