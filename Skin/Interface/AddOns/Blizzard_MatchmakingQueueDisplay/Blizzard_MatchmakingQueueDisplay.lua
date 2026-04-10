local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ AddOns\Blizzard_MatchmakingQueueDisplay.lua ]]
    Hook.QueueTypeSettingsFrameMixin = {}
    function Hook.QueueTypeSettingsFrameMixin:UpdateButtons()
        -- Post-hook: skin any queue type buttons that become visible
        local container = self.QueueContainer
        if not container then return end

        local buttons = { container.Training, container.Solo, container.Duo, container.Trio }
        for _, btn in next, buttons do
            if btn and not btn._auroraSkinned then
                Skin.FrameTypeButton(btn)
                btn._auroraSkinned = true
            end
        end

        if self.GameReadyButton and not self.GameReadyButton._auroraSkinned then
            Skin.FrameTypeButton(self.GameReadyButton)
            self.GameReadyButton._auroraSkinned = true
        end
    end
end

do --[[ AddOns\Blizzard_MatchmakingQueueDisplay.xml ]]
    -- Queue type selection buttons and ready/leave buttons are skinned
    -- dynamically via the UpdateButtons hook and the registration function.
end

function private.AddOns.Blizzard_MatchmakingQueueDisplay()
    ------------------------------------------------
    -- Hook mixin prototypes via Util.Mixin
    ------------------------------------------------
    Util.Mixin(_G.QueueTypeSettingsFrameMixin, Hook.QueueTypeSettingsFrameMixin)

    ------------------------------------------------
    -- Skin the QueueTypeSettingsFrame if it exists
    ------------------------------------------------
    local settingsFrame = _G.QueueTypeSettingsFrame
    if settingsFrame then
        Skin.FrameTypeFrame(settingsFrame)
        Base.StripBlizzardTextures(settingsFrame)

        -- Skin the QueueContainer
        local container = settingsFrame.QueueContainer
        if container then
            Base.StripBlizzardTextures(container)

            -- Skin queue type selection buttons
            local buttons = { container.Training, container.Solo, container.Duo, container.Trio }
            for _, btn in next, buttons do
                if btn and not btn._auroraSkinned then
                    Skin.FrameTypeButton(btn)
                    btn._auroraSkinned = true
                end
            end
        end

        -- Skin the GameReadyButton
        if settingsFrame.GameReadyButton and not settingsFrame.GameReadyButton._auroraSkinned then
            Skin.FrameTypeButton(settingsFrame.GameReadyButton)
            settingsFrame.GameReadyButton._auroraSkinned = true
        end
    end

    ------------------------------------------------
    -- Skin the MatchmakingQueueFrame if it exists
    ------------------------------------------------
    local queueFrame = _G.MatchmakingQueueFrame
    if queueFrame then
        Skin.FrameTypeFrame(queueFrame)
        Base.StripBlizzardTextures(queueFrame)

        -- Skin the LeaveQueueButton if present
        if queueFrame.LeaveQueueButton and not queueFrame.LeaveQueueButton._auroraSkinned then
            Skin.FrameTypeButton(queueFrame.LeaveQueueButton)
            queueFrame.LeaveQueueButton._auroraSkinned = true
        end
    end
end
