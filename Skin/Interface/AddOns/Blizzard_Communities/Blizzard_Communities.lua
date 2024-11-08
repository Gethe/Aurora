local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ AddOns\Blizzard_Communities.lua ]]
    do --[[ CommunitiesList ]]
        Hook.CommunitiesListEntryMixin = {}
        function Hook.CommunitiesListEntryMixin:SetAddCommunity()
            self.CircleMask:Hide()
            Base.CropIcon(self.Icon)
            self.Icon:ClearAllPoints()
            self.Icon:SetPoint("CENTER")
            self.Name:SetPoint("LEFT", self.Icon, "RIGHT", 11, 0)
            self.Icon:Show()
            self.Icon:SetColorTexture(Color.black:GetRGB())
        end
        if private.isRetail then
            function Hook.CommunitiesListEntryMixin:Init(elementData)
                local clubInfo = elementData.clubInfo
                -- self._iconBG:SetWidth(self._iconBG:GetHeight())

                if clubInfo and self._iconBG then
                    local isGuild = clubInfo.clubType == _G.Enum.ClubType.Guild
                    if isGuild then
                        self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)
                    else
                        self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
                    end

                    self.CircleMask:Hide()
                    Base.CropIcon(self.Icon)
                    self.Icon:SetAllPoints(self._iconBG)
                    self._iconBG:Hide()
                end
            end
            function Hook.CommunitiesListEntryMixin:SetFindCommunity()
                self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)

                self.CircleMask:Hide()
                self.Icon:SetTexCoord(0, 1, 0, 1)
                self.Icon:ClearAllPoints()
                self.Icon:SetSize(34, 34)
                self.Icon:SetPoint("CENTER" )
                self.Name:SetPoint("LEFT", self.Icon, "RIGHT", 11, 0)

                self.Icon:Show()
                self.Icon:SetColorTexture(Color.black:GetRGB())
            end
            function Hook.CommunitiesListEntryMixin:SetGuildFinder()
                self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)

                self.CircleMask:Hide()
                self.Icon:SetTexCoord(0, 1, 0, 1)
                self.Icon:ClearAllPoints()
                self.Icon:SetSize(40, 40)
                self.Icon:SetPoint("CENTER", self.GuildTabardBackground, 0, 4)

                self._iconBG:Hide()
            end
        else
            function Hook.CommunitiesListEntryMixin:SetClubInfo(clubInfo, isInvitation, isTicket, isInviteFromFinder)
                if clubInfo and self._iconBG then
                    local isGuild = clubInfo.clubType == _G.Enum.ClubType.Guild
                    if isGuild then
                        self.Selection:SetColorTexture(Color.green.r, Color.green.g, Color.green.b, Color.frame.a)
                    else
                        self.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
                    end

                    self.CircleMask:Hide()
                    Base.CropIcon(self.Icon)
                    self.Icon:SetAllPoints(self._iconBG)
                    self._iconBG:Hide()
                end
            end
        end
    end
    do --[[ CommunitiesMemberList ]]
        Hook.CommunitiesMemberListEntryMixin = {}
        function Hook.CommunitiesMemberListEntryMixin:UpdatePresence()
            local memberInfo = self:GetMemberInfo();
            if memberInfo then
                if memberInfo.presence ~= _G.Enum.ClubMemberPresence.Offline then
                    if memberInfo.classID then
                        local classInfo = _G.C_CreatureInfo.GetClassInfo(memberInfo.classID);
                        local color = (classInfo and _G.CUSTOM_CLASS_COLORS[classInfo.classFile]) or _G.NORMAL_FONT_COLOR;
                        self.NameFrame.Name:SetTextColor(color.r, color.g, color.b);
                    else
                        self.NameFrame.Name:SetTextColor(_G.BATTLENET_FONT_COLOR:GetRGB());
                    end
                end
            end
        end
    end
    do --[[ CommunitiesSettings ]]
        Hook.CommunitiesSettingsDialogMixin = {}
        function Hook.CommunitiesSettingsDialogMixin:SetClubId(clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
    end
    do --[[ CommunitiesTicketManagerDialog ]]
        Hook.CommunitiesTicketManagerDialogMixin = {}
        function Hook.CommunitiesTicketManagerDialogMixin:SetClubId(clubId)
            local clubInfo = _G.C_Club.GetClubInfo(clubId)
            if clubInfo then
                if clubInfo.clubType == _G.Enum.ClubType.BattleNet then
                    self._iconBorder:SetColorTexture(_G.FRIENDS_BNET_BACKGROUND_COLOR:GetRGB())
                else
                    self._iconBorder:SetColorTexture(_G.FRIENDS_WOW_BACKGROUND_COLOR:GetRGB())
                end
            end
        end
    end
end

do --[[ AddOns\Blizzard_Communities.xml ]]
    do --[[ CommunitiesList ]]
        function Skin.CommunitiesListEntryTemplate(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 7,
                right = 10,
                top = 8,
                bottom = 8,
            })

            local bg = Button:GetBackdropTexture("bg")
            Button.Background:Hide()

            Button.GuildTabardBackground:SetSize(60, 60)
            Button.GuildTabardBackground:SetPoint("TOPLEFT", bg, -1, 1)

            Button.Selection:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
            Button.Selection:SetAllPoints(bg)

            Button._iconBG = Button:CreateTexture(nil, "BACKGROUND", nil, 5)
            Button._iconBG:SetPoint("TOPLEFT", bg, 1, -1)
            Button._iconBG:SetPoint("BOTTOM", bg, 0, 1)

            Button.CircleMask:Hide()

            Button.GuildTabardEmblem:SetSize(36 * 1.3, 42 * 1.3)
            Button.GuildTabardEmblem:SetPoint("CENTER", Button.GuildTabardBackground, 0, 6)
            Button.GuildTabardBorder:SetAllPoints(Button.GuildTabardBackground)

            Button.IconRing:SetAlpha(0)
            Button.NewCommunityFlash:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
        end

        function Skin.CommunitiesListFrameTemplate(Frame)
            Frame.Bg:Hide()
            Frame.TopFiligree:Hide()
            Frame.BottomFiligree:Hide()

            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            Frame.FilligreeOverlay:Hide()
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end

        function Skin.CommunitiesListDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end

    end
    do --[[ CommunitiesMemberList ]]
        function Skin.CommunitiesMemberListEntryTemplate(Button)
            Util.Mixin(Button, Hook.CommunitiesMemberListEntryMixin)
        end
        function Skin.CommunitiesMemberListFrameTemplate(Frame)
            Skin.UICheckButtonTemplate(Frame.ShowOfflineButton)
            Skin.ColumnDisplayTemplate(Frame.ColumnDisplay)
            Frame.ColumnDisplay.InsetBorderTopLeft:Hide()
            Frame.ColumnDisplay.InsetBorderTopRight:Hide()
            Frame.ColumnDisplay.InsetBorderBottomLeft:Hide()
            Frame.ColumnDisplay.InsetBorderTop:Hide()
            Frame.ColumnDisplay.InsetBorderLeft:Hide()

            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.CommunitiesFrameMemberListDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
        Skin.GuildMemberListDropDownMenuTemplate = Skin.CommunitiesFrameMemberListDropDownMenuTemplate
        Skin.CommunityMemberListDropDownMenuTemplate = Skin.CommunitiesFrameMemberListDropDownMenuTemplate
    end
    do --[[ CommunitiesChatFrame ]]
        function Skin.CommunitiesChatTemplate(Frame)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            local _, _, JumpToUnreadButton = Frame:GetChildren()
            Skin.UIPanelButtonTemplate(JumpToUnreadButton)
            if JumpToUnreadButton then
                Skin.UIPanelButtonTemplate(Frame.JumpToUnreadButton)
            end
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.CommunitiesChatEditBoxTemplate(EditBox)
            Skin.FrameTypeEditBox(EditBox)
            EditBox:SetBackdropOption("offsets", {
                left = -5,
                right = -5,
                top = 5,
                bottom = 5,
            })

            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Mid:Hide()
        end
    end
    do --[[ CommunitiesInvitationFrame ]]
        function Skin.CommunitiesInvitationFrameTemplate(Frame)
        end
        function Skin.CommunitiesTicketFrameTemplate(Frame)
            Skin.CommunitiesInvitationFrameTemplate(Frame)
        end
        function Skin.CommunitiesInviteButtonTemplate(Frame)
            Skin.UIPanelDynamicResizeButtonTemplate(Frame)
        end
    end
    do --[[ CommunitiesGuildFinderFrame ]]
        function Skin.CommunitiesGuildFinderFrameTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.FindAGuildButton)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
    end
    do --[[ CommunitiesStreams ]]
        function Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(CheckButton)
            Skin.UIRadioButtonTemplate(CheckButton)
        end
        function Skin.CommunitiesNotificationSettingsStreamEntryTemplate(Button)
            Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(Button.HideNotificationsButton)
            Skin.CommunitiesNotificationSettingsStreamEntryCheckButtonTemplate(Button.ShowNotificationsButton)
        end
        function Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Button)
            Skin.UIMenuButtonStretchTemplate(Button)
        end
        function Skin.CommunitiesEditStreamDialogTemplate(Frame)
            Skin.FrameTypeFrame(Frame)

            Skin.InputBoxTemplate(Frame.NameEdit)
            Skin.InputScrollFrameTemplate(Frame.Description)
            Skin.UICheckButtonTemplate(Frame.TypeCheckBox)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Delete)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.CommunitiesNotificationSettingsDialogTemplate(Frame)
            Frame.Selector.Center = Frame.BG
            Skin.SelectionFrameTemplate(Frame.Selector)
            Skin.CommunitiesListDropDownMenuTemplate(Frame.CommunitiesListDropDownMenu)
            Skin.ScrollFrameTemplate(Frame.ScrollFrame)
            Skin.UICheckButtonTemplate(Frame.ScrollFrame.Child.QuickJoinButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.NoneButton)
            Skin.CommunitiesMassNotificationsSettingsButtonTemplate(Frame.ScrollFrame.Child.AllButton)
        end
        function Skin.AddToChatButtonTemplate(Frame)
            Skin.UIMenuButtonStretchTemplate(Frame)
            Hook.SquareButton_SetIcon(Frame, "DOWN")
        end
        function Skin.StreamDropDownMenuTemplate(Frame)
            Skin.UIDropDownMenuTemplate(Frame)
        end
    end
    do --[[ CommunitiesAvatarPickerDialog ]]
        function Skin.AvatarButtonTemplate(Button)
        end
    end
    do --[[ CommunitiesTabs ]]
        function Skin.CommunitiesFrameTabTemplate(CheckButton)
            Skin.SideTabTemplate(CheckButton)
            CheckButton.IconOverlay:Hide()
        end
    end
    do --[[ ClubFinderApplicantList ]]
        function Skin.ClubFinderApplicantListFrameTemplate(Frame)
            Skin.ColumnDisplayTemplate(Frame.ColumnDisplay)
            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
    end
    do --[[ ClubFinder ]]
        function Skin.ClubFinderEditBoxScrollFrameTemplate(ScrollFrame)
            Skin.InputScrollFrameTemplate(ScrollFrame)
        end
        function Skin.ClubsFinderJoinClubWarningTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderInvitationsFrameTemplate(Frame)
            Skin.ClubsFinderJoinClubWarningTemplate(Frame.WarningDialog)
            Skin.UIPanelButtonTemplate(Frame.AcceptButton)
            Skin.UIPanelButtonTemplate(Frame.ApplyButton)
            Skin.UIPanelButtonTemplate(Frame.DeclineButton)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
        end
        function Skin.ClubsRecruitmentDialogTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)

            Skin.ClubFinderCheckboxTemplate(Frame.ShouldListClub.Button)
            -- FIXLATER
            -- Skin.ClubFinderFocusDropdownTemplate(Frame.ClubFocusDropdown)
            -- Skin.UIDropDownMenuTemplate(Frame.LookingForDropdown)
            -- Skin.UIDropDownMenuTemplate(Frame.LanguageDropdown)

            -- BlizzWTF: RecruitmentMessageFrame.RecruitmentMessageInput already has a border via InputScrollFrameTemplate
            local EditBox = Frame.RecruitmentMessageFrame
            EditBox.TopLeft:Hide()
            EditBox.TopRight:Hide()
            EditBox.Top:Hide()
            EditBox.BottomLeft:Hide()
            EditBox.BottomRight:Hide()
            EditBox.Bottom:Hide()
            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Middle:Hide()
            Skin.ClubFinderEditBoxScrollFrameTemplate(EditBox.RecruitmentMessageInput)

            Skin.ClubFinderCheckboxTemplate(Frame.MaxLevelOnly.Button)
            Skin.ClubFinderCheckboxTemplate(Frame.MinIlvlOnly.Button)
            Skin.InputBoxTemplate(Frame.MinIlvlOnly.EditBox)
            Skin.UIPanelButtonTemplate(Frame.Accept)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderBigSpecializationCheckBoxTemplate(Frame)
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderLittleSpecializationCheckBoxTemplate(Frame)
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderRequestToJoinTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.BG)

            -- BlizzWTF: MessageFrame.MessageScroll already has a border via InputScrollFrameTemplate
            local EditBox = Frame.MessageFrame
            EditBox.TopLeft:Hide()
            EditBox.TopRight:Hide()
            EditBox.Top:Hide()
            EditBox.BottomLeft:Hide()
            EditBox.BottomRight:Hide()
            EditBox.Bottom:Hide()
            EditBox.Left:Hide()
            EditBox.Right:Hide()
            EditBox.Middle:Hide()
            Skin.ClubFinderEditBoxScrollFrameTemplate(EditBox.MessageScroll)

            Skin.UIPanelButtonTemplate(Frame.Apply)
            Skin.UIPanelButtonTemplate(Frame.Cancel)
        end
        function Skin.ClubFinderGuildCardTemplate(Frame)
            Base.SetBackdrop(Frame, Color.frame, 0.5)
            Frame:SetBackdropBorderColor(Color.button)

            Frame.CardBackground:Hide()
            Skin.UIPanelButtonTemplate(Frame.RequestJoin)
        end
        function Skin.ClubFinderFocusDropdownTemplate(Frame)
            -- FIXLATER
            -- Skin.UIDropDownMenuTemplate(Frame)
        end
        function Skin.ClubFinderFilterDropdownTemplate(Frame)
            -- FIXLATER
            -- Skin.UIDropDownMenuTemplate(Frame)
        end
        function Skin.ClubFinderCheckboxTemplate(CheckButton)
            -- -- FIXLATER
            -- Skin.UICheckButtonTemplate(CheckButton) -- BlizzWTF: Doesn't use the template
        end
        function Skin.ClubFinderGuildCardsFrameTemplate(Frame)
            Skin.ClubFinderGuildCardTemplate(Frame.FirstCard)
            Skin.ClubFinderGuildCardTemplate(Frame.SecondCard)
            Skin.ClubFinderGuildCardTemplate(Frame.ThirdCard)
            Skin.NavButtonPrevious(Frame.PreviousPage)
            Skin.NavButtonNext(Frame.NextPage)
        end
        local roleIcons = {
            ["UI-Frame-TankIcon"] = "iconTANK",
            ["UI-Frame-HealerIcon"] = "iconHEALER",
            ["UI-Frame-DpsIcon"] = "iconDAMAGER",
            ["UI-LFG-RoleIcon-Tank"] = "iconTANK",
            ["UI-LFG-RoleIcon-Healer"] = "iconHEALER",
            ["UI-LFG-RoleIcon-DPS"] = "iconDAMAGER",
            ["groupfinder-icon-role-micro-tank"] = "iconTANK",
            ["groupfinder-icon-role-micro-heal"] = "iconHEALER",
            ["groupfinder-icon-role-micro-dps"] = "iconDAMAGER",
        }
        function Skin.ClubFinderRoleTemplate(Frame)
            local atlas = Frame.Icon:GetAtlas()
            Base.SetTexture(Frame.Icon, roleIcons[atlas])
            Skin.ClubFinderCheckboxTemplate(Frame.CheckBox)
        end
        function Skin.ClubFinderCommunitiesCardTemplate(Button)
            Base.SetBackdrop(Button, Color.button, Color.frame.a)
            Button.Background:Hide()

            Button.LogoBorder:Hide()
            Base.CropIcon(Button.CommunityLogo, Button)
            Button.CircleMask:Hide()

            Button.HighlightBackground:SetAlpha(0)
            Base.SetHighlight(Button)
        end
        function Skin.ClubFinderCommunitiesCardFrameTemplate(Frame)
            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
        end
        function Skin.ClubFinderOptionsTemplate(Frame)
            Skin.ClubFinderFilterDropdownTemplate(Frame.ClubFilterDropdown)
            -- FIXLATER
            -- Skin.UIDropDownMenuTemplate(Frame.ClubSizeDropdown)
            -- Skin.UIDropDownMenuTemplate(Frame.SortByDropdown)
            Skin.ClubFinderRoleTemplate(Frame.TankRoleFrame)
            Skin.ClubFinderRoleTemplate(Frame.HealerRoleFrame)
            Skin.ClubFinderRoleTemplate(Frame.DpsRoleFrame)
            Skin.SearchBoxTemplate(Frame.SearchBox)
            Skin.UIPanelButtonTemplate(Frame.Search)
        end
        function Skin.ClubFinderGuildAndCommunityFrameTemplate(Frame)
            Skin.ClubFinderOptionsTemplate(Frame.OptionsList)
            Skin.ClubFinderGuildCardsFrameTemplate(Frame.GuildCards)
            Skin.ClubFinderCommunitiesCardFrameTemplate(Frame.CommunityCards)
            Skin.ClubFinderGuildCardsFrameTemplate(Frame.PendingGuildCards)
            Skin.ClubFinderCommunitiesCardFrameTemplate(Frame.PendingCommunityCards)
            Skin.ClubFinderRequestToJoinTemplate(Frame.RequestToJoinFrame)
            Skin.InsetFrameTemplate(Frame.InsetFrame)
            Skin.CommunitiesFrameTabTemplate(Frame.ClubFinderSearchTab)
            Skin.CommunitiesFrameTabTemplate(Frame.ClubFinderPendingTab)
            Util.PositionRelative("TOPLEFT", Frame, "TOPRIGHT", 10, 43, 5, "Down", {
                Frame.ClubFinderSearchTab,
                Frame.ClubFinderPendingTab,
            })
        end
    end
    do --[[ CommunitiesSettings ]]
        function Skin.CommunitiesSettingsButtonTemplate(Button)
            Skin.UIPanelDynamicResizeButtonTemplate(Button)
        end
    end
    do --[[ CommunitiesTicketManagerDialog ]]
        function Skin.CommunitiesTicketEntryTemplate(Button)
            Skin.UIMenuButtonStretchTemplate(Button.CopyLinkButton)
            Button.CopyLinkButton.Background:SetAllPoints()
            Button.CopyLinkButton.Background:SetAlpha(0.6)
            Skin.UIMenuButtonStretchTemplate(Button.RevokeButton)

            local highlight = Button:GetHighlightTexture()
            highlight:SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, 0.3)
        end
        function Skin.CommunitiesTicketManagerScrollFrameTemplate(Frame)
            Frame.ArtOverlay.TopLeft:ClearAllPoints()
            Frame.ArtOverlay.TopRight:ClearAllPoints()

            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            Skin.ColumnDisplayTemplate(Frame.ColumnDisplay)
            Frame.ColumnDisplay.InsetBorderTopLeft:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderTopRight:ClearAllPoints()
            Frame.ColumnDisplay.InsetBorderBottomLeft:ClearAllPoints()
        end
    end
    do --[[ CommunitiesCalendar ]]
        function Skin.CommunitiesCalendarButtonTemplate(Button)
        end
    end
    do --[[ GuildRewards ]]
        function Skin.GuildAchievementPointDisplayTemplate(Frame)
        end
        function Skin.GuildRewardsTutorialButtonTemplate(Button)
        end
        function Skin.CommunitiesGuildProgressBarTemplate(Frame)
            Frame.Left:Hide()
            Frame.Right:Hide()
            Frame.Middle:Hide()
            Frame.BG:Hide()

            Base.SetBackdrop(Frame, Color.button, Color.frame.a)
            Frame:SetBackdropOption("offsets", {
                left = 0,
                right = 1,
                top = 3,
                bottom = 1,
            })

            Base.SetTexture(Frame.Progress, "gradientUp")
            Frame.Shadow:Hide()
        end
        function Skin.CommunitiesGuildRewardsButtonTemplate(Button)
            Skin.SmallMoneyFrameTemplate(Button.Money)
            Base.CropIcon(Button.Icon, Button)

            Button:ClearNormalTexture()
            Button:ClearHighlightTexture()
        end
        function Skin.CommunitiesGuildRewardsFrameTemplate(Frame)
            Frame.Bg:Hide()
            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
        end
    end
    do --[[ GuildPerks ]]
        function Skin.CommunitiesGuildPerksButtonTemplate(Button)
            local left, right, mid, divider = Button:GetRegions()
            left:Hide()
            right:Hide()
            mid:Hide()
            divider:Hide()
            Base.CropIcon(Button.Icon, Button)
        end
        function Skin.CommunitiesGuildPerksFrameTemplate(Frame)
            Frame:GetRegions():Hide()
            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
        end
    end
    do --[[ GuildInfo ]]
        function Skin.CommunitiesGuildInfoFrameTemplate(Frame)
            local _, bar1, bar2, bar3, bar4, bg, header1, header2, header3, challengesBG = Frame:GetRegions()
            bar1:Hide()
            bar2:Hide()
            bar3:Hide()
            bar4:Hide()
            bg:Hide()
            header1:Hide()
            header2:Hide()
            header3:Hide()
            challengesBG:Hide()

            Frame.MOTDScrollFrame:SetWidth(246)
            Frame.MOTDScrollFrame.MOTD:SetWidth(246)
            Skin.ScrollFrameTemplate(Frame.MOTDScrollFrame)
            Skin.ScrollFrameTemplate(Frame.DetailsFrame)
        end
    end
    do --[[ GuildNews ]]
        function Skin.CommunitiesGuildNewsCheckButtonTemplate(CheckButton)
            Skin.FrameTypeCheckButton(CheckButton)
            CheckButton:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })

            local bg = CheckButton:GetBackdropTexture("bg")
            local check = CheckButton:GetCheckedTexture()
            check:ClearAllPoints()
            check:SetPoint("TOPLEFT", bg, -5, 5)
            check:SetPoint("BOTTOMRIGHT", bg, 5, -5)
            check:SetDesaturated(true)
            check:SetVertexColor(Color.highlight:GetRGB())

            local disabled = CheckButton:GetDisabledCheckedTexture()
            disabled:SetAllPoints(check)
        end
        function Skin.CommunitiesGuildNewsButtonTemplate(Button)
            Button.header:SetTexture("")
        end
        function Skin.CommunitiesGuildNewsBossModelTemplate(PlayerModel)
            local modelBackground = _G.CreateFrame("Frame", nil, PlayerModel)
            modelBackground:SetPoint("TOPLEFT", -1, 1)
            modelBackground:SetPoint("BOTTOMRIGHT", 1, -2)
            modelBackground:SetFrameLevel(0)
            Skin.FrameTypeFrame(modelBackground)

            PlayerModel.Bg:Hide()
            PlayerModel.ShadowOverlay:Hide()
            PlayerModel.TopBg:Hide()

            PlayerModel.BorderBottomLeft:Hide()
            PlayerModel.BorderBottomRight:Hide()
            PlayerModel.BorderTop:Hide()
            PlayerModel.BorderBottom:Hide()
            PlayerModel.BorderLeft:Hide()
            PlayerModel.BorderRight:Hide()

            PlayerModel.Nameplate:SetAlpha(0)
            PlayerModel.BossName:SetPoint("TOPLEFT", modelBackground, "BOTTOMLEFT")
            PlayerModel.BossName:SetPoint("BOTTOMRIGHT", PlayerModel.TextFrame, "TOPRIGHT")

            PlayerModel.CornerTopLeft:Hide()
            PlayerModel.CornerTopRight:Hide()
            PlayerModel.CornerBottomLeft:Hide()
            PlayerModel.CornerBottomRight:Hide()

            local TextFrame = PlayerModel.TextFrame
            Skin.FrameTypeFrame(TextFrame)
            TextFrame:SetPoint("TOPLEFT", PlayerModel.Nameplate, "BOTTOMLEFT", -1, 12)
            TextFrame:SetWidth(200)
            TextFrame.TextFrameBg:Hide()

            TextFrame.BorderBottomLeft:Hide()
            TextFrame.BorderBottomRight:Hide()
            TextFrame.BorderBottom:Hide()
            TextFrame.BorderLeft:Hide()
            TextFrame.BorderRight:Hide()
        end
        function Skin.CommunitiesGuildNewsFrameTemplate(Frame)
            Frame:GetRegions():Hide()
            Frame.Header:Hide()

            Skin.WowScrollBoxList(Frame.ScrollBox)
            Skin.MinimalScrollBar(Frame.ScrollBar)
            Skin.CommunitiesGuildNewsBossModelTemplate(Frame.BossModel)
        end
    end
    do --[[ GuildRoster ]]
        function Skin.CommunitiesGuildMemberDetailFrameTemplate(Frame)
            Skin.DialogBorderDarkTemplate(Frame.Border)
            Skin.UIPanelCloseButton(Frame.CloseButton)
            Skin.UIPanelButtonTemplate(Frame.RemoveButton)
            Skin.UIPanelButtonTemplate(Frame.GroupInviteButton)
            -- FIXLATER
            -- Skin.UIDropDownMenuTemplate(Frame.RankDropdown)

            Skin.FrameTypeFrame(Frame.NoteBackground)
            Skin.FrameTypeFrame(Frame.OfficerNoteBackground)
        end
    end
    do --[[ GuildNameChange ]]
        function Skin.CommunitiesGuildNameChangeAlertFrameTemplate(Frame)
            Skin.GlowBoxTemplate(Frame)
        end
        function Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelCloseButton(Frame.CloseButton)
        end
        function Skin.NameChangeEditBoxTemplate(Frame)
            Skin.InputBoxTemplate(Frame)
        end
        function Skin.GuildNameChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.NameChangeEditBoxTemplate(Frame.EditBox)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end
        function Skin.CommunityNameChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end

        function Skin.GuildPostingChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end
        function Skin.CommunityPostingChangeFrameTemplate(Frame)
            Skin.ReportedGuildOrCommunityChangeTemplate(Frame)
            Skin.UIPanelButtonTemplate(Frame.Button)
        end
    end
    do --[[ CommunitiesFrame ]]
        function Skin.GuildBenefitsFrameTemplate(Frame)
            Skin.CommunitiesGuildPerksFrameTemplate(Frame.Perks)
            Skin.CommunitiesGuildRewardsFrameTemplate(Frame.Rewards)
            Skin.GuildRewardsTutorialButtonTemplate(Frame.GuildRewardsTutorialButton)
            Skin.GuildAchievementPointDisplayTemplate(Frame.GuildAchievementPointDisplay)
            Skin.CommunitiesGuildProgressBarTemplate(Frame.FactionFrame.Bar)

            Frame.InsetBorderTopLeft:Hide()
            Frame.InsetBorderTopRight:Hide()
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
            Frame.InsetBorderTopLeft2:Hide()
            Frame.InsetBorderBottomLeft2:Hide()
            Frame.InsetBorderLeft2:Hide()
        end
        function Skin.GuildDetailsFrameTemplate(Frame)
            Skin.CommunitiesGuildInfoFrameTemplate(Frame.Info)
            Skin.CommunitiesGuildNewsFrameTemplate(Frame.News)

            Frame.InsetBorderTopLeft:Hide()
            Frame.InsetBorderTopRight:Hide()
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
            Frame.InsetBorderTopLeft2:Hide()
            Frame.InsetBorderBottomLeft2:Hide()
            Frame.InsetBorderLeft2:Hide()
        end
        function Skin.CommunitiesControlFrameTemplate(Frame)
            Skin.CommunitiesSettingsButtonTemplate(Frame.CommunitiesSettingsButton)
            Skin.UIPanelButtonTemplate(Frame.GuildControlButton)
            Skin.UIPanelButtonTemplate(Frame.GuildRecruitmentButton)
        end
        function Skin.CommunitiesFrameFriendTabTemplate(Frame)
            Skin.FriendsFrameTabTemplate(Frame)
        end
    end
end

function private.AddOns.Blizzard_Communities()
    ----====####$$$$%%%%%$$$$####====----
    --         CommunitiesList         --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.CommunitiesListEntryMixin, Hook.CommunitiesListEntryMixin)

    ----====####$$$$%%%%%$$$$####====----
    --      CommunitiesMemberList      --
    ----====####$$$$%%%%%$$$$####====----
    Util.Mixin(_G.CommunitiesMemberListEntryMixin, Hook.CommunitiesMemberListEntryMixin)

    ----====####$$$$%%%%$$$$####====----
    --      CommunitiesChatFrame      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --   CommunitiesInvitationFrame   --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --   CommunitiesGuildFinderFrame   --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --       CommunitiesStreams       --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --  CommunitiesAvatarPickerDialog  --
    ----====####$$$$%%%%%$$$$####====----
    local CommunitiesAvatarPickerDialog = _G.CommunitiesAvatarPickerDialog
    CommunitiesAvatarPickerDialog:ClearAllPoints()
    CommunitiesAvatarPickerDialog:SetPoint("TOP", 0, -140)

    if private.isRetail then
        CommunitiesAvatarPickerDialog.Selector.Center = CommunitiesAvatarPickerDialog:GetRegions()
        Skin.SelectionFrameTemplate(CommunitiesAvatarPickerDialog.Selector)
        Skin.WowScrollBoxList(CommunitiesAvatarPickerDialog.ScrollBox)
        Skin.MinimalScrollBar(CommunitiesAvatarPickerDialog.ScrollBar)
    else
        if private.isVanilla then
            Base.CreateBackdrop(CommunitiesAvatarPickerDialog, private.backdrop, {
                bg = select(9, CommunitiesAvatarPickerDialog:GetRegions())
            })
        else
            CommunitiesAvatarPickerDialog.Center = CommunitiesAvatarPickerDialog:GetRegions()
        end

        Skin.SelectionFrameTemplate(CommunitiesAvatarPickerDialog)
        Skin.ListScrollFrameTemplate(CommunitiesAvatarPickerDialog.ScrollFrame)
    end

    ----====####$$$$%%%%$$$$####====----
    --  CommunitiesAddDialogInsecure  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --      CommunitiesAddDialog      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --  CommunitiesAddDialogOutbound  --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --         CommunitiesTabs         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --     ClubFinderApplicantList     --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           ClubFinder           --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       CommunitiesSettings       --
    ----====####$$$$%%%%%$$$$####====----
    local CommunitiesSettingsDialog = _G.CommunitiesSettingsDialog
    _G.hooksecurefunc(CommunitiesSettingsDialog, "SetClubId", Hook.CommunitiesSettingsDialogMixin.SetClubId)
    if private.isRetail then
        Skin.DialogBorderDarkTemplate(CommunitiesSettingsDialog.BG)
    else
        Skin.DialogBorderDarkTemplate(CommunitiesSettingsDialog)
    end

    CommunitiesSettingsDialog.IconPreview:RemoveMaskTexture(CommunitiesSettingsDialog.CircleMask)
    CommunitiesSettingsDialog._iconBorder = Base.CropIcon(CommunitiesSettingsDialog.IconPreview, CommunitiesSettingsDialog)
    CommunitiesSettingsDialog.IconPreviewRing:SetAlpha(0)

    Skin.InputBoxTemplate(CommunitiesSettingsDialog.NameEdit)
    Skin.InputBoxTemplate(CommunitiesSettingsDialog.ShortNameEdit)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.ChangeAvatarButton)

    if private.isRetail then
        Skin.InputScrollFrameTemplate(CommunitiesSettingsDialog.MessageOfTheDay)

        Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.ShouldListClub.Button)
        Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.AutoAcceptApplications.Button)
        Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.MaxLevelOnly.Button)
        Skin.ClubFinderCheckboxTemplate(CommunitiesSettingsDialog.MinIlvlOnly.Button)
        Skin.InputBoxTemplate(CommunitiesSettingsDialog.MinIlvlOnly.EditBox)

        -- FIXLATER
        -- Skin.ClubFinderFocusDropdownTemplate(CommunitiesSettingsDialog.ClubFocusDropdown)
        -- Skin.UIDropDownMenuTemplate(CommunitiesSettingsDialog.LookingForDropdown)
        -- Skin.UIDropDownMenuTemplate(CommunitiesSettingsDialog.LanguageDropdown)

        Skin.InputScrollFrameTemplate(CommunitiesSettingsDialog.Description)
    else
        Skin.UIPanelInputScrollFrameTemplate(CommunitiesSettingsDialog.MessageOfTheDay)
        Skin.UIPanelInputScrollFrameTemplate(CommunitiesSettingsDialog.Description)
    end

    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Delete)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Accept)
    Skin.UIPanelButtonTemplate(CommunitiesSettingsDialog.Cancel)

    ----====####$$$$%%%%$$$$####====----
    -- CommunitiesTicketManagerDialog --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesTicketManagerDialog = _G.CommunitiesTicketManagerDialog
    _G.hooksecurefunc(CommunitiesTicketManagerDialog, "SetClubId", Hook.CommunitiesTicketManagerDialogMixin.SetClubId)

    CommunitiesTicketManagerDialog.Icon:RemoveMaskTexture(CommunitiesTicketManagerDialog.CircleMask)
    CommunitiesTicketManagerDialog._iconBorder = Base.CropIcon(CommunitiesTicketManagerDialog.Icon, CommunitiesTicketManagerDialog)
    CommunitiesTicketManagerDialog.IconRing:SetAlpha(0)

    Skin.FrameTypeFrame(CommunitiesTicketManagerDialog)
    CommunitiesTicketManagerDialog.TopLeft:ClearAllPoints()
    CommunitiesTicketManagerDialog.TopRight:ClearAllPoints()
    CommunitiesTicketManagerDialog.BottomLeft:ClearAllPoints()
    CommunitiesTicketManagerDialog.BottomRight:ClearAllPoints()
    CommunitiesTicketManagerDialog.Background:Hide()

    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.LinkToChat)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.Copy)
    -- FIXLATER
    -- Skin.UIDropDownMenuTemplate(CommunitiesTicketManagerDialog.ExpiresDropDownMenu)
    -- Skin.UIDropDownMenuTemplate(CommunitiesTicketManagerDialog.UsesDropDownMenu)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.GenerateLinkButton)
    Skin.UIPanelSquareButton(CommunitiesTicketManagerDialog.MaximizeButton, "DOWN")
    Skin.CommunitiesTicketManagerScrollFrameTemplate(CommunitiesTicketManagerDialog.InviteManager)
    Skin.UIPanelButtonTemplate(CommunitiesTicketManagerDialog.Close)

    ----====####$$$$%%%%%$$$$####====----
    --       CommunitiesCalendar       --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --          GuildRewards          --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           GuildPerks           --
    ----====####$$$$%%%%$$$$####====----

    if private.isRetail then
        ----====####$$$$%%%%%$$$$####====----
        --            GuildInfo            --
        ----====####$$$$%%%%%$$$$####====----
        Skin.TranslucentFrameTemplate(_G.CommunitiesGuildLogFrame)
        local close1, container, close2 = _G.CommunitiesGuildLogFrame:GetChildren()
        Skin.UIPanelCloseButton(close1) -- BlizzWTF: close1 and close2 have the same global name
        Util.HideNineSlice(container)
        Skin.ScrollFrameTemplate(container.ScrollFrame)
        Skin.UIPanelButtonTemplate(close2)

        ----====####$$$$%%%%%$$$$####====----
        --            GuildNews            --
        ----====####$$$$%%%%%$$$$####====----
        local CommunitiesGuildNewsFiltersFrame = _G.CommunitiesGuildNewsFiltersFrame
        Skin.TranslucentFrameTemplate(CommunitiesGuildNewsFiltersFrame)
        Skin.UIPanelCloseButton(CommunitiesGuildNewsFiltersFrame.CloseButton)
        for i, CheckButton in next, CommunitiesGuildNewsFiltersFrame.GuildNewsFilterButtons do
            Skin.CommunitiesGuildNewsCheckButtonTemplate(CheckButton)
        end
    end

    ----====####$$$$%%%%%$$$$####====----
    --           GuildRoster           --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --         GuildNameChange         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --        CommunitiesFrame        --
    ----====####$$$$%%%%$$$$####====----
    local CommunitiesFrame = _G.CommunitiesFrame

    Skin.ButtonFrameTemplateMinimizable(CommunitiesFrame)
    CommunitiesFrame.PortraitOverlay:SetAlpha(0)

    Skin.MaximizeMinimizeButtonFrameTemplate(CommunitiesFrame.MaximizeMinimizeFrame)
    _G.hooksecurefunc(CommunitiesFrame.MaximizeMinimizeFrame, "maximizedCallback", function(...)
        CommunitiesFrame.Chat:SetPoint("BOTTOMRIGHT", CommunitiesFrame.MemberList, "BOTTOMLEFT", -32, 32)
    end)
    Skin.CommunitiesListFrameTemplate(CommunitiesFrame.CommunitiesList)

    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.ChatTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.RosterTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildBenefitsTab)
    Skin.CommunitiesFrameTabTemplate(CommunitiesFrame.GuildInfoTab)
    Util.PositionRelative("TOPLEFT", CommunitiesFrame, "TOPRIGHT", 1, -40, 5, "Down", {
        CommunitiesFrame.ChatTab,
        CommunitiesFrame.RosterTab,
        CommunitiesFrame.GuildBenefitsTab,
        CommunitiesFrame.GuildInfoTab,
    })

    Skin.StreamDropDownMenuTemplate(CommunitiesFrame.StreamDropDownMenu)
    Skin.GuildMemberListDropDownMenuTemplate(CommunitiesFrame.GuildMemberListDropDownMenu)
    Skin.CommunityMemberListDropDownMenuTemplate(CommunitiesFrame.CommunityMemberListDropDownMenu)
    Skin.CommunitiesListDropDownMenuTemplate(CommunitiesFrame.CommunitiesListDropDownMenu)
    Skin.CommunitiesCalendarButtonTemplate(CommunitiesFrame.CommunitiesCalendarButton)
    Skin.CommunitiesMemberListFrameTemplate(CommunitiesFrame.MemberList)
    Skin.ClubFinderApplicantListFrameTemplate(CommunitiesFrame.ApplicantList)
    Skin.ClubFinderGuildAndCommunityFrameTemplate(CommunitiesFrame.GuildFinderFrame)
    Skin.ClubFinderGuildAndCommunityFrameTemplate(CommunitiesFrame.CommunityFinderFrame)
    Skin.CommunitiesChatTemplate(CommunitiesFrame.Chat)
    Skin.CommunitiesChatEditBoxTemplate(CommunitiesFrame.ChatEditBox)

    Skin.CommunitiesInvitationFrameTemplate(CommunitiesFrame.InvitationFrame)
    Skin.ClubFinderInvitationsFrameTemplate(CommunitiesFrame.ClubFinderInvitationFrame)
    Skin.CommunitiesTicketFrameTemplate(CommunitiesFrame.TicketFrame)
    Skin.GuildBenefitsFrameTemplate(CommunitiesFrame.GuildBenefitsFrame)
    Skin.GuildDetailsFrameTemplate(CommunitiesFrame.GuildDetailsFrame)
    Skin.GuildNameChangeFrameTemplate(CommunitiesFrame.GuildNameChangeFrame)
    Skin.CommunityNameChangeFrameTemplate(CommunitiesFrame.CommunityNameChangeFrame)
    Skin.GuildPostingChangeFrameTemplate(CommunitiesFrame.GuildPostingChangeFrame)
    Skin.CommunityPostingChangeFrameTemplate(CommunitiesFrame.CommunityPostingChangeFrame)

    Skin.CommunitiesEditStreamDialogTemplate(CommunitiesFrame.EditStreamDialog)
    Skin.CommunitiesNotificationSettingsDialogTemplate(CommunitiesFrame.NotificationSettingsDialog)
    Skin.ClubsRecruitmentDialogTemplate(CommunitiesFrame.RecruitmentDialog)
    Skin.AddToChatButtonTemplate(CommunitiesFrame.AddToChatButton)
    Skin.CommunitiesInviteButtonTemplate(CommunitiesFrame.InviteButton)
    Skin.CommunitiesControlFrameTemplate(CommunitiesFrame.CommunitiesControlFrame)
    Skin.UIPanelButtonTemplate(CommunitiesFrame.GuildLogButton)
    Skin.CommunitiesGuildMemberDetailFrameTemplate(CommunitiesFrame.GuildMemberDetailFrame)
end
