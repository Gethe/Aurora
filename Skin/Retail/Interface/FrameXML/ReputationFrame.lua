local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next type

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        _G.ReputationBar1:SetPoint("TOPRIGHT", -34, -49)
    end
    function Hook.ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
        if isHeader then
            factionRow:SetBackdrop(false)
        else
            factionRow:SetBackdrop(true)
        end
    end
    function Hook.ReputationFrame_InitReputationRow(factionRow, elementData)
        local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(elementData.index)

        local bd = factionRow._bdFrame or factionRow
        if atWarWith then
            Base.SetBackdropColor(bd, Color.red)
        else
            Base.SetBackdropColor(bd, Color.button)
        end

        if elementData.index == _G.GetSelectedFaction() then
            if _G.ReputationDetailFrame:IsShown() then
                bd:SetBackdropBorderColor(Color.highlight)
            end
        end
    end
    function Hook.ReputationFrame_Update(self)
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
        Skin.FrameTypeButton(Button, OnEnter, OnLeave)
        Button:SetBackdropOption("offsets", {
            left = 30,
            right = 10,
            top = 0,
            bottom = 0,
        })

        local Container = Button.Container
        Container.Background:SetAlpha(0)

        Skin.ExpandOrCollapse(Container.ExpandOrCollapseButton)

        local ReputationBar = Container.ReputationBar
        Skin.FrameTypeStatusBar(ReputationBar)
        ReputationBar:ClearAllPoints()
        ReputationBar:SetPoint("TOPRIGHT", -3, -2)
        ReputationBar:SetPoint("BOTTOMLEFT", Button, "BOTTOMRIGHT", -102, 2)

        ReputationBar.AtWarHighlight2:SetAlpha(0)
        ReputationBar.AtWarHighlight1:SetAlpha(0)

        ReputationBar.LeftTexture:Hide()
        ReputationBar.RightTexture:Hide()

        ReputationBar.Highlight2:SetAlpha(0)
        ReputationBar.Highlight1:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    local ReputationFrame = _G.ReputationFrame
    _G.hooksecurefunc("ReputationFrame_SetRowType", Hook.ReputationFrame_SetRowType)
    _G.hooksecurefunc("ReputationFrame_InitReputationRow", Hook.ReputationFrame_InitReputationRow)

    ---------------------
    -- ReputationFrame --
    ---------------------
    _G.ReputationFrameFactionLabel:SetPoint("TOPLEFT", 75, -32)
    _G.ReputationFrameStandingLabel:ClearAllPoints()
    _G.ReputationFrameStandingLabel:SetPoint("TOPRIGHT", -75, -32)

    Skin.WowScrollBoxList(ReputationFrame.ScrollBox)
    ReputationFrame.ScrollBox:SetPoint("TOPLEFT", _G.CharacterFrame.Inset, 4, -16)

    Skin.WowTrimScrollBar(ReputationFrame.ScrollBar)


    ---------------------------
    -- ReputationDetailFrame --
    ---------------------------
    local ReputationDetailFrame = _G.ReputationDetailFrame
    ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)
    Skin.DialogBorderTemplate(ReputationDetailFrame.Border)
    local repDetailBG = ReputationDetailFrame.Border:GetBackdropTexture("bg")

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
        atWarCheckBox:SetPoint("TOPLEFT", detailBG, "BOTTOMLEFT", 10, -2)
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

    Skin.UICheckButtonTemplate(_G.ReputationDetailInactiveCheckBox)
    Skin.UICheckButtonTemplate(_G.ReputationDetailMainScreenCheckBox)
end
