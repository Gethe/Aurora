local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next tinsert type

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do -- BlizzWTF: These are not templates, but they should be
    do -- ExpandOrCollapse
        local function Hook_SetHighlightTexture(self, texture)
            if self.settingHighlight then return end
            self.settingHighlight = true
            self:ClearHighlightTexture()
            self.settingHighlight = nil
        end
        local function Hook_SetPushedTexture(self, texture)
            self:GetPushedTexture():SetAlpha(0)
        end
        local function Hook_SetNormalTexture(self, texture)
            self:GetNormalTexture():SetAlpha(0)

            if type(texture) == "string" then
                texture = texture:lower()
            else
                if texture == 130838 then
                    texture = "plus"
                elseif texture == 130821 then
                    texture = "minus"
                end
            end

            if texture and texture ~= "" then
                if texture:find("plus") or texture:find("closed") then
                    self._plus:Show()
                elseif texture:find("minus") or texture:find("open") then
                    self._plus:Hide()
                end
                self:SetBackdrop(true)
            else
                self:SetBackdrop(false)
            end
        end
        function Skin.ExpandOrCollapse(Button)
            if Button:GetNormalTexture() then
                Button:GetNormalTexture():SetAlpha(0)
            end
            Skin.FrameTypeButton(Button)

            local bg = Button:GetBackdropTexture("bg")
            local minus = Button:CreateTexture(nil, "OVERLAY")
            minus:SetColorTexture(1, 1, 1)
            minus:SetSize(9, 1)
            minus:SetPoint("TOPLEFT", bg, 2, -6)
            Button._minus = minus

            local plus = Button:CreateTexture(nil, "OVERLAY")
            plus:SetColorTexture(1, 1, 1)
            plus:SetSize(1, 9)
            plus:SetPoint("TOPLEFT", bg, 6, -2)
            Button._plus = plus

            Button._auroraTextures = {
                minus,
                plus
            }
            _G.hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
            _G.hooksecurefunc(Button, "SetPushedTexture", Hook_SetPushedTexture)
            _G.hooksecurefunc(Button, "SetNormalAtlas", Hook_SetNormalTexture)
            _G.hooksecurefunc(Button, "SetPushedAtlas", Hook_SetPushedTexture)
            _G.hooksecurefunc(Button, "SetHighlightTexture", Hook_SetHighlightTexture)
        end
    end

    do -- Nav buttons
        local function NavButton(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })

            local bg = Button:GetBackdropTexture("bg")
            local arrow = Button:CreateTexture(nil, "ARTWORK")
            arrow:SetPoint("TOPLEFT", bg, 8, -5)
            arrow:SetPoint("BOTTOMRIGHT", bg, -8, 5)
            Button._auroraTextures = {arrow}

            return arrow
        end
        function Skin.NavButtonPrevious(Button)
            local arrow = NavButton(Button)
            Base.SetTexture(arrow, "arrowLeft")
        end
        function Skin.NavButtonNext(Button)
            local arrow = NavButton(Button)
            Base.SetTexture(arrow, "arrowRight")
        end
    end

    do -- Side Tabs
        local function Hook_SetChecked(self, isChecked)
            -- Set the selected tab
            if isChecked then
                self._auroraIconBG:SetColorTexture(Color.yellow:GetRGB())
            else
                self._auroraIconBG:SetColorTexture(Color.black:GetRGB())
            end
        end
        function Skin.SideTabTemplate(TabButton)
            TabButton:GetRegions():Hide()

            local CheckButton = TabButton.Button or TabButton
            _G.hooksecurefunc(CheckButton, "SetChecked", Hook_SetChecked)

            local icon = CheckButton.IconTexture
            if icon then
                CheckButton:ClearNormalTexture()
                Base.CropIcon(CheckButton:GetPushedTexture())
            else
                icon = CheckButton.Icon or CheckButton:GetNormalTexture()
            end

            CheckButton._auroraIconBG = Base.CropIcon(icon, CheckButton)
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
    end

    do -- Scroll thumb
        local function Hook_Hide(self)
            self._auroraThumb:Hide()
        end
        local function Hook_Show(self)
            self._auroraThumb:Show()
        end
        function Skin.ScrollBarThumb(Texture)
            Texture:SetAlpha(0)
            Texture:SetSize(17, 24)
            _G.hooksecurefunc(Texture, "Hide", Hook_Hide)
            _G.hooksecurefunc(Texture, "Show", Hook_Show)

            local thumb = _G.CreateFrame("Frame", nil, Texture:GetParent())
            thumb:SetPoint("TOPLEFT", Texture, 0, -2)
            thumb:SetPoint("BOTTOMRIGHT", Texture, 0, 2)
            thumb:SetShown(Texture:IsShown())
            Base.SetBackdrop(thumb, Color.button)
            Texture._auroraThumb = thumb
        end
    end

    do -- MinimizeButton
        function Skin.MinimizeButton(Button)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 4,
                right = 11,
                top = 10,
                bottom = 5,
            })

            local bg = Button:GetBackdropTexture("bg")
            local hline = Button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(11, 1)
            hline:SetPoint("BOTTOMLEFT", bg, 3, 3)
            Button._auroraTextures = {hline}
        end
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.lua ]]
    do --[[ PortraitFrame ]]
        Hook.PortraitFrameMixin = {}
        function Hook.PortraitFrameMixin:SetBorder(layoutName)
            if not self.NineSlice.SetBackdropOption then return end
            self.NineSlice:SetBackdrop(private.backdrop)
        end
    end
    do --[[ SharedUIPanelTemplates ]]
        function Hook.UIPanelCloseButton_SetBorderAtlas(self, atlas, xOffset, yOffset, textureKit)
            self.Border:SetAlpha(0)
        end

        local resizing = false
        function Hook.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
            if not tab._auroraTabResize or resizing then return end

            resizing = true
            local left = tab.Left or tab.leftTexture or _G[tab:GetName().."Left"]
            left:SetWidth(10)
            _G.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
            resizing = false
        end
        function Hook.PanelTemplates_DeselectTab(tab)
            local text = tab.Text or _G[tab:GetName().."Text"]
            text:SetPoint("CENTER", tab, "CENTER")
        end
        function Hook.PanelTemplates_SelectTab(tab)
            local text = tab.Text or _G[tab:GetName().."Text"]
            text:SetPoint("CENTER", tab, "CENTER")
        end

        Hook.SquareIconButtonMixin = {}
        function Hook.SquareIconButtonMixin:OnMouseDown()
            if self:IsEnabled() then
                self.Icon:SetPoint("CENTER", -1, -1)
            end
        end
        function Hook.SquareIconButtonMixin:OnMouseUp()
            self.Icon:SetPoint("CENTER", 0, 0)
        end

        Hook.ThreeSliceButtonMixin = {}
        function Hook.ThreeSliceButtonMixin:UpdateButton(buttonState)
            self.Left:SetTexture("")
            self.Right:SetTexture("")

            self:SetButtonColor((self:GetButtonColor()))
        end
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelHideButtonNoScripts(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 4,
            right = 11,
            top = 10,
            bottom = 5,
        })

        local bg = Button:GetBackdropTexture("bg")
        local hline = Button:CreateTexture()
        hline:SetColorTexture(1, 1, 1)
        hline:SetSize(11, 1)
        hline:SetPoint("BOTTOMLEFT", bg, 3, 3)
        Button._auroraTextures = {hline}
    end
    function Skin.UIPanelCloseButton(Button)
        Skin.FrameTypeButton(Button)
        if private.isRetail then
            Button:SetBackdropOption("offsets", {
                left = 3,
                right = 4,
                top = 3,
                bottom = 4,
            })
        else
            Button:SetBackdropOption("offsets", {
                left = 4,
                right = 11,
                top = 10,
                bottom = 5,
            })
        end

        local bg = Button:GetBackdropTexture("bg")
        local cross = {}
        for i = 1, 2 do
            local line = Button:CreateLine(nil, "ARTWORK")
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:Show()
            if i == 1 then
                line:SetStartPoint("TOPLEFT", bg, 3.6, -3)
                line:SetEndPoint("BOTTOMRIGHT", bg, -3, 3)
            else
                line:SetStartPoint("TOPRIGHT", bg, -3, -3)
                line:SetEndPoint("BOTTOMLEFT", bg, 3.6, 3)
            end
            tinsert(cross, line)
        end

        Button._auroraTextures = cross
    end
    function Skin.UIPanelCloseButtonDefaultAnchors(Button)
        Skin.UIPanelCloseButton(Button)
        Button:SetPoint("TOPRIGHT", 1.2, 0)
    end
    function Skin.UIPanelGoldButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 15,
            right = 18,
            top = 1,
            bottom = 5,
        })
        Button:SetBackdropBorderColor(Color.yellow)

        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.UIPanelButtonTemplate(Button)
        Skin.UIPanelButtonNoTooltipTemplate(Button)
    end
    function Skin.UIPanelDynamicResizeButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)
    end

    function Skin.UIRadioButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, 1, -1)
        check:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        check:SetColorTexture(Color.highlight:GetRGB())
    end
    function Skin.UICheckButtonTemplate(CheckButton)
        Skin.FrameTypeCheckButton(CheckButton)
        CheckButton:SetBackdropOption("offsets", {
            left = 6,
            right = 6,
            top = 6,
            bottom = 6,
        })

        local bg = CheckButton:GetBackdropTexture("bg")
        local check = CheckButton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bg, -6, 6)
        check:SetPoint("BOTTOMRIGHT", bg, 6, -6)
        check:SetDesaturated(true)
        check:SetVertexColor(Color.highlight:GetRGB())

        local disabled = CheckButton:GetDisabledCheckedTexture()
        if disabled then
            disabled:SetAllPoints(check)
        end
    end

    function Skin.GlowBoxArrowTemplate(Frame, direction)
        direction = direction or "Down"
        local parent = Frame:GetParent()
        if not parent.info then
            if direction == "Left" or direction == "Right" then
                Frame:SetSize(21, 53)
            else
                Frame:SetSize(53, 21)
            end

            Base.SetTexture(Frame.Arrow, "arrow"..direction)
        end
        Frame.Arrow:SetAllPoints()
        Frame.Arrow:SetVertexColor(1, 1, 0)
        Frame.Glow:Hide()
    end
    function Skin.GlowBoxTemplate(Frame)
        Frame.BG:Hide()

        Frame.GlowTopLeft:Hide()
        Frame.GlowTopRight:Hide()
        Frame.GlowBottomLeft:Hide()
        Frame.GlowBottomRight:Hide()

        Frame.GlowTop:Hide()
        Frame.GlowBottom:Hide()
        Frame.GlowLeft:Hide()
        Frame.GlowRight:Hide()

        Frame.ShadowTopLeft:Hide()
        Frame.ShadowTopRight:Hide()
        Frame.ShadowBottomLeft:Hide()
        Frame.ShadowBottomRight:Hide()

        Frame.ShadowTop:Hide()
        Frame.ShadowBottom:Hide()
        Frame.ShadowLeft:Hide()
        Frame.ShadowRight:Hide()

        Base.SetBackdrop(Frame, Color.yellow:Lightness(-0.8), 0.75)
        Frame:SetBackdropBorderColor(Color.yellow)
    end

    --[[
        SetClampedTextureRotation(self.Arrow.Arrow, 90) -- Left
        SetClampedTextureRotation(self.Arrow.Arrow, 180) -- Up
        SetClampedTextureRotation(self.Arrow.Arrow, 270) -- Right
    ]]
    -- BlizzWTF: This should be a template
    function Skin.GlowBoxFrame(Frame, direction)
        if Frame.BigText then
            -- BlizzWTF: Why not just use GlowBoxArrowTemplate?
            local Arrow = _G.CreateFrame("Frame", nil, Frame)
            Arrow.Arrow = Frame["Arrow"..direction] or Frame["Arrow"..direction:upper()]
            Arrow.Arrow:SetParent(Arrow)
            Arrow.Glow = Frame["ArrowGlow"..direction] or Frame["ArrowGlow"..direction:upper()]
            Arrow.Glow:SetParent(Arrow)

            Frame.Arrow = Arrow
            Frame.Text = Frame.BigText
        end
        Skin.GlowBoxTemplate(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)

        direction = direction or "Down"
        local point = direction:upper()
        if point == "UP" then
            point = "TOP"
        elseif point == "DOWN" then
            point = "BOTTOM"
        end

        Skin.GlowBoxArrowTemplate(Frame.Arrow, direction)
        Frame.Arrow:ClearAllPoints()
        Frame.Arrow:SetPoint(Util.OpposingSide[point], Frame, point)
    end

    function Skin.NineSlicePanelTemplate(Frame)
        Frame._auroraNineSlice = true
        if Frame.debug then
            _G.print("NineSlicePanelTemplate", Frame:GetDebugName())
        end
        Hook.NineSliceUtil.ApplyLayout(Frame)
    end
    function Skin.InsetFrameTemplate(Frame)
        if private.isRetail then
            Frame.NineSlice.Center = Frame.Bg
            if Frame.debug then
                Frame.NineSlice.debug = Frame.debug
            end
            Skin.NineSlicePanelTemplate(Frame.NineSlice)
        else
            Frame.Bg:Hide()

            Frame.InsetBorderTopLeft:Hide()
            Frame.InsetBorderTopRight:Hide()
            Frame.InsetBorderBottomLeft:Hide()
            Frame.InsetBorderBottomRight:Hide()

            Frame.InsetBorderTop:Hide()
            Frame.InsetBorderBottom:Hide()
            Frame.InsetBorderLeft:Hide()
            Frame.InsetBorderRight:Hide()
        end
    end
    function Skin.DialogBorderNoCenterTemplate(Frame)
        Skin.NineSlicePanelTemplate(Frame)

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0)
    end
    function Skin.DialogBorderTemplate(Frame)
        if Frame.Bg then
            Frame.Center = Frame.Bg
        end
        Skin.DialogBorderNoCenterTemplate(Frame)

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, Util.GetFrameAlpha())
    end
    function Skin.DialogBorderDarkTemplate(Frame)
        if Frame.Bg then
            Frame.Center = Frame.Bg
        end
        Skin.DialogBorderNoCenterTemplate(Frame)

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0.87)
    end
    function Skin.DialogBorderTranslucentTemplate(Frame)
        if Frame.Bg then
            Frame.Center = Frame.Bg
        end
        Skin.DialogBorderNoCenterTemplate(Frame)

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 0.8)
    end
    function Skin.DialogBorderOpaqueTemplate(Frame)
        if Frame.Bg then
            Frame.Center = Frame.Bg
        end
        Skin.DialogBorderNoCenterTemplate(Frame)

        local r, g, b = Frame:GetBackdropColor()
        Frame:SetBackdropColor(r, g, b, 1)
    end

    function Skin.DialogHeaderTemplate(Frame)
        Frame.LeftBG:Hide()
        Frame.RightBG:Hide()
        Frame.CenterBG:Hide()

        Frame.Text:SetPoint("TOP", 0, -17)
        Frame.Text:SetPoint("BOTTOM", Frame, "TOP", 0, -(private.FRAME_TITLE_HEIGHT + 17))
    end
    function Skin.FlatPanelBackgroundTemplate(Frame)
        Frame.BottomLeft:Hide()
        Frame.BottomRight:Hide()
        Frame.BottomEdge:Hide()
        Frame.TopSection:Hide()
    end

    function Skin.SimplePanelTemplate(Frame)
        Skin.InsetFrameTemplate(Frame.Inset)
        Frame.NineSlice.Center = Frame.Bg
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
    end

    function Skin.DefaultPanelBaseTemplate(Frame)
        Frame.NineSlice:SetFrameLevel(Frame:GetFrameLevel())
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
    end
    function Skin.DefaultPanelTemplate(Frame)
        Frame.NineSlice.Center = Frame.Bg
        Skin.DefaultPanelBaseTemplate(Frame)
    end
    function Skin.DefaultPanelFlatTemplate(Frame)
        Skin.DefaultPanelBaseTemplate(Frame)
        Skin.FlatPanelBackgroundTemplate(Frame.Bg)
    end

    function Skin.PortraitFrameBaseTemplate(Frame)
        Util.Mixin(Frame, Hook.PortraitFrameMixin)
        if not Frame then
            _G.print("ReportError: Frame is nil in PortraitFrameBaseTemplate - Report to Aurora developers.")
            return
        end
        if Frame.debug then
            Frame.NineSlice.debug = Frame.debug
        end
        Frame.NineSlice:SetFrameLevel(Frame:GetFrameLevel() + 1)
        Skin.NineSlicePanelTemplate(Frame.NineSlice)
        Frame.PortraitContainer:Hide()

        Frame.TitleContainer:SetHeight(private.FRAME_TITLE_HEIGHT)
        Frame.TitleContainer:SetPoint("TOPLEFT", 24, -1)
        local titleText = Frame.TitleContainer.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT", Frame.TitleContainer)
        titleText:SetPoint("BOTTOMRIGHT", Frame.TitleContainer)
    end
    function Skin.PortraitFrameTexturedBaseTemplate(Frame)
        Frame.NineSlice.Center = Frame.Bg
        Skin.PortraitFrameBaseTemplate(Frame)
        Frame.TopTileStreaks:SetTexture("")
    end
    function Skin.PortraitFrameFlatBaseTemplate(Frame)
        if not Frame then
            _G.print("ReportError: Frame is nil in PortraitFrameFlatBaseTemplate - Report to Aurora developers.")
            return
        end
        Skin.PortraitFrameBaseTemplate(Frame)
        Skin.FlatPanelBackgroundTemplate(Frame.Bg)
    end
    function Skin.PortraitFrameTemplateNoCloseButton(Frame)
        if private.isRetail then
            Skin.PortraitFrameTexturedBaseTemplate(Frame)
        else
            Skin.FrameTypeFrame(Frame)
            local bg = Frame:GetBackdropTexture("bg")

            Frame.Bg:Hide()

            Frame.TitleBg:Hide()
            Frame.portrait:SetAlpha(0)
            Frame.PortraitFrame:SetTexture("")
            Frame.TopRightCorner:Hide()
            Frame.TopLeftCorner:SetTexture("")
            Frame.TopBorder:SetTexture("")

            local titleText = Frame.TitleText
            titleText:ClearAllPoints()
            titleText:SetPoint("TOPLEFT", bg)
            titleText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

            Frame.TopTileStreaks:SetTexture("")
            Frame.BotLeftCorner:Hide()
            Frame.BotRightCorner:Hide()
            Frame.BottomBorder:Hide()
            Frame.LeftBorder:Hide()
            Frame.RightBorder:Hide()
        end
    end
    function Skin.PortraitFrameTemplate(Frame)
        Skin.PortraitFrameTemplateNoCloseButton(Frame)
        Skin.UIPanelCloseButton(Frame.CloseButton)

        --Frame.CloseButton:SetPoint("TOPRIGHT", Frame.Bg, 5.6, 5)
    end
    function Skin.PortraitFrameFlatTemplate(Frame)
        if not Frame then
            _G.print("ReportError: Frame is nil in PortraitFrameFlatTemplate - Report to Aurora developers.")
            return
        end
        Skin.PortraitFrameFlatBaseTemplate(Frame)
        Skin.UIPanelCloseButtonDefaultAnchors(Frame.CloseButton)
    end

    function Skin.ButtonFrameTemplate(Frame)
        if private.isRetail then
            Frame.NineSlice.Center = Frame.Bg
            Frame.TopTileStreaks:SetTexture("")
            Skin.PortraitFrameBaseTemplate(Frame)
            Skin.UIPanelCloseButtonDefaultAnchors(Frame.CloseButton)
        else
            Skin.PortraitFrameTemplate(Frame)

            local name = Frame:GetName()
            _G[name.."BtnCornerLeft"]:SetAlpha(0)
            _G[name.."BtnCornerRight"]:SetAlpha(0)
            _G[name.."ButtonBottomBorder"]:SetAlpha(0)
        end
        Skin.InsetFrameTemplate(Frame.Inset)
    end
    function Skin.ButtonFrameTemplateMinimizable(Frame)
        Skin.ButtonFrameTemplate(Frame)
    end

    function Skin.MagicButtonTemplate(Button)
        Skin.UIPanelButtonTemplate(Button)

        if Button.LeftSeparator then
            Button.LeftSeparator:Hide()
        end
        if Button.RightSeparator then
            Button.RightSeparator:Hide()
        end
    end

    function Skin.UIMenuButtonStretchTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2,
        })

        Button.TopLeft:Hide()
        Button.TopRight:Hide()
        Button.BottomLeft:Hide()
        Button.BottomRight:Hide()
        Button.TopMiddle:Hide()
        Button.MiddleLeft:Hide()
        Button.MiddleRight:Hide()
        Button.BottomMiddle:Hide()
        Button.MiddleMiddle:Hide()

        local bg = Button:GetBackdropTexture("bg")
        Button.Text:SetPoint("CENTER", bg, 0, 0)
    end
    function Skin.UIResettableDropdownButtonTemplate(Button)
        Skin.UIMenuButtonStretchTemplate(Button)
    end

    function Skin.HorizontalSliderTemplate(Slider)
        Base.SetBackdrop(Slider, Color.frame)
        Slider:SetBackdropBorderColor(Color.button)
        Slider:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        local thumbTexture = Slider:GetThumbTexture()
        thumbTexture:SetAlpha(0)
        thumbTexture:SetSize(8, 16)

        local thumb = _G.CreateFrame("Frame", nil, Slider)
        thumb:SetPoint("TOPLEFT", thumbTexture, 0, 0)
        thumb:SetPoint("BOTTOMRIGHT", thumbTexture, 0, 0)
        Base.SetBackdrop(thumb, Color.button)
        Slider._auroraThumb = thumb
    end

    function Skin.SpinnerButton(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        })
        local buttonBG = Button:GetBackdropTexture("bg")
        local arrow = Button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", buttonBG, 6, -3)
        arrow:SetPoint("BOTTOMRIGHT", buttonBG, -6, 3)
        Button._auroraTextures = {arrow}
    end
    function Skin.NumericInputSpinnerTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)

        -- BlizzWTF: You use the template, but still create three new textures for the input border?
        local _, _, left, right, mid = EditBox:GetRegions()
        left:Hide()
        right:Hide()
        mid:Hide()

        local bg = EditBox:GetBackdropTexture("bg")
        Skin.SpinnerButton(EditBox.DecrementButton)
        Base.SetTexture(EditBox.DecrementButton._auroraTextures[1], "arrowLeft")
        EditBox.DecrementButton:ClearAllPoints()
        EditBox.DecrementButton:SetPoint("RIGHT", bg, "LEFT", 0, 0)

        Skin.SpinnerButton(EditBox.IncrementButton)
        Base.SetTexture(EditBox.IncrementButton._auroraTextures[1], "arrowRight")
        EditBox.IncrementButton:ClearAllPoints()
        EditBox.IncrementButton:SetPoint("LEFT", bg, "RIGHT", 0, 0)
    end
    function Skin.InputBoxInstructionsTemplate(EditBox)
        Skin.InputBoxTemplate(EditBox)
    end
    function Skin.SearchBoxTemplate(EditBox)
        Skin.InputBoxInstructionsTemplate(EditBox)
        EditBox.Instructions:SetTextColor(Color.gray:GetRGB())
        EditBox.searchIcon:SetPoint("LEFT", 3, -1)
    end
    function Skin.PanelTabButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetButtonColor(Color.frame, Util.GetFrameAlpha(), false)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 0,
            top = 0,
            bottom = 6,
        })

        Button.LeftActive:SetAlpha(0)
        Button.RightActive:SetAlpha(0)
        Button.MiddleActive:SetAlpha(0)
        Button.Left:SetAlpha(0)
        Button.Right:SetAlpha(0)
        Button.Middle:SetAlpha(0)

        Button.LeftHighlight:SetAlpha(0)
        Button.RightHighlight:SetAlpha(0)
        Button.MiddleHighlight:SetAlpha(0)

        local bg = Button:GetBackdropTexture("bg")
        Button.Text:ClearAllPoints()
        Button.Text:SetAllPoints(bg)

        Button._auroraTabResize = true
    end
    function Skin.PanelTopTabButtonTemplate(Button)
        Skin.PanelTabButtonTemplate(Button)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 0,
            top = 8,
            bottom = -5,
        })
    end
    function Skin.TabButtonTemplate(Button)
        Button.LeftDisabled:SetAlpha(0)
        Button.MiddleDisabled:SetAlpha(0)
        Button.RightDisabled:SetAlpha(0)
        Button.Left:SetAlpha(0)
        Button.Middle:SetAlpha(0)
        Button.Right:SetAlpha(0)

        Button.HighlightTexture:SetTexture("")
        Button._auroraTabResize = true
    end

    function Skin.MaximizeMinimizeButtonFrameTemplate(Frame)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local Button = Frame[name]
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 3,
                right = 4,
                top = 3,
                bottom = 4,
            })


            local bg = Button:GetBackdropTexture("bg")
            local line = Button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(1.2)
            line:SetStartPoint("TOPRIGHT", bg, -3, -3)
            line:SetEndPoint("BOTTOMLEFT", bg, 3, 3)

            local hline = Button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)

            local vline = Button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", bg, 1, -3)
                vline:SetPoint("RIGHT", bg, -3, 1)
            else
                hline:SetPoint("BOTTOM", bg, -1, 3)
                vline:SetPoint("LEFT", bg, 3, -1)
            end

            Button._auroraTextures = {
                line,
                hline,
                vline,
            }
        end
    end
    function Skin.ColumnDisplayTemplate(Frame)
        Frame.Background:Hide()
        Frame.TopTileStreaks:Hide()
    end
    function Skin.ColumnDisplayButtonShortTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.ColumnDisplayButtonNoScriptsTemplate(Button)
        Button.Left:Hide()
        Button.Right:Hide()
        Button.Middle:Hide()
    end
    function Skin.ColumnDisplayButtonTemplate(Button)
        Skin.ColumnDisplayButtonNoScriptsTemplate(Button)
    end
    function Skin.SquareIconButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })

        Button.Icon:SetPoint("CENTER", 0, 0)
    end
    function Skin.RefreshButtonTemplate(Button)
        Skin.SquareIconButtonTemplate(Button)
    end

    function Skin.ThreeSliceButtonTemplate(Button)
        Util.Mixin(Button, Hook.ThreeSliceButtonMixin)
        Button:HookScript("OnShow", Hook.ThreeSliceButtonMixin.UpdateButton)
        Button:HookScript("OnDisable", Hook.ThreeSliceButtonMixin.UpdateButton)
        Button:HookScript("OnEnable", Hook.ThreeSliceButtonMixin.UpdateButton)

        Skin.FrameTypeButton(Button)
    end
    function Skin.BigRedThreeSliceButtonTemplate(Button)
        Skin.ThreeSliceButtonTemplate(Button)
    end
    function Skin.SharedButtonLargeTemplate(Button)
        Skin.BigRedThreeSliceButtonTemplate(Button)
    end
    function Skin.SharedButtonSmallTemplate(Button)
        Skin.BigRedThreeSliceButtonTemplate(Button)
    end

    function Skin.IconSelectorPopupFrameTemplate(Frame)
        Skin.SelectionFrameTemplate(Frame.BorderBox)
        Skin.ScrollBoxSelectorTemplate(Frame.IconSelector)
    end
    function Skin.BottomPopupScrollBoxTemplate(Frame)
        Skin.FrameTypeFrame(Frame)

        local titleText = Frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", Frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        local name = Frame:GetName()
        _G[name.."Bg"]:Hide()
        _G[name.."TopLeftCorner"]:Hide()
        _G[name.."TopRightCorner"]:Hide()
        _G[name.."TopBorder"]:Hide()
        Frame.leftBorderBar:Hide()
        _G[name.."RightBorder"]:Hide()
        _G[name.."TopTileStreaks"]:Hide()
        _G[name.."TopLeftCorner2"]:Hide()
        _G[name.."TopRightCorner2"]:Hide()
        _G[name.."TopBorder2"]:Hide()

        Skin.UIPanelCloseButton(_G[name.."CloseButton"])
        Skin.WowScrollBoxList(Frame.ScrollBox)
        Skin.MinimalScrollBar(Frame.ScrollBar)
    end
    function Skin.SearchBoxListTemplate(Frame)
        Skin.SearchBoxTemplate(Frame)

        local searchPreview = Frame.searchPreviewContainer
        searchPreview:DisableDrawLayer("ARTWORK")
        Skin.FrameTypeFrame(searchPreview)
        --local searchPreviewBG = searchPreview:GetBackdropTexture("bg")
        --searchPreviewBG:SetPoint("BOTTOMRIGHT", searchBox.showAllResults, 0, 0)
        searchPreview.botLeftCorner:Hide()
        searchPreview.botRightCorner:Hide()
        searchPreview.bottomBorder:Hide()
        searchPreview.leftBorder:Hide()
        searchPreview.rightBorder:Hide()
        searchPreview.topBorder:Hide()
    end
    function Skin.SearchBoxListAllButtonTemplate(Button)
        Button:ClearNormalTexture()
        Button:ClearPushedTexture()

        local r, g, b = Color.highlight:GetRGB()
        Button.selectedTexture:SetColorTexture(r, g, b, 0.2)
    end
end

function private.SharedXML.SharedUIPanelTemplates()
    if private.isRetail then
        _G.hooksecurefunc("UIPanelCloseButton_SetBorderAtlas", Hook.UIPanelCloseButton_SetBorderAtlas)
    end
    Util.Mixin(_G.SquareIconButtonMixin, Hook.SquareIconButtonMixin)

    _G.hooksecurefunc("PanelTemplates_TabResize", Hook.PanelTemplates_TabResize)
    _G.hooksecurefunc("PanelTemplates_DeselectTab", Hook.PanelTemplates_DeselectTab)
    _G.hooksecurefunc("PanelTemplates_SelectTab", Hook.PanelTemplates_SelectTab)
end
