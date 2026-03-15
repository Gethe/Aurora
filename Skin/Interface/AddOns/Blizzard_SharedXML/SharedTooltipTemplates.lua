local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\SharedTooltipTemplates.lua ]]
    -- Tooltips skinned via the taint-safe path (NineSlice border pieces
    -- hidden with SetAlpha(0), no _auroraNineSlice flag) must not have
    -- their NineSlice touched from addon context during display, or the
    -- "secret number" taint propagates to child widgets.
    local taintSafeTooltips = {}
    function Hook.SetTaintSafe(tooltip)
        taintSafeTooltips[tooltip] = true
    end

    function Hook.SharedTooltip_SetBackdropStyle(self, style, embedded)
        if self:IsForbidden() then return end
        if taintSafeTooltips[self] then return end
        if not (embedded or self.IsEmbedded) then
            local r, g, b = Color.frame:GetRGB()
            local a = Util.GetFrameAlpha()

            self.NineSlice:SetCenterColor(r, g, b, a);
        end
    end
end

do --[[ FrameXML\SharedTooltipTemplates.xml ]]
    function Skin.SharedTooltipTemplate(GameTooltip)
        if GameTooltip.debug then
            GameTooltip.NineSlice.debug = GameTooltip.debug
        end
        Skin.NineSlicePanelTemplate(GameTooltip.NineSlice)
    end
    function Skin.SharedNoHeaderTooltipTemplate(GameTooltip)
        Skin.SharedTooltipTemplate(GameTooltip)
    end

    function Skin.TooltipBackdropTemplate(Frame)
        if Frame.debug then
            Frame.NineSlice.debug = Frame.debug
        end
        Skin.NineSlicePanelTemplate(Frame.NineSlice)

        local r, g, b = Color.frame:GetRGB()
        Frame:SetBackdropColor(r, g, b, Frame.backdropColorAlpha or 1)
    end

    function Skin.TooltipBorderBackdropTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end

    function Skin.TooltipBorderedFrameTemplate(Frame)
        Skin.TooltipBackdropTemplate(Frame)
    end

end

function private.SharedXML.SharedTooltipTemplates()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("SharedTooltip_SetBackdropStyle", Hook.SharedTooltip_SetBackdropStyle)

    -- Replace GameTooltip_InsertFrame to avoid taint: Aurora's font
    -- modifications cause GetLineHeight() and GetHeight() to return secret
    -- numbers, breaking Round() arithmetic at SharedTooltipTemplates.lua:202.
    if _G.GameTooltip_InsertFrame then
        local function SafeNumber(value, fallback)
            if type(value) ~= "number" then return fallback end
            if _G.issecretvalue and _G.issecretvalue(value) then return fallback end
            return value
        end

        _G.GameTooltip_InsertFrame = function(tooltipFrame, frame, verticalPadding)
            verticalPadding = verticalPadding or 0

            local textSpacing = tooltipFrame:GetCustomLineSpacing() or 2
            local leftLine2 = tooltipFrame:GetLeftLine(2)
            local rawLineHeight = leftLine2 and leftLine2:GetLineHeight() or 12
            local textHeight = _G.Round(SafeNumber(rawLineHeight, 12))
            local rawFrameHeight = frame:GetHeight()
            local neededHeight = _G.Round(SafeNumber(rawFrameHeight, 0) + verticalPadding)
            local numLinesNeeded = _G.math.ceil(neededHeight / (textHeight + textSpacing))
            local currentLine = tooltipFrame:NumLines()
            _G.GameTooltip_AddBlankLinesToTooltip(tooltipFrame, numLinesNeeded)
            frame:SetParent(tooltipFrame)
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", tooltipFrame:GetLeftLine(currentLine + 1), "TOPLEFT", 0, -verticalPadding)
            if not tooltipFrame.insertedFrames then
                tooltipFrame.insertedFrames = {}
            end
            local frameWidth = SafeNumber(frame:GetWidth(), 0)
            if tooltipFrame:GetMinimumWidth() < frameWidth then
                tooltipFrame:SetMinimumWidth(frameWidth)
            end
            frame:Show()
            _G.tinsert(tooltipFrame.insertedFrames, frame)
            return (numLinesNeeded * textHeight) + (numLinesNeeded - 1) * textSpacing
        end
    end
end
