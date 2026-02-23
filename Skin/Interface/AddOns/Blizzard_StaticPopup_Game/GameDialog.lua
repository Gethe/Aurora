local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals tinsert max

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ AddOns\Blizzard_StaticPopup_Game\GameDialog.lua ]]
--end

do --[[ AddOns\Blizzard_StaticPopup_Game\GameDialog.lua ]]
    function Skin.StaticPopupButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
    end

    function Skin.StaticPopupTemplate(Frame)
        if ((not Frame) and private.isDev) then
            _G.print("ReportError: Frame is nil in StaticPopupTemplate - Report to Aurora developers.")
            return
        end
        local background = Frame.BG -- did 11.2.7 remove BG from StaticPopupTemplate??
        background.Top:SetTexture("")
        -- background.Bottom:SetTexture("")
        -- Skin.DialogBorderTemplate(border)

        local ButtonContainer = Frame.ButtonContainer
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button1)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button2)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button3)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button4)

        Skin.StaticPopupButtonTemplate(Frame.ExtraButton)
        Skin.StaticPopupButtonTemplate(Frame.CloseButton)

        local Buttons = ButtonContainer.Buttons
        for i = 1, #Buttons do
            Skin.StaticPopupButtonTemplate(Buttons[i])
        end

        -- EditBox now uses parentKey (not global string lookup) and TooltipBackdropTemplate
        -- (no Left/Right/Middle textures), so FrameTypeEditBox handles it directly.
        if Frame.EditBox then
            Skin.FrameTypeEditBox(Frame.EditBox)
        end

        Skin.SmallMoneyFrameTemplate(Frame.MoneyFrame)
        Skin.MoneyInputFrameTemplate(Frame.MoneyInputFrame)

        local ItemFrame = Frame.ItemFrame
        local nameFrame = ItemFrame.NameFrame
        Skin.FrameTypeFrame(ItemFrame)
        nameFrame:Hide()

        Skin.FrameTypeItemButton(ItemFrame.Item)
        ItemFrame.Item.IconBorder:Hide()
        -- ItemFrame.icon → ItemFrame.Item (ItemButton) in WoW 11
        local nameBG = _G.CreateFrame("Frame", nil, ItemFrame)
        nameBG:SetPoint("TOPLEFT", ItemFrame.Item, "TOPRIGHT", 2, 1)
        nameBG:SetPoint("BOTTOMLEFT", ItemFrame.Item, "BOTTOMRIGHT", 2, -1)
        nameBG:SetPoint("RIGHT", -4, 0)
        Base.SetBackdrop(nameBG, Color.frame)
    end
end

function private.FrameXML.Blizzard_StaticPopup_Game_GameDialog()
    Skin.StaticPopupTemplate(_G.StaticPopup1)
    Skin.StaticPopupTemplate(_G.StaticPopup2)
    Skin.StaticPopupTemplate(_G.StaticPopup3)
    Skin.StaticPopupTemplate(_G.StaticPopup4)
end
