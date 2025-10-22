local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\QuestMapFrame.lua ]]
    -- /dump C_CampaignInfo.GetCampaignInfo(C_CampaignInfo.GetCurrentCampaignID())
    function Hook.QuestLogQuests_Update(poiTable)
        local kit, overlay
        for campaignHeader in _G.QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
            local campaign = campaignHeader:GetCampaign()
            if campaign then
                kit = Util.GetTextureKit(campaign.uiTextureKit, true)
                campaignHeader.Background:SetTexture("")
                if campaignHeader._auroraBG then
                    campaignHeader._auroraBG:SetColorTexture(kit.color:GetRGB())
                end
                if campaignHeader._auroraOverlay then
                    overlay = campaignHeader._auroraOverlay
                    overlay:SetPoint("CENTER", campaignHeader._auroraBG, "RIGHT", -25, 0)
                    overlay:SetAtlas(kit.emblem)
                    overlay:SetSize(66.33, 76.56)

                    overlay:SetBlendMode("BLEND")
                    overlay:SetVertexColor(0, 0, 0)
                    campaignHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
                end
            end
        end

        local covenantData = _G.C_Covenants.GetCovenantData(_G.C_Covenants.GetActiveCovenantID())
        kit = Util.GetTextureKit(covenantData and covenantData.textureKit, true)
        for callingHeader in _G.QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
            callingHeader.Background:SetTexture("")
            callingHeader._auroraBG:SetColorTexture(Util.uiTextureKits.alt.color:GetRGB())

            overlay = callingHeader._auroraOverlay
            overlay:SetPoint("CENTER", callingHeader._auroraBG, "RIGHT", -25, 0)
            overlay:SetAtlas(kit.emblem)
            overlay:SetSize(66.33, 76.56)

            overlay:SetBlendMode("BLEND")
            overlay:SetVertexColor(0, 0, 0)
            callingHeader.HighlightBackground:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
        end

        local separator = _G.QuestMapFrame.QuestsFrame.ScrollFrame.Contents.Separator
        if separator:IsShown() then
            separator.Divider:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, 0.5)
            separator.Divider:SetSize(200, 1)
        end
    end

    local sessionCommandToButtonAtlas = {
        [_G.Enum.QuestSessionCommand.Start] = "QuestSharing-DialogIcon",
        [_G.Enum.QuestSessionCommand.Stop] = "QuestSharing-Stop-DialogIcon",
    }
    Hook.QuestSessionManagementMixin = {}
    function Hook.QuestSessionManagementMixin:UpdateExecuteCommandAtlases(command)
        self.ExecuteSessionCommand:ClearNormalTexture()
        self.ExecuteSessionCommand:ClearPushedTexture()
        self.ExecuteSessionCommand:ClearDisabledTexture()

        local atlas = sessionCommandToButtonAtlas[command];
        if atlas then
            self.ExecuteSessionCommand._auroraIcon:SetAtlas(atlas)
        end
    end
end

do --[[ FrameXML\QuestMapFrame.xml ]]
    function Skin.QuestLogHeaderTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
    end
    function Skin.CovenantCallingsHeaderTemplate(Button)
        Skin.QuestLogHeaderTemplate(Button)

        local clipFrame = _G.CreateFrame("Frame", nil, Button)
        clipFrame:SetFrameLevel(Button:GetFrameLevel())
        clipFrame:SetPoint("TOPLEFT", -12, 7)
        clipFrame:SetPoint("TOPRIGHT", 217, 7)
        clipFrame:SetHeight(31)
        clipFrame:SetClipsChildren(true)
        Button._clipFrame = clipFrame

        local BG = clipFrame:CreateTexture(nil, "BACKGROUND")
        BG:SetAllPoints()
        Button._auroraBG = BG

        local overlay = clipFrame:CreateTexture(nil, "OVERLAY")
        overlay:SetDesaturated(true)
        overlay:SetAlpha(0.3)
        Button._auroraOverlay = overlay

        Button.Divider:Hide()
        Button.HighlightBackground:SetAllPoints(clipFrame)
    end
    function Skin.QuestLogTitleTemplate(Button)
    end
    function Skin.QuestLogObjectiveTemplate(Button)
    end
    function Skin.QuestMapFrameTabTemplate(Button)
        Button:GetRegions():Hide()
        -- local CheckButton = Button.Button or Button
        local icon = Button.IconTexture
        if icon then
            Button:ClearNormalTexture()
            Base.CropIcon(Button:GetPushedTexture())
        else
            icon = Button.Icon or Button:GetNormalTexture()
        end
        Button._auroraIconBG = Base.CropIcon(icon, Button)
        -- Base.CropIcon(Button:GetHighlightTexture())
        -- Base.CropIcon(Button:GetCheckedTexture())
        Button.Background:SetTexture("")
        Button.SelectedTexture:SetTexture("")
    end
end

function private.FrameXML.QuestMapFrame()
    ------------------------------
    -- QuestLogPopupDetailFrame --
    ------------------------------
    local QuestLogPopupDetailFrame = _G.QuestLogPopupDetailFrame
    local frameBG, _, artBG, _, _, _, _, _, portrait = QuestLogPopupDetailFrame:GetRegions()
    portrait:Hide()

    QuestLogPopupDetailFrame.Bg = frameBG -- Bg from ButtonFrameTemplate
    Skin.ButtonFrameTemplate(QuestLogPopupDetailFrame)
    QuestLogPopupDetailFrame.Bg = artBG -- Bg from QuestFramePanelTemplate
    Skin.QuestFramePanelTemplate(QuestLogPopupDetailFrame)

    Skin.ScrollFrameTemplate(QuestLogPopupDetailFrame.ScrollFrame)
    QuestLogPopupDetailFrame.ScrollFrame:SetPoint("TOPLEFT", 5, -(private.FRAME_TITLE_HEIGHT + 5))
    QuestLogPopupDetailFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", -23, 32)

    local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton
    ShowMapButton.Texture:Hide()
    ShowMapButton.Highlight:SetTexture("")
    ShowMapButton.Highlight:SetTexture("")

    ShowMapButton.Text:ClearAllPoints()
    ShowMapButton.Text:SetPoint("CENTER", 1, 0)
    ShowMapButton:SetFontString(ShowMapButton.Text)
    ShowMapButton:SetNormalFontObject("GameFontNormal")
    ShowMapButton:SetHighlightFontObject("GameFontHighlight")
    ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)

    ShowMapButton:ClearAllPoints()
    ShowMapButton:SetPoint("TOPRIGHT", -30, -5)
    Base.SetBackdrop(ShowMapButton, Color.button)
    Base.SetHighlight(ShowMapButton)

    -- FIXLATER

    -- Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.AbandonButton)
    QuestLogPopupDetailFrame.AbandonButton:SetPoint("BOTTOMLEFT", 5, 5)
    -- FIXLATER
    -- Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.TrackButton)
    QuestLogPopupDetailFrame.TrackButton:SetPoint("BOTTOMRIGHT", -5, 5)
    -- FIXLATER
    -- Skin.UIPanelButtonTemplate(QuestLogPopupDetailFrame.ShareButton)
    QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
    QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)


    -------------------
    -- QuestMapFrame --
    -------------------
    _G.hooksecurefunc("QuestLogQuests_Update", Hook.QuestLogQuests_Update)

    local QuestMapFrame = _G.QuestMapFrame
    if  QuestMapFrame.Background then
        QuestMapFrame.Background:Hide()
    end
    QuestMapFrame.VerticalSeparator:Hide()

    -- SET UP TABS
    local QuestsTab = QuestMapFrame.QuestsTab
    Skin.QuestMapFrameTabTemplate(QuestsTab)

    local MapLegendTab = QuestMapFrame.MapLegendTab
    Skin.QuestMapFrameTabTemplate(MapLegendTab)

    local EventsTab = QuestMapFrame.EventsTab
    Skin.QuestMapFrameTabTemplate(EventsTab)

    Util.PositionRelative("TOPLEFT", QuestMapFrame, "TOPRIGHT", 1, -40, 1, "Down", {
        QuestsTab,
        MapLegendTab,
        EventsTab,
    })

    local QuestsFrame = QuestMapFrame.QuestsFrame
    Skin.ScrollFrameTemplate(QuestsFrame.ScrollFrame)
    -- FIXLATER
    -- Util.Mixin(QuestsFrame.titleFramePool, Hook.ObjectPoolMixin)
    -- Util.Mixin(QuestsFrame.objectiveFramePool, Hook.ObjectPoolMixin)
    -- Util.Mixin(QuestsFrame.headerFramePool, Hook.ObjectPoolMixin)
    -- Util.Mixin(QuestsFrame.campaignHeaderFramePool, Hook.ObjectPoolMixin)
    -- Util.Mixin(QuestsFrame.covenantCallingsHeaderFramePool, Hook.ObjectPoolMixin)

    QuestsFrame.ScrollFrame.Contents.Separator:SetSize(260, 10)
    QuestsFrame.ScrollFrame.Contents.Separator.Divider:SetPoint("TOP", 0, 0)

    do -- StoryHeader
        local StoryHeader = QuestsFrame.ScrollFrame.Contents.StoryHeader
        StoryHeader.Text:SetPoint("TOPLEFT", 18, -25)

        local mask = StoryHeader:CreateMaskTexture(nil, "BACKGROUND")
        mask:SetTexture([[Interface/SpellBook/UI-SpellbookPanel-Tab-Highlight]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetPoint("LEFT", -54, 0)
        mask:SetPoint("RIGHT", 38, 0)
        mask:SetPoint("TOP", StoryHeader.Text, 0, 52)
        mask:SetPoint("BOTTOM", StoryHeader.Progress, 0, -58)

        StoryHeader.Background:AddMaskTexture(mask)
        StoryHeader.Background:SetColorTexture(Color.button:GetRGB())

        StoryHeader.HighlightTexture:AddMaskTexture(mask)
        StoryHeader.HighlightTexture:SetAllPoints(StoryHeader.Background)
        StoryHeader.HighlightTexture:SetColorTexture(Color.white.r, Color.white.g, Color.white.b, Color.frame.a)
    end

    if QuestsFrame.DetailFrame then
        QuestsFrame.DetailFrame.BottomDetail:Hide()
        QuestsFrame.DetailFrame.TopDetail:Hide()
    end
    -- FIXLATER --broken in 11.1.0
    -- Skin.FrameTypeFrame(QuestsFrame.StoryTooltip)

    do -- QuestSessionManagement
        local QuestSessionManagement = QuestMapFrame.QuestSessionManagement
        Util.Mixin(QuestSessionManagement, Hook.QuestSessionManagementMixin)

        local ExecuteSessionCommand = QuestSessionManagement.ExecuteSessionCommand
        Skin.FrameTypeButton(ExecuteSessionCommand)
        local icon = ExecuteSessionCommand:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", 0, 0)
        icon:SetPoint("BOTTOMRIGHT", 0, 0)
        ExecuteSessionCommand._auroraIcon = icon

        QuestSessionManagement.BG:SetColorTexture(Color.frame.r, Color.frame.g, Color.frame.b, 0.5)
    end

    local DetailsFrame = QuestMapFrame.DetailsFrame
    local bg, overlay, _, _ = DetailsFrame:GetRegions()

    bg:Hide()
    overlay:Hide()
    local BorderFrame = DetailsFrame.BorderFrame
    BorderFrame:Hide()

    local BackFrame = DetailsFrame.BackFrame
    Base.StripBlizzardTextures(BackFrame)
    Skin.UIPanelButtonTemplate(BackFrame.BackButton)

    local RewardsFrameContainer = DetailsFrame.RewardsFrameContainer
    local RewardsFrame = RewardsFrameContainer.RewardsFrame
    Base.StripBlizzardTextures(RewardsFrame)
    Skin.ScrollFrameTemplate(DetailsFrame.ScrollFrame)

    Skin.UIPanelButtonTemplate(_G.QuestFrameCompleteButton)
    local QuestFrameCompleteButtonLeft, QuestFrameCompleteButtonRight = select(6, _G.QuestFrameCompleteButton:GetRegions())
    QuestFrameCompleteButtonLeft:Hide()
    QuestFrameCompleteButtonRight:Hide()

    Skin.UIPanelButtonTemplate(DetailsFrame.AbandonButton)
    Skin.UIPanelButtonTemplate(DetailsFrame.ShareButton)
    local ShareButtonLeft, ShareButtonRight = select(6, DetailsFrame.ShareButton:GetRegions())
    ShareButtonLeft:Hide()
    ShareButtonRight:Hide()
    Skin.UIPanelButtonTemplate(DetailsFrame.TrackButton)
    Skin.CampaignOverviewTemplate(QuestMapFrame.QuestsFrame.CampaignOverview)

    local MapLegend = QuestMapFrame.MapLegend
    Skin.ScrollFrameTemplate(MapLegend.ScrollFrame)
end
