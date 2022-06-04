local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollTemplates.lua ]]
--end

do --[[ FrameXML\ScrollTemplates.xml ]]
    function Skin.WowScrollBoxList(Frame)
        Skin.ScrollBoxBaseTemplate(Frame)
    end
    function Skin.VerticalScrollBarTemplate(Frame)
        Skin.ScrollBarBaseTemplate(Frame)
    end

    function Skin.OribosScrollBarButtonScripts(Frame)
        Skin.FrameTypeScrollBarButton(Frame)
    end

    function Skin.OribosScrollBar(Frame)
        Skin.VerticalScrollBarTemplate(Frame)

        Frame.Track:GetRegions():Hide() -- background
        Skin.OribosScrollBarButtonScripts(Frame.Track.Thumb)
        Skin.OribosScrollBarButtonScripts(Frame.Back)
        Skin.OribosScrollBarButtonScripts(Frame.Forward)
    end
end

function private.SharedXML.ScrollTemplates()
end
