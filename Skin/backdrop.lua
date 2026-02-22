local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals type next error
local MergeTable = _G.MergeTable -- From TableUtil.lua

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Color, Util = Aurora.Color, Aurora.Util

local backdrop = {
    -- Blizzard options
    bgFile = private.textures.plain,
    tile = false,
    tileEdge = false,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    edgeFile = private.textures.plain,
    edgeSize = 1,

    -- Custom options
    offsets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    backdropLayer = "BACKGROUND",
    backdropSubLevel = -8,
    backdropBorderLayer = "BACKGROUND",
    backdropBorderSubLevel = -7,
}
private.backdrop = backdrop

local function GetColor(red, green, blue, alpha)
    local a
    if type(red) == "table" then
        a = green
        red, green, blue, alpha = red:GetRGBA()
    end
    return Color.Create(red, green, blue, a or alpha)
end
local function CopyBackdrop(bdOptions)
    return {
        bgFile = bdOptions.bgFile,
        tile = bdOptions.tile,
        tileEdge = bdOptions.tileEdge,
        insets = {
            left = bdOptions.insets.left,
            right = bdOptions.insets.right,
            top = bdOptions.insets.top,
            bottom = bdOptions.insets.bottom,
        },
        edgeFile = bdOptions.edgeFile,
        edgeSize = bdOptions.edgeSize,

        offsets = {
            left = bdOptions.offsets.left,
            right = bdOptions.offsets.right,
            top = bdOptions.offsets.top,
            bottom = bdOptions.offsets.bottom,
        },
        backdropLayer = bdOptions.backdropLayer,
        backdropSubLevel = bdOptions.backdropSubLevel,
        backdropBorderLayer = bdOptions.backdropBorderLayer,
        backdropBorderSubLevel = bdOptions.backdropBorderSubLevel,
    }
end
local function SanitizeTable(optionDB, parentDB)
    for option, value in next, parentDB do
        if type(value) == "table" then
            optionDB[option] = SanitizeTable(optionDB[option] or {}, value)
        else
            if optionDB[option] == nil then
                optionDB[option] = parentDB[option]
            end
        end
    end

    return optionDB
end

local bgTextures = {}
for new, old in next, Util.NineSliceTextures do
    bgTextures[old] = new
end

local function IsForbiddenFrame(frame)
    if not frame or not frame.IsForbidden then
        return false
    end

    local ok, isForbidden = _G.pcall(function()
        return frame:IsForbidden()
    end)
    return ok and isForbidden
end

local function SafeFrameName(frame)
    if not frame then
        return "<nil>"
    end

    local ok, debugName = _G.pcall(function()
        return frame.GetDebugName and frame:GetDebugName()
    end)
    if ok and type(debugName) == "string" and debugName ~= "" then
        return debugName
    end

    local okName, name = _G.pcall(function()
        return frame.GetName and frame:GetName()
    end)
    if okName and type(name) == "string" and name ~= "" then
        return name
    end

    return "<frame>"
end


-- Blizzard methods
local BackdropMixin do
    BackdropMixin = _G.Mixin({}, _G.BackdropTemplateMixin)
    local function GetNineSliceLayout(frame)
        local backdropInfo = frame.backdropInfo

        local x, y, x1, y1 = 0, 0, 0, 0
        if backdropInfo.bgFile then
            local edgeSize = frame:GetEdgeSize()
            x = -edgeSize
            y = edgeSize
            x1 = edgeSize
            y1 = -edgeSize
            local insets = backdropInfo.insets
            if insets then
                x = x + (insets.left or 0)
                y = y - (insets.top or 0)
                x1 = x1 - (insets.right or 0)
                y1 = y1 + (insets.bottom or 0)
            end
        end

        local left, right, top, bottom = 0, 0, 0, 0
        local offsets = backdropInfo.offsets
        if offsets then
            left, right, top, bottom = (offsets.left or left), (offsets.right or right), (offsets.top or top), (offsets.bottom or bottom)
        end
        if frame.debug then
            private.debug("GetNineSliceLayout", frame:GetDebugName(), frame.debug)
            private.debug("  offsets:", left, right, top, bottom)
            if Aurora.debug then
                _G.error("Found usage")
            end
        end

        return {
            TopLeftCorner = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
                x = left, y = -top
            },
            TopRightCorner =    {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
                x = -right, y = -top
            },
            BottomLeftCorner =  {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
                x = left, y = bottom
            },
            BottomRightCorner = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
                x = -right, y = bottom
            },
            TopEdge = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
            },
            BottomEdge = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
            },
            LeftEdge = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
            },
            RightEdge = {
                layer = backdropInfo.backdropBorderLayer,
                subLevel = backdropInfo.backdropBorderSubLevel,
            },
            Center = {
                layer = backdropInfo.backdropLayer,
                subLevel = backdropInfo.backdropSubLevel,
                x = x, y = y,
                x1 = x1, y1 = y1,
            },
            disableSharpening = true,
            setupPieceVisualsFunction = BackdropMixin.SetupPieceVisuals,
        }
    end

    function BackdropMixin:OnBackdropLoaded()
        return _G.BackdropTemplateMixin.OnBackdropLoaded(self)
    end
    function BackdropMixin:SetupPieceVisuals(piece, setupInfo, pieceLayout, textureKit, userLayout)
        if self.debug then
            private.debug("SetupPieceVisuals", piece:GetDebugName(),self.debug)
            private.debug("  ", setupInfo.pieceName, ":")
            private.debug("      size:", piece:GetSize())
            if pieceLayout.x then
                private.debug("      x, y:", pieceLayout.x, pieceLayout.y)
            end
            if pieceLayout.x1 then
                private.debug("      x1, y1:", pieceLayout.x1, pieceLayout.y1)
            end
            --_G.error("Found usage")
        end
        _G.BackdropTemplateMixin.SetupPieceVisuals(self, piece, setupInfo, pieceLayout, textureKit, userLayout)
    end
    function BackdropMixin:ApplyBackdrop()
        local userLayout = GetNineSliceLayout(self)
        _G.NineSliceUtil.ApplyLayout(self, userLayout, "AuroraSkin")
        if self.debug then
            _G.print("ApplyBackdrop", self:GetDebugName(), self.debug)
        end
        for old, pieceName in next, bgTextures do
            local pieceLayout = userLayout[pieceName]
            local piece = Util.GetNineSlicePiece(self, pieceName)
            if piece then
                if self.debug then
                    private.debug("  ", pieceName, ":")
                    private.debug("      size:", piece:GetSize())
                    if pieceLayout.x then
                        private.debug("      x, y:", pieceLayout.x, pieceLayout.y)
                    end
                    if pieceLayout.x1 then
                        private.debug("      x1, y1:", pieceLayout.x1, pieceLayout.y1)
                    end
                    --_G.error("Found usage")
                end

                if pieceLayout.layer then
                    piece:SetDrawLayer(pieceLayout.layer, pieceLayout.subLevel)
                end

                -- Blizzard's NineSlice SetupEdge hardcodes tileHorizontal/tileVertical=true
                -- on edge pieces; disable it to prevent seam lines at non-integer UI scales.
                piece:SetHorizTile(false)
                piece:SetVertTile(false)
                piece:Show()
            end
        end

        local backdropInfo = self.backdropInfo
        if Base.IsTextureRegistered(backdropInfo.bgFile) then
            Base.SetTexture(Util.GetNineSlicePiece(self, "Center"), backdropInfo.bgFile)
        end

        local r, g, b, a = 1, 1, 1, 1
        if backdropInfo.backdropColor then
            r, g, b, a = backdropInfo.backdropColor:GetRGBA()
        end
        self:SetBackdropColor(r, g, b, a)


        r, g, b, a = 1, 1, 1, 1
        if backdropInfo.backdropBorderColor then
            r, g, b, a = backdropInfo.backdropBorderColor:GetRGBA()
        end
        self:SetBackdropBorderColor(r, g, b, a)
        if _G.canaccesssecrets(self) then
            self:SetupTextureCoordinates()
        end
    end


    function BackdropMixin:SetBackdrop(backdropInfo, textures)
        if self.debug then
            _G.print("BackdropMixin:SetBackdrop", self.debug, backdropInfo, self.backdropInfo, self._backdropInfo)
        end

        if IsForbiddenFrame(self) then
            return
        end

        if backdropInfo == true then
            backdropInfo = self._backdropInfo
        end

        if self.backdropInfo then
            if backdropInfo then
                backdropInfo = self.backdropInfo
            end
        end

        if textures and backdropInfo then
            for textureName, texture in next, textures do
                if bgTextures[textureName] then
                    textureName = bgTextures[textureName]
                end

                if not self[textureName] then
                    self[textureName] = texture
                end
            end
        end

        local ok, result = _G.pcall(_G.BackdropTemplateMixin.SetBackdrop, self, backdropInfo)
        if not ok then
            private.debug("BackdropMixin:SetBackdrop failed", SafeFrameName(self), result)
            return
        end
        return result
    end
    function BackdropMixin:SetBackdropColor(red, green, blue, alpha)
        if not self.backdropInfo then return end
        self.backdropInfo.backdropColor = GetColor(red, green, blue, alpha)

        local center = Util.GetNineSlicePiece(self, "Center")
        if center then
            center:SetVertexColor(self.backdropInfo.backdropColor:GetRGBA())
        end
        --return _G.BackdropTemplateMixin.SetBackdropColor(self, self.backdropInfo.backdropColor:GetRGBA())
    end
    function BackdropMixin:GetBackdropColor()
        if not self.backdropInfo then return end
        return self.backdropInfo.backdropColor:GetRGBA()
    end
    function BackdropMixin:SetBackdropBorderColor(red, green, blue, alpha)
        if not self.backdropInfo then return end

        local backdropBorderColor = GetColor(red, green, blue, alpha)
        for _, pieceName in next, bgTextures do
            if pieceName ~= "Center" then
                local region = Util.GetNineSlicePiece(self, pieceName)
                if region then
                    region:SetVertexColor(backdropBorderColor:GetRGBA());
                end
            end
        end

        self.backdropInfo.backdropBorderColor = backdropBorderColor
        --return _G.BackdropTemplateMixin.SetBackdropBorderColor(self, self.backdropInfo.backdropBorderColor:GetRGBA())
    end
    function BackdropMixin:GetBackdropBorderColor()
        if not self.backdropInfo then return end
        return self.backdropInfo.backdropBorderColor:GetRGBA()
    end

    -- Custom Methods
    function BackdropMixin:SetBackdropGradient(red, green, blue, alpha)
        if not self.backdropInfo then return end

        if red then
            self.backdropInfo.backdropColor = GetColor(red, green, blue, alpha)
        end
        self:SetBackdropOption("bgFile", "gradientUp")
    end
    function BackdropMixin:SetBackdropLayer(layer, sublevel)
        if not self.backdropInfo then return end

        self.backdropInfo.backdropLayer = layer
        self.backdropInfo.backdropSubLevel = sublevel
        self.backdropInfo.backdropBorderLayer = layer
        self.backdropInfo.backdropBorderSubLevel = sublevel + 1
        self:ApplyBackdrop()
    end
    function BackdropMixin:GetBackdropLayer()
        if self.backdropInfo then
            return self.backdropInfo.backdropLayer, self.backdropInfo.backdropSubLevel
        end
    end
    function BackdropMixin:GetBackdropTexture(texture)
        if not self.backdropInfo then return end

        if bgTextures[texture] then
            texture = bgTextures[texture]
        end

        return (Util.GetNineSlicePiece(self, texture))
    end
    function BackdropMixin:SetBackdropOption(optionKey, optionValue, skipApply)
        if self.backdropInfo then
            local options = self.backdropInfo
            if type(options[optionKey]) == "table" then
                MergeTable(options[optionKey], optionValue)
            else
                if options[optionKey] ~= optionValue then
                    options[optionKey] = optionValue
                end
            end

            if not skipApply then
                self:ApplyBackdrop()
            end
        end
    end
    function BackdropMixin:GetBackdropOption(optionKey)
        if self.backdropInfo then
            local options = self.backdropInfo
            return options[optionKey]
        end
    end
    function BackdropMixin:SetBackdropOptions(options)
        if self.backdropInfo then
            for optionKey, optionValue in next, options do
                self:SetBackdropOption(optionKey, optionValue, true)
            end
            self:ApplyBackdrop()
        end
    end
end

function Base.CreateBackdrop(frame, options, textures)
    if not frame or IsForbiddenFrame(frame) then
        return
    end

    for name, func in next, BackdropMixin do
        frame[name] = func
    end

    local backdropInfo
    if options == backdrop then
        backdropInfo = CopyBackdrop(options)
    else
        backdropInfo = SanitizeTable(options, backdrop)
    end

    frame._backdropInfo = backdropInfo
    if frame.backdropInfo then
        frame.backdropInfo = nil
    end
    frame:SetBackdrop(backdropInfo, textures)
end

function Base.SetBackdrop(frame, color, alpha)
    if frame.debug then
        _G.print("Base.SetBackdrop", frame.debug)
    end
    Base.CreateBackdrop(frame, frame._backdropInfo or backdrop)
    Base.SetBackdropColor(frame, color, alpha)
end
function Base.SetBackdropColor(frame, color, alpha)
    if not color then color = Color.frame end
    if type(color) ~= "table" and color.r then error("`color` must be a Color object. See Color.Create") end
    if frame.debug then
        private.debug("Base.SetBackdropColor", frame.debug)
    end

    frame:SetBackdropColor(Color.Lightness(color, -0.3), alpha or color.a)
    frame:SetBackdropBorderColor(color, 1)
end
