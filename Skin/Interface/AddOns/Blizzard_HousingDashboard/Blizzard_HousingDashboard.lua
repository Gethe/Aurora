local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select next ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


do --[[ AddOns\Blizzard_HousingDashboard\Blizzard_HousingDashboard.lua ]]
    Hook.HousingDashboardFrameMixin = {}
    function Hook.HousingDashboardFrameMixin:SetTab(activeTab)
        for _, tab in ipairs(self.tabs) do
            local isActive = tab == self.activeTab
            if tab.tabButton._auroraIconBG then
                if isActive then
                    tab.tabButton._auroraIconBG:SetColorTexture(Color.yellow:GetRGB())
                else
                    tab.tabButton._auroraIconBG:SetColorTexture(Color.black:GetRGB())
                end
            end
        end
    end

    Hook.HousingUpgradeFrameMixin = {}
    function Hook.HousingUpgradeFrameMixin:OnHouseSelected(houseInfoID)
        if self.Background then
            self.Background:SetAlpha(0)
        end
        -- Hide filigree art
        if self.FiligreeTL then self.FiligreeTL:SetAlpha(0) end
        if self.FiligreeTR then self.FiligreeTR:SetAlpha(0) end
        if self.FiligreeBL then self.FiligreeBL:SetAlpha(0) end
        if self.FiligreeBR then self.FiligreeBR:SetAlpha(0) end
    end

    Hook.InitiativesTabMixin = {}
    function Hook.InitiativesTabMixin:RefreshInitiativeTab()
        -- Hide initiative art backgrounds
        if self.InitiativesArt then
            for _, region in pairs({self.InitiativesArt:GetRegions()}) do
                if region:IsObjectType("Texture") then
                    region:SetAlpha(0)
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_HousingDashboard\Blizzard_HousingDashboard.xml ]]
    function Skin.HousingDashboardSideTabTemplate(TabButton)
        -- Hide the highlight atlas
        if TabButton.Highlight then TabButton.Highlight:SetAlpha(0) end

        -- Crop the icon and create the colored border
        local icon = TabButton.Icon
        if icon then
            TabButton._auroraIconBG = Base.CropIcon(icon, TabButton)
        end
    end
end

function private.AddOns.Blizzard_HousingDashboard()
    ----
    -- Main Frame
    ----
    local HousingDashboardFrame = _G.HousingDashboardFrame

    Skin.PortraitFrameTemplate(HousingDashboardFrame)

    -- Dark flat background
    if HousingDashboardFrame.Bg then
        HousingDashboardFrame.Bg:SetColorTexture(0.08, 0.08, 0.08, 1)
        HousingDashboardFrame.Bg:SetAllPoints(HousingDashboardFrame.NineSlice)
        HousingDashboardFrame.Bg:Show()
    end

    -- Hook the main mixin
    Util.Mixin(HousingDashboardFrame, Hook.HousingDashboardFrameMixin)

    ----
    -- Side Tab Buttons (2 buttons on the right side)
    ----
    Skin.HousingDashboardSideTabTemplate(HousingDashboardFrame.HouseInfoTabButton)
    Skin.HousingDashboardSideTabTemplate(HousingDashboardFrame.CatalogTabButton)

    ----
    -- HouseInfo Content
    ----
    local HouseInfoContent = HousingDashboardFrame.HouseInfoContent

    -- Dropdown
    if HouseInfoContent.HouseDropdown then
        Skin.WowStyle1ArrowDropdownTemplate(HouseInfoContent.HouseDropdown)
    end

    -- House Finder Button
    if HouseInfoContent.HouseFinderButton then
        Skin.UIPanelButtonTemplate(HouseInfoContent.HouseFinderButton)
    end

    -- No Houses Dashboard
    local NoHousesFrame = HouseInfoContent.DashboardNoHousesFrame
    if NoHousesFrame then
        if NoHousesFrame.Background then NoHousesFrame.Background:SetAlpha(0) end
        if NoHousesFrame.NoHouseButton then
            Skin.UIPanelButtonTemplate(NoHousesFrame.NoHouseButton)
        end
    end

    ----
    -- Inner Content Frame (House Level / Endeavors tabs)
    ----
    local ContentFrame = HouseInfoContent.ContentFrame
    if ContentFrame then
        -- Skin TabSystem top tabs when they are created
        local function SkinTabSystemTabs()
            if ContentFrame.TabSystem then
                for _, tab in ipairs({ContentFrame.TabSystem:GetChildren()}) do
                    if tab.Left and tab.LeftActive and not tab._auroraSkinned then
                        tab._auroraSkinned = true
                        Skin.TabSystemButtonTemplate(tab)
                    end
                end
            end
        end

        -- Hook Initialize to skin tabs after they're created
        if ContentFrame.Initialize then
            _G.hooksecurefunc(ContentFrame, "Initialize", SkinTabSystemTabs)
        end

        ----
        -- Initiatives / Endeavors Frame
        ----
        local InitiativesFrame = ContentFrame.InitiativesFrame
        if InitiativesFrame then
            Util.Mixin(InitiativesFrame, Hook.InitiativesTabMixin)

            -- Hide decorative art
            if InitiativesFrame.InitiativesArt then
                for _, region in pairs({InitiativesFrame.InitiativesArt:GetRegions()}) do
                    if region:IsObjectType("Texture") then
                        region:SetAlpha(0)
                    end
                end
            end

            -- Initiative Set Frame
            local InitiativeSetFrame = InitiativesFrame.InitiativeSetFrame
            if InitiativeSetFrame then
                -- Task list scroll
                if InitiativeSetFrame.InitiativeTasks then
                    local TaskList = InitiativeSetFrame.InitiativeTasks
                    if TaskList.ScrollBox then Skin.WowScrollBoxList(TaskList.ScrollBox) end
                    if TaskList.ScrollBar then Skin.MinimalScrollBar(TaskList.ScrollBar) end
                    -- Hide decorative art on task list
                    if TaskList.TitleArt then TaskList.TitleArt:SetAlpha(0) end
                    if TaskList.TitleArtLeft then TaskList.TitleArtLeft:SetAlpha(0) end
                    if TaskList.TitleArtRight then TaskList.TitleArtRight:SetAlpha(0) end
                end

                -- Activity log scroll
                if InitiativeSetFrame.InitiativeActivity then
                    local ActivityLog = InitiativeSetFrame.InitiativeActivity
                    if ActivityLog.ScrollBox then Skin.WowScrollBoxList(ActivityLog.ScrollBox) end
                    if ActivityLog.ScrollBar then Skin.MinimalScrollBar(ActivityLog.ScrollBar) end
                end
            end
        end

        ----
        -- House Upgrade Frame
        ----
        local HouseUpgradeFrame = ContentFrame.HouseUpgradeFrame
        if HouseUpgradeFrame then
            Util.Mixin(HouseUpgradeFrame, Hook.HousingUpgradeFrameMixin)

            -- Hide background and filigree art
            if HouseUpgradeFrame.Background then HouseUpgradeFrame.Background:SetAlpha(0) end
            if HouseUpgradeFrame.FiligreeTL then HouseUpgradeFrame.FiligreeTL:SetAlpha(0) end
            if HouseUpgradeFrame.FiligreeTR then HouseUpgradeFrame.FiligreeTR:SetAlpha(0) end
            if HouseUpgradeFrame.FiligreeBL then HouseUpgradeFrame.FiligreeBL:SetAlpha(0) end
            if HouseUpgradeFrame.FiligreeBR then HouseUpgradeFrame.FiligreeBR:SetAlpha(0) end

            -- Watch Favor Button (checkbox)
            if HouseUpgradeFrame.WatchFavorButton then
                Skin.UICheckButtonTemplate(HouseUpgradeFrame.WatchFavorButton)
            end
        end
    end

    ----
    -- Catalog Content
    ----
    local CatalogContent = HousingDashboardFrame.CatalogContent
    if CatalogContent then
        -- Hide the background
        if CatalogContent.Background then CatalogContent.Background:SetAlpha(0) end

        -- Search box
        if CatalogContent.SearchBox then
            Skin.SearchBoxTemplate(CatalogContent.SearchBox)
        end

        -- Filter button
        if CatalogContent.Filters then
            Skin.FilterButton(CatalogContent.Filters)
        end

        -- Divider
        if CatalogContent.Divider then CatalogContent.Divider:SetAlpha(0) end

        -- Options container (scroll catalog)
        if CatalogContent.OptionsContainer then
            local OptionsContainer = CatalogContent.OptionsContainer
            if OptionsContainer.ScrollBox then Skin.WowScrollBoxList(OptionsContainer.ScrollBox) end
            if OptionsContainer.ScrollBar then Skin.MinimalScrollBar(OptionsContainer.ScrollBar) end
        end

        -- Categories sidebar
        if CatalogContent.Categories then
            local Categories = CatalogContent.Categories
            if Categories.ScrollBox then Skin.WowScrollBoxList(Categories.ScrollBox) end
            if Categories.ScrollBar then Skin.MinimalScrollBar(Categories.ScrollBar) end
        end
    end
end
