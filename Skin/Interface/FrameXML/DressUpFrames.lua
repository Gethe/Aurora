local _, private = ...
if private.shouldSkip() then return end

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
        - AuctionUI - classic
        - AuctionHouseUI - retail
        - VoidStorageUI - retail
    ]]
    local SideDressUpFrame = _G.SideDressUpFrame
    Skin.FrameTypeFrame(SideDressUpFrame)

    local top, bottom, left, right = SideDressUpFrame:GetRegions()
    top:Hide()
    bottom:Hide()
    left:Hide()
    right:Hide()

    if private.isRetail then
        SideDressUpFrame.ModelScene:SetPoint("TOPLEFT")
        SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT")

        Skin.UIPanelButtonTemplate(SideDressUpFrame.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpFrameCloseButton)
        select(5, _G.SideDressUpFrameCloseButton:GetRegions()):Hide()
    else
        _G.SideDressUpModel:SetPoint("TOPLEFT")
        _G.SideDressUpModel:SetPoint("BOTTOMRIGHT")
        _G.SideDressUpModel.controlFrame:SetPoint("TOP", 0, -5)

        Skin.UIPanelButtonTemplate(_G.SideDressUpModel.ResetButton)
        Skin.UIPanelCloseButton(_G.SideDressUpModelCloseButton)
        select(5, _G.SideDressUpModelCloseButton:GetRegions()):Hide()
    end



    ----------------------------------
    -- TransmogAndMountDressupFrame --
    ----------------------------------
    if private.isRetail then
        local TransmogAndMountDressupFrame = _G.TransmogAndMountDressupFrame
        Skin.UICheckButtonTemplate(TransmogAndMountDressupFrame.ShowMountCheckButton)
        TransmogAndMountDressupFrame.ShowMountCheckButton:ClearAllPoints()
        TransmogAndMountDressupFrame.ShowMountCheckButton:SetPoint("BOTTOMRIGHT", -5, 5)
    end


    ------------------
    -- DressUpFrame --
    ------------------
    local DressUpFrame = _G.DressUpFrame

    if private.isRetail then
        Skin.ButtonFrameTemplateMinimizable(DressUpFrame)
        Skin.WardrobeOutfitDropDownTemplate(DressUpFrame.OutfitDropDown)
        Skin.MaximizeMinimizeButtonFrameTemplate(DressUpFrame.MaxMinButtonFrame)
        Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)

        local ModelScene = DressUpFrame.ModelScene
        ModelScene:SetPoint("TOPLEFT", 0, -private.FRAME_TITLE_HEIGHT)
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
    else
        Skin.FrameTypeFrame(DressUpFrame)
        DressUpFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local bg = DressUpFrame:GetBackdropTexture("bg")
        Skin.UIPanelCloseButton(_G.DressUpFrameCloseButton)
        Skin.UIPanelButtonTemplate(_G.DressUpFrameCancelButton)
        _G.DressUpFrameCancelButton:SetFrameLevel(_G.DressUpFrameCancelButton:GetFrameLevel() + 1)
        Skin.UIPanelButtonTemplate(DressUpFrame.ResetButton)
        DressUpFrame.ResetButton:SetFrameLevel(DressUpFrame.ResetButton:GetFrameLevel() + 1)
        Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -15, 15, 5, "Left", {
            _G.DressUpFrameCancelButton,
            DressUpFrame.ResetButton,
        })

        DressUpFrame.DressUpModel:SetPoint("TOPLEFT", bg, 0, -private.FRAME_TITLE_HEIGHT)
        DressUpFrame.DressUpModel:SetPoint("BOTTOMRIGHT", bg)
        _G.DressUpModelFrameRotateRightButton:SetPoint("TOPLEFT", bg, 5, -5)
        Skin.NavButtonNext(_G.DressUpModelFrameRotateRightButton)
        Skin.NavButtonPrevious(_G.DressUpModelFrameRotateLeftButton)

        local portrait, tl, tr, bl, br, _, desc = DressUpFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()
        desc:Hide()


        local titleText = DressUpFrame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT", bg)
        titleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local textures = {
            BGTopLeft = {
                point = "TOPLEFT",
                x = 271,
                y = 326,
            },
            BGTopRight = {
                x = 66,
                y = 326,
            },
            BGBottomLeft = {
                x = 271,
                y = 164,
            },
            BGBottomRight = {
                x = 66,
                y = 164,
            },
        }
        for name, info in next, textures do
            local tex = DressUpFrame[name]
            if info.point then
                tex:SetPoint(info.point, bg)
            end
            tex:SetSize(info.x, info.y)
            tex:SetDrawLayer("BACKGROUND", 3)
            tex:SetAlpha(0.7)
        end
    end
end
