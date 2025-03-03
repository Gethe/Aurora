local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util
-- local Color = Aurora.Color

do --[[ SharedXML\AddonList.lua ]]
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

do --[[ SharedXML\AddonList.xml ]]
    function Skin.AddonListEntryTemplate(Button)
        if private.isRetail then
            Skin.UICheckButtonTemplate(Button.Enabled) -- BlizzWTF: Doesn't use a template, but it should
        else
            Skin.UICheckButtonTemplate(_G[Button:GetName().."Enabled"]) -- BlizzWTF: Doesn't use a template, but it should
        end
        Skin.UIPanelButtonTemplate(Button.LoadAddonButton)
    end
end

function private.SharedXML.AddonList()
    if private.isRetail then
        return
    end
    local AddonList = _G.AddonList
    Skin.ButtonFrameTemplate(AddonList)
    Skin.UICheckButtonTemplate(_G.AddonListForceLoad) -- BlizzWTF: Doesn't use a template, but it should
    _G.AddonListForceLoad:ClearAllPoints()
    _G.AddonListForceLoad:SetPoint("TOPRIGHT", -150, -25)

    if private.isRetail then
        Skin.SharedButtonSmallTemplate(AddonList.CancelButton)
        Skin.SharedButtonSmallTemplate(AddonList.OkayButton)
    else
        Skin.MagicButtonTemplate(AddonList.CancelButton)
        Skin.MagicButtonTemplate(AddonList.OkayButton)
    end
    Util.PositionRelative("BOTTOMRIGHT", AddonList, "BOTTOMRIGHT", -5, 5, 5, "Left", {
        AddonList.CancelButton,
        AddonList.OkayButton,
    })

    Skin.SharedButtonSmallTemplate(AddonList.EnableAllButton)
    Skin.SharedButtonSmallTemplate(AddonList.DisableAllButton)

    Util.PositionRelative("BOTTOMLEFT", AddonList, "BOTTOMLEFT", 5, 5, 5, "Right", {
        AddonList.EnableAllButton,
        AddonList.DisableAllButton,
    })

    Skin.WowScrollBoxList(AddonList.ScrollBox)
    AddonList.ScrollBox:SetPoint("TOPLEFT", 5, -60)
    AddonList.ScrollBox:SetPoint("BOTTOMRIGHT", AddonList.CancelButton, "TOPRIGHT", -21, 5)

    Skin.MinimalScrollBar(AddonList.ScrollBar)

    -- FIXLATER - removed in 11.0.0
    Skin.DropdownButton(AddonList.Dropdown)
    -- _G.AddonCharacterDropDown:SetPoint("TOPLEFT", 10, -27)
    -- _G.AddonCharacterDropDown.Button:HookScript("OnClick", Hook.AddonListCharacterDropDownButton_OnClick)
end
