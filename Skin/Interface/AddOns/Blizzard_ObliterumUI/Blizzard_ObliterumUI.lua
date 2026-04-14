local _, private = ...
if private.shouldSkip() then return end

local Aurora = private.Aurora
local Base, _, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

function private.AddOns.Blizzard_ObliterumUI()
    local frame = _G.ObliterumForgeFrame
    if not frame then return end

    ------------------------------------
    -- Main frame (ButtonFrameTemplate)
    ------------------------------------
    Skin.FrameTypeFrame(frame)

    ------------------------------------
    -- Strip decorative textures
    ------------------------------------
    -- Background atlas (obliterumforge-background)
    if frame.Background then
        frame.Background:SetAlpha(0)
    end

    ------------------------------------
    -- Item slot icon
    ------------------------------------
    local ItemSlot = frame.ItemSlot
    if ItemSlot then
        if ItemSlot.Icon then
            Base.CropIcon(ItemSlot.Icon, ItemSlot)
        end
        -- Hide decorative corner textures
        if ItemSlot.Corners then
            ItemSlot.Corners:SetAlpha(0)
        end
        if ItemSlot.GlowCorners then
            ItemSlot.GlowCorners:SetAlpha(0)
        end
    end

    ------------------------------------
    -- Obliterate action button
    ------------------------------------
    if frame.ObliterateButton then
        Skin.FrameTypeButton(frame.ObliterateButton)
    end
end
