local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_ScrappingMachineUI.lua ]]
    Hook.ScrappingMachineItemSlotMixin = {}
    function Hook.ScrappingMachineItemSlotMixin:ClearSlot()
        if self._auroraIconOverlay then
            self._auroraIconBorder:SetBackdropBorderColor(Color.button, 1)
            self._auroraIconOverlay:Hide()
        end
    end
end

do --[[ AddOns\Blizzard_ScrappingMachineUI.xml ]]
    function Skin.ScrappingMachineItemSlot(Button)
        Util.Mixin(Button, Hook.ScrappingMachineItemSlotMixin)
        Base.CreateBackdrop(Button, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        Base.CropIcon(Button:GetBackdropTexture("bg"))
        Button:SetBackdropColor(1, 1, 1, 0.75)
        Button:SetBackdropBorderColor(Color.button, 1)
        Button._auroraIconBorder = Button

        Base.CropIcon(Button.Icon)
        Base.CropIcon(Button:GetHighlightTexture())
    end
end

function private.AddOns.Blizzard_ScrappingMachineUI()
    local ScrappingMachineFrame = _G.ScrappingMachineFrame

    -- TAINT-SAFE: ScrappingMachineFrame calls protected C_Scrapping.ScrapItems().
    -- The old Skin.ButtonFrameTemplate path tainted the frame hierarchy via
    -- BackdropMixin writes + NineSlicePanelTemplate + FrameTypeButton.
    Skin.TaintSafeButtonFrameTemplate(ScrappingMachineFrame)

    ScrappingMachineFrame.ItemSlots:GetRegions():Hide()
    ScrappingMachineFrame.ItemSlots:ClearAllPoints()
    ScrappingMachineFrame.ItemSlots:SetPoint("TOPLEFT", 93, -73)
    for button in ScrappingMachineFrame.ItemSlots.scrapButtons:EnumerateActive() do
        Skin.ScrappingMachineItemSlot(button)
    end

    -- TAINT-SAFE: ScrapButton triggers the protected scrap path
    Skin.TaintSafeUIPanelButtonTemplate(ScrappingMachineFrame.ScrapButton)
end
