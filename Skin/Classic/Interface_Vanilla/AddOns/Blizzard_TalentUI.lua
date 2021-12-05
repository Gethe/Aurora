local _, private = ...
if not private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ AddOns\Blizzard_TalentUI.lua ]]
--end

do --[[ AddOns\Blizzard_TalentUI.xml ]]
    function Skin.TalentTabTemplate(Button)
        Skin.CharacterFrameTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.TalentBranchTemplate(Texture)
    end
    function Skin.TalentArrowTemplate(Texture)
    end
    function Skin.TalentButtonTemplate(Button)
        Skin.FrameTypeItemButton(Button)

        local name = Button:GetName()
        _G[name.."Slot"]:Hide()
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
    local portrait, tl, tr, bl, br = PlayerTalentFrame:GetRegions()
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
            x = 72,
            y = 327,
        },
        BottomLeft = {
            x = 286,
            y = 163,
        },
        BottomRight = {
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

    _G.PlayerTalentFramePointsLeft:Hide()
    _G.PlayerTalentFramePointsMiddle:Hide()
    _G.PlayerTalentFramePointsRight:Hide()

    _G.PlayerTalentFrameSpentPoints:SetPoint("TOP", _G.PlayerTalentFrameTitleText, "BOTTOM", 0, 5)

    Skin.UIPanelCloseButton(_G.PlayerTalentFrameCloseButton)
    Skin.UIPanelButtonTemplate(_G.PlayerTalentFrameCancelButton)

    Skin.TalentTabTemplate(_G.PlayerTalentFrameTab1)
    Skin.TalentTabTemplate(_G.PlayerTalentFrameTab2)
    Skin.TalentTabTemplate(_G.PlayerTalentFrameTab3)
    Skin.TalentTabTemplate(_G.PlayerTalentFrameTab4)
    Skin.TalentTabTemplate(_G.PlayerTalentFrameTab5)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.PlayerTalentFrameTab1,
        _G.PlayerTalentFrameTab2,
        _G.PlayerTalentFrameTab3,
        _G.PlayerTalentFrameTab4,
        _G.PlayerTalentFrameTab5,
    })

    _G.PlayerTalentFrameScrollFrame:ClearAllPoints()
    _G.PlayerTalentFrameScrollFrame:SetPoint("TOPLEFT", bg, 5, -45)
    _G.PlayerTalentFrameScrollFrame:SetPoint("BOTTOMRIGHT", bg, -25, 30)
    Skin.UIPanelScrollFrameTemplate(_G.PlayerTalentFrameScrollFrame)
    local top, bottom = _G.PlayerTalentFrameScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    for i = 1, _G.MAX_NUM_TALENTS do
        Skin.TalentButtonTemplate(_G["PlayerTalentFrameTalent"..i])
    end
end
