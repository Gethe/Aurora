local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Color = Aurora.Color

do --[[ SharedXML\SharedColorConstants.lua ]]
    private.PAPER_FRAME_TITLE_COLOR = Color.white
    private.PAPER_FRAME_TEXT_COLOR = Color.grayLight
end

--function private.SharedXML.SharedColorConstants()
--end
