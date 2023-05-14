local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next type

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        local charFrameBG = _G.CharacterFrame:GetBackdropTexture("bg")
        _G.ReputationBar1:SetPoint("TOPRIGHT", charFrameBG, -34, -(private.FRAME_TITLE_HEIGHT + 22))
    end

    local hasShown = false
    function Hook.ReputationFrame_Update(self)
        if not hasShown then
            hasShown = true
            _G.ReputationFrame:Hide()
            _G.ReputationFrame:Show()
            return
        end

        for i = 1, _G.NUM_FACTIONS_DISPLAYED do
            local factionRow = _G["ReputationBar"..i]
            if factionRow.index then
                local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(factionRow.index)

                local bd = factionRow._bdFrame or factionRow
                if atWarWith then
                    Base.SetBackdropColor(bd, Color.red)
                else
                    Base.SetBackdropColor(bd, Color.button)
                end

                if factionRow.index == _G.GetSelectedFaction() then
                    if _G.ReputationDetailFrame:IsShown() then
                        bd:SetBackdropBorderColor(Color.highlight)
                    end
                end
            end
        end

        Hook.ReputationFrame_OnShow(self)
    end
end

do --[[ FrameXML\ReputationFrame.xml ]]
    local function OnEnter(button)
        (button._bdFrame or button):SetBackdropBorderColor(Color.highlight)
    end
    local function OnLeave(button)
        if (_G.GetSelectedFaction() ~= button.index) or (not _G.ReputationDetailFrame:IsShown()) then
            local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(button.index)
            if atWarWith then
                (button._bdFrame or button):SetBackdropBorderColor(Color.red)
            else
                (button._bdFrame or button):SetBackdropBorderColor(Color.button)
            end
        end
    end

    function Skin.ReputationBarTemplate(Button)
        local factionRowName = Button:GetName()

        Skin.FrameTypeButton(Button, OnEnter, OnLeave)
        _G[factionRowName.."Background"]:SetAlpha(0)

        Skin.ExpandOrCollapse(_G[factionRowName.."ExpandOrCollapseButton"])

        local statusName = factionRowName.."ReputationBar"
        local statusBar = _G[statusName]
        Skin.FrameTypeStatusBar(statusBar)
        statusBar:ClearAllPoints()
        statusBar:SetPoint("TOPRIGHT", -3, -2)
        statusBar:SetPoint("BOTTOMLEFT", Button, "BOTTOMRIGHT", -102, 2)

        _G[statusName.."LeftTexture"]:Hide()
        _G[statusName.."RightTexture"]:Hide()

        _G[statusName.."AtWarHighlight2"]:SetAlpha(0)
        _G[statusName.."AtWarHighlight1"]:SetAlpha(0)

        _G[statusName.."Highlight2"]:SetAlpha(0)
        _G[statusName.."Highlight1"]:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    --_G.ReputationFrame:HookScript("OnShow", Hook.ReputationFrame_OnShow)
    --_G.hooksecurefunc(_G.ReputationFrame, "Show", Hook.ReputationFrame_OnShow)
    _G.hooksecurefunc("ReputationFrame_Update", Hook.ReputationFrame_Update)

    ---------------------
    -- ReputationFrame --
    ---------------------
    local charFrameBG = _G.CharacterFrame:GetBackdropTexture("bg")

    local tl, tr, bl, br = _G.ReputationFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    Skin.ReputationBarTemplate(_G.ReputationBar1)
    for i = 2, _G.NUM_FACTIONS_DISPLAYED do
        local factionRow = _G["ReputationBar"..i]
        factionRow:SetPoint("TOPRIGHT", _G["ReputationBar"..i - 1], "BOTTOMRIGHT", 0, -4)
        Skin.ReputationBarTemplate(factionRow)
    end

    _G.ReputationFrameFactionLabel:SetPoint("TOPLEFT", 80, -40)
    _G.ReputationFrameStandingLabel:SetPoint("TOPLEFT", 220, -40)

    _G.ReputationListScrollFrame:SetPoint("TOPLEFT", charFrameBG, 4, -4)
    _G.ReputationListScrollFrame:SetPoint("BOTTOMRIGHT", charFrameBG, -23, 4)

    Skin.FauxScrollFrameTemplate(_G.ReputationListScrollFrame)
    local top, bottom = _G.ReputationListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()


    Skin.MainMenuBarWatchBarTemplate(_G.ReputationWatchBar)


    ---------------------------
    -- ReputationDetailFrame --
    ---------------------------
    local ReputationDetailFrame = _G.ReputationDetailFrame
    ReputationDetailFrame:SetPoint("TOPLEFT", charFrameBG, "TOPRIGHT", 1, -28)
    Skin.DialogBorderTemplate(ReputationDetailFrame)
    local repDetailBG = ReputationDetailFrame:GetBackdropTexture("bg")

    _G.ReputationDetailFactionName:SetPoint("TOPLEFT", repDetailBG, 10, -8)
    _G.ReputationDetailFactionName:SetPoint("BOTTOMRIGHT", repDetailBG, "TOPRIGHT", -10, -26)
    _G.ReputationDetailFactionDescription:SetPoint("TOPLEFT", _G.ReputationDetailFactionName, "BOTTOMLEFT", 0, -5)
    _G.ReputationDetailFactionDescription:SetPoint("TOPRIGHT", _G.ReputationDetailFactionName, "BOTTOMRIGHT", 0, -5)

    local detailBG = _G.select(3, ReputationDetailFrame:GetRegions())
    detailBG:SetPoint("TOPLEFT", repDetailBG, 1, -1)
    detailBG:SetPoint("BOTTOMRIGHT", repDetailBG, "TOPRIGHT", -1, -142)
    detailBG:SetColorTexture(Color.button:GetRGB())
    _G.ReputationDetailCorner:Hide()

    _G.ReputationDetailDivider:SetColorTexture(Color.frame:GetRGB())
    _G.ReputationDetailDivider:ClearAllPoints()
    _G.ReputationDetailDivider:SetPoint("BOTTOMLEFT", detailBG)
    _G.ReputationDetailDivider:SetPoint("BOTTOMRIGHT", detailBG)
    _G.ReputationDetailDivider:SetHeight(1)

    Skin.UIPanelCloseButton(_G.ReputationDetailCloseButton)

    do -- AtWarCheckBox
        local atWarCheckBox = _G.ReputationDetailAtWarCheckBox
        Skin.FrameTypeCheckButton(atWarCheckBox)
        atWarCheckBox:SetPoint("BOTTOMLEFT", repDetailBG, 14, 25)
        atWarCheckBox:SetBackdropOption("offsets", {
            left = 6,
            right = 6,
            top = 6,
            bottom = 6,
        })

        local bg = atWarCheckBox:GetBackdropTexture("bg")
        local check = atWarCheckBox:GetCheckedTexture()
        check:SetPoint("TOPLEFT", bg, -3, 2)

        local disabled = atWarCheckBox:GetDisabledCheckedTexture()
        disabled:SetTexture([[Interface\Buttons\UI-CheckBox-SwordCheck]])
        disabled:SetAllPoints(check)
    end

    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailInactiveCheckBox)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailMainScreenCheckBox)
end
