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

    function Skin.ReputationHeaderTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 286,
            top = 0,
            bottom = 0,
        })
    end
    function Skin.ReputationBarTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)
        StatusBar:HookScript("OnEnter", OnEnter)
        StatusBar:HookScript("OnLeave", OnLeave)

        local bdFrame = _G.CreateFrame("Frame", nil, StatusBar)
        bdFrame:SetFrameLevel(StatusBar:GetFrameLevel() - 1)
        bdFrame:SetPoint("TOPRIGHT", 3, 3)
        bdFrame:SetPoint("BOTTOMLEFT", -133, -3)
        Base.SetBackdrop(bdFrame, Color.button)
        StatusBar._bdFrame = bdFrame

        local name = StatusBar:GetName()
        local atWarCheck = _G[name.."AtWarCheck"]:GetRegions()
        atWarCheck:SetTexture([[Interface\Buttons\UI-CheckBox-SwordCheck]])
        atWarCheck:SetTexCoord(0, 0.625, 0, 0.5625)
        atWarCheck:SetSize(20, 18)

        _G[name.."FactionName"]:SetPoint("LEFT", bdFrame, 5, 0)
        _G[name.."FactionName"]:SetPoint("RIGHT", StatusBar,"LEFT" , -5, 0)

        _G[name.."ReputationBarLeft"]:Hide()
        _G[name.."ReputationBarRight"]:Hide()

        _G[name.."Highlight2"]:SetAlpha(0)
        _G[name.."Highlight1"]:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    _G.ReputationFrame:HookScript("OnShow", Hook.ReputationFrame_OnShow)
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

    _G.ReputationHeader1:ClearAllPoints()
    _G.ReputationHeader1:SetPoint("TOPLEFT", charFrameBG, 10, -45)
    for i = 1, _G.NUM_FACTIONS_DISPLAYED do
        local factionRow = _G["ReputationBar"..i]
        local factionHeader = _G["ReputationHeader"..i]
        Skin.ReputationBarTemplate(factionRow)
        Skin.ReputationHeaderTemplate(factionHeader)

        if i > 1 then
            factionHeader:ClearAllPoints()
            factionHeader:SetPoint("TOPLEFT", _G["ReputationHeader"..i-1], "BOTTOMLEFT", 0, -10)
        end
        factionRow:SetPoint("TOPLEFT", factionHeader, 152, 0)
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
