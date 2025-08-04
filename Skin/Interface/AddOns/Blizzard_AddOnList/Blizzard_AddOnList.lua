local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util
-- local Color = Aurora.Color

do --[[ AddOns\AddonList.lua ]]
    function Hook.AddonListCharacterDropDownButton_OnClick(self)
        for i = 1, 2 do
            local buttonName = "DropDownList1Button"..i
            local button = _G[buttonName]
            local checkBox = button._auroraCheckBox
            local check = checkBox.check

            checkBox:SetSize(8, 8)
            checkBox:SetPoint("LEFT", 4, 0)
            check:SetTexture(private.textures.plain)
            check:SetSize(6, 6)
            check:SetAlpha(0.6)

            local checked = button.checked
            if checked then
                check:Show()
            else
                check:Hide()
            end

            _G[buttonName.."UnCheck"]:Hide()
        end
    end
end


-- FIXMELATER - No Longer used
do --[[ AddOns\AddonList.xml ]]
    function Skin.AddonListEntryTemplate(Button)
        if private.isRetail then
            Skin.UICheckButtonTemplate(Button.Enabled) -- BlizzWTF: Doesn't use a template, but it should
        else
            Skin.UICheckButtonTemplate(_G[Button:GetName().."Enabled"]) -- BlizzWTF: Doesn't use a template, but it should
        end
        Skin.UIPanelButtonTemplate(Button.LoadAddonButton)
    end
end

function private.AddOns.Blizzard_AddOnList()
    local AddonList = _G.AddonList
    Skin.ButtonFrameTemplate(AddonList)
    Skin.UICheckButtonTemplate(AddonList.ForceLoad)
    AddonList.ForceLoad:ClearAllPoints()
    AddonList.ForceLoad:SetPoint("TOPRIGHT", -150, -25)

    Skin.SharedButtonSmallTemplate(AddonList.CancelButton)
    Skin.SharedButtonSmallTemplate(AddonList.OkayButton)
    Skin.SharedButtonSmallTemplate(AddonList.EnableAllButton)
    Skin.SharedButtonSmallTemplate(AddonList.DisableAllButton)
    Util.PositionRelative("BOTTOMRIGHT", AddonList, "BOTTOMRIGHT", -5, 5, 5, "Left", {
        AddonList.CancelButton,
        AddonList.OkayButton,
    })
    Util.PositionRelative("BOTTOMLEFT", AddonList, "BOTTOMLEFT", 5, 5, 5, "Right", {
        AddonList.EnableAllButton,
        AddonList.DisableAllButton,
    })
    Skin.DropdownButton(AddonList.Dropdown)
    AddonList.Dropdown:SetPoint("TOPLEFT", 10, -27)

    Skin.WowScrollBoxList(AddonList.ScrollBox)
    Skin.MinimalScrollBar(AddonList.ScrollBar)
    AddonList.ScrollBox:SetPoint("BOTTOMRIGHT", AddonList.CancelButton, "TOPRIGHT", -21, 5)
    AddonList.ScrollBox:SetPoint("TOPLEFT", 5, -120)
    -- FIXLATER - removed in 11.0.0 - replaced with a dropdown
    -- AddonCharacterDropDown.Button:HookScript("OnClick", Hook.AddonListCharacterDropDownButton_OnClick)
end
