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
            local _, quality, isQuestItem, isActive
            if LootFrame.AutoLootTable then
                local entry = LootFrame.AutoLootTable[slot]
                if not entry.hide then
                    isQuestItem = entry.isQuestItem
                    quality = entry.quality
                end
            else
                _, _, _, _, quality, _, isQuestItem, _, isActive = _G.GetLootSlotInfo(slot)
            end

            local questTexture = button._questTexture
            if isQuestItem then
                button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
                questTexture:Show()

                if isActive then
                    questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BANG)
                else
                    questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
                end
            else
                Hook.SetItemButtonQuality(button, quality)
                questTexture:Hide()
            end
        end
    end
end

do --[[ FrameXML\LootFrame.xml ]]
    function Skin.LootButtonTemplate(Frame)
        Skin.FrameTypeItemButton(Frame)

        local name = Frame:GetName()
        _G[name.."NameFrame"]:Hide()

        local questTexture
        if private.isRetail then
            questTexture = _G[name.."IconQuestTexture"]
        else
            Frame._questTexture = Frame:CreateTexture(nil, "ARTWORK")
            Frame._questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
            questTexture = Frame._questTexture
        end
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

        if private.isVanilla then
            Frame:SetNormalTexture("")
            Frame:SetPushedTexture("")
        else
            Frame:ClearNormalTexture()
            Frame:ClearPushedTexture()
        end
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
    if private.isClassic then
        _G.hooksecurefunc("LootFrame_UpdateButton", Hook.LootFrame_UpdateButton)
    end

    ---------------
    -- LootFrame --
    ---------------
    local LootFrame = _G.LootFrame
    if private.isRetail then
        Skin.ScrollingFlatPanelTemplate(LootFrame)
    else
        Skin.ButtonFrameTemplate(LootFrame)
        _G.LootFramePortraitOverlay:Hide()
        select(19, LootFrame:GetRegions()):SetAllPoints(LootFrame.TitleText) -- Items text

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


        ---------------
        -- GroupLoot --
        ---------------
    end
end
