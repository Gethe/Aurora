local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Skin = Aurora.Skin

local wrappedPools = setmetatable({}, {__mode = "k"})

local function WrapPoolAcquire(pool, skinFunc)
    if not pool or wrappedPools[pool] then
        return
    end

    local acquire = pool.Acquire
    pool.Acquire = function(self, ...)
        local frame, isNew = acquire(self, ...)
        skinFunc(frame)
        return frame, isNew
    end

    wrappedPools[pool] = true

    for frame in pool:EnumerateActive() do
        skinFunc(frame)
    end
end

function private.AddOns.Blizzard_DelvesDifficultyPicker()
    local DelvesDifficultyPickerFrame = _G.DelvesDifficultyPickerFrame

    Skin.InsetFrameTemplate(DelvesDifficultyPickerFrame)
    Skin.DialogBorderTemplate(DelvesDifficultyPickerFrame.Border)
    Skin.UIPanelCloseButton(DelvesDifficultyPickerFrame.CloseButton)
    Skin.WowStyle1DropdownTemplate(DelvesDifficultyPickerFrame.Dropdown)
    Skin.UIPanelButtonTemplate(DelvesDifficultyPickerFrame.EnterDelveButton)

    local rewardsFrame = DelvesDifficultyPickerFrame.DelveRewardsContainerFrame
    if rewardsFrame then
        if rewardsFrame.ScrollBox then
            Skin.WowScrollBoxList(rewardsFrame.ScrollBox)
        end
        if rewardsFrame.ScrollBar then
            Skin.MinimalScrollBar(rewardsFrame.ScrollBar)
        end

        WrapPoolAcquire(rewardsFrame.rewardPool, Skin.LargeItemButtonTemplate)
    end
end
