local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\UIMenu.lua ]]
--end

do --[[ FrameXML\UIMenu.xml ]]
    function Skin.UIMenuTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end
end

--function private.FrameXML.UIMenu()
--end
