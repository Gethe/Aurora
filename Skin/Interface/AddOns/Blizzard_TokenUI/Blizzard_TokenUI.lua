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
        local button = self.button
        if not button then
            if private.isDev then
                _G.error("TokenFrameMixin:OnLoad called without button")
            end
            return
        end
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
            button.Highlight:SetPoint("TOPLEFT", 1, 0)
            button.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)

            button._auroraMinus:Hide()
            button._auroraPlus:Hide()
            button.Stripe:SetShown(button.index % 2 == 1)
            button.Icon.bg:Show()
        end
    end
    function Hook.TokenFrameMixin:Update(resetScrollPosition)
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
end

function private.AddOns.Blizzard_TokenUI()
    local TokenFrame = _G.TokenFrame
    Util.Mixin(_G.TokenFrameMixin, Hook.TokenFrameMixin)

    -- FIXLATER - disable for now
    -- _G.hooksecurefunc("TokenFrame_InitTokenButton", Hook.TokenFrame_InitTokenButton)

    Skin.WowScrollBoxList(TokenFrame.ScrollBox)
    Skin.MinimalScrollBar(TokenFrame.ScrollBar)

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

    Skin.UIPanelCloseButton(TokenFramePopup["$parent.CloseButton"])
end
