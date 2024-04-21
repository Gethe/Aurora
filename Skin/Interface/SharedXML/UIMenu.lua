local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ SharedXML\UIMenu.lua ]]
--end

do --[[ SharedXML\UIMenu.xml ]]
    function Skin.UIMenuTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end
end

--function private.SharedXML.UIMenu()
--end
