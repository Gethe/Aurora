local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next type
local wago = _G.LibStub("WagoAnalytics"):Register("JZKbRK19")
private.wago = wago

-- [[ Core ]]
local Aurora = private.Aurora
local _, C = _G.unpack(Aurora)
local Config = private.Config
local Analytics = private.Analytics
local Compatibility = private.Compatibility
local Integration = private.Integration

-- [[ Constants and settings ]]
local AuroraConfig

C.frames = {}
-- Maintain C.defaults for backward compatibility
C.defaults = Config.defaults

function private.OnLoad()
    -- Initialize integration system first
    Integration.Initialize()

    -- Load and initialize configuration using the Config module with error handling
    local configSuccess, configResult = pcall(function()
        return Config.load(wago)
    end)

    if configSuccess then
        AuroraConfig = configResult
    else
        Integration.HandleError("Config", configResult, {phase = "load", recoverable = true})
        AuroraConfig = Config.defaults
    end

    -- Initialize compatibility system with error handling
    local compatSuccess, compatErr = pcall(Compatibility.initialize, AuroraConfig)
    if not compatSuccess then
        Integration.HandleError("Compatibility", compatErr, {phase = "initialize", recoverable = false})
    end

    -- Initialize analytics system with user consent and error handling
    local analyticsSuccess, analyticsErr = pcall(Analytics.initialize, wago, AuroraConfig)
    if not analyticsSuccess then
        Integration.HandleError("Analytics", analyticsErr, {phase = "initialize", recoverable = false})
    end

    -- Check if configuration needs recovery
    local needsRecovery, reason = Config.needsRecovery(AuroraConfig)
    if needsRecovery then
        private.debug("Config", "Recovery needed:", reason)
        local recoverSuccess, recoverResult = pcall(Config.recover)
        if recoverSuccess then
            AuroraConfig = recoverResult
        else
            Integration.HandleError("Config", recoverResult, {phase = "recovery", recoverable = false})
        end
    end

    -- Setup colors
    local Color, Util = Aurora.Color, Aurora.Util
    local Theme = Aurora.Theme
    local customClassColors = AuroraConfig.customClassColors

    -- Initialize theme engine
    Theme.Initialize()
    Theme.InitializeAlpha(AuroraConfig)

    function private.updateHighlightColor()
        --print("updateHighlightColor override")
        -- Use the enhanced color management system with dynamic updates
        Color.RefreshHighlightColor(AuroraConfig)

        -- Update deprecated references
        C.r, C.g, C.b = Color.highlight:GetRGB()
    end
    _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
        --print("aurora CCC:RegisterCallback")
        private.updateHighlightColor()
        _G.AuroraOptions.refresh()
    end)
    private.setColorCache(customClassColors)

    if AuroraConfig.buttonsHaveGradient then
        Color.button:SetRGB(.4, .4, .4)
    end

    -- Show splash screen for first time users
    if not AuroraConfig.acknowledgedSplashScreen then
        _G.AuroraSplashScreen:Show()
    end

    -- Store frame alpha from saved vars
    Util.SetFrameAlpha(AuroraConfig.alpha)

    -- Create API hooks
    local Hook = Aurora.Hook
    local Skin = Aurora.Skin

    _G.hooksecurefunc(Skin, "FrameTypeButton", function(Button)
        if AuroraConfig.buttonsHaveGradient and Button.SetBackdropGradient then
            Button:SetBackdropGradient()
        end
    end)

    -- Skip CharacterFrame modifications if Chonky Character Sheet is loaded
    if not _G.C_AddOns.IsAddOnLoaded("ChonkyCharacterSheet") then
        _G.hooksecurefunc(private.FrameXML, "CharacterFrame", function()
            _G.CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", 0, -12)
            _G.CharacterStatsPane.ItemLevelFrame.Background:Hide()
            _G.CharacterStatsPane.ItemLevelFrame.Value:SetFontObject("SystemFont_Outline_WTF2")

            _G.hooksecurefunc("PaperDollFrame_UpdateStats", function()
                if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then
                    _G.CharacterStatsPane.ItemLevelCategory:Hide()
                    _G.CharacterStatsPane.AttributesCategory:SetPoint("TOP", 0, -40)
                end
            end)
        end)
    end

    _G.hooksecurefunc(private.FrameXML, "FriendsFrame", function()
        local FriendsFrame = _G.FriendsFrame
        local titleText = FriendsFrame.TitleText or FriendsFrame:GetTitleText()

        local BNetFrame = _G.FriendsFrameBattlenetFrame
        BNetFrame.Tag:SetParent(FriendsFrame)
        BNetFrame.Tag:SetAllPoints(titleText)
        local BroadcastFrame = BNetFrame.BroadcastFrame
        local EditBox = BroadcastFrame.EditBox
        EditBox:SetParent(FriendsFrame)
        EditBox:ClearAllPoints()
        EditBox:SetSize(239, 25)
        EditBox:SetPoint("TOPLEFT", 57, -28)
        EditBox:SetScript("OnEnterPressed", function()
            BroadcastFrame:SetBroadcast()
        end)
        _G.hooksecurefunc("FriendsFrame_Update", function()
            local selectedTab = _G.PanelTemplates_GetSelectedTab(FriendsFrame) or _G.FRIEND_TAB_FRIENDS
            local isFriendsTab = selectedTab == _G.FRIEND_TAB_FRIENDS

            titleText:SetShown(not isFriendsTab)
            BNetFrame.Tag:SetShown(isFriendsTab)
            EditBox:SetShown(_G.BNConnected() and isFriendsTab)
        end)
        _G.hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
            if _G.BNFeaturesEnabled() then
                if _G.BNConnected() then
                    BNetFrame:Hide()
                    EditBox:Show()
                    BroadcastFrame:UpdateBroadcast()
                else
                    EditBox:Hide()
                end
            end
        end)
    end)

    -- Disable skins as per user settings
    private.disabled.bags = not AuroraConfig.bags
    private.disabled.banks = not AuroraConfig.banks
    private.disabled.chat = not AuroraConfig.chat
    private.disabled.fonts = not AuroraConfig.fonts
    private.disabled.tooltips = not AuroraConfig.tooltips
    private.disabled.mainmenubar = not AuroraConfig.mainmenubar
    if not AuroraConfig.chatBubbles then
        Hook.ChatBubble_OnEvent = private.nop
        Hook.ChatBubble_OnUpdate = private.nop
    end
    if not AuroraConfig.chatBubbleNames then
        Hook.ChatBubble_SetName = private.nop
    end
    if not AuroraConfig.loot then
        private.FrameXML.LootFrame = private.nop
    end

    function private.AddOns.Aurora()
        private.SetupGUI()
    end
end
