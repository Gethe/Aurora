local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\AddonList.lua ]]
    function Hook.TriStateCheckbox_SetState(checked, checkButton)
        local checkedTexture = _G[checkButton:GetName().."CheckedTexture"]
        if not checked or checked == 0 then
            -- nil or 0 means not checked
            checkButton:SetChecked(false)
        else
            checkedTexture:SetDesaturated(true)
            checkButton:SetChecked(true)

            if checked == 2 then
                -- 2 is a normal check
                checkedTexture:SetVertexColor(Color.highlight:GetRGB())
            else
                -- 1 is a dark check
                checkedTexture:SetVertexColor(Color.gray:GetRGB())
            end
        end
    end
    function Hook.AddonList_InitButton(entry, addonIndex)
        Hook.TriStateCheckbox_SetState(entry.Enabled.state, entry.Enabled)
    end
    function Hook.AddonList_Update()
        local entry, checkbox
        for i = 1, _G.MAX_ADDONS_DISPLAYED do
            entry = _G["AddonListEntry"..i]
            if entry:IsShown() then
                checkbox = _G["AddonListEntry"..i.."Enabled"]
                Hook.TriStateCheckbox_SetState(checkbox.state, checkbox)
            end
        end
    end

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
        Skin.UICheckButtonTemplate(Button.Enabled) -- BlizzWTF: Doesn't use a template, but it should
        Skin.UIPanelButtonTemplate(Button.LoadAddonButton)
    end
end

function private.SharedXML.AddonList()
    _G.hooksecurefunc("AddonList_InitButton", Hook.AddonList_InitButton)

    local AddonList = _G.AddonList
    Skin.ButtonFrameTemplate(AddonList)
    Skin.UICheckButtonTemplate(_G.AddonListForceLoad) -- BlizzWTF: Doesn't use a template, but it should
    _G.AddonListForceLoad:ClearAllPoints()
    _G.AddonListForceLoad:SetPoint("TOPRIGHT", -150, -25)

    Skin.SharedButtonSmallTemplate(AddonList.CancelButton)
    Skin.SharedButtonSmallTemplate(AddonList.OkayButton)
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

    Skin.UIDropDownMenuTemplate(_G.AddonCharacterDropDown)
    _G.AddonCharacterDropDown:SetPoint("TOPLEFT", 10, -27)
    _G.AddonCharacterDropDown.Button:HookScript("OnClick", Hook.AddonListCharacterDropDownButton_OnClick)
end
