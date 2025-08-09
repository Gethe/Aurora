local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ Blizzard_Flyout\Blizzard_Flyout.lua ]]
    Hook.FlyoutButtonMixin = {}
    function Hook.FlyoutButtonMixin:OnLoad()
        _G.print("Hook.FlyoutButtonMixin:OnLoad", self:GetName())
    end
    function Skin.FlyoutButtonTemplate()
        local button = _G[self:GetName() .. "Button"]
        if button then
            _G.print("Skin.FlyoutButtonTemplate", button:GetName())
        end
        local icon = _G[self:GetName() .. "Icon"]
        if icon then
            _G.print("Skin.FlyoutButtonTemplate", button:GetName())
        end
    end
end

--do --[[ Blizzard_Flyout\Blizzard_Flyout.xml ]]
--end

function private.FrameXML.Blizzard_Flyout()
    -- Util.Mixin(_G.FlyoutButtonMixin, Hook.FlyoutButtonMixin)
end
-- <Button name="FlyoutButtonTemplate" mixin="FlyoutButtonMixin" virtual="true">
--- <Frame name="FlyoutPopupTemplate" mixin="FlyoutPopupMixin" virtual="true">
-- <Frame name="FlyoutPopupButtonTemplate" mixin="FlyoutPopupButtonMixin" virtual="true">