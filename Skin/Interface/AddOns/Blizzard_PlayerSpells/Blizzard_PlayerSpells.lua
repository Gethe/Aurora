local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook = Aurora.Hook
local Skin = Aurora.Skin
-- local Color, Util = Aurora.Color, Aurora.Util

do
    local RoleIcons = {
        TANK = "groupfinder-icon-role-micro-tank",
        HEALER = "groupfinder-icon-role-micro-heal",
        DAMAGER = "groupfinder-icon-role-micro-dps",
        DPS = "groupfinder-icon-role-micro-dps",
    }
    function Hook.UpdatePlayeerSpecFrame(self)
        for SpecContentFrame in self.SpecContentFramePool:EnumerateActive() do
            if not SpecContentFrame._auroraSkinned then
                Skin.UIPanelButtonTemplate(SpecContentFrame.ActivateButton)
                local role = _G.GetSpecializationRole(SpecContentFrame.specIndex)
                if role then
                    local RoleIcon = SpecContentFrame.RoleIcon
                    RoleIcon:SetTexCoord(0, 1, 0, 1)
                    RoleIcon:SetAtlas(RoleIcons[role])
                end
                if SpecContentFrame.SpellButtonPool then
                    for Button in SpecContentFrame.SpellButtonPool:EnumerateActive() do
                        Button.Ring:Hide()
                        Base.CropIcon(Button.Icon, Button)
                        local texture = Button.spellID and _G.C_Spell.GetSpellTexture(Button.spellID)
                        if texture then
                            Button.Icon:SetTexture(texture)
                        end
                    end
                end
                SpecContentFrame._auroraSkinned = true
            end
        end
    end
    function Skin.PlayerSpellsFrameTabTemplate(Button)
        Skin.PanelTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.PlayerSpellsButtonTemplate(Button)
        Base.CropIcon(Button.Icon, Button)
        Base.CropIcon(Button:GetPushedTexture())
        Base.CropIcon(Button:GetHighlightTexture())
    end
end
function private.AddOns.Blizzard_PlayerSpells()
    local PlayerSpellsFrame = _G.PlayerSpellsFrame
    Skin.NineSlicePanelTemplate(PlayerSpellsFrame.NineSlice)
    for i = 1, 3 do
        local tab = select(i, PlayerSpellsFrame.TabSystem:GetChildren())
        Skin.PlayerSpellsFrameTabTemplate(tab)
    end
    PlayerSpellsFrame.NineSlice:SetFrameLevel(1)
    Skin.UIPanelCloseButton(_G.PlayerSpellsFrameCloseButton)
    Skin.MaximizeMinimizeButtonFrameTemplate(PlayerSpellsFrame.MaxMinButtonFrame)

    -- SpecFrame
    local SpecFrame = PlayerSpellsFrame.SpecFrame
    _G.hooksecurefunc(SpecFrame, "UpdateSpecFrame", Hook.UpdatePlayeerSpecFrame)

    -- TalentsFrame
    local TalentsFrame = PlayerSpellsFrame.TalentsFrame
    Skin.UIPanelButtonTemplate(TalentsFrame.ApplyButton)
    Skin.UIPanelButtonTemplate(TalentsFrame.InspectCopyButton)
    Skin.SearchBoxTemplate(TalentsFrame.SearchBox)
    Skin.DropdownButton(TalentsFrame.LoadSystem.Dropdown)

    -- SpellBookFrame
    local SpellBookFrame = PlayerSpellsFrame.SpellBookFrame
    SpellBookFrame.HelpPlateButton:Hide()
    Skin.SearchBoxTemplate(SpellBookFrame.SearchBox)
    -- FIXLATER
    -- Skin.UIPanelButtonTemplate(SpellBookFrame.SettingsDropdown)
    for i = 1, 3 do
        local tab = select(i, SpellBookFrame.CategoryTabSystem:GetChildren())
        Skin.PlayerSpellsFrameTabTemplate(tab)
    end
    Skin.PlayerSpellsButtonTemplate(SpellBookFrame.AssistedCombatRotationSpellFrame.Button)
    -- for i = 1, _G.SPELLS_PER_PAGE do
    --     Skin.SpellButtonTemplate(_G["SpellButton"..i])
    -- end
    local PagedSpellsFrame = SpellBookFrame.PagedSpellsFrame
    local PagingControls = PagedSpellsFrame.PagingControls
    Skin.NavButtonPrevious(PagingControls.PrevPageButton)
    Skin.NavButtonNext(PagingControls.NextPageButton)
end
