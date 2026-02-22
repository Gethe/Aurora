local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\ZoneAbility.lua ]]
--end

do --[[ FrameXML\ZoneAbility.xml ]]
    function Skin.ZoneAbilityFrameTemplate(Frame)
        Frame.Style:Hide()
        -- contentFramePool is created by ManagedLayoutFrameMixin:SetTemplate during OnLoad.
        -- Hook.ObjectPoolMixin removed in 11.0.0; hook the button mixin's OnLoad instead.
    end
    function Skin.ZoneAbilityFrameSpellButtonTemplate(Button)
        --Button.Icon:SetTexture(private.textures.plain)
        Base.CropIcon(Button.Icon, Button)

        Button.Count:SetPoint("TOPLEFT", -5, 5)
        Button.Cooldown:SetPoint("TOPLEFT")
        Button.Cooldown:SetPoint("BOTTOMRIGHT")

        Button.NormalTexture:SetTexture("")
        Base.CropIcon(Button:GetHighlightTexture())
        --Base.CropIcon(Button:GetCheckedTexture())
    end
end

function private.FrameXML.ZoneAbility()
    Skin.ZoneAbilityFrameTemplate(_G.ZoneAbilityFrame)
    _G.hooksecurefunc(_G.ZoneAbilityFrameSpellButtonMixin, "OnLoad", Skin.ZoneAbilityFrameSpellButtonTemplate)
end
