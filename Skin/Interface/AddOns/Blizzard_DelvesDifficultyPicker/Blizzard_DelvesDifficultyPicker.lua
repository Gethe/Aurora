local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

function private.AddOns.Blizzard_DelvesDifficultyPicker()
    local DelvesDifficultyPickerFrame = _G.DelvesDifficultyPickerFrame

    Skin.InsetFrameTemplate(DelvesDifficultyPickerFrame)
    Skin.DialogBorderTemplate(DelvesDifficultyPickerFrame.Border)
    Skin.UIPanelCloseButton(DelvesDifficultyPickerFrame.CloseButton)
    Skin.DropdownButton(DelvesDifficultyPickerFrame.Dropdown)
    Skin.UIPanelButtonTemplate(DelvesDifficultyPickerFrame.EnterDelveButton)

    local rewardsFrame = DelvesDifficultyPickerFrame.DelveRewardsContainerFrame
    if rewardsFrame then
        if rewardsFrame.ScrollBox then
            Skin.WowScrollBoxList(rewardsFrame.ScrollBox)
        end
        if rewardsFrame.ScrollBar then
            Skin.MinimalScrollBar(rewardsFrame.ScrollBar)
        end

        Util.WrapPoolAcquire(rewardsFrame.rewardPool, Skin.LargeItemButtonTemplate)
    end
end
