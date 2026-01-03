local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
-- local Hook = Aurora.Hook
local Skin = Aurora.Skin
local Color = Aurora.Color
-- local util = Aurora.util

do --[[ FrameXML\WardrobeOutfits.xml ]]
    function Skin.WardrobeOutfitButtonTemplate(Frame)
        local parent = Frame:GetParent()
        local selection = Frame.Selection
        selection:SetColorTexture(Color.gray.r, Color.gray.g, Color.gray.b, 0.5)
        selection:ClearAllPoints()
        selection:SetPoint("LEFT", parent, 1, 0)
        selection:SetPoint("RIGHT", parent, -1, 0)
        selection:SetPoint("TOP", 0, 0)
        selection:SetPoint("BOTTOM", 0, 0)

        local highlight = Frame.Highlight
        highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, .2)
        highlight:ClearAllPoints()
        highlight:SetPoint("LEFT", parent, 1, 0)
        highlight:SetPoint("RIGHT", parent, -1, 0)
        highlight:SetPoint("TOP", 0, 0)
        highlight:SetPoint("BOTTOM", 0, 0)

        Base.CropIcon(Frame.Icon)
    end
    function Skin.WardrobeOutfitDropDownTemplate(Frame)
        Skin.DropdownButton(Frame)

        local offsets = Frame:GetBackdropOption("offsets")
        Frame:SetBackdropOption("offsets", {
            left = offsets.left,
            right = offsets.right,
            top = offsets.top,
            bottom = -1,
        })

        Skin.UIPanelButtonTemplate(Frame.SaveButton)
    end
end

function private.FrameXML.WardrobeOutfits()
    -- FIXBETA
    if private.isMidnight then return end
    local WardrobeOutfitEditFrame = _G.WardrobeOutfitEditFrame
    Skin.DialogBorderTemplate(WardrobeOutfitEditFrame.Border)

    local EditBox = WardrobeOutfitEditFrame.EditBox
    Skin.FrameTypeEditBox(EditBox)
    EditBox:SetBackdropOption("offsets", {
        left = -5,
        right = 3,
        top = 3,
        bottom = 3,
    })

    EditBox.LeftTexture:Hide()
    EditBox.RightTexture:Hide()
    EditBox.MiddleTexture:Hide()

    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.AcceptButton)
    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.CancelButton)
    Skin.UIPanelButtonTemplate(WardrobeOutfitEditFrame.DeleteButton)
end
