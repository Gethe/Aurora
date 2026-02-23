local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Base = Aurora.Base
local Color = Aurora.Color

do --[[ FrameXML\UIDropDownMenu.xml ]]
    do --[[ UIDropDownMenuTemplates.xml ]]
        function Skin.MenuVariants1(Button)
        end
    end
end


function private.AddOns.MenuVariants()
    -- Hook MenuStyle1Mixin:Generate to replace the atlas background with Aurora's backdrop.
    -- This affects all context menus and dropdown popups that use the default menu style.
    _G.hooksecurefunc(_G.MenuStyle1Mixin, "Generate", function(self)
        for _, region in ipairs({ self:GetRegions() }) do
            if region:IsObjectType("Texture") and region:GetAtlas() == "common-dropdown-bg" then
                region:SetAlpha(0)
            end
        end
        Base.SetBackdrop(self, Color.frame)
    end)
end

