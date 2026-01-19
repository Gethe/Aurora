local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

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
                private.debug("Skinning template for UIWidgetContainerMixin", widgetFrame:GetDebugName(), template)
                if not widgetFrame._auroraSkinned then
                    Skin[template](widgetFrame)
                    widgetFrame._auroraSkinned = true
                end
            else
                private.debug("Missing template for UIWidgetContainerMixin", widgetFrame:GetDebugName(), template)
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
            _G.print("UIWidgetBelowMinimapContainerMixin:OnLoad", self:GetDebugName())
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

            Frame.Border:SetAlpha(0)
            Frame.DebuffBorder:SetAlpha(0)
        end
        function Skin.UIWidgetBaseScenarioHeaderTemplate(Frame)
            Frame.Frame:SetAlpha(0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateIconAndText ]]
        Skin.UIWidgetTemplateIconAndText = private.nop
    end
    do --[[ Blizzard_UIWidgetTemplateStatusBar ]]
        function Skin.UIWidgetTemplateStatusBar(Frame)
            local StatusBar = Frame.Bar
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)
            StatusBar.BGLeft:SetAlpha(0)
            StatusBar.BGRight:SetAlpha(0)
            StatusBar.BGCenter:SetAlpha(0)
            StatusBar.BorderLeft:SetAlpha(0)
            StatusBar.BorderRight:SetAlpha(0)
            StatusBar.BorderCenter:SetAlpha(0)
            StatusBar.Spark:SetAlpha(0)
        end
    end
    do --[[ Blizzard_UIWidgetTemplateDoubleStatusBar ]]
        function Skin.UIWidgetTemplateDoubleStatusBar_StatusBarTemplate(StatusBar)
            Skin.UIWidgetBaseStatusBarTemplate(StatusBar)

            StatusBar.BG:SetAlpha(0)
            StatusBar.BorderLeft:SetAlpha(0)
            StatusBar.BorderRight:SetAlpha(0)
            StatusBar.BorderCenter:SetAlpha(0)
            StatusBar.Spark:SetAlpha(0)
            StatusBar.SparkGlow:SetAlpha(0)
            StatusBar.BorderGlow:SetAllPoints(StatusBar)
            StatusBar.BorderGlow:SetTexCoord(0.025, 0.975, 0.19354838709677, 0.80645161290323)
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
            _G.print("Skin.UIWidgetBelowMinimapContainerFrame", Frame:GetDebugName())
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