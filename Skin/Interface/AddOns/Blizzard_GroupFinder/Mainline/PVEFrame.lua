local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\PVEFrame.lua ]]
    function Hook.GroupFinderFrame_SelectGroupButton(index)
        for i = 1, 3 do
            local button = _G.GroupFinderFrame["groupButton"..i]
            if i == index then
                button.bg:Show()
            else
                button.bg:Hide()
            end
        end
    end
end

do --[[ FrameXML\PVEFrame.xml ]]
    function Skin.GroupFinderGroupButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 0,
            top = -3,
            bottom = -5,
        })

        local bg = Button:GetBackdropTexture("bg")
        Button.bg:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        Button.bg:SetAllPoints(bg)
        Button.bg:Hide()

        Button.ring:Hide()
        Button.CircleMask:Hide()
        Base.CropIcon(Button.icon)
    end
end

function private.FrameXML.PVEFrame()
    _G.hooksecurefunc("GroupFinderFrame_SelectGroupButton", Hook.GroupFinderFrame_SelectGroupButton)

    local PVEFrame = _G.PVEFrame
    Skin.PortraitFrameTemplate(PVEFrame)

    _G.PVEFrameBlueBg:SetAlpha(0)
    _G.PVEFrameTLCorner:SetAlpha(0)
    _G.PVEFrameTRCorner:SetAlpha(0)
    _G.PVEFrameBRCorner:SetAlpha(0)
    _G.PVEFrameBLCorner:SetAlpha(0)
    _G.PVEFrameLLVert:SetAlpha(0)
    _G.PVEFrameRLVert:SetAlpha(0)
    _G.PVEFrameBottomLine:SetAlpha(0)
    _G.PVEFrameTopLine:SetAlpha(0)
    _G.PVEFrameTopFiligree:SetAlpha(0)
    _G.PVEFrameBottomFiligree:SetAlpha(0)

    Skin.InsetFrameTemplate(PVEFrame.Inset)
    local tabs = {}
    for i = 1, 4 do
        local tab = PVEFrame["tab"..i]
        if tab then
            Skin.PanelTabButtonTemplate(tab)
            tabs[#tabs + 1] = tab
        end
    end
    if #tabs > 0 then
        Util.PositionRelative("TOPLEFT", PVEFrame, "BOTTOMLEFT", 20, -1, 1, "Right", tabs)
    end

    local GroupFinderFrame = _G.GroupFinderFrame
    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton1)
    GroupFinderFrame.groupButton1.icon:SetTexture([[Interface\Icons\INV_Helmet_08]])

    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton2)
    GroupFinderFrame.groupButton2:SetPoint("LEFT", GroupFinderFrame.groupButton1)
    GroupFinderFrame.groupButton2.icon:SetTexture([[Interface\Icons\Icon_Scenarios]])

    Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton3)
    GroupFinderFrame.groupButton3:SetPoint("LEFT", GroupFinderFrame.groupButton2)
    GroupFinderFrame.groupButton3.icon:SetTexture([[Interface\Icons\INV_Helmet_06]])

    if GroupFinderFrame.groupButton4 then
        Skin.GroupFinderGroupButtonTemplate(GroupFinderFrame.groupButton4)
    end

    _G.LFGListPVEStub:SetWidth(339)
    PVEFrame.shadows:SetAlpha(0)
end
