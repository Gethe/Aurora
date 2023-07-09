local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\ScrollingFlatPanel.lua ]]
--end

do --[[ FrameXML\ScrollingFlatPanel.xml ]]
    function Skin.ScrollingFlatPanelTemplate(Frame)
        Skin.DefaultPanelFlatTemplate(Frame)
        Skin.UIPanelCloseButtonDefaultAnchors(Frame.ClosePanelButton)
        Skin.WowScrollBoxList(Frame.ScrollBox)
        Skin.MinimalScrollBar(Frame.ScrollBar)
    end
end

function private.FrameXML.ScrollingFlatPanel()
    ----====####$$$$%%%%$$$$####====----
    --              ScrollingFlatPanel              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
