local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util


do -- Frame
    function Skin.FrameTypeFrame(Frame)
        Base.SetBackdrop(Frame, Color.frame, Util.GetFrameAlpha())
    end
end


do -- Button
    local function SetTexturesToColor(self, color)
        if self._auroraTextures then
            for _, texture in next, self._auroraTextures do
                texture:SetVertexColor(color:GetRGB())
            end
        end
    end
    local function MinimalOnEnter(self, highlight, alpha)
        SetTexturesToColor(self, highlight)
    end
    local function MinimalOnLeave(self, returnColor)
        SetTexturesToColor(self, returnColor)
    end


    local DISABLED_COLOR = Color.Lightness(Color.button, -0.3)
    local function Hook_Enable(self)
        if self._isMinimal then
            SetTexturesToColor(self, self._enabledColor)
        else
            Base.SetBackdropColor(self, self._enabledColor)
            SetTexturesToColor(self, Color.white)
        end
    end
    local function Hook_Disable(self)
        if self._isMinimal then
            SetTexturesToColor(self, self._disabledColor)
        else
            Base.SetBackdropColor(self, self._disabledColor)
            SetTexturesToColor(self, Color.gray)
        end
    end
    local function Hook_SetEnabled(self, enabledState)
        if enabledState then
            Hook_Enable(self)
        else
            Hook_Disable(self)
        end
    end
    function Skin.FrameTypeButton(Button, OnEnter, OnLeave)
        _G.hooksecurefunc(Button, "Enable", Hook_Enable)
        _G.hooksecurefunc(Button, "Disable", Hook_Disable)
        _G.hooksecurefunc(Button, "SetEnabled", Hook_SetEnabled)

        if Button.ClearNormalTexture then
            Button:ClearNormalTexture()
            Button:ClearPushedTexture()
            Button:ClearDisabledTexture()

            local highlight = Button:GetHighlightTexture()
            if highlight then
                highlight:Hide()
            end
        else
            Button:SetNormalTexture("")
            Button:SetPushedTexture("")
            Button:SetHighlightTexture("")
            Button:SetDisabledTexture("")
        end

        function Button:SetButtonColor(color, alpha, disabledColor)
            local r, g, b, a, _
            if Button._isMinimal then
                r, g, b = color:GetRGB()
            else
                Base.SetBackdrop(self, color, alpha)
                _, _, _, a = self:GetBackdropColor()
                r, g, b = self:GetBackdropBorderColor()
            end


            self._enabledColor = Color.Create(r, g, b, alpha or a)

            if disabledColor == false then
                self._disabledColor = self._enabledColor
            else
                if disabledColor then
                    self._disabledColor = disabledColor
                else
                    self._disabledColor = Color.Lightness(self._enabledColor, -0.3)
                end
            end

            Hook_SetEnabled(self, self:IsEnabled())
        end
        function Button:GetButtonColor()
            return self._enabledColor, self._disabledColor
        end

        if Button._isMinimal then
            Button:SetButtonColor(Color.grayLight, 1, Color.gray)
            Base.SetHighlight(Button, MinimalOnEnter, MinimalOnLeave)
        else
            Button:SetButtonColor(Color.button, nil, DISABLED_COLOR)
            Base.SetHighlight(Button, OnEnter, OnLeave)
        end
    end
end


do -- CheckButton
    function Skin.FrameTypeCheckButton(CheckButton)
        if CheckButton.ClearNormalTexture then
            CheckButton:ClearNormalTexture()
            CheckButton:ClearPushedTexture()
            CheckButton:ClearHighlightTexture()
        else
            CheckButton:SetNormalTexture("")
            CheckButton:SetPushedTexture("")
            CheckButton:SetHighlightTexture("")
        end

        Base.SetBackdrop(CheckButton, Color.button, 0.3)
        Base.SetHighlight(CheckButton)
    end
end


do -- EditBox
    function Skin.FrameTypeEditBox(EditBox)
        Base.SetBackdrop(EditBox, Color.frame)
        EditBox:SetBackdropBorderColor(Color.button)
    end
end


do -- StatusBar
    local function Hook_SetStatusBarTexture(self, asset)
        if self.__SetStatusBarTexture then return end
        self.__SetStatusBarTexture = true
        local color = private.assetColors[asset]
        local color2 = private.assetColors[asset.."_2"]

        if color then
            local texture = self:GetStatusBarTexture()
            texture:SetTexture(private.textures.plain)
            if color2 then
                if texture.SetGradientAlpha then
                    local r, g, b = color:GetRGB()
                    local r2, g2, b2 = color2:GetRGB()
                    texture:SetGradient("VERTICAL", r, g, b, r2, g2, b2)
                else
                    texture:SetGradient("VERTICAL", color, color2)
                end
            else
                texture:SetVertexColor(color:GetRGB())
            end
        else
            private.debug("Missing color for status bar asset:", asset, self:GetDebugName())
        end

        self.__SetStatusBarTexture = nil
    end
    local function Hook_SetStatusBarColor(self, r, g, b)
        self:GetStatusBarTexture():SetVertexColor(r, g, b)
    end
    function Skin.FrameTypeStatusBar(StatusBar)
        if StatusBar.SetStatusBarAtlas then
            _G.hooksecurefunc(StatusBar, "SetStatusBarAtlas", Hook_SetStatusBarTexture)
        else
            _G.hooksecurefunc(StatusBar, "SetStatusBarTexture", Hook_SetStatusBarTexture)
        end
        _G.hooksecurefunc(StatusBar, "SetStatusBarColor", Hook_SetStatusBarColor)

        Base.SetBackdrop(StatusBar, Color.button, Color.frame.a)
        StatusBar:SetBackdropOption("offsets", {
            left = -1,
            right = -2,
            top = -1,
            bottom = -1,
        })

        local red, green, blue = StatusBar:GetStatusBarColor()
        local tex = StatusBar:GetStatusBarTexture()

        local asset
        if tex then
            asset = tex:GetAtlas()
            if not asset then
                asset = tex:GetTexture()
            end
        else
            StatusBar:SetStatusBarTexture(private.textures.plain)
            tex = StatusBar:GetStatusBarTexture()
        end

        Base.SetTexture(tex, "gradientUp")
        if asset and private.assetColors[asset] then
            Hook_SetStatusBarTexture(StatusBar, asset)
        else
            Hook_SetStatusBarColor(StatusBar, red, green, blue)
        end
    end
end


do -- ScrollBar
    local function Hook_Hide(self)
        self._auroraThumb:Hide()
    end
    local function Hook_Show(self)
        self._auroraThumb:Show()
    end
    local function ScrollBarThumb(ScrollThumb)
        local thumb
        if ScrollThumb.Middle then
            ScrollThumb.Middle:SetAlpha(0)
            ScrollThumb.Begin:SetAlpha(0)
            ScrollThumb.End:SetAlpha(0)

            thumb = ScrollThumb
        else
            ScrollThumb:SetAlpha(0)
            ScrollThumb:SetSize(16, 24)

            thumb = _G.CreateFrame("Frame", nil, ScrollThumb:GetParent())
            thumb:SetPoint("TOPLEFT", ScrollThumb)
            thumb:SetPoint("BOTTOMRIGHT", ScrollThumb)
        end

        Base.SetBackdrop(thumb, Color.button)
        thumb:SetShown(ScrollThumb:IsShown())
        thumb:SetBackdropOption("offsets", {
            left = 0,
            right = 0,
            top = 2,
            bottom = 2,
        })
        ScrollThumb._auroraThumb = thumb

        _G.hooksecurefunc(ScrollThumb, "Hide", Hook_Hide)
        _G.hooksecurefunc(ScrollThumb, "Show", Hook_Show)
    end

    local function UpdateTexture(self)
        local tex = self._auroraTextures[1]
        local texAnchor = self
        local length, width = 14, 6
        local xOffset, yOffset = 2, 4
        if not self._isMinimal then
            texAnchor = self:GetBackdropTexture("bg")
        end

        local isDecrement = self.direction == _G.ScrollControllerMixin.Directions.Decrease
        self:SetSize(18, 16)
        tex:ClearAllPoints()
        if self.isHorizontal then
            tex:SetSize(width, length)
            if isDecrement then
                tex:SetPoint("BOTTOMRIGHT", texAnchor, -yOffset, xOffset)
                Base.SetTexture(tex, "arrowLeft")
            else
                tex:SetPoint("BOTTOMLEFT", texAnchor, yOffset, xOffset)
                Base.SetTexture(tex, "arrowRight")
            end
        else
            tex:SetSize(length, width)
            if isDecrement then
                tex:SetPoint("BOTTOMLEFT", texAnchor, xOffset, yOffset)
                Base.SetTexture(tex, "arrowUp")
            else
                tex:SetPoint("TOPLEFT", texAnchor, xOffset, -yOffset)
                Base.SetTexture(tex, "arrowDown")
            end
        end
    end
    local function ScrollBarButton(Button, notMinimal)
        Button._isMinimal = not notMinimal
        Skin.FrameTypeButton(Button)

        local tex = Button:GetRegions()
        if Button.direction then
            Button._auroraTextures = {tex}
            if Button.UpdateAtlas then
                _G.hooksecurefunc(Button, "UpdateAtlas", UpdateTexture)
                Button:HookScript("OnDisable", UpdateTexture)
            else
                Button:HookScript("OnShow", UpdateTexture)
            end

            UpdateTexture(Button)
        else
            tex:Hide()
        end
    end

    function Skin.FrameTypeScrollBar(ScrollBar, notMinimal)
        local back = ScrollBar.ScrollUpButton or ScrollBar.Back
        ScrollBarButton(back, notMinimal)

        local forward = ScrollBar.ScrollDownButton or ScrollBar.Forward
        ScrollBarButton(forward, notMinimal)

        local thumb = ScrollBar.ThumbTexture or ScrollBar.Track.Thumb
        ScrollBarThumb(thumb)
    end
end
