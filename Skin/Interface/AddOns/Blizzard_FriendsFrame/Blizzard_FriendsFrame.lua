local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\FriendsFrame.lua ]]
    Hook.FriendsBroadcastFrameMixin = {}
    function Hook.FriendsBroadcastFrameMixin:ShowFrame()
        -- self.BroadcastButton:LockHighlight()
    end
    function Hook.FriendsBroadcastFrameMixin:HideFrame()
        -- self.BroadcastButton:UnlockHighlight()
    end

    function Hook.FriendsFrame_UpdateFriendButton(button, elementData)
        local gameIcon = button.gameIcon
        if gameIcon._bg then
            gameIcon._bg:SetShown(gameIcon:IsShown())
        end
    end
    function Hook.WhoList_InitButton(button, elementData)
        local info = elementData.info
        if info.filename then
            button.Class:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
        end
    end
    function Hook.WhoList_Update()
        local buttons = _G.WhoListScrollFrame.buttons
        local numButtons = #buttons

        for i = 1, numButtons do
            local button = buttons[i]
            if button.index then
                local info = _G.C_FriendList.GetWhoInfo(button.index)
                if info.filename then
                    button.Class:SetTextColor(_G.CUSTOM_CLASS_COLORS[info.filename]:GetRGB())
                end
            end
        end
    end
end

do --[[ SharedXML\FriendsFrame.xml ]]
    function Skin.FriendsTabTemplate(Button)
        Skin.TabSystemButtonTemplate(Button)
    end
    function Skin.FriendsFrameSlider(Slider)
        Skin.HybridScrollBarTrimTemplate(Slider)
    end
    function Skin.FriendsFrameScrollFrame(ScrollFrame)
        Skin.FriendsFrameSlider(ScrollFrame.scrollBar)
    end
    function Skin.FriendsFrameHeaderTemplate(Frame)
    end
    function Skin.FriendsFrameButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end
    function Skin.FriendsListButtonTemplate(Button)
        local gameIcon = Button.gameIcon
        gameIcon._bg = Base.CropIcon(Button.gameIcon, Button)
        gameIcon:SetSize(22, 22)
        gameIcon:SetTexCoord(0.15625, 0.84375, 0.15625, 0.84375)
        gameIcon:SetPoint("TOPRIGHT", -21, -6)

        local travelPassButton = Button.travelPassButton
        Skin.FrameTypeButton(travelPassButton)
        travelPassButton:SetSize(20, 32)

        local texture = travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
        texture:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
        texture:SetPoint("TOPRIGHT", 1, -4)
        texture:SetSize(22, 22)
        texture:SetAlpha(0.75)
        travelPassButton._auroraTextures = {texture}
    end
    function Skin.WhoFrameColumnHeaderTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
        Button.HighlightTexture:SetAlpha(0)
    end
    function Skin.FriendsFrameGuildPlayerStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.FriendsFrameGuildStatusButtonTemplate(Button)
        Button:GetHighlightTexture():SetColorTexture(Color.highlight.r, Color.highlight.g, Color.highlight.b, Color.frame.a)
    end
    function Skin.GuildFrameColumnHeaderTemplate(Button)
        local name = Button:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
    end
    function Skin.FriendsFrameTabTemplate(Button)
        Skin.PanelTabButtonTemplate(Button)
        Button._auroraTabResize = true
    end
    function Skin.GuildControlPopupFrameCheckboxTemplate(CheckButton)
        Skin.UICheckButtonTemplate(CheckButton)
    end
end

function private.SharedXML.FriendsFrame()
    _G.hooksecurefunc("FriendsFrame_UpdateFriendButton", Hook.FriendsFrame_UpdateFriendButton)
    _G.hooksecurefunc("WhoList_InitButton", Hook.WhoList_InitButton)

    local FriendsFrame = _G.FriendsFrame
    Skin.ButtonFrameTemplate(FriendsFrame)
    _G.FriendsFrameIcon:Hide()

    ----------------------
    -- FriendsTabHeader --
    ----------------------
    local BNetFrame = _G.FriendsFrameBattlenetFrame
    BNetFrame:GetRegions():Hide() -- BattleTag background
    BNetFrame:SetWidth(250)
    BNetFrame:SetPoint("TOP", 0, -26)
    Base.SetBackdrop(BNetFrame, _G.FRIENDS_BNET_BACKGROUND_COLOR, Color.frame.a)

    do -- BNetFrame.BroadcastButton
        local Button = BNetFrame.ContactsMenuButton
        Skin.FrameTypeButton(Button)
        Button:GetNormalTexture():SetAlpha(0)
        Button:GetPushedTexture():SetAlpha(0)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        local icon = Button:CreateTexture(nil, "ARTWORK")
        icon:SetTexture([[Interface\FriendsFrame\MenuIcon]])
        icon:SetSize(16, 16)
        icon:SetPoint("CENTER")
    end

    Skin.UIPanelInfoButton(BNetFrame.UnavailableInfoButton)

    local BroadcastFrame = BNetFrame.BroadcastFrame
    BroadcastFrame:SetPoint("TOPLEFT", -55, -24)

    -- Util.Mixin(BroadcastFrame, Hook.FriendsBroadcastFrameMixin)
    Skin.DialogBorderOpaqueTemplate(BroadcastFrame.Border)

    local EditBox = BroadcastFrame.EditBox
    Base.CreateBackdrop(EditBox, private.backdrop, {
        tl = EditBox.TopLeftBorder,
        tr = EditBox.TopRightBorder,
        t = EditBox.TopBorder,

        bl = EditBox.BottomLeftBorder,
        br = EditBox.BottomRightBorder,
        b = EditBox.BottomBorder,

        l = EditBox.LeftBorder,
        r = EditBox.RightBorder,

        bg = EditBox.MiddleBorder
    })
    Skin.FrameTypeEditBox(EditBox)
    EditBox:SetBackdropOption("offsets", {
        left = -7,
        right = -5,
        top = 0,
        bottom = 0,
    })

    Skin.FriendsFrameButtonTemplate(BroadcastFrame.UpdateButton)
    Skin.FriendsFrameButtonTemplate(BroadcastFrame.CancelButton)

    Skin.DialogBorderTemplate(BNetFrame.UnavailableInfoFrame)
    local _, blizzIcon = select(11, BNetFrame.UnavailableInfoFrame:GetRegions())
    blizzIcon:SetTexture([[Interface\Glues\MainMenu\Glues-BlizzardLogo]])

    -- FIXLATER
    local FriendsFrameStatusDropdown = _G.FriendsFrameStatusDropdown
    FriendsFrameStatusDropdown:ClearAllPoints()
    Skin.DropdownButton(FriendsFrameStatusDropdown)
    FriendsFrameStatusDropdown:SetPoint("TOPLEFT", 5, -27)
    FriendsFrameStatusDropdown:SetWidth(50)

    local FriendsTabHeader = _G.FriendsTabHeader
    for _, tab in next, {FriendsTabHeader.TabSystem:GetChildren()} do
        local button = tab
        if not tab._auroraSkinned then
            Skin.FriendsTabTemplate(tab)
            tab._auroraSkinned = true
        end
    end

    ----------------------
    -- FriendsListFrame --
    ----------------------
    local FriendsListFrame = _G.FriendsListFrame
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameAddFriendButton)
    Skin.FriendsFrameButtonTemplate(_G.FriendsFrameSendMessageButton)
    -- FIXLATER
    --- Skin.WowStyle1FilterDropdownTemplate(FriendsListFrame.FilterDropdown)
    Skin.UIPanelButtonTemplate(FriendsListFrame.RIDWarning:GetChildren()) -- ContinueButton
    Skin.WowScrollBoxList(FriendsListFrame.ScrollBox)
    Skin.MinimalScrollBar(FriendsListFrame.ScrollBar)


    ----------------------
    -- IgnoreListFrame --
    ----------------------
    -- local IgnoreListFrame = _G.IgnoreListFrame
    -- Skin.FriendsFrameButtonTemplate(_G.FriendsFrameIgnorePlayerButton)
    -- Skin.FriendsFrameButtonTemplate(_G.FriendsFrameUnsquelchButton)
    -- Skin.WowScrollBoxList(IgnoreListFrame.ScrollBox)
    -- Skin.MinimalScrollBar(IgnoreListFrame.ScrollBar)

    -----------------------
    -- RecentAlliesFrame --
    -----------------------
    local RecentAlliesFrame = _G.RecentAlliesFrame
    Skin.WowScrollBoxList(RecentAlliesFrame.List.ScrollBox)
    Skin.MinimalScrollBar(RecentAlliesFrame.List.ScrollBar)

    --------------
    -- WhoFrame --
    --------------
    local WhoFrame = _G.WhoFrame
    Skin.InsetFrameTemplate(_G.WhoFrameListInset)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader1)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader2)

    -- FIXLATER
    Skin.DropdownButton(_G.WhoFrameDropdown)
    -- _G.WhoFrameDropdownHighlightTexture:SetAlpha(0)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader3)
    Skin.WhoFrameColumnHeaderTemplate(_G.WhoFrameColumnHeader4)

    Skin.FriendsFrameButtonTemplate(_G.WhoFrameGroupInviteButton)
    Skin.UIPanelButtonTemplate(_G.WhoFrameAddFriendButton)
    Skin.UIPanelButtonTemplate(_G.WhoFrameWhoButton)

    _G.WhoFrameGroupInviteButton:SetPoint("BOTTOMRIGHT", -5, 5)
    _G.WhoFrameWhoButton:ClearAllPoints()
    _G.WhoFrameWhoButton:SetPoint("BOTTOMLEFT", 5, 5)
    _G.WhoFrameAddFriendButton:ClearAllPoints()
    _G.WhoFrameAddFriendButton:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "BOTTOMRIGHT", 1, 0)
    _G.WhoFrameAddFriendButton:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "BOTTOMLEFT", -1, 0)
    -- FIXLATER removed in 11.2?
    -- Skin.InsetFrameTemplate(_G.WhoFrameEditBoxInset)
    Skin.FrameTypeEditBox(_G.WhoFrameEditBox)
    _G.WhoFrameEditBox:ClearAllPoints()
    _G.WhoFrameEditBox:SetPoint("BOTTOMLEFT", _G.WhoFrameWhoButton, "TOPLEFT", 2, -2)
    _G.WhoFrameEditBox:SetPoint("BOTTOMRIGHT", _G.WhoFrameGroupInviteButton, "TOPRIGHT", -2, -2)
    _G.WhoFrameEditBox:SetBackdropOption("offsets", {
        left = -2,
        right = -2,
        top = 7,
        bottom = 7,
    })

    Skin.WowScrollBoxList(WhoFrame.ScrollBox)
    Skin.MinimalScrollBar(WhoFrame.ScrollBar)

    ----------------------
    -- FriendsFrameMisc --
    ----------------------
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab1)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab2)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab3)
    Skin.FriendsFrameTabTemplate(_G.FriendsFrameTab4)
    Util.PositionRelative("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.FriendsFrameTab1,
        _G.FriendsFrameTab2,
        _G.FriendsFrameTab3,
        _G.FriendsFrameTab4,
    })

    if not private.disabled.tooltips then
        Skin.FrameTypeFrame(_G.FriendsTooltip)
    end

    --------------------
    -- AddFriendFrame --
    --------------------
    Skin.DialogBorderTemplate(_G.AddFriendFrame.Border)
    -- FIXLATER
    -- Did this work?
    Skin.FrameTypeButton(_G.AddFriendInfoFrame.ContinueButton)

    Skin.UIPanelInfoButton(_G.AddFriendEntryFrameInfoButton)
    do -- AddFriendNameEditBox
        Skin.FrameTypeEditBox(_G.AddFriendNameEditBox)
        _G.AddFriendNameEditBoxLeft:Hide()
        _G.AddFriendNameEditBoxRight:Hide()
        _G.AddFriendNameEditBoxMiddle:Hide()
    end
    -- FIXLATER
    -- Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameAcceptButton)
    -- Skin.UIPanelButtonTemplate(_G.AddFriendEntryFrameCancelButton)
    -- Skin.FrameTypeButton(Button)

    -------------------------
    -- FriendsFriendsFrame --
    -------------------------
    local FriendsFriendsFrame = _G.FriendsFriendsFrame
    Skin.DialogBorderTemplate(FriendsFriendsFrame.Border)
    -- FIXLATER
    -- FriendsFriendsFrameDropdown:Enable(); FriendsFriendsFrameDropdown:GenerateMenu();
    -- Skin.DropdownButton(_G.FriendsFriendsFrameDropdown)
    Util.HideNineSlice(FriendsFriendsFrame.ScrollFrameBorder)
    Skin.WowScrollBoxList(FriendsFriendsFrame.ScrollBox)
    Skin.MinimalScrollBar(FriendsFriendsFrame.ScrollBar)
    Skin.UIPanelButtonTemplate(FriendsFriendsFrame.SendRequestButton)
    Skin.UIPanelButtonTemplate(FriendsFriendsFrame.CloseButton)

    --------------------------
    -- BattleTagInviteFrame --
    --------------------------
    Skin.DialogBorderTemplate(_G.BattleTagInviteFrame.Border)

    local _, send, cancel = _G.BattleTagInviteFrame:GetChildren()
    Skin.UIPanelButtonTemplate(send)
    Skin.UIPanelButtonTemplate(cancel)
end
