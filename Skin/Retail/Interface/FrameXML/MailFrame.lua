local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\MailFrame.lua ]]
    function Hook.MailFrame_UpdateTrialState(self)
        local isTrialOrVeteran = _G.GameLimitedMode_IsActive()
        _G.InboxTitleText:SetShown(not isTrialOrVeteran)
    end
    function Hook.InboxFrame_Update()
        local numItems = _G.GetInboxNumItems()
        local index = ((_G.InboxFrame.pageNum - 1) * _G.INBOXITEMS_TO_DISPLAY) + 1
        for i = 1, _G.INBOXITEMS_TO_DISPLAY do
            local name = "MailItem"..i
            local item = _G[name]
            if index <= numItems then
                local _, _, _, _, _, _, _, _, wasRead, _, _, _, _, firstItemQuantity, _, firstItemLink = _G.GetInboxHeaderInfo(index)

                if not firstItemQuantity then
                    item.Button._auroraIconBorder:SetBackdropBorderColor(Color.frame, 1)
                end

                if wasRead then
                    -- We need to call this in case the item is a relic, to ensure that the relic border color is updated.
                    Hook.SetItemButtonQuality(item.Button, _G.Enum.ItemQuality.Common, firstItemLink)
                end
            else
                item.Button._auroraIconBorder:SetBackdropBorderColor(Color.frame, 1)
            end
            index = index + 1
        end
    end
    function Hook.SendMailFrame_Update()
        local numAttachments = 0
        for i = 1, _G.ATTACHMENTS_MAX_SEND do
            local button = _G.SendMailFrame.SendMailAttachments[i]
            if i == 1 then
                button:SetPoint("TOPLEFT", _G.SendMailScrollFrame, "BOTTOMLEFT", 1, -12)
            else
                if (i % _G.ATTACHMENTS_PER_ROW_SEND) == 1 then
                    button:SetPoint("TOPLEFT", _G.SendMailFrame.SendMailAttachments[i - _G.ATTACHMENTS_PER_ROW_SEND], "BOTTOMLEFT", 23, -9)
                else
                    button:SetPoint("TOPLEFT", _G.SendMailFrame.SendMailAttachments[i - 1], "TOPRIGHT", 9, 0)
                end
            end

            local icon = button:GetNormalTexture()
            if icon then
                Base.CropIcon(icon)
            end

            if _G.HasSendMailItem(i) then
                numAttachments = numAttachments + 1
            end
        end

        local scrollHeight = 194
        if numAttachments >= _G.ATTACHMENTS_PER_ROW_SEND then
            scrollHeight = 148
        end

        _G.SendMailScrollFrame:SetHeight(scrollHeight + 20)
        _G.SendMailScrollChildFrame:SetHeight(scrollHeight)
    end
    function Hook.OpenMail_Update()
        if ( not _G.InboxFrame.openMailID ) then
            return
        end

        local _, _, _, _, isInvoice = _G.GetInboxText(_G.InboxFrame.openMailID)
        if isInvoice then
            local invoiceType = _G.GetInboxInvoiceInfo(_G.InboxFrame.openMailID)
            if invoiceType then
                if invoiceType == "buyer" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", _G.OpenMailInvoicePurchaser, "BOTTOMLEFT", 125, -5)
                elseif invoiceType == "seller" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", _G.OpenMailInvoiceHouseCut, "BOTTOMRIGHT", -114, -22)
                elseif invoiceType == "seller_temp_invoice" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", _G.OpenMailInvoicePurchaser, "BOTTOMLEFT", 125, -5)
                end
            end
        end
    end
end

do --[[ FrameXML\MailFrame.xml ]]
    function Skin.SendMailRadioButtonTemplate(CheckButton)
        Skin.UIRadioButtonTemplate(CheckButton)
    end
    function Skin.MailItemTemplate(Frame)
        local name = Frame:GetName()

        local left, right, div = Frame:GetRegions()
        left:Hide()
        right:Hide()
        div:Hide()

        local button = Frame.Button
        button:SetPoint("TOPLEFT", 2, -2)
        button:SetSize(39, 39)

        _G[name.."ButtonSlot"]:Hide()
        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetFrameLevel(button:GetFrameLevel() - 1)
        bg:SetPoint("TOPLEFT", button, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", button, 1, -1)

        Base.CreateBackdrop(bg, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            insets = {left = 1, right = 1, top = 1, bottom = 1},
            edgeSize = 1,
        })
        Base.CropIcon(bg:GetBackdropTexture("bg"))
        bg:SetBackdropColor(1, 1, 1, 0.75)
        bg:SetBackdropBorderColor(Color.frame, 1)
        button._auroraIconBorder = bg

        Base.CropIcon(button.Icon)
        button.Icon:SetPoint("BOTTOMRIGHT")

        Base.CropIcon(button:GetHighlightTexture())
        Base.CropIcon(button:GetCheckedTexture())
    end
    function Skin.SendMailAttachment(Button)
        Button:GetRegions():Hide()

        local bg = _G.CreateFrame("Frame", nil, Button)
        bg:SetFrameLevel(Button:GetFrameLevel() - 1)
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)

        Base.CreateBackdrop(bg, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            insets = {left = 1, right = 1, top = 1, bottom = 1},
            edgeSize = 1,
        })
        Base.CropIcon(bg:GetBackdropTexture("bg"))
        bg:SetBackdropColor(1, 1, 1, 0.75)
        bg:SetBackdropBorderColor(Color.frame, 1)
        Button._auroraIconBorder = bg

        Base.CropIcon(Button:GetHighlightTexture())
    end
    function Skin.OpenMailAttachment(ItemButton)
        Skin.FrameTypeItemButton(ItemButton)
    end

    --[[ Fake template ]]--
    function Skin.SendMailInputBox(EditBox)
        Skin.FrameTypeEditBox(EditBox)
        EditBox:SetHeight(22)
        EditBox:SetBackdropOption("offsets", {
            left = -8,
            right = -8,
            top = 1,
            bottom = 1,
        })

        local name = EditBox:GetName()
        _G[name.."Left"]:Hide()
        _G[name.."Middle"]:Hide()
        _G[name.."Right"]:Hide()
    end
end


function private.FrameXML.MailFrame()
    _G.hooksecurefunc("MailFrame_UpdateTrialState", Hook.MailFrame_UpdateTrialState)
    _G.hooksecurefunc("InboxFrame_Update", Hook.InboxFrame_Update)
    _G.hooksecurefunc("SendMailFrame_Update", Hook.SendMailFrame_Update)
    _G.hooksecurefunc("OpenMail_Update", Hook.OpenMail_Update)

    ---------------
    -- MailFrame --
    ---------------
    Skin.ButtonFrameTemplate(_G.MailFrame)

    -- BlizzWTF: The portrait in the template is not being used.
    _G.select(3, _G.MailFrame:GetRegions()):Hide()
    _G.MailFrame.trialError:ClearAllPoints()
    _G.MailFrame.trialError:SetPoint("TOPLEFT", _G.MailFrame.TitleText, 50, -5)
    _G.MailFrame.trialError:SetPoint("BOTTOMRIGHT", _G.MailFrame.TitleText, -50, -6)

    ----------------
    -- InboxFrame --
    ----------------
    _G.InboxFrame:SetPoint("BOTTOMRIGHT")
    _G.InboxFrameBg:Hide()

    _G.InboxTooMuchMail:ClearAllPoints()
    _G.InboxTooMuchMail:SetAllPoints(_G.MailFrame.trialError)
    for index = 1, _G.INBOXITEMS_TO_DISPLAY do
        local name = "MailItem"..index
        local item = _G[name]

        Skin.MailItemTemplate(item)

        if index == 1 then
            item:SetPoint("TOPLEFT", 13, -(private.FRAME_TITLE_HEIGHT + 5))
        else
            item:SetPoint("TOPLEFT", _G["MailItem"..(index - 1)], "BOTTOMLEFT", 0, -6)
        end
    end

    Skin.NavButtonPrevious(_G.InboxPrevPageButton)
    _G.InboxPrevPageButton:ClearAllPoints()
    _G.InboxPrevPageButton:SetPoint("BOTTOMLEFT", 14, 10)

    Skin.NavButtonNext(_G.InboxNextPageButton)
    _G.InboxNextPageButton:ClearAllPoints()
    _G.InboxNextPageButton:SetPoint("BOTTOMRIGHT", -17, 10)

    Skin.UIPanelButtonTemplate(_G.OpenAllMail)
    _G.OpenAllMail:ClearAllPoints()
    _G.OpenAllMail:SetPoint("BOTTOM", 0, 14)

    -------------------
    -- SendMailFrame --
    -------------------
    _G.SendMailFrame:SetPoint("BOTTOMRIGHT")
    for i = 3, 6 do
        select(i, _G.SendMailFrame:GetRegions()):Hide()
    end

    Skin.ScrollFrameTemplate(_G.SendMailScrollFrame)
    _G.SendStationeryBackgroundLeft:Hide()
    _G.SendStationeryBackgroundRight:Hide()

    -- BlizzWTF: these should use InputBoxTemplate
    Skin.SendMailInputBox(_G.SendMailNameEditBox)
    Skin.SmallMoneyFrameTemplate(_G.SendMailCostMoneyFrame)
    _G.SendMailCostMoneyFrame:SetPoint("TOPRIGHT", -5, -34)
    Skin.SendMailInputBox(_G.SendMailSubjectEditBox)

    for i = 1, _G.ATTACHMENTS_MAX_SEND do
        Skin.SendMailAttachment(_G.SendMailFrame.SendMailAttachments[i])
    end

    _G.SendMailMoneyButton:SetPoint("BOTTOMLEFT", 15, 38)
    _G.SendMailMoneyButton:SetSize(31, 31)
    _G.SendMailMoneyText:SetPoint("TOPLEFT", _G.SendMailMoneyButton)
    Skin.MoneyInputFrameTemplate(_G.SendMailMoney)
    _G.SendMailMoney:ClearAllPoints()
    _G.SendMailMoney:SetPoint("BOTTOMLEFT", _G.SendMailMoneyButton, 5, 0)
    Skin.SendMailRadioButtonTemplate(_G.SendMailSendMoneyButton)
    Skin.SendMailRadioButtonTemplate(_G.SendMailCODButton)

    Skin.InsetFrameTemplate(_G.SendMailMoneyInset)
    Skin.ThinGoldEdgeTemplate(_G.SendMailMoneyBg)
    _G.SendMailMoneyBg:SetPoint("TOPRIGHT", _G.SendMailFrame, "BOTTOMLEFT", 165, 27)
    _G.SendMailMoneyBg:SetPoint("BOTTOMLEFT", 5, 5)
    Skin.SmallMoneyFrameTemplate(_G.SendMailMoneyFrame)
    _G.SendMailMoneyFrame:SetPoint("BOTTOMRIGHT", _G.SendMailMoneyBg, 7, 5)

    Skin.UIPanelButtonTemplate(_G.SendMailCancelButton)
    Skin.UIPanelButtonTemplate(_G.SendMailMailButton)
    Util.PositionRelative("BOTTOMRIGHT", _G.SendMailFrame, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.SendMailCancelButton,
        _G.SendMailMailButton,
    })

    _G.SendMailFrameLockSendMail:SetPoint("TOPLEFT", "SendMailAttachment1", -12, 12)
    _G.SendMailFrameLockSendMail:SetPoint("BOTTOMRIGHT", "SendMailCancelButton", 5, -5)

    Skin.FriendsFrameTabTemplate(_G.MailFrameTab1)
    Skin.FriendsFrameTabTemplate(_G.MailFrameTab2)
    Util.PositionRelative("TOPLEFT", _G.MailFrame, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.MailFrameTab1,
        _G.MailFrameTab2,
    })

    -------------------
    -- OpenMailFrame --
    -------------------
    Skin.ButtonFrameTemplate(_G.OpenMailFrame)
    _G.OpenMailFrame:SetPoint("TOPLEFT", _G.InboxFrame, "TOPRIGHT", 5, 0)

    _G.OpenMailFrameIcon:Hide()
    _G.OpenMailHorizontalBarLeft:Hide()
    select(9, _G.OpenMailFrame:GetRegions()):Hide() -- HorizontalBarRight

    Skin.UIPanelButtonTemplate(_G.OpenMailReportSpamButton)

    Skin.ScrollFrameTemplate(_G.OpenMailScrollFrame)
    _G.OpenStationeryBackgroundLeft:Hide()
    _G.OpenStationeryBackgroundRight:Hide()

    _G.OpenMailArithmeticLine:SetColorTexture(Color.grayLight:GetRGB())
    _G.OpenMailArithmeticLine:SetSize(256, 1)
    _G.OpenMailInvoiceAmountReceived:SetPoint("TOPRIGHT", _G.OpenMailArithmeticLine, "BOTTOMRIGHT", -14, -5)

    Skin.FrameTypeItemButton(_G.OpenMailLetterButton)
    for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
        Skin.OpenMailAttachment(_G.OpenMailFrame.OpenMailAttachments[i])
    end
    Skin.FrameTypeItemButton(_G.OpenMailMoneyButton)

    Skin.UIPanelButtonTemplate(_G.OpenMailCancelButton)
    Skin.UIPanelButtonTemplate(_G.OpenMailDeleteButton)
    Skin.UIPanelButtonTemplate(_G.OpenMailReplyButton)
    Util.PositionRelative("BOTTOMRIGHT", _G.OpenMailFrame, "BOTTOMRIGHT", -5, 5, 1, "Left", {
        _G.OpenMailCancelButton,
        _G.OpenMailDeleteButton,
        _G.OpenMailReplyButton,
    })

end
