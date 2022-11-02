local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\MirrorTimer.lua ]]
--end

do --[[ FrameXML\MirrorTimer.xml ]]
    function Skin.MirrorTimerTemplate(Frame)
        Skin.FrameTypeStatusBar(Frame.StatusBar)
        Frame.Border:Hide()
    end
end

function private.FrameXML.MirrorTimer()
    Skin.MirrorTimerTemplate(_G.MirrorTimer1)
    Skin.MirrorTimerTemplate(_G.MirrorTimer2)
    Skin.MirrorTimerTemplate(_G.MirrorTimer3)
end
