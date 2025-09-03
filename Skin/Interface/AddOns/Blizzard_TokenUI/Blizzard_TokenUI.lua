local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color
local Util = Aurora.Util

do --[[ AddOns\Blizzard_TokenUI\Blizzard_TokenUI.lua ]]
    Hook.TokenFrameMixin = {}
    function Hook.TokenFrameMixin:OnLoad()
        _G.print("TokenFrameMixin:OnLoad")
        local button = self.button
        if not button then
            if private.isDev then
                _G.error("TokenFrameMixin:OnLoad called without button")
            end
            return
        end
        _G.print("TokenFrameMixin:OnLoad" .. button:GetName())
        if not button._auroraSkinned then
            Skin.TokenButtonTemplate(button)
        end
        if button.isHeader then
            Base.SetBackdrop(button, Color.button)
            button.Highlight:SetAlpha(0)

            button._auroraMinus:Show()
            button._auroraPlus:SetShown(not button.isExpanded)
            button.Stripe:Hide()
            button.Icon.bg:Hide()
        else
            button:SetBackdrop(false)

            local r, g, b = Color.highlight:GetRGB()
            button.Highlight:SetColorTexture(r, g, b)
            button.Highlight:SetAlpha(0.2)
            button.Highlight:SetPoint("TOPLEFT", -10, 0)
            button.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)

            button._auroraMinus:Hide()
            button._auroraPlus:Hide()
            button.Stripe:SetShown(button.index % 2 == 1)
            button.Icon.bg:Show()
        end
    end
    function Hook.TokenFrameMixin:Update(resetScrollPosition)
        _G.print("TokenFrameMixin:Update")

        local buttons = _G.TokenFrameContainer.buttons
        if not buttons then return end

        for i = 1, #buttons do
            local button = buttons[i]
            if button:IsShown() then

                if button.isHeader then
                    Base.SetBackdrop(button, Color.button)
                    button.highlight:SetAlpha(0)

                    button._auroraMinus:Show()
                    button._auroraPlus:SetShown(not button.isExpanded)
                    button.stripe:Hide()
                    button.icon.bg:Hide()
                else
                    button:SetBackdrop(false)

                    local r, g, b = Color.highlight:GetRGB()
                    button.highlight:SetColorTexture(r, g, b)
                    button.highlight:SetAlpha(0.2)
                    button.highlight:SetPoint("TOPLEFT", 1, 0)
                    button.highlight:SetPoint("BOTTOMRIGHT", -1, 0)

                    button._auroraMinus:Hide()
                    button._auroraPlus:Hide()
                    button.stripe:SetShown(button.index % 2 == 1)
                    button.icon.bg:Show()
                end
            end
        end
    end
    function Hook.TokenFrameMixin:OnEvent(event, ...)
        _G.print("TokenFrameMixin:OnEvent", event, ...)
     end
end

do --[[ AddOns\Blizzard_TokenUI\Blizzard_TokenUI.xml ]]
    function Skin.TokenButtonTemplate(Button)
        local stripe = Button.Stripe
        stripe:SetPoint("TOPLEFT", 1, 1)
        stripe:SetPoint("BOTTOMRIGHT", -1, -1)

        Button.Icon.bg = Base.CropIcon(Button.Icon, Button)

        Button.CategoryLeft:SetAlpha(0)
        Button.CategoryRight:SetAlpha(0)
        Button.CategoryMiddle:SetAlpha(0)
        Skin.FrameTypeButton(Button)

        Button.ExpandIcon:SetTexture("")
        local minus = Button:CreateTexture(nil, "ARTWORK")
        minus:SetSize(7, 1)
        minus:SetPoint("LEFT", 8, 0)
        minus:SetColorTexture(1, 1, 1)
        minus:Hide()
        Button._auroraMinus = minus

        local plus = Button:CreateTexture(nil, "ARTWORK")
        plus:SetSize(1, 7)
        plus:SetPoint("LEFT", 11, 0)
        plus:SetColorTexture(1, 1, 1)
        plus:Hide()
        Button._auroraPlus = plus
        if not Button._auroraSkinned then
            Button._auroraSkinned = true
        end
    end
    function Skin.BackpackTokenTemplate(Button)
        Base.CropIcon(Button.Icon, Button)
        Button.Count:SetPoint("RIGHT", Button.Icon, "LEFT", -2, 0)
    end

    local function SecureUpdateCollapse(texture, atlas)
        if not atlas then
            local parent = texture:GetParent()
            if parent:IsCollapsed() then
                texture:SetAtlas('Soulbinds_Collection_CategoryHeader_Expand')
            else
                texture:SetAtlas('Soulbinds_Collection_CategoryHeader_Collapse')
            end
        end
    end    
    local function SecureUpdateCurrencyScrollBoxEntries(entry)
        if not entry._auroraSkinned then
            if entry.Right then
                Base.SetBackdrop(entry, Color.button)
                SecureUpdateCollapse(entry.Right)
                SecureUpdateCollapse(entry.HighlightRight)
                hooksecurefunc(entry.Right, 'SetAtlas', SecureUpdateCollapse)
                hooksecurefunc(entry.HighlightRight, 'SetAtlas', SecureUpdateCollapse)
            end
            local icon = entry.Content and entry.Content.CurrencyIcon
            if icon then
                Base.CropIcon(icon)
            end
            entry._auroraSkinned = true
        end
    end    
    function Hook.UpdateCurrencyScrollBox(frame)
        frame:ForEachFrame(SecureUpdateCurrencyScrollBoxEntries)
    end
end

function private.AddOns.Blizzard_TokenUI()
    _G.print("Skinning Blizzard_TokenUI")
    Util.Mixin(_G.TokenFrameMixin, Hook.TokenFrameMixin)
    _G.print("Blizzard_TokenUI Mixin applied")
    local TokenFrame = _G.TokenFrame
    hooksecurefunc(TokenFrame.ScrollBox, 'Update', Hook.UpdateCurrencyScrollBox)

    local TokenFramePopup = _G.TokenFramePopup
    Skin.SecureDialogBorderTemplate(TokenFramePopup.Border)
    TokenFramePopup:SetSize(175, 90)
    local titleText = TokenFramePopup.Title
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", TokenFramePopup, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    Skin.UICheckButtonTemplate(TokenFramePopup.InactiveCheckbox)
    TokenFramePopup.InactiveCheckbox:SetPoint("TOPLEFT", TokenFramePopup, 24, -26)
    Skin.UICheckButtonTemplate(TokenFramePopup.BackpackCheckbox)
    TokenFramePopup.BackpackCheckbox:SetPoint("TOPLEFT", TokenFramePopup.InactiveCheckbox, "BOTTOMLEFT", 0, -8)
    Skin.UIPanelButtonTemplate(TokenFramePopup.CurrencyTransferToggleButton)
    TokenFramePopup.CurrencyTransferToggleButton:SetPoint("TOPLEFT", TokenFramePopup.BackpackCheckbox, "BOTTOMLEFT", 0, -8)
    Skin.UIPanelCloseButton(TokenFramePopup["$parent.CloseButton"])

    local CurrencyTransferMenu = _G.CurrencyTransferMenu
    Skin.DialogBorderNoCenterTemplate(CurrencyTransferMenu.NineSlice)
    Skin.UIPanelButtonTemplate(CurrencyTransferMenu.Content.AmountSelector.MaxQuantityButton)
    Skin.InputBoxTemplate(CurrencyTransferMenu.Content.AmountSelector.InputBox)
    Skin.UIPanelButtonTemplate(CurrencyTransferMenu.Content.ConfirmButton)
    Skin.UIPanelButtonTemplate(CurrencyTransferMenu.Content.CancelButton)
    Skin.UIPanelCloseButton(CurrencyTransferMenu.CloseButton)
    -- FIXLATER
    Skin.DropdownButton(CurrencyTransferMenu.Content.SourceSelector.Dropdown)
end
