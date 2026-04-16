local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin


function private.AddOns.Blizzard_HousingModelPreview()
    ----
    -- Main Frame (ButtonFrameTemplate-based)
    ----
    local HousingModelPreviewFrame = _G.HousingModelPreviewFrame

    Skin.PortraitFrameTemplate(HousingModelPreviewFrame)

    ----
    -- ModelPreview (HousingModelPreviewTemplate)
    -- Hide decorative textures, leave ModelScene and ModelSceneControls unskinned
    ----
    local ModelPreview = HousingModelPreviewFrame.ModelPreview
    if ModelPreview then
        if ModelPreview.PreviewBackground then ModelPreview.PreviewBackground:SetAlpha(0) end
        if ModelPreview.PreviewCornerLeft then ModelPreview.PreviewCornerLeft:SetAlpha(0) end
        if ModelPreview.PreviewCornerRight then ModelPreview.PreviewCornerRight:SetAlpha(0) end
    end
end
