local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ AddOns\Blizzard_TalentUI.lua ]]
--end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.PlayerTalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.PlayerTalentButtonTemplate(Button)
        Skin.TalentButtonTemplate(Button)
    end
end

function private.AddOns.Blizzard_TalentUI()
    local PlayerTalentFrame = _G.PlayerTalentFrame
    Skin.FrameTypeFrame(PlayerTalentFrame)
    PlayerTalentFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local bg = PlayerTalentFrame:GetBackdropTexture("bg")
    local portrait, _, tl, tr, bl, br = PlayerTalentFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local settings = private.CLASS_BACKGROUND_SETTINGS[private.charClass.token] or private.CLASS_BACKGROUND_SETTINGS["DEFAULT"];
    local textures = {
        TopLeft = {
            point = "TOPLEFT",
            x = 286, -- textureSize * (frameSize / fullBGSize)
            y = 327,
        },
        TopRight = {
            point = "TOPRIGHT",
            x = 72,
            y = 327,
        },
        BottomLeft = {
            point = "BOTTOMLEFT",
            x = 286,
            y = 163,
        },
        BottomRight = {
            point = "BOTTOMRIGHT",
            x = 72,
            y = 163,
        },
    }
    for name, info in next, textures do
        local specBG = _G["PlayerTalentFrameBackground"..name]
        if info.point then
            specBG:SetPoint(info.point, bg)
        end
        specBG:SetSize(info.x, info.y)
        specBG:SetDrawLayer("BACKGROUND", 3)
        specBG:SetDesaturation(settings.desaturation)
        specBG:SetAlpha(settings.alpha)
    end

    _G.PlayerTalentFrameTitleText:ClearAllPoints()
    _G.PlayerTalentFrameTitleText:SetPoint("TOPLEFT", bg)
    _G.PlayerTalentFrameTitleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.PlayerTalentFrameCloseButton)
    _G.PlayerTalentFrameRoleButton:SetPoint("TOPRIGHT", bg, -30, -8)

    _G.PlayerTalentFramePointsBar:SetPoint("LEFT", bg, 0, 0)
    _G.PlayerTalentFramePointsBar:SetPoint("RIGHT", bg, 0, 0)
    _G.PlayerTalentFramePointsBarBackground:Hide()
    _G.PlayerTalentFramePointsBarBorderLeft:Hide()
    _G.PlayerTalentFramePointsBarBorderMiddle:Hide()
    _G.PlayerTalentFramePointsBarBorderRight:Hide()

    _G.PlayerTalentFramePreviewBar:SetPoint("LEFT", bg, 0, 0)
    _G.PlayerTalentFramePreviewBar:SetPoint("RIGHT", bg, 0, 0)
    _G.PlayerTalentFramePreviewBarButtonBorder:Hide()
    Skin.UIPanelButtonTemplate(_G.PlayerTalentFrameResetButton)
    Skin.UIPanelButtonTemplate(_G.PlayerTalentFrameLearnButton)
    _G.PlayerTalentFramePreviewBarFiller:Hide()

    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab1)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab2)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab3)
    Skin.PlayerTalentTabTemplate(_G.PlayerTalentFrameTab4)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.PlayerTalentFrameTab1,
        _G.PlayerTalentFrameTab2,
        _G.PlayerTalentFrameTab3,
        _G.PlayerTalentFrameTab4,
    })

    _G.PlayerTalentFrameScrollFrame:ClearAllPoints()
    _G.PlayerTalentFrameScrollFrame:SetPoint("TOPLEFT", bg, 5, -45)
    _G.PlayerTalentFrameScrollFrame:SetPoint("BOTTOMRIGHT", PlayerTalentFramePointsBar, "TOPRIGHT", -25, 5)

    Skin.UIPanelScrollFrameTemplate(_G.PlayerTalentFrameScrollFrame)
    _G.PlayerTalentFrameScrollFrameBackgroundTop:Hide()
    _G.PlayerTalentFrameScrollFrameBackgroundBottom:Hide()

    for i = 1, _G.MAX_NUM_TALENTS do
        Skin.PlayerTalentButtonTemplate(_G["PlayerTalentFrameTalent"..i])
    end
end
