local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Skin = Aurora.Skin
local Util = Aurora.Util

local wrappedPools = setmetatable({}, {__mode = "k"})

local function WrapPoolAcquire(pool, skinFunc)
    if not pool or wrappedPools[pool] then
        return
    end

    local acquire = pool.Acquire
    pool.Acquire = function(self, ...)
        local frame, isNew = acquire(self, ...)
        skinFunc(frame)
        return frame, isNew
    end

    wrappedPools[pool] = true

    for frame in pool:EnumerateActive() do
        skinFunc(frame)
    end
end

--do --[[ AddOns\Blizzard_PVPMatch.lua ]]
do
    Hook.PVPMatchResultsMixin = {}
    function Hook.PVPMatchResultsMixin:OnLoad()
        WrapPoolAcquire(self.itemPool, Skin.PVPMatchResultsLoot)
    end
end

do --[[ AddOns\Blizzard_PVPMatch.xml ]]
    do --[[ PVPMatchTable.xml ]]
        function Skin.PVPTableRowTemplate(Frame)
            Frame.backgroundLeft:ClearAllPoints()
            Frame.backgroundLeft:SetPoint("TOPLEFT")
            Frame.backgroundLeft:SetTexture(private.textures.plain)
            Frame.backgroundLeft:SetHeight(15)
            Frame.backgroundLeft:SetAlpha(0.5)

            Frame.backgroundRight:ClearAllPoints()
            Frame.backgroundRight:SetPoint("TOPRIGHT")
            Frame.backgroundRight:SetTexture(private.textures.plain)
            Frame.backgroundRight:SetHeight(15)
            Frame.backgroundRight:SetAlpha(0.5)

            Frame.backgroundCenter:SetTexture(private.textures.plain)
            Frame.backgroundCenter:SetHeight(15)
            Frame.backgroundCenter:SetAlpha(0.5)
        end
        function Skin.PVPMatchResultsLoot(Button)
            if Button._auroraSkinned then
                return
            end

            Button._auroraSkinned = true
            Skin.LargeItemButtonTemplate(Button)

            if Button.IconBorder then
                Button.IconBorder:SetAlpha(0)
            end
        end
    end
end

function private.AddOns.Blizzard_PVPMatch()
    ----====#####################====----
    --         PVPMatchResults         --
    ----====#####################====----
    local PVPMatchResults = _G.PVPMatchResults
    _G.hooksecurefunc(_G.PVPMatchResultsMixin, "OnLoad", Hook.PVPMatchResultsMixin.OnLoad)
    Skin.UIPanelCloseButton(PVPMatchResults.CloseButton)
    PVPMatchResults.CloseButton.Border:Hide()
    WrapPoolAcquire(PVPMatchResults.itemPool, Skin.PVPMatchResultsLoot)

    local resultsContent = PVPMatchResults.content
    resultsContent.background:Hide()
    resultsContent.InsetBorderTopLeft:Hide()
    resultsContent.InsetBorderTopRight:Hide()
    resultsContent.InsetBorderBottomLeft:Hide()
    resultsContent.InsetBorderBottomRight:Hide()
    resultsContent.InsetBorderTop:Hide()
    resultsContent.InsetBorderBottom:Hide()
    resultsContent.InsetBorderLeft:Hide()
    resultsContent.InsetBorderRight:Hide()

    Skin.WowScrollBoxList(resultsContent.scrollBox)
    Skin.MinimalScrollBar(resultsContent.scrollBar)

    local tabContainer = resultsContent.tabContainer
    tabContainer.InsetBorderTop:Hide()
    tabContainer.InsetBorderBottom:Hide()
    Skin.PanelTabButtonTemplate(tabContainer.tabGroup.tab1)
    Skin.PanelTabButtonTemplate(tabContainer.tabGroup.tab2)
    Skin.PanelTabButtonTemplate(tabContainer.tabGroup.tab3)
    Util.PositionRelative("TOPLEFT", tabContainer.tabGroup, "BOTTOMLEFT", 20, 49, 1, "Right", {
        tabContainer.tabGroup.tab1,
        tabContainer.tabGroup.tab2,
        tabContainer.tabGroup.tab3,
    })

    Skin.UIPanelButtonTemplate(PVPMatchResults.buttonContainer.requeueButton)
    Skin.UIPanelButtonTemplate(PVPMatchResults.buttonContainer.leaveButton)

    PVPMatchResults:GetRegions():Hide() -- groupfinder-background


    ----====####################====----
    --       PVPMatchScoreboard       --
    ----====####################====----
    local PVPMatchScoreboard = _G.PVPMatchScoreboard
    Skin.UIPanelCloseButton(PVPMatchScoreboard.CloseButton)

    local scoreContent = PVPMatchScoreboard.Content
    scoreContent.Background:Hide()
    scoreContent.InsetBorderTopLeft:Hide()
    scoreContent.InsetBorderTopRight:Hide()
    scoreContent.InsetBorderBottomLeft:Hide()
    scoreContent.InsetBorderBottomRight:Hide()
    scoreContent.InsetBorderTop:Hide()
    scoreContent.InsetBorderBottom:Hide()
    scoreContent.InsetBorderLeft:Hide()
    scoreContent.InsetBorderRight:Hide()

    Skin.WowScrollBoxList(scoreContent.ScrollBox)
    Skin.MinimalScrollBar(scoreContent.ScrollBar)

    local scoreTabContainer = scoreContent.TabContainer
    scoreTabContainer.InsetBorderTop:Hide()
    Skin.PanelTabButtonTemplate(scoreTabContainer.TabGroup.Tab1)
    Skin.PanelTabButtonTemplate(scoreTabContainer.TabGroup.Tab2)
    Skin.PanelTabButtonTemplate(scoreTabContainer.TabGroup.Tab3)
    Util.PositionRelative("TOPLEFT", scoreTabContainer.TabGroup, "BOTTOMLEFT", 20, 49, 1, "Right", {
        scoreTabContainer.TabGroup.Tab1,
        scoreTabContainer.TabGroup.Tab2,
        scoreTabContainer.TabGroup.Tab3,
    })

    PVPMatchScoreboard:GetRegions():Hide() -- groupfinder-background
end
