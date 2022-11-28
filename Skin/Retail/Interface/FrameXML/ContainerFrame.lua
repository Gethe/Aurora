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
    function Hook.ContainerFrame_GenerateFrame(frame, size, id)
        if id > _G.NUM_BAG_FRAMES then
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

        if bagID == 0 then
            _G.BagItemSearchBox:ClearAllPoints()
            _G.BagItemSearchBox:SetPoint("TOPLEFT", self, 20, -35)
            _G.BagItemAutoSortButton:ClearAllPoints()
            _G.BagItemAutoSortButton:SetPoint("TOPRIGHT", self, -16, -31)
        end

        for i = 1, self.size do
            local itemButton = _G[name.."Item"..i]
            local slotID = itemButton:GetID()
            local _, _, _, quality, _, _, link = _G.C_Container.GetContainerItemInfo(bagID, slotID)

            if not itemButton._auroraIconBorder then
                itemButton._isKey = bagID == _G.KEYRING_CONTAINER
                Skin.ContainerFrameItemButtonTemplate(itemButton)

                Hook.SetItemButtonQuality(itemButton, quality, link)
            end

            if link then
                local _, _, _, _, _, _, _, _, _, _, _, itemClassID = _G.GetItemInfo(link)
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

        Base.CropIcon(ItemButton.icon)

        local name = ItemButton:GetName()
        ItemButton._questTexture = _G[name.."IconQuestTexture"]
        Base.CropIcon(ItemButton._questTexture)
        Base.CropIcon(ItemButton.NewItemTexture)
        ItemButton.BattlepayItemTexture:SetTexCoord(0.203125, 0.78125, 0.203125, 0.78125)
        ItemButton.BattlepayItemTexture:SetAllPoints()
    end
    function Skin.ContainerFrameCurrencyBorderTemplate(Frame)
    end
    function Skin.ContainerMoneyFrameTemplate(Frame)
        Skin.ContainerFrameCurrencyBorderTemplate(Frame.Border)
    end
    function Skin.ContainerFrameTemplate(Frame)
        Skin.PortraitFrameFlatTemplate(Frame)
        local bg = Frame.NineSlice:GetBackdropTexture("bg")

        for i = 1, 36 do
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
    end
    function Skin.ContainerFrameBackpackTemplate(Frame)
        Skin.ContainerFrameTemplate(Frame)
        Skin.ContainerMoneyFrameTemplate(Frame.MoneyFrame)
    end
end

function private.FrameXML.ContainerFrame()
    if private.disabled.bags then return end
    _G.hooksecurefunc("ContainerFrame_GenerateFrame", Hook.ContainerFrame_GenerateFrame)


    Skin.ContainerFrameBackpackTemplate(_G.ContainerFrame1)
    for i = 2, 13 do
        Skin.ContainerFrameTemplate(_G["ContainerFrame"..i])
    end

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
end
