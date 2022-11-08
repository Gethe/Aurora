local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollTemplates.lua ]]
--end

do --[[ FrameXML\ScrollTemplates.xml ]]
    function Skin.WowScrollBoxList(Frame)
        Skin.ScrollBoxBaseTemplate(Frame)
    end
    function Skin.WowScrollBox(Frame)
        Skin.ScrollBoxBaseTemplate(Frame)
    end
    function Skin.VerticalScrollBarTemplate(Frame)
        Skin.ScrollBarBaseTemplate(Frame)
    end
    function Skin.ScrollingEditBoxTemplate(Frame)
        Skin.WowScrollBox(Frame.ScrollBox)
    end
    function Skin.ScrollingFontTemplate(Frame)
        Skin.WowScrollBox(Frame.ScrollBox)
    end
end

function private.SharedXML.ScrollTemplates()
end
