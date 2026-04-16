local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color


-- Shared helper: skins frames inheriting HousingCreateNeighborhoodTemplate
-- Both HousingCreateNeighborhoodCharterFrame and HousingCreateGuildNeighborhoodFrame use this template.
local function SkinCreateNeighborhoodTemplate(Frame)
    Base.SetBackdrop(Frame, Color.frame)

    -- Hide decorative textures
    if Frame.Border then Frame.Border:SetAlpha(0) end
    if Frame.Background then Frame.Background:SetAlpha(0) end
    if Frame.Header then Frame.Header:SetAlpha(0) end
    if Frame.DetailsBackground then Frame.DetailsBackground:SetAlpha(0) end
    if Frame.DetailsDivider then Frame.DetailsDivider:SetAlpha(0) end
    if Frame.PlantDecoLeft then Frame.PlantDecoLeft:SetAlpha(0) end

    -- Edit box
    if Frame.NeighborhoodNameEditBox then
        Skin.FrameTypeEditBox(Frame.NeighborhoodNameEditBox)
    end

    -- Buttons
    if Frame.ConfirmButton then Skin.UIPanelButtonTemplate(Frame.ConfirmButton) end
    if Frame.CancelButton then Skin.UIPanelButtonTemplate(Frame.CancelButton) end
end

-- Shared helper: skins frames inheriting HousingCreateNeighborhoodConfirmationTemplate
-- Used by HousingCreateCharterNeighborhoodConfirmationFrame and the guild inline ConfirmationFrame.
local function SkinConfirmationTemplate(Frame)
    Base.SetBackdrop(Frame, Color.frame)

    -- Hide decorative textures (same set as the creation template)
    if Frame.Border then Frame.Border:SetAlpha(0) end
    if Frame.Background then Frame.Background:SetAlpha(0) end
    if Frame.Header then Frame.Header:SetAlpha(0) end
    if Frame.DetailsBackground then Frame.DetailsBackground:SetAlpha(0) end
    if Frame.DetailsDivider then Frame.DetailsDivider:SetAlpha(0) end
    if Frame.PlantDecoLeft then Frame.PlantDecoLeft:SetAlpha(0) end

    -- Buttons
    if Frame.ConfirmButton then Skin.UIPanelButtonTemplate(Frame.ConfirmButton) end
    if Frame.CancelButton then Skin.UIPanelButtonTemplate(Frame.CancelButton) end
end


function private.AddOns.Blizzard_HousingCreateNeighborhood()
    ----
    -- Charter Creation Frame (HousingCreateNeighborhoodTemplate)
    ----
    local CharterFrame = _G.HousingCreateNeighborhoodCharterFrame
    SkinCreateNeighborhoodTemplate(CharterFrame)

    ----
    -- Guild Creation Frame (HousingCreateNeighborhoodTemplate)
    ----
    local GuildFrame = _G.HousingCreateGuildNeighborhoodFrame
    SkinCreateNeighborhoodTemplate(GuildFrame)

    -- Guild inline confirmation frame (HousingCreateNeighborhoodConfirmationTemplate child)
    if GuildFrame.ConfirmationFrame then
        SkinConfirmationTemplate(GuildFrame.ConfirmationFrame)
    end

    ----
    -- Charter Confirmation Frame (standalone global, HousingCreateNeighborhoodConfirmationTemplate)
    ----
    local CharterConfirmation = _G.HousingCreateCharterNeighborhoodConfirmationFrame
    SkinConfirmationTemplate(CharterConfirmation)
end
