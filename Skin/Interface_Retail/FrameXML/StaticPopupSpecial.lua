local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\StaticPopupSpecial.lua ]]
--end

--do --[[ FrameXML\StaticPopupSpecial.xml ]]
--end

function private.FrameXML.StaticPopupSpecial()
    local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
    Skin.DialogBorderTemplate(PetBattleQueueReadyFrame.Border)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.AcceptButton)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.DeclineButton)
end
