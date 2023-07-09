local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals floor wipe tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\PetPaperDollFrame.lua ]]
    local tabs = {}
    function Hook.PetPaperDollFrame_UpdateTabs(self)
        _G.PetPaperDollFrameTab1:ClearAllPoints()
        _G.PetPaperDollFrameTab2:ClearAllPoints()
        _G.PetPaperDollFrameTab3:ClearAllPoints()
        wipe(tabs)

        if _G.HasPetUI() then
            tinsert(tabs, _G.PetPaperDollFrameTab1)
        end
        if _G.GetNumCompanions("CRITTER") > 0 then
            tinsert(tabs, _G.PetPaperDollFrameTab2)
        end
        if _G.GetNumCompanions("MOUNT") > 0 then
            tinsert(tabs, _G.PetPaperDollFrameTab3)
        end

        if #tabs > 0 then
            Util.PositionRelative("BOTTOMLEFT", _G.CompanionModelFrame._bg, "TOPLEFT", 20, 1, 1, "Right", tabs)
        end
    end
end

do --[[ FrameXML\PetPaperDollFrame.xml ]]
    function Skin.CompanionButtonTemplate(CheckButton)
        Base.SetBackdrop(CheckButton, Color.black, Color.frame.a)
        CheckButton._auroraIconBorder = CheckButton

        Base.CropIcon(_G[CheckButton:GetName().."ActiveTexture"])

        local bg = CheckButton:GetBackdropTexture("bg")
        local disabled = CheckButton:GetDisabledTexture()
        disabled:SetTexCoord(0.234375, 0.75, 0.234375, 0.75)
        disabled:SetPoint("TOPLEFT", bg, 1, -1)
        disabled:SetPoint("BOTTOMRIGHT", bg, -1, 1)

        Base.CropIcon(CheckButton:GetHighlightTexture())
        CheckButton:SetNormalTexture(private.textures.plain)
        local normal = CheckButton:GetNormalTexture()
        Base.CropIcon(normal)
        normal:SetPoint("TOPLEFT", bg, 1, -1)
        normal:SetPoint("BOTTOMRIGHT", bg, -1, 1)
    end
end

function private.FrameXML.PetPaperDollFrame()
    _G.hooksecurefunc("PetPaperDollFrame_UpdateTabs", Hook.PetPaperDollFrame_UpdateTabs)

    local PetPaperDollFrame = _G.PetPaperDollFrame

    _G.PetNameText:SetAllPoints(_G.CharacterNameText)
    local _, TopLeft, TopRight, BotLeft, BotRight = PetPaperDollFrame:GetRegions()
    TopLeft:Hide()
    TopRight:Hide()
    BotLeft:Hide()
    BotRight:Hide()


    --------------
    -- PetFrame --
    --------------
    Skin.FrameTypeStatusBar(_G.PetPaperDollFrameExpBar)
    local left, right = _G.PetPaperDollFrameExpBar:GetRegions()
    left:Hide()
    right:Hide()
    Util.PositionBarTicks(_G.PetPaperDollFrameExpBar, 6)

    Skin.NavButtonNext(_G.PetModelFrameRotateRightButton)
    Skin.NavButtonPrevious(_G.PetModelFrameRotateLeftButton)

    Skin.UIPanelButtonTemplate(_G.PetPaperDollCloseButton)

    left, right = _G.PetAttributesFrame:GetRegions()
    left:Hide()
    right:Hide()

    -- Resists
    local resists = {
        {icon = [[Interface\Icons\Spell_Arcane_StarFire]]},
        {icon = [[Interface\Icons\INV_SummerFest_FireSpirit]]},
        {icon = [[Interface\Icons\Spell_Nature_ResistNature]]},
        {icon = [[Interface\Icons\Spell_Frost_FreezingBreath]]},
        {icon = [[Interface\Icons\Spell_Shadow_Twilight]]},
    }
    for i = 1, #resists do
        local frame = _G["PetMagicResFrame"..i]
        Skin.MagicResistanceFrameTemplate(frame)
        frame._icon:SetTexture(resists[i].icon)

        frame:ClearAllPoints()
        if i == 1 then
            frame:SetPoint("TOPRIGHT", -5, -5)
        else
            frame:SetPoint("TOPRIGHT", _G["PetMagicResFrame"..i - 1], "BOTTOMRIGHT", 0, -6)
        end
    end


    --------------------
    -- CompanionFrame --
    --------------------
    local slotsBG, modelBG = _G.PetPaperDollFrameCompanionFrame:GetRegions()
    slotsBG:Hide()
    modelBG:Hide()

    Base.SetBackdrop(_G.CompanionModelFrame, Color.frame)
    _G.CompanionModelFrame:SetBackdropOption("offsets", {
        left = -9,
        right = -9,
        top = -9,
        bottom = -53,
    })
    _G.CompanionModelFrame._bg = _G.CompanionModelFrame:GetBackdropTexture("bg")

    Skin.NavButtonPrevious(_G.CompanionModelFrameRotateLeftButton)
    Skin.NavButtonNext(_G.CompanionModelFrameRotateRightButton)
    Skin.GameMenuButtonTemplate(_G.CompanionSummonButton)

    for i = 1, 12 do
        Skin.CompanionButtonTemplate(_G["CompanionButton"..i])
    end

    Skin.NavButtonPrevious(_G.CompanionPrevPageButton)
    Skin.NavButtonNext(_G.CompanionNextPageButton)

    Skin.TabButtonTemplate(_G.PetPaperDollFrameTab1)
    Skin.TabButtonTemplate(_G.PetPaperDollFrameTab2)
    Skin.TabButtonTemplate(_G.PetPaperDollFrameTab3)


    --------------
    -- PetFrame --
    --------------
end
