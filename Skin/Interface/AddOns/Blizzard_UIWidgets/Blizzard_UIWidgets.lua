local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals _G next type

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

local FORCE_WIDGET_CHAT_DEBUG = false

local function IsSecret(value)
    if _G.issecretvalue and _G.issecretvalue(value) then
        return true
    end
    if _G.issecrettable and _G.issecrettable(value) then
        return true
    end
    return false
end

local function SafeSetAlpha(obj, alpha)
    if obj then
        _G.pcall(obj.SetAlpha, obj, alpha)
    end
end

local function SafeNumber(value, fallback)
    if type(value) ~= "number" or IsSecret(value) then
        return fallback
    end
    return value
end

local function SafeDebugName(frame)
    if not frame then
        return "<nil>"
    end

    local ok, debugName = _G.pcall(function()
        return frame:GetDebugName()
    end)
    if ok and type(debugName) == "string" and debugName ~= "" then
        return debugName
    end

    local okName, name = _G.pcall(function()
        return frame.GetName and frame:GetName()
    end)
    if okName and type(name) == "string" and name ~= "" then
        return name
    end

    return "<frame>"
end

local function IsBelowMinimapContainer(container)
    return container == _G.UIWidgetBelowMinimapContainerFrame
end

local function DebugBelowMinimap(...)
    if not private.isDev and not FORCE_WIDGET_CHAT_DEBUG then
        return
    end

    if private.debug then
        private.debug("UIWidgetBelowMinimap", ...)
    end
    if FORCE_WIDGET_CHAT_DEBUG then
        _G.pcall(_G.print, "|cff33ff99Aurora UIWidgetBelowMinimap|r", ...)
    end
end

local function DebugUIWidgets(...)
    if not private.isDev and not FORCE_WIDGET_CHAT_DEBUG then
        return
    end

    if private.debug then
        private.debug(...)
    end
    if FORCE_WIDGET_CHAT_DEBUG then
        _G.pcall(_G.print, "|cff33ff99Aurora UIWidgets|r", ...)
    end
end

local function BootstrapWidgetContainer(container)
    if not container then
        return
    end

    local activeSetID = container.widgetSetID
    local belowMinimapSetID = _G.C_UIWidgetManager and _G.C_UIWidgetManager.GetBelowMinimapWidgetSetID and _G.C_UIWidgetManager.GetBelowMinimapWidgetSetID()
    DebugBelowMinimap("Bootstrap", SafeDebugName(container), "activeSetID", activeSetID, "belowMinimapSetID", belowMinimapSetID)

    if not activeSetID then
        return
    end

    local setWidgets = _G.C_UIWidgetManager.GetAllWidgetsBySetID(activeSetID)
    DebugBelowMinimap("Bootstrap widgets", #setWidgets)
    for _, widgetInfo in next, setWidgets do
        local widgetTypeInfo = _G.UIWidgetManager:GetWidgetTypeInfo(widgetInfo.widgetType)
        local template = widgetTypeInfo and widgetTypeInfo.templateInfo and widgetTypeInfo.templateInfo.frameTemplate or "<missing>"
        DebugBelowMinimap("Bootstrap widget", "widgetID", widgetInfo.widgetID, "widgetType", widgetInfo.widgetType, "template", template)
    end

    Hook.UIWidgetManagerMixin.OnWidgetContainerRegistered(_G.UIWidgetManager, container)
end

do --[[ AddOns\Blizzard_UIWidgets.lua ]]
    do --[[ Blizzard_UIWidgetManager ]]
        Hook.UIWidgetContainerMixin = {}
        function Hook.UIWidgetContainerMixin:CreateWidget(widgetID, widgetType, widgetTypeInfo, widgetInfo)
            local widgetFrame = self.widgetFrames[widgetID]
            if not widgetFrame then
                -- if private.isDev then
                --     _G.print("UIWidgetContainerMixin:CreateWidget no widgetFrame", self:GetDebugName(), widgetID, widgetType)
                -- end
                return
            end

            local template = widgetTypeInfo.templateInfo.frameTemplate
            if IsBelowMinimapContainer(self) then
                DebugBelowMinimap("CreateWidget", "container", SafeDebugName(self), "widgetID", widgetID, "widgetType", widgetType, "template", template)
            end

            if Skin[template] then
                DebugUIWidgets("Skinning template for UIWidgetContainerMixin", SafeDebugName(widgetFrame), template)
                if not widgetFrame._auroraSkinned then
                    local ok, err = _G.pcall(Skin[template], widgetFrame)
                    if not ok then
                        DebugUIWidgets("Error skinning template", template, SafeDebugName(widgetFrame), err)
                    end
                    widgetFrame._auroraSkinned = true
                    if IsBelowMinimapContainer(self) then
                        DebugBelowMinimap("Skinned template", template, SafeDebugName(widgetFrame))
                    end
                end
            else
                DebugUIWidgets("Missing template for UIWidgetContainerMixin", SafeDebugName(widgetFrame), template)
                if IsBelowMinimapContainer(self) then
                    DebugBelowMinimap("Missing template", template, SafeDebugName(widgetFrame))
                end
            end
        end

        Hook.UIWidgetManagerMixin = {}
        function Hook.UIWidgetManagerMixin:OnWidgetContainerRegistered(widgetContainer)
            local setWidgets = _G.C_UIWidgetManager.GetAllWidgetsBySetID(widgetContainer.widgetSetID)
            if IsBelowMinimapContainer(widgetContainer) then
                DebugBelowMinimap("OnWidgetContainerRegistered", SafeDebugName(widgetContainer), "widgetSetID", widgetContainer.widgetSetID, "count", #setWidgets)
            end

            local widgetID, widgetType, widgetTypeInfo, widgetVisInfo
            for _, widgetInfo in next, setWidgets do
                widgetID, widgetType = widgetInfo.widgetID, widgetInfo.widgetType
                widgetTypeInfo = _G.UIWidgetManager:GetWidgetTypeInfo(widgetType)
                widgetVisInfo = widgetTypeInfo.visInfoDataFunction(widgetID)

                Hook.UIWidgetContainerMixin.CreateWidget(widgetContainer, widgetID, widgetType, widgetTypeInfo, widgetVisInfo)
            end

            Util.Mixin(widgetContainer, Hook.UIWidgetContainerMixin)
        end
    end

    do --[[ Blizzard_UIWidgetBelowMinimapFrame ]]
        function Skin.UIWidgetBelowMinimapContainerFrame(Frame)
            DebugBelowMinimap("Skin container frame", SafeDebugName(Frame))

            SafeSetAlpha(Frame and Frame.LeftLine, 0)
            SafeSetAlpha(Frame and Frame.RightLine, 0)
            SafeSetAlpha(Frame and Frame.BarBackground, 0)
            SafeSetAlpha(Frame and Frame.Glow1, 0)
            SafeSetAlpha(Frame and Frame.Glow2, 0)
            SafeSetAlpha(Frame and Frame.Glow3, 0)
        end
    
        Hook.UIWidgetBelowMinimapContainerMixin = {}
        function Hook.UIWidgetBelowMinimapContainerMixin:RegisterForWidgetSet(widgetSetID)
                if IsBelowMinimapContainer(self) then
                    DebugBelowMinimap("RegisterForWidgetSet", SafeDebugName(self), widgetSetID)
                Skin.UIWidgetBelowMinimapContainerFrame(self)
            end
        end

        function Hook.UIWidgetBelowMinimapContainerMixin:ProcessAllWidgets()
                if IsBelowMinimapContainer(self) then
                    DebugBelowMinimap("ProcessAllWidgets", SafeDebugName(self), self.widgetSetID)
                Skin.UIWidgetBelowMinimapContainerFrame(self)
            end
        end
    end
end

do --[[ AddOns\Blizzard_UIWidgets.xml ]]
    do --[[ Blizzard_UIWidgetTemplateBase ]]
        function Skin.UIWidgetBaseStatusBarTemplate(StatusBar)
            Skin.FrameTypeStatusBar(StatusBar)
        end
        function Skin.UIWidgetBaseSpellTemplate(Frame)
            Base.CropIcon(Frame.Icon, Frame)

            SafeSetAlpha(Frame.Border, 0)
            SafeSetAlpha(Frame.DebuffBorder, 0)
        end
        function Skin.UIWidgetBaseScenarioHeaderTemplate(Frame)
            SafeSetAlpha(Frame.Frame, 0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateIconAndText ]]
        Skin.UIWidgetTemplateIconAndText = private.nop
    end
    do --[[ Blizzard_UIWidgetTemplateStatusBar ]]
        function Skin.UIWidgetTemplateStatusBar(Frame)
            local StatusBar = Frame.Bar
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)
            SafeSetAlpha(StatusBar.BGLeft, 0)
            SafeSetAlpha(StatusBar.BGRight, 0)
            SafeSetAlpha(StatusBar.BGCenter, 0)
            SafeSetAlpha(StatusBar.BorderLeft, 0)
            SafeSetAlpha(StatusBar.BorderRight, 0)
            SafeSetAlpha(StatusBar.BorderCenter, 0)
            SafeSetAlpha(StatusBar.Spark, 0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateDoubleStatusBar ]]
        function Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(StatusBar)
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)

            SafeSetAlpha(StatusBar.BG, 0)
            SafeSetAlpha(StatusBar.BorderLeft, 0)
            SafeSetAlpha(StatusBar.BorderRight, 0)
            SafeSetAlpha(StatusBar.BorderCenter, 0)
            SafeSetAlpha(StatusBar.Spark, 0)
            SafeSetAlpha(StatusBar.SparkGlow, 0)
            if StatusBar.BorderGlow then
                StatusBar.BorderGlow:SetAllPoints(StatusBar)
                StatusBar.BorderGlow:SetTexCoord(0.025, 0.975, 0.19354838709677, 0.80645161290323)
            end
        end
        function Skin.UIWidgetTemplateDoubleStatusBar(Frame)
            Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(Frame.LeftBar)
            Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(Frame.RightBar)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateTextWithState ]]
        Skin.UIWidgetTemplateTextWithState = private.nop
    end
    do --[[ Blizzard_UIWidgetTemplateButtonHeader ]]
        function Skin.ButtonHeaderButton(Button)
            if Button._auroraSkinned then
                return
            end
            -- _isMinimal prevents Skin.FrameTypeButton from adding its own backdrop,
            -- so the button sits seamlessly inside our unified _auroraBackdrop
            Button._isMinimal = true
            Skin.FrameTypeButton(Button)
            -- Explicitly hide the atlas texture sub-objects (parentKey refs in UIWidgetBaseButtonTemplate)
            SafeSetAlpha(Button.NormalTexture, 0)
            SafeSetAlpha(Button.HighlightTexture, 0)
            SafeSetAlpha(Button.PushedTexture, 0)
            Base.CropIcon(Button.Icon, Button)
            Button._auroraSkinned = true
        end

        local function ApplyButtonHeaderBackdrop(Frame)
            if not Frame._auroraBackdrop then
                local backdrop = _G.CreateFrame("Frame", nil, Frame)
                backdrop:SetFrameLevel(Frame:GetFrameLevel())
                Skin.FrameTypeFrame(backdrop)
                Frame._auroraBackdrop = backdrop
            end
            Frame._auroraBackdrop:ClearAllPoints()
            Frame._auroraBackdrop:SetPoint("LEFT",   Frame.HeaderText,      "LEFT",  -16, 0)
            Frame._auroraBackdrop:SetPoint("TOP",    Frame.ButtonContainer, "TOP")
            Frame._auroraBackdrop:SetPoint("RIGHT",  Frame.ButtonContainer, "RIGHT")
            Frame._auroraBackdrop:SetPoint("BOTTOM", Frame.ButtonContainer, "BOTTOM")
        end

        function Skin.UIWidgetTemplateButtonHeader(Frame)
            SafeSetAlpha(Frame.Frame, 0)

            if Frame.buttonPool then
                for Button in Frame.buttonPool:EnumerateActive() do
                    Skin.ButtonHeaderButton(Button)
                end
            end

            -- Apply immediately if already laid out (bootstrap: Setup already ran before skin)
            if Frame.ButtonContainer and Frame.ButtonContainer:GetWidth() > 0 then
                ApplyButtonHeaderBackdrop(Frame)
            end

            if not Frame._auroraButtonHeaderSetupHook then
                _G.hooksecurefunc(Frame, "Setup", function(self)
                    if self.buttonPool then
                        for Button in self.buttonPool:EnumerateActive() do
                            Skin.ButtonHeaderButton(Button)
                        end
                    end
                    -- Runs after ButtonContainer:Layout(), so size is correct
                    ApplyButtonHeaderBackdrop(self)
                end)
                Frame._auroraButtonHeaderSetupHook = true
            end
        end
    end
    do --[[ Blizzard_UIWidgetTemplateScenarioHeaderCurrenciesAndBackground ]]
        function Skin.UIWidgetTemplateScenarioHeaderCurrenciesAndBackground(Frame)
            Skin.UIWidgetBaseScenarioHeaderTemplate(Frame)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateSpellDisplay ]]
        function Skin.UIWidgetTemplateSpellDisplay(Frame)
            Skin.UIWidgetBaseSpellTemplate(Frame.Spell)
        end
    end
end

function private.AddOns.Blizzard_UIWidgets()
    ----====####$$$$%%%%$$$$####====----
    --    Blizzard_UIWidgetManager    --
    ----====####$$$$%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetManager, Hook.UIWidgetManagerMixin)

    ----====####$$$$%%%%%$$$$####====----
    --  Blizzard_UIWidgetTemplateBase  --
    ----====####$$$$%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconAndText --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconTextAndBackground --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateCaptureBar --
    ----====####$$$$%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateStatusBar --
    ----====####$$$$%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleStatusBar --
    ----====####$$$$%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleIconAndText --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateStackedResourceTracker --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateIconTextAndCurrencies --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextWithState --
    ----====####$$$$%%%%%%%%%%%%$$$$####====----
    if _G.UIWidgetTemplateTextWithStateMixin and _G.UIWidgetTemplateTextWithStateMixin.Setup then
        local OriginalTextWithStateSetup = _G.UIWidgetTemplateTextWithStateMixin.Setup
        _G.UIWidgetTemplateTextWithStateMixin.Setup = function(self, widgetInfo, widgetContainer)
            if IsSecret(widgetInfo) or IsSecret(widgetInfo and widgetInfo.widgetSizeSetting) then
                if _G.UIWidgetBaseTemplateMixin and _G.UIWidgetBaseTemplateMixin.Setup then
                    _G.UIWidgetBaseTemplateMixin.Setup(self, widgetInfo, widgetContainer)
                end

                local tooltip = widgetInfo and widgetInfo.tooltip
                if IsSecret(tooltip) then
                    tooltip = ""
                end
                self:SetTooltip(tooltip)

                local text = widgetInfo and widgetInfo.text
                if IsSecret(text) or type(text) ~= "string" then
                    text = ""
                end

                local fontType = SafeNumber(widgetInfo and widgetInfo.fontType, 0)
                local textSizeType = SafeNumber(widgetInfo and widgetInfo.textSizeType, 0)
                local enabledState = SafeNumber(widgetInfo and widgetInfo.enabledState, 0)
                local hAlign = SafeNumber(widgetInfo and widgetInfo.hAlign, 0)

                self.Text:SetWidth(0)
                self.Text:Setup(text, fontType, textSizeType, enabledState, hAlign)

                if self.fontColor then
                    self.Text:SetTextColor(self.fontColor:GetRGB())
                end

                self:SetWidth(self.Text:GetStringWidth())

                local textHeight = self.Text:GetStringHeight()
                local bottomPadding = SafeNumber(widgetInfo and widgetInfo.bottomPadding, 0)
                if _G.Clamp then
                    bottomPadding = _G.Clamp(bottomPadding, 0, textHeight - 1)
                end
                self:SetHeight(textHeight + bottomPadding)
                return
            end

            return OriginalTextWithStateSetup(self, widgetInfo, widgetContainer)
        end
    end


    ----====####$$$$%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateHorizontalCurrencies --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateBulletTextList --
    ----====####$$$$%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateScenarioHeaderCurrenciesAndBackground --
    ----====####$$$$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextureAndText --
    ----====####$$$$%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateSpellDisplay --
    ----====####$$$$%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateDoubleStateIconRow --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateTextureAndTextRow --
    ----====####$$$$%%%%%%%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateZoneControl --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    ----====####$$$$%%%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetTemplateCaptureZone --
    ----====####$$$$%%%%%%%%%%$$$$####====----


    --====####$$$$%%%%%$$$$####====----
    -- Blizzard_UIWidgetTopCenterFrame --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.UIWidgetTopCenterContainerFrame, Hook.UIWidgetContainerMixin)

    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_UIWidgetBelowMinimapFrame --
    ----====####$$$$%%%%%%%%$$$$####====----
    local BelowMinimapFrame = _G.UIWidgetBelowMinimapContainerFrame
    DebugBelowMinimap("Setup hooks", SafeDebugName(BelowMinimapFrame))
    Skin.UIWidgetBelowMinimapContainerFrame(BelowMinimapFrame)
    Util.Mixin(BelowMinimapFrame, Hook.UIWidgetContainerMixin, Hook.UIWidgetBelowMinimapContainerMixin)
    BootstrapWidgetContainer(BelowMinimapFrame)
    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_UIWidgetPowerBarFrame --
    ----====####$$$$%%%%$$$$####====----

end
