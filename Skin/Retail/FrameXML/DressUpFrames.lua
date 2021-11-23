local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Util = Aurora.Util

function private.FrameXML.DressUpFrames()
    -----------------
    -- SideDressUp --
    -----------------

    --[[ Used with:
        - AuctionHouseUI
        - VoidStorageUI
    ]]
    local SideDressUpFrame = _G.SideDressUpFrame
    Skin.FrameTypeFrame(SideDressUpFrame)

    local top, bottom, left, right = SideDressUpFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    left:Hide()
    right:Hide()

    SideDressUpFrame.ModelScene:SetPoint("TOPLEFT")
    SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")

    Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
    Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
    select(5, _G.SideDressUpFrameCloseButton:GetRegions()):Hide()


    ----------------------------------
    -- TransmogAndMountDressupFrame --
    ----------------------------------
    local TransmogAndMountDressupFrame = _G.TransmogAndMountDressupFrame
    Skin.UICheckButtonTemplate(TransmogAndMountDressupFrame.ShowMountCheckButton)
    TransmogAndMountDressupFrame.ShowMountCheckButton:ClearAllPoints()
    TransmogAndMountDressupFrame.ShowMountCheckButton:SetPoint("BOTTOMRIGHT", -5, 5)


    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame

    Skin.ButtonFrameTemplateMinimizable(DressUpFrame)
    Skin.WardrobeOutfitDropDownTemplate(DressUpFrame.OutfitDropDown)
    Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)

    Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)

    local ModelScene = DressUpFrame.ModelScene
    ModelScene:SetPoint("TOPLEFT")
    ModelScene:SetPoint("BOTTOMRIGHT")

    local detailsButton = DressUpFrame.ToggleOutfitDetailsButton
    Base.CropIcon(detailsButton:GetNormalTexture())
    Base.CropIcon(detailsButton:GetPushedTexture())

    local settings = private.CLASS_BACKGROUND_SETTINGS[private.charClass.token] or private.CLASS_BACKGROUND_SETTINGS["DEFAULT"];
    local OutfitDetailsPanel = DressUpFrame.OutfitDetailsPanel
    local blackBG, classBG, frameBG = OutfitDetailsPanel:GetRegions()
    blackBG:SetPoint("TOPLEFT", 10, -19)
    classBG:SetPoint("TOPLEFT", blackBG, 1, -1)
    classBG:SetPoint("BOTTOMRIGHT", blackBG, -1, 1)
    classBG:SetDesaturation(settings.desaturation)
    classBG:SetAlpha(settings.alpha)
    frameBG:Hide()

    Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
    Util.PositionRelative("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -15, 15, 5, "Left", {
        _G.DressUpFrameCancelButton,
        DressUpFrame.ResetButton,
    })

    Skin.UIPanelButtonTemplate(DressUpFrame.LinkButton)
    DressUpFrame.LinkButton:SetPoint("BOTTOMLEFT", 15, 15)

    DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
    DressUpFrame.ModelBackground:SetDesaturation(settings.desaturation)
    DressUpFrame.ModelBackground:SetAlpha(settings.alpha)


    -- Raise the frame level of interactable child frames above the model frame.
    local newFrameLevel = ModelScene:GetFrameLevel() + 1
    DressUpFrame.OutfitDropDown:SetFrameLevel(newFrameLevel)
    DressUpFrame.MaximizeMinimizeFrame:SetFrameLevel(newFrameLevel)
    _G.DressUpFrameCancelButton:SetFrameLevel(newFrameLevel)
    DressUpFrame.ToggleOutfitDetailsButton:SetFrameLevel(newFrameLevel)
    DressUpFrame.ResetButton:SetFrameLevel(newFrameLevel)
    DressUpFrame.LinkButton:SetFrameLevel(newFrameLevel)
end
