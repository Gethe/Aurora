local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style, embedded)
        if not (embedded or self.IsEmbedded) then
            self.NineSlice:SetCenterColor(Color.frame:GetRGB());
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        Skin.NineSlicePanelTemplate(GameTooltip.NineSlice)
    end
    function Skin.SharedNoHeaderTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end
end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
end
