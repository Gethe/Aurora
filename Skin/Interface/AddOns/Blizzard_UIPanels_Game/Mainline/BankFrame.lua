local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
-- local Hook = Aurora.Hook
local Util = Aurora.Util

-- FIXME
-- do --[[ FrameXML\BankFrame.lua ]]
--     -- function Hook.BankFrameItemButton_Update(button)
--     --     local bagID = button.isBag and -4 or button:GetParent():GetID()
--     --     local slotID = button:GetID()

--     --     local info = _G.C_Container.GetContainerItemInfo(bagID, slotID)
--     --     if not button._auroraIconBorder then
--     --         if button.isBag then
--     --             Skin.BankItemButtonBagTemplate(button)
--     --         else
--     --             Skin.BankItemButtonGenericTemplate(button)
--     --         end
--     --         Hook.SetItemButtonQuality(button, info.quality, info.hyperlink)
--     --     end

--     --     if not button.isBag and button.IconQuestTexture:IsShown() then
--     --         button._auroraIconBorder:SetBackdropBorderColor(1, 1, 0)
--     --     end
--     -- end
-- end

do --[[ FrameXML\BankFrame.xml ]]
    function Skin.BankItemButtonGenericTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        ItemButton:SetBackdropOptions({
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false
        })
        ItemButton:SetBackdropColor(1, 1, 1, 0.75)
        Base.CropIcon(ItemButton:GetBackdropTexture("bg"))

        Base.CropIcon(ItemButton.IconQuestTexture)
    end
    function Skin.BankItemButtonBagTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        Base.CropIcon(ItemButton.SlotHighlightTexture)
    end
    Skin.ReagentBankItemButtonGenericTemplate = Skin.BankItemButtonGenericTemplate

    -- BlizzWTF: Why is this not shared with ContainerFrame?
    function Skin.BankAutoSortButtonTemplate(Button)
        Button:SetSize(26, 26)
        Button:SetNormalTexture([[Interface\Icons\INV_Pet_Broom]])
        Button:GetNormalTexture():SetTexCoord(.13, .92, .13, .92)

        Button:SetPushedTexture([[Interface\Icons\INV_Pet_Broom]])
        Button:GetPushedTexture():SetTexCoord(.08, .87, .08, .87)

        local iconBorder = Button:CreateTexture(nil, "BACKGROUND")
        iconBorder:SetPoint("TOPLEFT", Button, -1, 1)
        iconBorder:SetPoint("BOTTOMRIGHT", Button, 1, -1)
        iconBorder:SetColorTexture(0, 0, 0)
    end
end

function private.FrameXML.BankFrame()
    if private.disabled.bags then return end
    if private.isRetail then
        _G.print("ReportError: BankFrame is not supported in Retail 11.2 - Report to Aurora developers.")
        return
        -- FIXLATER is it removed in 11.2?
        -- Skin.StaticPopupTemplate(_G.StaticPopup1)
        -- Skin.StaticPopupTemplate(_G.StaticPopup2)
        -- Skin.StaticPopupTemplate(_G.StaticPopup3)
        -- Skin.StaticPopupTemplate(_G.StaticPopup4)
    end
    -- FIXLATER is it removed in 11.2
    --  _G.hooksecurefunc("BankFrameItemButton_Update", Hook.BankFrameItemButton_Update)

    --[[ BankFrame ]]--
    local BankFrame = _G.BankFrame
    Skin.PortraitFrameTemplate(BankFrame)
    select(4, BankFrame:GetRegions()):Hide() -- Bank-Background
    Skin.PanelTabButtonTemplate(_G.BankFrameTab1)
    Skin.PanelTabButtonTemplate(_G.BankFrameTab2)
    Skin.PanelTabButtonTemplate(_G.BankFrameTab3)

    Util.PositionRelative("TOPLEFT", BankFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.BankFrameTab1,
        _G.BankFrameTab2,
        _G.BankFrameTab3,
    })

    Skin.BagSearchBoxTemplate(_G.BankItemSearchBox)
    Skin.BankAutoSortButtonTemplate(_G.BankItemAutoSortButton)

    local BankSlotsFrame = _G.BankSlotsFrame
    BankSlotsFrame:DisableDrawLayer("BORDER")
    select(9, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- ITEMSLOTTEXT
    select(10, BankSlotsFrame:GetRegions()):SetDrawLayer("OVERLAY") -- BAGSLOTTEXT

    Skin.UIPanelButtonTemplate(_G.BankFramePurchaseButton)
    Skin.ThinGoldEdgeTemplate(_G.BankFrameMoneyFrameBorder)


    --[[ ReagentBankFrame ]]--
    local ReagentBankFrame = _G.ReagentBankFrame
    ReagentBankFrame:DisableDrawLayer("BACKGROUND")
    ReagentBankFrame:DisableDrawLayer("BORDER")
    ReagentBankFrame:DisableDrawLayer("ARTWORK")

    Skin.UIPanelButtonTemplate(ReagentBankFrame.DespositButton)

    ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
    Skin.UIPanelButtonTemplate(_G.ReagentBankFrameUnlockInfoPurchaseButton) -- BlizzWTF: no parentKey?
end
