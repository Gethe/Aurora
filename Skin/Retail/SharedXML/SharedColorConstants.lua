local _, private = ...
if private.isClassic then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
--local Aurora = private.Aurora

--do --[[ SharedXML\SharedColorConstants.lua ]]
--end

function private.SharedXML.SharedColorConstants()
    _G.CUSTOM_CLASS_COLORS:NotifyChanges()
end
