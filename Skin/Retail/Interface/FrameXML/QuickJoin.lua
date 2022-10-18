local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.QuickJoin()
    local QuickJoinFrame = _G.QuickJoinFrame
    if private.isPatch then
        Skin.WowScrollBoxList(QuickJoinFrame.ScrollBox)
        Skin.WowTrimScrollBar(QuickJoinFrame.ScrollBar)
    else
        Skin.FriendsFrameScrollFrame(QuickJoinFrame.ScrollFrame)
        QuickJoinFrame.ScrollFrame:SetPoint("TOPLEFT", 8, -(private.FRAME_TITLE_HEIGHT + 5))
        QuickJoinFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", -28, 30)
    end
    Skin.MagicButtonTemplate(QuickJoinFrame.JoinQueueButton)
end
