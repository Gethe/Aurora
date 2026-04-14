local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Base = Aurora.Base
local Color = Aurora.Color

do --[[ AddOns\Blizzard_QuestTimer.lua ]]
end

do --[[ AddOns\Blizzard_QuestTimer.xml ]]
end

function private.AddOns.Blizzard_QuestTimer()
    local frame = _G.QuestTimerFrame
    if not frame then return end

    ------------------------------------
    -- Apply Aurora backdrop (replace BACKDROP_DIALOG_32_32)
    ------------------------------------
    Base.SetBackdrop(frame, Color.frame)

    ------------------------------------
    -- Strip QuestTimerHeader dialog header texture and decorative borders
    ------------------------------------
    local header = _G.QuestTimerHeader
    if header then
        header:SetAlpha(0)
    end
end
