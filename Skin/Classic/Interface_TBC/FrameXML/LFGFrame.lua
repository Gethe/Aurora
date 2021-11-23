local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\LFGFrame.lua ]]
    Hook.LFGFrameMixin = {}
    function Hook.LFGFrameMixin:UpdateActivityIcon(i)
        local activityIcon = self.ActivityIcon[i]
        if activityIcon:GetTexture() then
            activityIcon:SetTexCoord(0.03125, 0.78125, 0.03125, 0.703125)
        else
            activityIcon:SetTexture([[Interface\LFGFrame\LFGFrame-SearchIcon-Background]])
            activityIcon:SetTexCoord(0.078125, 0.828125, 0.078125, 0.75)
        end
    end
end

--do --[[ FrameXML\LFGFrame.xml ]]
--end

function private.FrameXML.LFGFrame()
    ----====####$$$$%%%%$$$$####====----
    --              LFGFrame              --
    ----====####$$$$%%%%$$$$####====----
    local LFGParentFrame = _G.LFGParentFrame

    Skin.FrameTypeFrame(LFGParentFrame)
    LFGParentFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    _G.LFGParentFrameIcon:Hide()
    _G.LFGParentFrameBackground:Hide()

    local bg = LFGParentFrame:GetBackdropTexture("bg")
    _G.LFGParentFrameTitle:ClearAllPoints()
    _G.LFGParentFrameTitle:SetPoint("TOPLEFT", bg)
    _G.LFGParentFrameTitle:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    --------------
    -- LFMFrame --
    --------------

    --------------
    -- LFGFrame --
    --------------
    local LFGFrame = _G.LFGFrame
    Util.Mixin(LFGFrame, Hook.LFGFrameMixin)

    _G.LFGSearchBg1:Hide()
    _G.LFGSearchBg2:Hide()
    _G.LFGSearchBg3:Hide()

    for i = 1, 3 do
        local tex = LFGFrame:CreateTexture(nil, "BACKGROUND")
        tex:SetPoint("TOPLEFT", LFGFrame.ActivityIcon[i], -1, 1)
        tex:SetPoint("BOTTOMRIGHT", LFGFrame.ActivityIcon[i], 1, -1)
        tex:SetColorTexture(0, 0, 0)

        LFGFrame.ActivityIcon[i]:SetSize(48, 43)
        LFGFrame.ActivityIcon[i]:SetPoint("TOPLEFT", LFGFrame.TypeDropDown[i], "TOPRIGHT", 0, -6)
        Skin.UIDropDownMenuTemplate(LFGFrame.TypeDropDown[i])
        Skin.UIDropDownMenuTemplate(LFGFrame.ActivityDropDown[i])
    end

    Skin.InputBoxInstructionsTemplate(LFGFrame.Comment)
    Skin.UIPanelButtonTemplate(_G.LFGFrameClearAllButton)
    _G.LFGFrameClearAllButton:SetPoint("BOTTOMLEFT", bg, 5, 5)
    Skin.UIPanelButtonTemplate(LFGFrame.PostButton)
    LFGFrame.PostButton:SetPoint("BOTTOMRIGHT", bg, -5, 5)

    ----------
    -- Misc --
    ----------
    local closeButton = select(3, LFGParentFrame:GetChildren())
    Skin.UIPanelCloseButton(closeButton)
    Skin.CharacterFrameTabButtonTemplate(_G.LFGParentFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.LFGParentFrameTab2)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.LFGParentFrameTab1,
        _G.LFGParentFrameTab2,
    })
end
