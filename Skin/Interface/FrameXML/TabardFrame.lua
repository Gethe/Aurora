local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ FrameXML\TabardFrame.lua ]]
--end

do --[[ FrameXML\TabardFrame.xml ]]
    function Skin.TabardFrameCustomizeTemplate(Frame)
        local name = Frame:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
        Skin.NavButtonPrevious(_G[name.."LeftButton"])
        Skin.NavButtonNext(_G[name.."RightButton"])
    end
end

function private.FrameXML.TabardFrame()
    local TabardFrame = _G.TabardFrame

    local bg
    if private.isRetail then
        Skin.ButtonFrameTemplate(TabardFrame)
        for i = 4, 13 do -- OuterFrame textures
            _G.select(i, TabardFrame:GetRegions()):Hide()
        end
        _G.TabardFrameEmblemTopRight:SetPoint("TOPRIGHT", 15, -50)
        bg = TabardFrame.NineSlice:GetBackdropTexture("bg")
    else
        Skin.FrameTypeFrame(TabardFrame)
        TabardFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        for i = 1, 6 do -- portrait and background
            _G.select(i, TabardFrame:GetRegions()):Hide()
        end
        for i = 7, 16 do -- OuterFrame textures
            _G.select(i, TabardFrame:GetRegions()):Hide()
        end
        bg = TabardFrame:GetBackdropTexture("bg")
    end

    _G.TabardFrameNameText:ClearAllPoints()
    _G.TabardFrameNameText:SetPoint("TOPLEFT", bg)
    _G.TabardFrameNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    _G.TabardFrameGreetingText:ClearAllPoints()
    _G.TabardFrameGreetingText:SetPoint("TOPLEFT", bg, 50, -private.FRAME_TITLE_HEIGHT)
    _G.TabardFrameGreetingText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", -50, -(private.FRAME_TITLE_HEIGHT + 40))

    Skin.NavButtonPrevious(_G.TabardCharacterModelRotateLeftButton)
    Skin.NavButtonNext(_G.TabardCharacterModelRotateRightButton)
    _G.TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", _G.TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

    Util.HideNineSlice(_G.TabardFrameCostFrame)
    Skin.SmallMoneyFrameTemplate(_G.TabardFrameCostMoneyFrame)

    _G.TabardFrameCustomizationBorder:Hide()
    _G.TabardFrameCustomization1:ClearAllPoints()
    _G.TabardFrameCustomization1:SetPoint("BOTTOMRIGHT", bg, -3, 140)
    for i = 1, 5 do
        Skin.TabardFrameCustomizeTemplate(_G["TabardFrameCustomization"..i])
    end

    if private.isRetail then
        Skin.InsetFrameTemplate(_G.TabardFrameMoneyInset)
        Skin.ThinGoldEdgeTemplate(_G.TabardFrameMoneyBg)
    else
        local moneyBG = _G.CreateFrame("Frame", nil, TabardFrame)
        Base.SetBackdrop(moneyBG, Color.frame)
        moneyBG:SetBackdropBorderColor(1, 0.95, 0.15)
        moneyBG:SetPoint("BOTTOMLEFT", bg, 5, 5)
        moneyBG:SetSize(160, 22)
        Skin.SmallMoneyFrameTemplate(_G.TabardFrameMoneyFrame)
        _G.TabardFrameMoneyFrame:SetPoint("BOTTOMRIGHT", moneyBG, 7, 5)

        Skin.UIPanelCloseButton(_G.TabardFrameCloseButton)
    end

    Skin.UIPanelButtonTemplate(_G.TabardFrameAcceptButton)
    Skin.UIPanelButtonTemplate(_G.TabardFrameCancelButton)
    Util.PositionRelative("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.TabardFrameAcceptButton,
        _G.TabardFrameCancelButton,
    })
end
