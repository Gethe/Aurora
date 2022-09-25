local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\Blizzard_TalentUITemplates.lua ]]
    function Skin.TalentButtonTemplate(Button)
        Skin.FrameTypeItemButton(Button)

        local name = Button:GetName()
        _G[name.."Slot"]:Hide()
    end
end

--do --[[ FrameXML\Blizzard_TalentUITemplates.xml ]]
--end

function private.FrameXML.Blizzard_TalentUITemplates()
    ----====####$$$$%%%%$$$$####====----
    --              Blizzard_TalentUITemplates              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
