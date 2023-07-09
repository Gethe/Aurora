local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\SpellBookFrame.lua ]]
    function Hook.SpellButton_UpdateButton(self)
        if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

        local slot = _G.SpellBook_GetSpellBookSlot(self)
        if slot then
            if self.shine then
                local shine = self.shine
                shine:ClearAllPoints()
                shine:SetPoint("TOPLEFT", 3, -2)
                shine:SetPoint("BOTTOMRIGHT", -1, 1)
            end
        else
            self:SetBackdropBorderColor(Color.black:GetRGB())
        end
    end
    function Hook.SpellBookFrame_UpdateSkillLineTabs(self)
        local numSkillLineTabs = _G.GetNumSpellTabs()
        for i = 1, _G.MAX_SKILLLINE_TABS do
            local skillLineTab = _G["SpellBookSkillLineTab"..i]
            local prevTab = _G["SpellBookSkillLineTab"..i-1]
            if i <= numSkillLineTabs and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL then
                local _, _, _, _, isGuild, _, shouldHide = _G.GetSpellTabInfo(i)

                if not shouldHide then
                    -- Guild tab gets additional space
                    if prevTab then
                        if isGuild then
                            skillLineTab:SetPoint("TOPLEFT", prevTab, "BOTTOMLEFT", 0, -25)
                        elseif skillLineTab.isOffSpec and not prevTab.isOffSpec then
                            skillLineTab:SetPoint("TOPLEFT", prevTab, "BOTTOMLEFT", 0, -20)
                        else
                            skillLineTab:SetPoint("TOPLEFT", prevTab, "BOTTOMLEFT", 0, -5)
                        end
                    end
                end
            else
                _G["SpellBookSkillLineTab"..i.."Flash"]:Hide()
                skillLineTab:Hide()
            end
        end
    end
end

do --[[ FrameXML\SpellBookFrame.xml ]]
    function Skin.SpellBookSkillLineTabTemplate(CheckButton)
        Skin.SideTabTemplate(CheckButton)
    end
    function Skin.SpellBookFrameTabButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetButtonColor(Color.frame, Util.GetFrameAlpha(), false)

        Button:SetHeight(28)
        Button:SetHitRectInsets(0, 0, 0, 0)
        if private.isClassic then
            Button:SetNormalTexture("")
            Button:SetHighlightTexture("")
        else
            Button:ClearNormalTexture()
            Button:ClearHighlightTexture()
        end
        Button._auroraTabResize = true
    end
    function Skin.SpellButtonTemplate(CheckButton)
        local name = CheckButton:GetName()

        CheckButton.EmptySlot:Hide()
        CheckButton.SpellSubName:SetTextColor(Color.gray:GetRGB())

        Base.CropIcon(_G[name.."IconTexture"])
        Base.CreateBackdrop(CheckButton, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            }
        })
        CheckButton:SetBackdropColor(1, 1, 1, 0.75)
        CheckButton:SetBackdropBorderColor(Color.frame, 1)
        Base.CropIcon(CheckButton:GetBackdropTexture("bg"))

        local autoCast = _G[name.."AutoCastable"]
        autoCast:ClearAllPoints()
        autoCast:SetPoint("TOPLEFT")
        autoCast:SetPoint("BOTTOMRIGHT")
        autoCast:SetTexCoord(0.2344, 0.75, 0.25, 0.75)

        if private.isClassic then
            CheckButton:SetNormalTexture("")
        else
            CheckButton:ClearNormalTexture()
        end
        Base.CropIcon(CheckButton:GetPushedTexture())
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.FrameXML.SpellBookFrame()
    _G.hooksecurefunc("SpellButton_UpdateButton", Hook.SpellButton_UpdateButton)
    _G.hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", Hook.SpellBookFrame_UpdateSkillLineTabs)

    local SpellBookFrame = _G.SpellBookFrame
    Skin.FrameTypeFrame(SpellBookFrame)
    SpellBookFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local portrait, tl, tr, bl, br, title, page = SpellBookFrame:GetRegions()
    portrait:Hide()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    local bg = SpellBookFrame:GetBackdropTexture("bg")
    title:ClearAllPoints()
    title:SetPoint("TOPLEFT", bg)
    title:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    page:SetTextColor(Color.gray:GetRGB())

    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton1)
    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton2)
    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton3)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.SpellBookFrameTabButton1,
        _G.SpellBookFrameTabButton2,
        _G.SpellBookFrameTabButton3,
    })

    _G.SpellBookPageText:SetTextColor(Color.gray:GetRGB())
    Skin.NavButtonPrevious(_G.SpellBookPrevPageButton)
    Skin.NavButtonNext(_G.SpellBookNextPageButton)

    Skin.UIPanelCloseButton(_G.SpellBookCloseButton)
    if private.isWrath then
        Skin.OptionsSmallCheckButtonTemplate(_G.ShowAllSpellRanksCheckBox)
    end

    ----------------
    -- SpellIcons --
    ----------------
    for i = 1, _G.SPELLS_PER_PAGE do
        Skin.SpellButtonTemplate(_G["SpellButton"..i])
    end

    --------------
    -- SideTabs --
    --------------
    for i = 1, _G.MAX_SKILLLINE_TABS do
        local tab = _G["SpellBookSkillLineTab"..i]
        Skin.SpellBookSkillLineTabTemplate(tab)
        tab:ClearAllPoints()
        if i == 1 then
            tab:SetPoint("TOPLEFT", bg, "TOPRIGHT", 2, -40)
        else
            tab:SetPoint("TOPLEFT", _G["SpellBookSkillLineTab"..i - 1], "BOTTOMLEFT", 0, -5)
        end
    end
end
