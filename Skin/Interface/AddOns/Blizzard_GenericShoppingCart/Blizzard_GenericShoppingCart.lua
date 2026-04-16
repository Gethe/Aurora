local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_GenericShoppingCart\Blizzard_GenericShoppingCartTemplates.lua ]]
    Hook.ShoppingCartVisualsFrameMixin = {}
    function Hook.ShoppingCartVisualsFrameMixin:OnLoad()
        local CartVisible = self.CartVisibleContainer
        local CartHidden = self.CartHiddenContainer

        -- Hide Background NineSlice on CartVisibleContainer
        -- CartVisible.Background IS the NineSlice frame (no .NineSlice child),
        -- so hide its texture pieces directly instead of Util.HideNineSlice
        if CartVisible.Background then
            for _, region in _G.pairs({CartVisible.Background:GetRegions()}) do
                if region:IsObjectType("Texture") then
                    region:SetAlpha(0)
                end
            end
        end

        -- Header / Footer dividers (perks-divider atlas)
        if CartVisible.Header and CartVisible.Header.TopDivider then
            CartVisible.Header.TopDivider:SetAlpha(0)
        end
        if CartVisible.Footer and CartVisible.Footer.BottomDivider then
            CartVisible.Footer.BottomDivider:SetAlpha(0)
        end

        -- Buttons on CartVisibleContainer
        if CartVisible.Header and CartVisible.Header.HideCartButton then
            Skin.FrameTypeButton(CartVisible.Header.HideCartButton)
        end
        if CartVisible.Footer then
            if CartVisible.Footer.ClearCartButton then
                Skin.FrameTypeButton(CartVisible.Footer.ClearCartButton)
            end
            -- PurchaseCartButton is created dynamically in OnLoad, available in post-hook
            if CartVisible.Footer.PurchaseCartButton then
                Skin.FrameTypeButton(CartVisible.Footer.PurchaseCartButton)
            end
        end

        -- Buttons on CartHiddenContainer
        if CartHidden.ViewCartButton then
            Skin.FrameTypeButton(CartHidden.ViewCartButton)
        end
        -- PurchaseCartButton is created dynamically in OnLoad, available in post-hook
        if CartHidden.PurchaseCartButton then
            Skin.FrameTypeButton(CartHidden.PurchaseCartButton)
        end

        -- ScrollBox / ScrollBar (set up in OnLoad via SetupScrollBox)
        if self.ScrollBox then
            Skin.WowScrollBoxList(self.ScrollBox)
        end
        if self.ScrollBar then
            Skin.MinimalScrollBar(self.ScrollBar)
        end
    end
end

function private.AddOns.Blizzard_GenericShoppingCart()
    -- Template-only addon — no global frame to skin.
    -- Hook the mixin OnLoad so ALL consumers of ShoppingCartVisualsFrameTemplate
    -- (including HousingMarketCart) get base styling automatically.
    Util.Mixin(_G.ShoppingCartVisualsFrameMixin, Hook.ShoppingCartVisualsFrameMixin)
end
