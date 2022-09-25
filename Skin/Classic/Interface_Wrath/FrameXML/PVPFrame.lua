local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local Util = Aurora.Util

--do --[[ FrameXML\PVPFrame.lua ]]
--end

--do --[[ FrameXML\PVPFrame.xml ]]
--end

function private.FrameXML.PVPFrame()
    Skin.UIPanelCloseButton(_G.PVPParentFrame.CloseButton)

    local PVPFrame = _G.PVPFrame
    Skin.FrameTypeFrame(PVPFrame)
    PVPFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local bg = PVPFrame:GetBackdropTexture("bg")
    local portrait, _, topLeft, topRight, bottomLeft, bottomRight, background = PVPFrame:GetRegions()
    portrait:Hide()
    topLeft:Hide()
    topRight:Hide()
    bottomLeft:Hide()
    bottomRight:Hide()
    background:Hide()

    Skin.CharacterFrameTabButtonTemplate(_G.PVPParentFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.PVPParentFrameTab2)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.PVPParentFrameTab1,
        _G.PVPParentFrameTab2,
    })
end
