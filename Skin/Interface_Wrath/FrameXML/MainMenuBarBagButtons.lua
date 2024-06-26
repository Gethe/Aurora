local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\MainMenuBarBagButtons.lua ]]
--end

do --[[ FrameXML\MainMenuBarBagButtons.xml ]]
    function Skin.BagSlotButtonTemplate(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
        Base.CropIcon(ItemButton:GetCheckedTexture())
    end
end

function private.FrameXML.MainMenuBarBagButtons()
    if private.disabled.mainmenubar then return end

    Skin.FrameTypeItemButton(_G.MainMenuBarBackpackButton)
    Base.CropIcon(_G.MainMenuBarBackpackButton:GetCheckedTexture())

    Skin.BagSlotButtonTemplate(_G.CharacterBag0Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag1Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag2Slot)
    Skin.BagSlotButtonTemplate(_G.CharacterBag3Slot)


    local KeyRingButton = _G.KeyRingButton
    Base.SetBackdrop(KeyRingButton, Color.frame)
    Base.SetHighlight(KeyRingButton)

    local normal = KeyRingButton:GetNormalTexture()
    normal:SetTexture([[Interface\Icons\Inv_Misc_Key_13]])
    --normal:SetTexCoord(0.1875, 0.8125, 0.0625, 0.9375)
    --normal:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
    normal:SetTexCoord(0.625, 0.03125, 0.03125, 0.84375, 0.921875, 0.171875, 0.34375, 0.984375)
    normal:ClearAllPoints()
    normal:SetPoint("TOPLEFT", 1, -1)
    normal:SetPoint("BOTTOMRIGHT", -1, 1)

    local pushed = KeyRingButton:GetPushedTexture()
    pushed:SetTexture([[Interface\Icons\Inv_Misc_Key_13]])
    --pushed:SetTexCoord(0.09375, 0.46875, 0.046875, 0.5625)
    pushed:SetTexCoord(0.625, 0.03125, 0.03125, 0.84375, 0.921875, 0.171875, 0.34375, 0.984375)
    pushed:SetAllPoints(normal)

    KeyRingButton:GetHighlightTexture():SetTexture("")
end
