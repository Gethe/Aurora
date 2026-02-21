local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals _G next type

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

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
            if Skin[template] then
                private.debug("Skinning template for UIWidgetContainerMixin", SafeDebugName(widgetFrame), template)
                if not widgetFrame._auroraSkinned then
                    local ok, err = _G.pcall(Skin[template], widgetFrame)
                    if not ok then
                        private.debug("Error skinning template", template, SafeDebugName(widgetFrame), err)
                    end
                    widgetFrame._auroraSkinned = true
                end
            else
                private.debug("Missing template for UIWidgetContainerMixin", SafeDebugName(widgetFrame), template)
            end
        end

        Hook.UIWidgetManagerMixin = {}
        function Hook.UIWidgetManagerMixin:OnWidgetContainerRegistered(widgetContainer)
            local setWidgets = _G.C_UIWidgetManager.GetAllWidgetsBySetID(widgetContainer.widgetSetID)
            local widgetID, widgetType, widgetTypeInfo, widgetVisInfo
            for _, widgetInfo in next, setWidgets do
                -- FIXME: This is a hack to get the widgetID and widgetType
                -- _G.print("UIWidgetManagerMixin:OnWidgetContainerRegistered", widgetContainer:GetDebugName(), widgetInfo.widgetID, widgetInfo.widgetType)
                widgetID, widgetType = widgetInfo.widgetID, widgetInfo.widgetType
                widgetTypeInfo = _G.UIWidgetManager:GetWidgetTypeInfo(widgetType)
                widgetVisInfo = widgetTypeInfo.visInfoDataFunction(widgetID)

                Hook.UIWidgetContainerMixin.CreateWidget(widgetContainer, widgetID, widgetType, widgetTypeInfo, widgetVisInfo)
            end

            Util.Mixin(widgetContainer, Hook.UIWidgetContainerMixin)
        end
    end

    do --[[ Blizzard_UIWidgetBelowMinimapFrame ]]
        Hook.UIWidgetBelowMinimapContainerMixin = {}
        function Hook.UIWidgetBelowMinimapContainerMixin:OnLoad()
            _G.print("UIWidgetBelowMinimapContainerMixin:OnLoad", SafeDebugName(self))
            -- Util.Mixin(self, Hook.UIWidgetContainerMixin)
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
    do --[[ Blizzard_UIWidgetBelowMinimapContainerFrame ]]
        function Skin.UIWidgetBelowMinimapContainerFrame(Frame)
            _G.print("Skin.UIWidgetBelowMinimapContainerFrame", SafeDebugName(Frame))
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
    Util.Mixin(_G.UIWidgetBelowMinimapContainerFrame, Hook.UIWidgetBelowMinimapContainerMixin)
    _G.UIWidgetBelowMinimapContainerFrame:Hide() -- Hide the frame until we can set the point
    -- _G.UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
    -- _G.UIWidgetBelowMinimapContainerFrame:SetPoint("TOP", 0, -60) -- Set the point to be below the minimap
    ----====####$$$$%%%%$$$$####====----
    -- Blizzard_UIWidgetPowerBarFrame --
    ----====####$$$$%%%%$$$$####====----


end
--[[
<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.blizzard.com/wow/ui/
..\Blizzard_SharedXML\UI.xsd">
        <Frame name="UIWidgetBelowMinimapContainerFrame" toplevel="true" parent="UIParent" inherits="UIWidgetContainerTemplate, UIParentRightManagedFrameTemplate" mixin="UIWidgetBelowMinimapContainerMixin">
                <KeyValues>
                        <KeyValue key="verticalAnchorPoint" value="TOPRIGHT" type="string"/>
                        <KeyValue key="verticalRelativePoint" value="BOTTOMRIGHT" type="string"/>
                        <KeyValue key="layoutIndex" value="1" type="number"/>
                </KeyValues>
                <Anchors>
                        <Anchor point="TOPRIGHT" relativeTo="MinimapCluster" relativePoint="BOTTOMRIGHT"/>
                </Anchors>
        </Frame>
</Ui>
	UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
	UIWidgetBelowMinimapContainerFrame:SetPoint('TOP', 0, -60)

--]]