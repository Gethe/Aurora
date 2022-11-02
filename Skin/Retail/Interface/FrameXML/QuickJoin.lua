local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.QuickJoin()
    local QuickJoinFrame = _G.QuickJoinFrame
    Skin.WowScrollBoxList(QuickJoinFrame.ScrollBox)
    Skin.WowTrimScrollBar(QuickJoinFrame.ScrollBar)
    Skin.MagicButtonTemplate(QuickJoinFrame.JoinQueueButton)
end
