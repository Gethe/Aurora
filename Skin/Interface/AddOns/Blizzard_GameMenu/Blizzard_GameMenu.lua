local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

function private.FrameXML.GameMenuFrame()
    -- FIXLATER
    -- local GameMenuFrame = _G.GameMenuFrameMixin

    -- if private.isRetail then
    --     Skin.DialogBorderTemplate(GameMenuFrame.Frame.Border)
    --     Skin.DialogHeaderTemplate(GameMenuFrame.Header)
    -- else
    --     Skin.DialogBorderTemplate(GameMenuFrame)

    --     local header, text = GameMenuFrame:GetRegions()
    --     header:Hide()
    --     text:ClearAllPoints()
    --     text:SetPoint("TOPLEFT")
    --     text:SetPoint("BOTTOMRIGHT", _G.GameMenuFrameMixin, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    -- end

    -- FIXLATER
    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonHelp)
    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonStore)

    -- if private.isRetail then
    --     Skin.GameMenuButtonTemplate(_G.GameMenuButtonWhatsNew)

    --     Skin.GameMenuButtonTemplate(_G.GameMenuButtonSettings)
    --     Skin.GameMenuButtonTemplate(_G.GameMenuButtonEditMode)
    -- else
    --     Skin.GameMenuButtonTemplate(_G.GameMenuButtonOptions)
    -- end

    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonMacros)
    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonAddons)
    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonRatings) -- Used in Korean locale

    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonLogout)
    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonQuit)

    -- Skin.GameMenuButtonTemplate(_G.GameMenuButtonContinue)
end
