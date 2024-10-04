local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_OrderHallUI.lua ]]
    do --[[ Blizzard_OrderHallTalents ]]
        Hook.OrderHallTalentFrameMixin = {}
        function Hook.OrderHallTalentFrameMixin:SetUseThemedTextures(isThemed)
            self.Background:SetPoint("TOPLEFT")
            self.Background:SetPoint("BOTTOMRIGHT")
        end
        function Hook.OrderHallTalentFrameMixin:RefreshAllData()
            -- FIXLATER
            -- for choiceBackground in self.choiceTrackTexturePool:EnumerateActive() do
            --     if choiceBackground:GetAtlas():find("-on") then
            --         choiceBackground._auroraLeft:Hide()
            --         choiceBackground._auroraRight:Hide()
            --     else
            --         choiceBackground._auroraLeft:Show()
            --         choiceBackground._auroraRight:Show()
            --     end
            -- end
            -- for _, pulsingArrows in self.arrowTexturePool:EnumerateInactive() do
            --     pulsingArrows._auroraLeft:Hide()
            --     pulsingArrows._auroraRight:Hide()
            -- end
            -- for pulsingArrows in self.arrowTexturePool:EnumerateActive() do
            --     pulsingArrows._auroraLeft:Show()
            --     pulsingArrows._auroraRight:Show()
            -- end

            for talentFrame in self.buttonPool:EnumerateActive() do
                if talentFrame._auroraIconBorder then
                    if talentFrame.Border:IsShown() then
                        local atlas = talentFrame.Border:GetAtlas()
                        if atlas:find("yellow") then
                            talentFrame._auroraIconBorder:SetColorTexture(Color.yellow:GetRGB())
                        elseif atlas:find("green") then
                            talentFrame._auroraIconBorder:SetColorTexture(Color.green:GetRGB())
                        else
                            talentFrame._auroraIconBorder:SetColorTexture(Color.gray:GetRGB())
                        end
                    else
                        talentFrame._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
                    end
                end
            end
        end

        Hook.GarrisonTalentButtonMixin = {}
        function Hook.GarrisonTalentButtonMixin:SetBorder(borderAtlas)
            -- FIXLATER
            if self._auroraIconBorder then
                if borderAtlas then
                    self._auroraIconBorder:SetColorTexture(Color.yellow:GetRGB())
                else
                    self._auroraIconBorder:SetColorTexture(Color.black:GetRGB())
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_OrderHallUI.xml ]]
    do --[[ Blizzard_OrderHallTalents ]]
        function Skin.GarrisonTalentButtonTemplate(Button)
            Util.Mixin(Button, Hook.GarrisonTalentButtonMixin)

            Button._auroraIconBorder = Base.CropIcon(Button.Icon, Button)
            Button._auroraIconBorder:SetColorTexture(Color.yellow:GetRGB())

            Button.CooldownTimerBackground:SetAlpha(0)
            Button.Border:SetAlpha(0)
            Base.CropIcon(Button.Highlight)

            Button.Cooldown:SetSwipeTexture(private.textures.plain)
            Button.Cooldown:SetSwipeColor(Color.green.r, Color.green.g, Color.green.b, 0.5)
        end
        function Skin.GarrisonTalentTrackTemplate(Texture)
            local parent = Texture:GetParent()
            Texture:SetAlpha(0)

            local left = parent:CreateTexture(nil, "ARTWORK")
            left:SetPoint("TOPLEFT", Texture, 16, -26)
            left:SetSize(4, 8)
            Base.SetTexture(left, "arrowLeft")
            Texture._auroraLeft = left

            local right = parent:CreateTexture(nil, "ARTWORK")
            right:SetPoint("TOPRIGHT", Texture, -15, -25)
            right:SetSize(5, 10)
            Base.SetTexture(right, "arrowRight")
            Texture._auroraRight = right
        end
        function Skin.GarrisonTalentChoiceTemplate(Texture)
            Texture:SetAlpha(0)
        end
        function Skin.GarrisonTalentArrowTemplate(Texture)
            local parent = Texture:GetParent()
            Texture:SetAlpha(0)

            local left = parent:CreateTexture(nil, "ARTWORK")
            left:SetPoint("TOPLEFT", Texture, 5, -6)
            left:SetSize(8, 15)
            Base.SetTexture(left, "arrowLeft")
            left:SetColorTexture(Color.yellow:GetRGB())
            Texture._auroraLeft = left

            local anim = Texture.Pulse:GetAnimations()
            anim:SetTarget(left)


            local right = parent:CreateTexture(nil, "ARTWORK")
            right:SetPoint("TOPRIGHT", Texture, -5, -6)
            right:SetSize(8, 15)
            Base.SetTexture(right, "arrowRight")
            right:SetColorTexture(Color.yellow:GetRGB())
            Texture._auroraRight = right

            local anim2 = Texture.Pulse:CreateAnimation("Alpha")
            anim2:SetFromAlpha(1)
            anim2:SetToAlpha(0)
            anim2:SetDuration(1)
            anim2:SetTarget(right)
        end
    end
end

function private.AddOns.Blizzard_OrderHallUI()
    ----====####$$$$%%%%%$$$$####====----
    --    Blizzard_OrderHallTalents    --
    ----====####$$$$%%%%%$$$$####====----
    local OrderHallTalentFrame = _G.OrderHallTalentFrame
    Util.Mixin(OrderHallTalentFrame, Hook.OrderHallTalentFrameMixin)
    -- Util.Mixin(Button, Hook.GarrisonTalentButtonMixin)
    -- FIXLATER
    -- Util.Mixin(OrderHallTalentFrame, Hook.GarrisonTalentButtonMixin)

    Skin.PortraitFrameTemplate(OrderHallTalentFrame)
    OrderHallTalentFrame.CurrencyBG:SetAlpha(0)
    OrderHallTalentFrame.OverlayElements.CornerLogo:SetAlpha(0)
    Base.CropIcon(OrderHallTalentFrame.Currency.Icon, OrderHallTalentFrame.Currency)
    Skin.InsetFrameTemplate(OrderHallTalentFrame.Inset)
    Skin.UIPanelButtonTemplate(OrderHallTalentFrame.BackButton)
    -- Skin.GarrisonTalentButtonTemplate(OrderHallTalentFrame.buttonPool)

    OrderHallTalentFrame.Background:SetAlpha(0.5)
    OrderHallTalentFrame.Background:SetPoint("BOTTOMRIGHT")

    ----====####$$$$%%%%$$$$####====----
    --  Blizzard_OrderHallCommandBar  --
    ----====####$$$$%%%%$$$$####====----
end
