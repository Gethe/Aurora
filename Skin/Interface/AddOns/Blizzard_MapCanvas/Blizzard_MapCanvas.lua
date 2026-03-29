local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals MapCanvasScrollControllerMixin

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_MapCanvas.lua ]]
    Hook.MapCanvasScrollControllerMixin = {}

    function Hook.MapCanvasScrollControllerMixin:IsZoomingIn()
        local currentScale = self:GetCanvasScale()
        local targetScale = self.targetScale
        if not currentScale or not targetScale then
            return false
        end
        return currentScale < targetScale
    end

    function Hook.MapCanvasScrollControllerMixin:IsZoomingOut()
        local currentScale = self:GetCanvasScale()
        local targetScale = self.targetScale
        if not currentScale or not targetScale then
            return false
        end
        return targetScale < currentScale
    end

    function Hook.MapCanvasScrollControllerMixin:CalculateLerpScaling()
        if not self.targetScale then
            return 1.0, 1.0, 1.0
        end

        return Aurora.Hook.MapCanvasScrollControllerMixin.origCalculateLerpScaling(self)
    end

    function Hook.MapCanvasScrollControllerMixin:RefreshCanvasScale()
        if not self.zoomLevels or not self.zoomLevels[1] then
            return
        end

        return Aurora.Hook.MapCanvasScrollControllerMixin.origRefreshCanvasScale(self)
    end
end

do --[[ AddOns\Blizzard_MapCanvas.xml ]]
    function Skin.MapCanvasFrameScrollContainerTemplate(ScrollFrame)
    end
    function Skin.MapCanvasFrameTemplate(Frame)
    end
end

function private.AddOns.Blizzard_MapCanvas()
    ----====####################====----
    --   MapCanvas_DataProviderBase   --
    ----====####################====----

    ----====#####################====----
    -- MapCanvas_PinFrameLevelsManager --
    ----====#####################====----

    ----====#####################====----
    --  Blizzard_MapCanvasDetailLayer  --
    ----====#####################====----

    ----====####################====----
    -- MapCanvas_ScrollContainerMixin --
    ----====####################====----
    ---@diagnostic disable-next-line: undefined-global
    local ScrollControllerMixin = MapCanvasScrollControllerMixin
    if ScrollControllerMixin and not ScrollControllerMixin._auroraNilGuarded then
        Hook.MapCanvasScrollControllerMixin.origCalculateLerpScaling = ScrollControllerMixin.CalculateLerpScaling
        Hook.MapCanvasScrollControllerMixin.origRefreshCanvasScale = ScrollControllerMixin.RefreshCanvasScale
        Hook.MapCanvasScrollControllerMixin.origIsZoomingIn = ScrollControllerMixin.IsZoomingIn
        Hook.MapCanvasScrollControllerMixin.origIsZoomingOut = ScrollControllerMixin.IsZoomingOut

        ScrollControllerMixin.IsZoomingIn = Hook.MapCanvasScrollControllerMixin.IsZoomingIn
        ScrollControllerMixin.IsZoomingOut = Hook.MapCanvasScrollControllerMixin.IsZoomingOut
        ScrollControllerMixin.CalculateLerpScaling = Hook.MapCanvasScrollControllerMixin.CalculateLerpScaling
        ScrollControllerMixin.RefreshCanvasScale = Hook.MapCanvasScrollControllerMixin.RefreshCanvasScale
        ScrollControllerMixin._auroraNilGuarded = true
    end

    ----====####################====----
    --       Blizzard_MapCanvas       --
    ----====####################====----
end
