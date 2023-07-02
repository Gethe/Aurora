local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\OribosScrollBar.lua ]]
--end

do --[[ FrameXML\OribosScrollBar.xml ]]
    function Skin.OribosScrollBarButtonScripts(Frame)
        Skin.FrameTypeScrollBarButton(Frame)
    end

    function Skin.OribosScrollBar(Frame)
        Skin.VerticalScrollBarTemplate(Frame)
        Skin.FrameTypeScrollBar(Frame)

        Frame.Track:GetRegions():Hide() -- background
        Skin.OribosScrollBarButtonScripts(Frame.Track.Thumb)
        Skin.OribosScrollBarButtonScripts(Frame.Back)
        Skin.OribosScrollBarButtonScripts(Frame.Forward)
    end
end

--function private.SharedXML.OribosScrollBar()
--end
