local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\Blizzard_LFGFrame.lua ]]
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

--do --[[ FrameXML\Blizzard_LFGFrame.xml ]]
--end

function private.AddOns.Blizzard_LookingForGroupUI()
    ----====####$$$$%%%%$$$$####====----
    --         LFGParentFrame         --
    ----====####$$$$%%%%$$$$####====----

    local LFGParentFrame = _G.LFGParentFrame
    Skin.FrameTypeFrame(LFGParentFrame)
    LFGParentFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local closeButton = LFGParentFrame:GetChildren()
    Skin.UIPanelCloseButton(closeButton)

    local bg = LFGParentFrame:GetBackdropTexture("bg")
    Skin.CharacterFrameTabButtonTemplate(_G.LFGParentFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.LFGParentFrameTab2)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.LFGParentFrameTab1,
        _G.LFGParentFrameTab2,
    })

    _G.LFGParentFramePortrait:Hide()


    ----====####$$$$%%%%$$$$####====----
    --           LFGListing           --
    ----====####$$$$%%%%$$$$####====----
    _G.LFGListingFrameFrameBackgroundTop:Hide()
    _G.LFGListingFrame.BackgroundArt:Hide()
    _G.LFGListingFrameFrameBackgroundBottom:Hide()

    _G.LFGListingFrameFrameTitle:ClearAllPoints()
    _G.LFGListingFrameFrameTitle:SetPoint("TOPLEFT", bg)
    _G.LFGListingFrameFrameTitle:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelButtonTemplate(_G.LFGListingFrame.BackButton)
    Skin.UIPanelButtonTemplate(_G.LFGListingFrame.PostButton)


    ----====####$$$$%%%%%$$$$####====----
    --            LFGBrowse            --
    ----====####$$$$%%%%%$$$$####====----

    _G.LFGBrowseFrameFrameBackgroundTop:Hide()
    _G.LFGBrowseFrameFrameBackgroundMiddle:Hide()
    _G.LFGBrowseFrame.BackgroundArt:Hide()
    _G.LFGBrowseFrameFrameBackgroundBottom:Hide()

    _G.LFGBrowseFrameFrameTitle:ClearAllPoints()
    _G.LFGBrowseFrameFrameTitle:SetPoint("TOPLEFT", bg)
    _G.LFGBrowseFrameFrameTitle:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIDropDownMenuTemplate(_G.LFGBrowseFrame.CategoryDropDown)
    Skin.UIDropDownMenuTemplate(_G.LFGBrowseFrame.ActivityDropDown)
    Skin.WowScrollBoxList(_G.LFGBrowseFrame.ScrollBox)
    Skin.WowClassicScrollBar(_G.LFGBrowseFrame.ScrollBar)
    Skin.RefreshButtonTemplate(_G.LFGBrowseFrame.RefreshButton)
    Skin.UIPanelButtonTemplate(_G.LFGBrowseFrame.SendMessageButton)
    Skin.UIPanelButtonTemplate(_G.LFGBrowseFrame.GroupInviteButton)
end
