local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
-- local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_StaticPopup_Game\Mainline\StaticPopupSpecial.lua ]]
--end

--do --[[ AddOns\Blizzard_StaticPopup_Game\Mainline\StaticPopupSpecial.xml ]]
--end
function private.AddOns.StaticPopupSpecial()
    local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
    Skin.DialogBorderTemplate(PetBattleQueueReadyFrame.Border)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.AcceptButton)
    Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.DeclineButton)
end
