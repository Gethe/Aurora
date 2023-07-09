local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\ScrollBox.lua ]]
--end

do --[[ FrameXML\ScrollBox.xml ]]
    function Skin.ScrollBoxBaseTemplate(Frame)
        Base.SetBackdrop(Frame, Color.frame)
    end
end

function private.SharedXML.ScrollBox()
end
