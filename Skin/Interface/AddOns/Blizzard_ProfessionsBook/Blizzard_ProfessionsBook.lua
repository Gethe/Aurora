local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- FIXME -- move to others..
-- local F, C = _G.unpack(private.Aurora)


do --[[ AddOns\Blizzard_ProfessionsBook ]]
    function Skin.ProfessionButtonTemplate(CheckButton)
        Base.CropIcon(CheckButton.IconTexture, CheckButton)

        local nameFrame = _G[CheckButton:GetName().."NameFrame"]
        nameFrame:SetTexture([[Interface\Spellbook\Spellbook-Parts]])
        nameFrame:SetTexCoord(0.31250000, 0.96484375, 0.37109375, 0.52343750)
        nameFrame:SetDesaturated(true)
        nameFrame:SetAlpha(1)
        nameFrame:SetSize(167, 39)
        nameFrame:SetPoint("LEFT", CheckButton.iconTexture, "RIGHT", -2, 0)

        Base.CropIcon(CheckButton:GetPushedTexture())
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
    function Skin.ProfessionStatusBarTemplate(StatusBar)
        local name = StatusBar:GetName()
        Skin.FrameTypeStatusBar(StatusBar)
        StatusBar:SetStatusBarColor(Color.green:GetRGB())

        StatusBar:SetSize(115, 12)
        StatusBar.rankText:SetPoint("CENTER")

        _G[name.."Left"]:Hide()
        StatusBar.capRight:SetAlpha(0)

        _G[name.."BGLeft"]:Hide()
        _G[name.."BGMiddle"]:Hide()
        _G[name.."BGRight"]:Hide()
    end
    function Skin.PrimaryProfessionTemplate(Frame)
        local name = Frame:GetName()

        Frame.professionName:SetPoint("TOPLEFT", Frame.icon, "TOPRIGHT", 12, 0)
        Frame.missingHeader:SetTextColor(Color.white:GetRGB())
        Frame.missingText:SetTextColor(Color.grayLight:GetRGB())
        _G[name.."IconBorder"]:Hide()

        Frame.icon:ClearAllPoints()
        Frame.icon:SetPoint("TOPLEFT", 6, -6)
        Frame.icon:SetSize(81, 81)
        Base.CropIcon(Frame.icon, Frame)

        Skin.ProfessionButtonTemplate(Frame.SpellButton2)
        Frame.SpellButton2:SetPoint("TOPRIGHT", -109, 0)
        Skin.ProfessionButtonTemplate(Frame.SpellButton1)
        Frame.SpellButton1:SetPoint("TOPLEFT", Frame.SpellButton2, "BOTTOMLEFT", 0, -3)
        Skin.ProfessionStatusBarTemplate(Frame.statusBar)
        Frame.statusBar:ClearAllPoints()
        Frame.statusBar:SetPoint("BOTTOMLEFT", Frame.icon, "BOTTOMRIGHT", 9, 5)

        Frame.UnlearnButton:ClearAllPoints()
        Frame.UnlearnButton:SetPoint("BOTTOMRIGHT", Frame.icon)
    end
    function Skin.SecondaryProfessionTemplate(Button)
        Skin.ProfessionButtonTemplate(Button.SpellButton1)
        Skin.ProfessionButtonTemplate(Button.SpellButton2)
        Skin.ProfessionStatusBarTemplate(Button.statusBar)
        Button.statusBar:SetPoint("BOTTOMLEFT", -10, 5)

        Button.rank:SetPoint("BOTTOMLEFT", Button.statusBar, "TOPLEFT", 3, 4)
        Button.missingHeader:SetTextColor(Color.white:GetRGB())
        Button.missingText:SetTextColor(Color.grayLight:GetRGB())
    end
end

function private.AddOns.Blizzard_ProfessionsBook()
    -- local ProfessionsContentFrame = _G.ProfessionsContentFrame
    -- Skin.ProfessionsContentFrameTemplate(ProfessionsContentFrame)
    local ProfessionsBookFrame = _G.ProfessionsBookFrame
    Skin.NineSlicePanelTemplate(ProfessionsBookFrame.NineSlice)
    ProfessionsBookFrame.NineSlice:SetFrameLevel(1)
    Skin.UIPanelCloseButton(ProfessionsBookFrame.CloseButton)
    _G.ProfessionsBookFrameTutorialButton:Hide()
    -- local bg = ProfessionsBookFrame.Bg
    -- local titleText = ProfessionsBookFrame.TitleContainer
    -- titleText:ClearAllPoints()
    -- titleText:SetPoint("TOPLEFT", bg)
    -- titleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    local ProfessionsBookFrameInset = _G.ProfessionsBookFrameInset
    Skin.NineSlicePanelTemplate(ProfessionsBookFrameInset.NineSlice)
    Skin.PrimaryProfessionTemplate(_G.PrimaryProfession1)
    Skin.PrimaryProfessionTemplate(_G.PrimaryProfession2)
    Skin.SecondaryProfessionTemplate(_G.SecondaryProfession1)
    Skin.SecondaryProfessionTemplate(_G.SecondaryProfession2)
    Skin.SecondaryProfessionTemplate(_G.SecondaryProfession3)
end
