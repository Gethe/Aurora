local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

-- Shared helper: skin a single CompanionConfigListButton (curio/role option)
local function SkinListButton(button)
    if not button or button._auroraSkinned then return end

    if button.Icon then
        Base.CropIcon(button.Icon)
    end

    -- Strip the curio icon border overlay
    if button.Border then
        button.Border:SetAlpha(0)
    end

    button._auroraSkinned = true
end

-- Shared helper: skin a CompanionConfigSlot's OptionsList dropdown panel
local function SkinOptionsList(optionsList)
    if not optionsList or optionsList._auroraSkinned then return end

    -- Strip the Top/Middle/Bottom background atlas textures
    Base.StripBlizzardTextures(optionsList)

    -- Apply a flat backdrop to the options list
    Base.SetBackdrop(optionsList, Color.frame)

    -- Wrap the ScrollBox so dynamically created list buttons are skinned
    local scrollBox = optionsList.ScrollBox
    if scrollBox then
        _G.ScrollUtil.AddAcquiredFrameCallback(scrollBox, function(o, frame)
            SkinListButton(frame)
        end, optionsList)

        -- Skin any already-existing frames
        scrollBox:ForEachFrame(function(frame)
            SkinListButton(frame)
        end)
    end

    optionsList._auroraSkinned = true
end

-- Shared helper: skin a CompanionConfigSlot (role/trinket slot button)
local function SkinConfigSlot(slot)
    if not slot or slot._auroraSkinned then return end

    -- Strip the decorative shadow texture behind the slot
    if slot.Shadow then
        slot.Shadow:SetAlpha(0)
    end

    -- Skin the options list dropdown
    SkinOptionsList(slot.OptionsList)

    slot._auroraSkinned = true
end

do --[[ AddOns\Blizzard_DelvesCompanionConfiguration.lua ]]
    Hook.CompanionConfigSlotTemplateMixin = {}
    function Hook.CompanionConfigSlotTemplateMixin:OnLoad()
        -- Post-hook: skin the slot and its OptionsList after the
        -- ScrollBox view is initialised in the original OnLoad.
        SkinConfigSlot(self)
    end
end

--[[ AddOns\Blizzard_DelvesCompanionConfiguration.xml ]]
-- CompanionConfigSlotTemplate, CompanionConfigListTemplate,
-- CompanionConfigListButtonTemplate, and the main
-- DelvesCompanionConfigurationFrame are defined in XML.
-- Skinning is applied in the addon registration function below.

function private.AddOns.Blizzard_DelvesCompanionConfiguration()
    ------------------------------------------------
    -- Hook mixin prototypes via Util.Mixin
    ------------------------------------------------
    Util.Mixin(_G.CompanionConfigSlotTemplateMixin, Hook.CompanionConfigSlotTemplateMixin)

    ------------------------------------------------
    -- Skin the main configuration frame
    ------------------------------------------------
    local frame = _G.DelvesCompanionConfigurationFrame
    if not frame then return end

    Skin.FrameTypeFrame(frame)

    -- Strip the InsetFrameTemplate and DialogBorderTemplate decorative textures
    Base.StripBlizzardTextures(frame)

    -- Strip the companion background atlas
    if frame.Background then
        frame.Background:SetAlpha(0)
    end

    -- Strip the DialogBorder NineSlice
    if frame.Border then
        Base.StripBlizzardTextures(frame.Border)
    end

    ------------------------------------------------
    -- Close button
    ------------------------------------------------
    if frame.CloseButton then
        Skin.UIPanelCloseButton(frame.CloseButton)
    end

    ------------------------------------------------
    -- Abilities button (UIPanelButtonTemplate)
    ------------------------------------------------
    if frame.CompanionConfigShowAbilitiesButton then
        Skin.FrameTypeButton(frame.CompanionConfigShowAbilitiesButton)
    end

    ------------------------------------------------
    -- Skin the three config slots (if already loaded)
    ------------------------------------------------
    SkinConfigSlot(frame.CompanionCombatRoleSlot)
    SkinConfigSlot(frame.CompanionCombatTrinketSlot)
    SkinConfigSlot(frame.CompanionUtilityTrinketSlot)

    ------------------------------------------------
    -- Skin the Ability List frame (separate UIPanel)
    ------------------------------------------------
    local abilityList = _G.DelvesCompanionAbilityListFrame
    if abilityList then
        Skin.FrameTypeFrame(abilityList)
        Base.StripBlizzardTextures(abilityList)

        -- Strip the ability list background atlas
        if abilityList.CompanionAbilityListBackground then
            abilityList.CompanionAbilityListBackground:SetAlpha(0)
        end

        -- Skin paging control buttons
        local pagingControls = abilityList.DelvesCompanionAbilityListPagingControls
        if pagingControls then
            if pagingControls.NextPageButton then
                Skin.FrameTypeButton(pagingControls.NextPageButton)
            end
            if pagingControls.PrevPageButton then
                Skin.FrameTypeButton(pagingControls.PrevPageButton)
            end
        end

        -- Hook InstantiateTalentButton to crop ability icons as they are created
        _G.hooksecurefunc(_G.DelvesCompanionAbilityListFrameMixin, "InstantiateTalentButton", function(self, nodeID, nodeInfo)
            -- Skin any newly created ability buttons
            if self.buttons then
                for _, button in ipairs(self.buttons) do
                    if not button._auroraSkinned then
                        if button.Icon then
                            Base.CropIcon(button.Icon)
                        end
                        button._auroraSkinned = true
                    end
                end
            end
        end)
    end
end
