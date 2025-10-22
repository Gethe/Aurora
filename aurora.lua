local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next type
local wago = _G.LibStub("WagoAnalytics"):Register("JZKbRK19")
private.wago = wago

-- [[ Core ]]
local Aurora = private.Aurora
local _, C = _G.unpack(Aurora)

-- [[ Constants and settings ]]
local AuroraConfig

C.frames = {}
C.defaults = {
    acknowledgedSplashScreen = false,

    bags = true,
    chat = true,
    loot = true,
    mainmenubar = false,
    fonts = true,
    tooltips = true,
    chatBubbles = true,
        chatBubbleNames = true,

    buttonsHaveGradient = true,
    customHighlight = {enabled = false, r = 0.243, g = 0.570, b = 1},
    alpha = 0.5,
    hasAnalytics = true,
    --[[
        TODO: colorize - generate a monochrome color palette using the highlight
            color which overrides the default frame, button, and font colors
    ]]

    customClassColors = {},
}

function private.OnLoad()
    -- Load Variables
    _G.AuroraConfig = _G.AuroraConfig or {}
    AuroraConfig = _G.AuroraConfig

    if AuroraConfig.useButtonGradientColour ~= nil then
        AuroraConfig.buttonsHaveGradient = AuroraConfig.useButtonGradientColour
    end
    if AuroraConfig.enableFont ~= nil then
        AuroraConfig.fonts = AuroraConfig.enableFont
    end
    if AuroraConfig.customColour ~= nil then
        AuroraConfig.customHighlight = AuroraConfig.customColour
        if AuroraConfig.useCustomColour ~= nil then
            AuroraConfig.customHighlight.enabled = AuroraConfig.useCustomColour
        end
    end

    -- Remove deprecated or corrupt variables
    for key, value in next, AuroraConfig do
        if C.defaults[key] == nil then
            AuroraConfig[key] = nil
        end

        if AuroraConfig.hasAnalytics == nil then
            if key ~= "acknowledgedSplashScreen" then
                if key == "customHighlight" then
                    wago:Switch(key, value.enabled)
                elseif key == "alpha" then
                    wago:SetCounter(key, value)
                else
                    wago:Switch(key, value)
                end
            end
        end
    end

    -- Load or init variables
    for key, value in next, C.defaults do
        if AuroraConfig[key] == nil then


            if _G.type(value) == "table" then
                AuroraConfig[key] = {}
                for k in next, value do
                    AuroraConfig[key][k] = value[k]
                end
            else
                AuroraConfig[key] = value
            end
        end
    end

    -- Setup colors
    local Color, Util = Aurora.Color, Aurora.Util
    local customClassColors = AuroraConfig.customClassColors

    function private.updateHighlightColor()
        --print("updateHighlightColor override")
        local r, g, b
        if AuroraConfig.customHighlight.enabled then
            r, g, b = AuroraConfig.customHighlight.r, AuroraConfig.customHighlight.g, AuroraConfig.customHighlight.b
        else
            r, g, b = _G.CUSTOM_CLASS_COLORS[private.charClass.token]:GetRGB()
        end

        C.r, C.g, C.b = r, g, b -- deprecated
        Color.highlight:SetRGB(r, g, b)
    end
    _G.CUSTOM_CLASS_COLORS:RegisterCallback(function()
        --print("aurora CCC:RegisterCallback")
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
