local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin =  Aurora.Skin

-- local Base = Aurora.Base
-- local Hook, Skin = Aurora.Hook, Aurora.Skin
-- local Color = Aurora.Color
do --[[ FrameXML\UIDropDownMenu.xml ]]
    do --[[ UIDropDownMenuTemplates.xml ]]
        function Skin.MenuVariants1(Button)
        end
    end
end


function private.AddOns.MenuVariants()

end

