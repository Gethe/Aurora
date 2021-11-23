local _, private = ...
if not private.isBCC then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util


do --[[ AddOns\Blizzard_InspectUI.lua ]]
    do --[[ InspectPaperDollFrame.lua ]]
        function Hook.InspectPaperDollItemSlotButton_Update(button)
            local unit = _G.InspectFrame.unit
            local quality = _G.GetInventoryItemQuality(unit, button:GetID())
            Hook.SetItemButtonQuality(button, quality, _G.GetInventoryItemID(unit, button:GetID()))
        end
    end
end

do --[[ AddOns\Blizzard_InspectUI.xml ]]
    do --[[ InspectPaperDollFrame.xml ]]
        function Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            Skin.FrameTypeItemButton(ItemButton)
            ItemButton:SetNormalTexture("")
        end
        function Skin.InspectPaperDollItemSlotButtonLeftTemplate(ItemButton)
            Skin.InspectPaperDollItemSlotButtonTemplate(ItemButton)
            _G[ItemButton:GetName().."Frame"]:Hide()
        end
    end
end

function private.AddOns.Blizzard_InspectUI()
    local InspectFrame = _G.InspectFrame
    Skin.FrameTypeFrame(InspectFrame)
    InspectFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })
    local bg = InspectFrame:GetBackdropTexture("bg")

    _G.InspectFramePortrait:Hide()
    _G.InspectNameFrame:ClearAllPoints()
    _G.InspectNameFrame:SetPoint("TOPLEFT", bg)
    _G.InspectNameFrame:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.InspectFrameCloseButton)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.InspectFrameTab3)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.InspectFrameTab1,
        _G.InspectFrameTab2,
        _G.InspectFrameTab3,
    })

    ----====####$$$$%%%%%$$$$####====----
    --      InspectPaperDollFrame      --
    ----====####$$$$%%%%%$$$$####====----
    _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", Hook.InspectPaperDollItemSlotButton_Update)

    local tl, tr, bl, br = _G.InspectPaperDollFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    Skin.NavButtonNext(_G.InspectModelFrameRotateRightButton)
    Skin.NavButtonPrevious(_G.InspectModelFrameRotateLeftButton)

    local slots = {
        "InspectHeadSlot", "InspectNeckSlot", "InspectShoulderSlot", "InspectBackSlot", "InspectChestSlot", "InspectShirtSlot", "InspectTabardSlot", "InspectWristSlot",
        "InspectHandsSlot", "InspectWaistSlot", "InspectLegsSlot", "InspectFeetSlot", "InspectFinger0Slot", "InspectFinger1Slot", "InspectTrinket0Slot", "InspectTrinket1Slot",
        "InspectMainHandSlot", "InspectSecondaryHandSlot", "InspectRangedSlot"
    }

    for i = 1, #slots do
        Skin.InspectPaperDollItemSlotButtonTemplate(_G[slots[i]])
    end

    ----====####$$$$%%%%%$$$$####====----
    --         InspectPVPFrame         --
    ----====####$$$$%%%%%$$$$####====----
    -- /run InspectPVPFramePvPIcon:SetTexture("Interface\\PvPRankBadges\\PvPRank05"); InspectPVPFramePvPIcon:Show()
    local bd
    tl, tr, bl, br, bd = _G.InspectPVPFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()
    bd:Hide()

    ----====####$$$$%%%%%%%%$$$$####====----
    --         InspectTalentFrame         --
    ----====####$$$$%%%%%%%%$$$$####====----
    local InspectTalentFrame = _G.InspectTalentFrame

    local portrait
    portrait, tl, tr, bl, br = InspectTalentFrame:GetRegions()
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
        local specBG = _G["InspectTalentFrameBackground"..name]
        if info.point then
            specBG:SetPoint(info.point, bg)
        end
        specBG:SetSize(info.x, info.y)
        specBG:SetDrawLayer("BACKGROUND", 3)
        specBG:SetDesaturation(settings.desaturation)
        specBG:SetAlpha(settings.alpha)
    end

    Skin.TabButtonTemplate(_G.InspectTalentFrameTab1)
    Skin.TabButtonTemplate(_G.InspectTalentFrameTab2)
    Skin.TabButtonTemplate(_G.InspectTalentFrameTab3)

    _G.InspectTalentFrameCloseButton:Hide()
    Skin.UIPanelButtonTemplate(_G.InspectTalentFrameCancelButton)

    for i = 1, _G.MAX_NUM_TALENTS do
        Skin.TalentButtonTemplate(_G["InspectTalentFrameTalent"..i])
    end
end
