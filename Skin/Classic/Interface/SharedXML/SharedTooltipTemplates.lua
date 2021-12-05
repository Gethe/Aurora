local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    function Hook.SharedTooltip_SetBackdropStyle(self, style, embedded)
        if not (embedded or self.IsEmbedded) then
            local r, g, b = Color.frame:GetRGB()
            local a = Util.GetFrameAlpha()

            if private.hasAPI then
                self.NineSlice:SetCenterColor(r, g, b, a);
            else
                self:SetBackdropColor(r, g, b, a)
                self:SetBackdropBorderColor(r, g, b)
            end
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        if private.hasAPI then
            Skin.NineSlicePanelTemplate(GameTooltip.NineSlice)
        else
            Skin.FrameTypeFrame(GameTooltip)
        end
    end
    function Skin.SharedNoHeaderTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end
    function Skin.TooltipBackdropTemplate(Frame)
        if private.hasAPI then
            Skin.NineSlicePanelTemplate(Frame.NineSlice)
        else
            Skin.FrameTypeFrame(Frame)
        end
    end
    function Skin.TooltipBorderBackdropTemplate(Frame)
        if private.hasAPI then
            Skin.TooltipBackdropTemplate(Frame)
        else
            Skin.FrameTypeFrame(Frame)
            Frame:SetBackdropColor(Color.frame, 0)
        end
    end
    function Skin.TooltipBorderedFrameTemplate(Frame)
        if private.hasAPI then
            Skin.TooltipBackdropTemplate(Frame)
        else
            Frame.BorderTopLeft:Hide()
            Frame.BorderTopRight:Hide()

            Frame.BorderBottomLeft:Hide()
            Frame.BorderBottomRight:Hide()

            Frame.BorderTop:Hide()
            Frame.BorderBottom:Hide()
            Frame.BorderLeft:Hide()
            Frame.BorderRight:Hide()

            Frame.Background:Hide()
            Skin.FrameTypeFrame(Frame)
        end
    end
end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    if not private.hasAPI then
        _G.hooksecurefunc("GameTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
    end
    _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)
end
