local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ SharedXML\MinimalScrollBar.lua ]]
--end

do --[[ SharedXML\MinimalScrollBar.xml ]]
    function Skin.MinimalScrollBar(Frame)
        Skin.FrameTypeScrollBar(Frame)
    end
end

function private.SharedXML.MinimalScrollBar()
    ----====####$$$$%%%%$$$$####====----
    --              MinimalScrollBar              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end

