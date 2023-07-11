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
        if private.isRetail then
            Skin.FrameTypeStatusBar(Frame.StatusBar)
            Frame.Border:Hide()
        else
            Skin.FrameTypeStatusBar(_G[Frame:GetName().."StatusBar"])
            _G[Frame:GetName().."Border"]:Hide()
        end
    end
end

function private.FrameXML.MirrorTimer()
    if private.isPatch then
        Skin.MirrorTimerTemplate(_G.MirrorTimerContainer.mirrorTimers[1])
        Skin.MirrorTimerTemplate(_G.MirrorTimerContainer.mirrorTimers[2])
        Skin.MirrorTimerTemplate(_G.MirrorTimerContainer.mirrorTimers[3])
    else
        Skin.MirrorTimerTemplate(_G.MirrorTimer1)
        Skin.MirrorTimerTemplate(_G.MirrorTimer2)
        Skin.MirrorTimerTemplate(_G.MirrorTimer3)
    end
end
