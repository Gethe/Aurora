local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    Skin.DialogBorderTemplate(GameMenuFrame.Border)
    Skin.DialogHeaderTemplate(GameMenuFrame.Header)

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonHelp)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonStore)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonWhatsNew)

    if private.isPatch then
        Skin.GameMenuButtonTemplate(_G.GameMenuButtonSettings)
        Skin.GameMenuButtonTemplate(_G.GameMenuButtonEditMode)
    else
        Skin.GameMenuButtonTemplate(_G.GameMenuButtonOptions)
        Skin.GameMenuButtonTemplate(_G.GameMenuButtonUIOptions)
        Skin.GameMenuButtonTemplate(_G.GameMenuButtonKeybindings)
    end
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonMacros)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonAddons)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonRatings) -- Used in Korean locale

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonLogout)
    Skin.GameMenuButtonTemplate(_G.GameMenuButtonQuit)

    Skin.GameMenuButtonTemplate(_G.GameMenuButtonContinue)
end
