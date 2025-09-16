local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\SpellBook\Blizzard_SpellBookFrame.lua ]]
    function Hook.SpellButton_UpdateButton(self)
        if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then return end

        if private.isRetail then
            self.TextBackground:SetDesaturated(true)
            self.TextBackground2:SetDesaturated(true)
        end

        local isOffSpec = self.offSpecID ~= 0 and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
        local slot, slotType = _G.SpellBook_GetSpellBookSlot(self)
        if slot then
            if private.isRetail then

                local spellID = select(2,_G.C_SpellBook.GetSpellBookItemType(slot, _G.Enum.SpellBookSpellBank.Player))

                local isDisabled = spellID and _G.C_SpellBook.IsSpellDisabled(spellID)
                if slotType == "FUTURESPELL" or isDisabled then
                    local level = _G.GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
                    if _G.IsCharacterNewlyBoosted() or (level and level > _G.UnitLevel("player")) or isDisabled then
                        self.SpellName:SetTextColor(Color.grayLight:GetRGB())
                        self.SpellSubName:SetTextColor(Color.gray:GetRGB())
                        self.RequiredLevelString:SetTextColor(Color.gray:GetRGB())
                        self:SetBackdropBorderColor(Color.gray:GetRGB())
                    else
                        -- Can learn spell, but hasn't yet. eg. riding skill
                        self.TrainFrame:Hide()
                        self.TrainTextBackground:Hide()

                        self.SpellSubName:SetTextColor(Color.grayLight:GetRGB())
                        self:SetBackdropBorderColor(Color.yellow:GetRGB())
                    end
                else
                    self.SpellSubName:SetTextColor(Color.gray:GetRGB())

                    if isOffSpec then
                        local level = _G.GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
                        if level and level > _G.UnitLevel("player") then
                            self.RequiredLevelString:SetTextColor(Color.gray:GetRGB())
                        end
                        self:SetBackdropBorderColor(Color.gray:GetRGB())
                    elseif self.SpellHighlightTexture and self.SpellHighlightTexture:IsShown() then
                        self:SetBackdropBorderColor(Color.yellow:GetRGB())
                    else
                        self:SetBackdropBorderColor(Color.highlight:GetRGB())
                    end
                end
            end

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
        local numSkillLineTabs = _G.C_SpellBook.GetNumSpellBookSkillLines()
        for i = 1, _G.MAX_SKILLLINE_TABS do
            local skillLineTab = _G["SpellBookSkillLineTab"..i]
            local prevTab = _G["SpellBookSkillLineTab"..i-1]
            if i <= numSkillLineTabs and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL then

                local skillLineInfo = _G.C_SpellBook.GetSpellBookSkillLineInfo(i)
                local isGuild = skillLineInfo.isGuild
                local shouldHide = skillLineInfo.shouldHide

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
    function Hook.FormatProfession(frame, index)
        if index then
            local _, texture = _G.GetProfessionInfo(index)
            if frame.icon and texture then
                frame.icon:SetTexture(texture)
            end
        end
    end
end

do --[[ AddOns\SpellBook\Blizzard_SpellBookFrame.xml ]]
    function Skin.SpellBookSkillLineTabTemplate(CheckButton)
        Skin.SideTabTemplate(CheckButton)
    end
    function Skin.SpellBookFrameTabButtonTemplate(Button)
        if private.isRetail then
            Skin.PanelTabButtonTemplate(Button)
        else
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

            local bg = Button:GetBackdropTexture("bg")
            Button.Text:ClearAllPoints()
            Button.Text:SetAllPoints(bg)

            Button._auroraTabResize = true
        end
    end
    function Skin.SpellButtonTemplate(CheckButton)
        if private.isRetail then
            _G.hooksecurefunc(CheckButton, "UpdateButton", Hook.SpellButton_UpdateButton)
        end
        local name = CheckButton:GetName()

        CheckButton.EmptySlot:Hide()
        if private.isRetail then
            CheckButton.SeeTrainerString:SetTextColor(Color.gray:GetRGB())
        else
            CheckButton.SpellSubName:SetTextColor(Color.gray:GetRGB())
        end

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

        if private.isRetail then
            _G[name.."SlotFrame"]:SetAlpha(0)
            CheckButton.UnlearnedFrame:SetAlpha(0)
        end

        local autoCast = _G[name.."AutoCastable"] or _G[name.."AutoCastOverlay"]
        autoCast:ClearAllPoints()
        autoCast:SetPoint("TOPLEFT")
        autoCast:SetPoint("BOTTOMRIGHT")
        autoCast:SetTexCoord(0.2344, 0.75, 0.25, 0.75)

        if private.isVanilla then
            CheckButton:SetNormalTexture("")
        else
            if private.isRetail then
                local spellHighlight = CheckButton.SpellHighlightTexture
                spellHighlight:ClearAllPoints()
                spellHighlight:SetPoint("TOPLEFT")
                spellHighlight:SetPoint("BOTTOMRIGHT")
                spellHighlight:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            end

            CheckButton:ClearNormalTexture()
        end

        Base.CropIcon(CheckButton:GetPushedTexture())
        Base.CropIcon(CheckButton:GetHighlightTexture())
        Base.CropIcon(CheckButton:GetCheckedTexture())
    end
end

function private.AddOns.Blizzard_SpellBookFrame()
    -- FIXMELATER
    if private.isRetail then
        _G.print("Blizzard_SpellBookFrame is not yet implemented.")
        return
    end
    --_G.hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", Hook.SpellBookFrame_UpdateSkillLineTabs)

    local SpellBookFrame = _G.SpellBookFrame
    -- if private.isRetail then
        -- FIXLATER ?? FormatProfession deprecated .. new spellbook setup
        -- _G.hooksecurefunc("FormatProfession", Hook.FormatProfession)

        -- Skin.ButtonFrameTemplate(SpellBookFrame)
        _G.SpellBookPage1:Hide()
        _G.SpellBookPage2:Hide()

        Skin.MainHelpPlateButton(SpellBookFrame.MainHelpButton)
        SpellBookFrame.MainHelpButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -15, 15)
    -- else
    --     _G.hooksecurefunc("SpellButton_UpdateButton", Hook.SpellButton_UpdateButton)

    --     Skin.FrameTypeFrame(SpellBookFrame)
    --     SpellBookFrame:SetBackdropOption("offsets", {
    --         left = 14,
    --         right = 34,
    --         top = 14,
    --         bottom = 75,
    --     })

    --     local portrait, tl, tr, bl, br, title, page = SpellBookFrame:GetRegions()
    --     portrait:Hide()
    --     tl:Hide()
    --     tr:Hide()
    --     bl:Hide()
    --     br:Hide()

    --     local bg = SpellBookFrame:GetBackdropTexture("bg")
    --     title:ClearAllPoints()
    --     title:SetPoint("TOPLEFT", bg)
    --     title:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    --     page:SetTextColor(Color.gray:GetRGB())
    -- end

    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton1)
    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton2)
    Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton3)
    if private.isRetail then
        Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton4)
        Skin.SpellBookFrameTabButtonTemplate(_G.SpellBookFrameTabButton5)
    end
    Util.PositionRelative("TOPLEFT", SpellBookFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.SpellBookFrameTabButton1,
        _G.SpellBookFrameTabButton2,
        _G.SpellBookFrameTabButton3,
        private.isRetail and _G.SpellBookFrameTabButton4 or nil,
        private.isRetail and _G.SpellBookFrameTabButton5 or nil,
    })

    _G.SpellBookPageText:SetTextColor(Color.gray:GetRGB())
    Skin.NavButtonPrevious(_G.SpellBookPrevPageButton)
    Skin.NavButtonNext(_G.SpellBookNextPageButton)

    if private.isClassic then
        Skin.UIPanelCloseButton(_G.SpellBookCloseButton)
        if private.isWrath then
            Skin.OptionsSmallCheckButtonTemplate(_G.ShowAllSpellRanksCheckBox)
        end
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
    _G.SpellBookSideTabsFrame:SetPoint("BOTTOMRIGHT", 2, 0)
    for i = 1, _G.MAX_SKILLLINE_TABS do
        local tab = _G["SpellBookSkillLineTab"..i]
        Skin.SpellBookSkillLineTabTemplate(tab)
    end
end
