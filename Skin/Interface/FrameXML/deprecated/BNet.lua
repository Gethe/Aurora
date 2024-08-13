local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ SharedXML\BNet.lua ]]
--end

--do --[[ SharedXML\BNet.xml ]]
--end

function private.SharedXML.BNet()
    ------------------
    -- BNToastFrame --
    ------------------
    Skin.SocialToastTemplate(_G.BNToastFrame)


    --------------------
    -- TimeAlertFrame --
    --------------------
    Skin.SocialToastTemplate(_G.TimeAlertFrame)
end
