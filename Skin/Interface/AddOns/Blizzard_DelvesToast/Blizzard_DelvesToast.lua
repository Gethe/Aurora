local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

function private.AddOns.Blizzard_DelvesToast()
    local frame = _G.DelvesToastFrame
    if not frame then return end

    ------------------------------------
    -- Apply Aurora backdrop
    ------------------------------------
    Base.SetBackdrop(frame, Color.frame)

    ------------------------------------
    -- Strip the UI-Frame-Delves-notification-frame atlas background
    ------------------------------------
    Base.StripBlizzardTextures(frame)

    ------------------------------------
    -- Skin the close button
    ------------------------------------
    if frame.CloseButton then
        Skin.UIPanelCloseButton(frame.CloseButton)
    end
end
