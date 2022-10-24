local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ SharedXML\NineSlice.lua ]]
    local nineSliceSetup = {
        "TopLeftCorner",
        "TopRightCorner",
        "BottomLeftCorner",
        "BottomRightCorner",
        "TopEdge",
        "BottomEdge",
        "LeftEdge",
        "RightEdge",
        "Center",
    }

    local function BasicFrame(Frame, kit)
        Skin.FrameTypeFrame(Frame)
        Base.SetBackdropColor(Frame, kit.backdrop, Util.GetFrameAlpha())
    end

    local layouts = {
        Dialog = function(Frame, kit)
            BasicFrame(Frame, kit)
            Frame:SetBackdropOption("offsets", {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
            })
        end,
        ChatBubble = BasicFrame,
        GMChatRequest = BasicFrame,
        TooltipDefaultLayout = BasicFrame,
        TooltipGluesLayout = BasicFrame,
        TooltipMixedLayout = BasicFrame,
        UniqueCornersLayout = BasicFrame,
        IdenticalCornersLayout = BasicFrame,
    }

    local function GetNameforLayout(userLayout)
        for layoutName, layout in next, _G.NineSliceLayouts do
            if layout == userLayout then
                return layoutName
            end
        end
    end

    Hook.NineSliceUtil = {}
    function Hook.NineSliceUtil.ApplyLayout(container, userLayout, textureKit)
        if not container._auroraNineSlice then return end
        if container._applyLayout then return end

        container._applyLayout = true
        local userLayoutName = container:GetFrameLayoutType()
        if not userLayoutName then
            userLayoutName = GetNameforLayout(userLayout)
        end

        if container.debug then
            _G.print("ApplyLayout", container.debug, userLayout, userLayoutName, textureKit)
            if not userLayoutName and not textureKit then
                _G.error("Found usage")
            end
        end

        if layouts[userLayoutName] then
            if container.debug then
                private.debug("Apply layout with textureKit", userLayoutName)
            end
            layouts[userLayoutName](container, Util.GetTextureKit(textureKit))
        else
            if userLayoutName then
                private.debug("Missing skin for nineslice layout", userLayoutName)
            elseif private.isDev then
                _G.print("Missing name for nineslice layout:", container:GetDebugName())
            end

            if not container.SetBackdropOption then return end
            container:SetBackdrop(private.backdrop)
            for i = 1, #nineSliceSetup do
                local piece = Util.GetNineSlicePiece(container, nineSliceSetup[i])
                if piece then
                    piece:SetTexture("")
                end
            end
        end
        container._applyLayout = false
    end
end

function private.SharedXML.NineSlice()
    Util.Mixin(_G.NineSliceUtil, Hook.NineSliceUtil)
end
