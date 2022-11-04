local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

--do --[[ SharedXML\Selector\Blizzard_ScrollBoxSelector.lua ]]
--end

do --[[ SharedXML\Selector\Blizzard_ScrollBoxSelector.xml ]]
    function Skin.ScrollBoxSelectorTemplate(Frame)
        Skin.SelectorTemplate(Frame)
        Skin.WowTrimScrollBar(Frame.ScrollBar)
        Skin.WowScrollBoxList(Frame.ScrollBox)
    end
end

function private.SharedXML.Blizzard_ScrollBoxSelector()
    ----====####$$$$%%%%$$$$####====----
    --              Selector\Blizzard_ScrollBoxSelector              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
