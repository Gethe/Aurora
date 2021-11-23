local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_ItemUpgradeUI.lua ]]
    Hook.ItemUpgradeMixin = {}
    function Hook.ItemUpgradeMixin:Update(fromDropDown)
        local UpgradeItemButton = self.UpgradeItemButton
        if not self.upgradeInfo then
            Hook.SetItemButtonQuality(UpgradeItemButton, _G.Enum.ItemQuality.Uncommon)

            local tex = UpgradeItemButton:GetNormalTexture()
            tex:SetAllPoints(UpgradeItemButton.icon)
            Base.CropIcon(tex)
        end

        Base.CropIcon(UpgradeItemButton:GetPushedTexture())
    end
end

do --[[ AddOns\Blizzard_ItemUpgradeUI.xml ]]
    function Skin.ItemUpgradeTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end
    function Skin.ItemUpgradePreviewTemplate(GameTooltip)
        Skin.ItemUpgradeTooltipTemplate(GameTooltip)
    end
end

function private.AddOns.Blizzard_ItemUpgradeUI()
    local ItemUpgradeFrame = _G.ItemUpgradeFrame
    Util.Mixin(ItemUpgradeFrame, Hook.ItemUpgradeMixin)
    Skin.PortraitFrameTemplate(ItemUpgradeFrame)

    ItemUpgradeFrame.BottomBG:Hide()

    ItemUpgradeFrame.BottomPanel_Flash:Hide()
    ItemUpgradeFrame.IdleGlow:Hide()
    ItemUpgradeFrame.Ring:Hide()

    ItemUpgradeFrame.BottomBGShadow:Hide()
    ItemUpgradeFrame.TopBG:Hide()
    ItemUpgradeFrame.MicaFleckSheen:Hide()

    local UpgradeItemButton = ItemUpgradeFrame.UpgradeItemButton
    Skin.FrameTypeItemButton(UpgradeItemButton)
    Base.CropIcon(UpgradeItemButton.EmptySlotGlow)
    UpgradeItemButton.EmptySlotGlow:SetAllPoints(UpgradeItemButton.icon)
    UpgradeItemButton.ButtonFrame:Hide()

    Skin.UIDropDownMenuTemplate(ItemUpgradeFrame.ItemInfo.Dropdown)
    Skin.ItemUpgradePreviewTemplate(ItemUpgradeFrame.LeftItemPreviewFrame)
    Skin.ItemUpgradePreviewTemplate(ItemUpgradeFrame.RightItemPreviewFrame)

    Skin.UIPanelButtonTemplate(ItemUpgradeFrame.UpgradeButton)
    local glow = ItemUpgradeFrame.UpgradeButton.GlowAnim:GetAnimations()
    glow:SetFromAlpha(0.0)
    glow:SetToAlpha(0.2)

    Skin.ThinGoldEdgeTemplate(ItemUpgradeFrame.PlayerCurrenciesBorder)
end
