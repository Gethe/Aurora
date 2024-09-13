local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

local keyColor = Color.Create(0.7254, 0.5490, 0.2235, 0.75)
do --[[ FrameXML\ContainerFrame.lua ]]
    local BAG_FILTER_ICONS = {
        ["bags-icon-equipment"] = [[Interface\Icons\INV_Chest_Chain]],
        ["bags-icon-consumables"] = [[Interface\Icons\INV_Potion_93]],
        ["bags-icon-tradegoods"] = [[Interface\Icons\INV_Fabric_Silk_02]],
    }
    function Hook.ContainerFrameFilterIcon_SetAtlas(self, atlas)
        self:SetTexture(BAG_FILTER_ICONS[atlas])
    end

    local NUM_BAG_SLOTS = _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS or _G.NUM_BAG_SLOTS
    function Hook.ContainerFrame_GenerateFrame(frame, size, id)
        if id > NUM_BAG_SLOTS then
            -- bank bags
            local _, _, _, a = frame:GetBackdropColor()
            Base.SetBackdropColor(frame, Color.grayLight, a)
        elseif id == _G.KEYRING_CONTAINER then
            -- key ring
            local _, _, _, a = frame:GetBackdropColor()
            Base.SetBackdropColor(frame, keyColor, a)
        end
    end
    function Hook.ContainerFrame_Update(self)
        local bagID = self:GetID()
        local name = self:GetName()

        if private.isRetail and bagID == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint("TOPLEFT", self, 20, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint("TOPRIGHT", self, -16, -31)
        end

        for i = 1, self.size do
            local itemButton = _G[name.."Item"..i]
            local slotID, _ = itemButton:GetID()
            local quality, link
            if private.isVanilla then
                _, _, _, quality, _, _, link = _G.GetContainerItemInfo(bagID, slotID)
            else
                local info = _G.C_Container.GetContainerItemInfo(bagID, slotID);
                quality = info and info.quality;
                link = info and info.itemLink;
            end

            if not itemButton._auroraIconBorder then
                itemButton._isKey = bagID == _G.KEYRING_CONTAINER
                Skin.ContainerFrameItemButtonTemplate(itemButton)

                Hook.SetItemButtonQuality(itemButton, quality, link)
            end

            if link then
                local _, _, _, _, _, _, _, _, _, _, _, itemClassID = _G.C_Item.GetItemInfo(link)
                if itemClassID == _G.LE_ITEM_CLASS_QUESTITEM then
                    itemButton._questTexture:Show()
                    itemButton._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
                end
            end
        end
    end
end

do --[[ FrameXML\ContainerFrame.xml ]]
    function Skin.ContainerFrameHelpBoxTemplate(Frame)
        Skin.GlowBoxFrame(Frame, "Right")
    end

    function Skin.ContainerFrameItemButtonTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        ItemButton:SetBackdropColor(1, 1, 1, 0.75)

        local name = ItemButton:GetName()
        ItemButton._questTexture = _G[name.."IconQuestTexture"]
        Base.CropIcon(ItemButton._questTexture)
        Base.CropIcon(ItemButton.NewItemTexture)
        ItemButton.BattlepayItemTexture:SetTexCoord(0.203125, 0.78125, 0.203125, 0.78125)
        ItemButton.BattlepayItemTexture:SetAllPoints()

        if private.isRetail then
            Base.CropIcon(ItemButton.icon)
        else
            ItemButton:SetBackdropOptions({
                bgFile = ItemButton._isKey and [[Interface\ContainerFrame\KeyRing-Bag-Icon]] or [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false
            })
            local bg = ItemButton:GetBackdropTexture("bg")
            bg:SetDesaturated(ItemButton._isKey)
            Base.CropIcon(bg)

            ItemButton._questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BORDER)
        end
    end
    function Skin.ContainerFrameTemplate(Frame)
        local bg
        if private.isRetail then
            Skin.PortraitFrameFlatTemplate(Frame)
            bg = Frame.NineSlice:GetBackdropTexture("bg")

            for i = 1, 36 do
                _G.print("contents of Frame.Items["..i.."]:")
                Skin.ContainerFrameItemButtonTemplate(Frame.Items[i])
            end

            _G.hooksecurefunc(Frame.FilterIcon.Icon, "SetAtlas", Hook.ContainerFrameFilterIcon_SetAtlas)

            Frame.PortraitButton:Hide()
            Frame.FilterIcon:ClearAllPoints()
            Frame.FilterIcon:SetPoint("TOPLEFT", bg, 5, -5)
            Frame.FilterIcon:SetSize(17, 17)
            Frame.FilterIcon.Icon:SetAllPoints()

            Base.CropIcon(Frame.FilterIcon.Icon, Frame.FilterIcon)

            Frame.ClickableTitleFrame:ClearAllPoints()
            Frame.ClickableTitleFrame:SetPoint("TOPLEFT", bg)
            Frame.ClickableTitleFrame:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
        else
            Skin.FrameTypeFrame(Frame)
            Frame:SetBackdropOption("offsets", {
                left = 11,
                right = 6,
                top = 0,
                bottom = 3,
            })

            local name = Frame:GetName()
            Frame.Portrait:Hide()
            _G[name.."BackgroundTop"]:SetAlpha(0)
            _G[name.."BackgroundMiddle1"]:SetAlpha(0)
            _G[name.."BackgroundMiddle2"]:SetAlpha(0)
            _G[name.."BackgroundBottom"]:SetAlpha(0)
            _G[name.."Background1Slot"]:SetAlpha(0)

            local nameText = _G[name.."Name"]
            nameText:ClearAllPoints()
            nameText:SetPoint("TOPLEFT", Frame.ClickableTitleFrame, 19, 0)
            nameText:SetPoint("BOTTOMRIGHT", Frame.ClickableTitleFrame, -19, 0)

            bg = Frame:GetBackdropTexture("bg")
            local moneyFrame = _G[name.."MoneyFrame"]
            local moneyBG = _G.CreateFrame("Frame", nil, moneyFrame)
            Base.SetBackdrop(moneyBG, Color.frame)
            moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
            moneyBG:SetPoint("TOP", moneyFrame, 0, 2)
            moneyBG:SetPoint("BOTTOM", moneyFrame, 0, -2)
            moneyBG:SetPoint("LEFT", bg, 3, 0)
            moneyBG:SetPoint("RIGHT", bg, -3, 0)

            Frame.PortraitButton:Hide()
            Skin.UIPanelCloseButton(_G[name.."CloseButton"])
            _G[name.."CloseButton"]:SetPoint("TOPRIGHT", bg, 6, 5)
        end

        Frame.ClickableTitleFrame:ClearAllPoints()
        Frame.ClickableTitleFrame:SetPoint("TOPLEFT", bg)
        Frame.ClickableTitleFrame:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end
    function Skin.ContainerFrameBackpackTemplate(Frame)
        -- FIXLATER
        -- Skin.ContainerFrameTemplate(Frame)
        --Skin.ContainerMoneyFrameTemplate(Frame.MoneyFrame)
    end
end

function private.FrameXML.ContainerFrame()

    if private.disabled.bags then return end
    _G.hooksecurefunc("ContainerFrame_GenerateFrame", Hook.ContainerFrame_GenerateFrame)

    Skin.ContainerFrameBackpackTemplate(_G.ContainerFrame)
                          
    if private.isRetail then
        Skin.BagSearchBoxTemplate(_G.BagItemSearchBox)
        _G.BagItemSearchBox:SetWidth(120)

        local autoSort = _G.BagItemAutoSortButton
        autoSort:SetSize(26, 26)
        autoSort:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
        autoSort:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

        autoSort:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
        autoSort:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)

        local iconBorder = autoSort:CreateTexture(nil, "BACKGROUND")
        iconBorder:SetPoint("TOPLEFT", autoSort, -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", autoSort, 1, -1)
        iconBorder:SetColorTexture(0, 0, 0)
    else
        _G.hooksecurefunc("ContainerFrame_Update", Hook.ContainerFrame_Update)
    end
end
