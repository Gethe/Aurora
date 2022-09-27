local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals wipe tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do --[[ FrameXML\CharacterFrame.lua ]]
    local CharTabtable = {}
    function Hook.CharacterFrame_TabBoundsCheck(self)
        wipe(CharTabtable)
		for i=1, 5 do
            if _G["CharacterFrameTab"..i]:IsShown() then
                tinsert(CharTabtable, _G["CharacterFrameTab"..i])
            end
		end

        local bg = _G.CharacterFrame:GetBackdropTexture("bg")
        Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", CharTabtable)
    end
end

--do --[[ FrameXML\CharacterFrame.xml ]]
--end

function private.FrameXML.CharacterFrame()
    _G.hooksecurefunc("CharacterFrame_TabBoundsCheck", Hook.CharacterFrame_TabBoundsCheck)

    local CharacterFrame = _G.CharacterFrame
    Skin.FrameTypeFrame(CharacterFrame)
    CharacterFrame:SetBackdropOption("offsets", {
        left = 14,
        right = 34,
        top = 14,
        bottom = 75,
    })

    local portrait = CharacterFrame:GetRegions()
    portrait:Hide()

    local bg = CharacterFrame:GetBackdropTexture("bg")
    _G.CharacterNameText:ClearAllPoints()
    _G.CharacterNameText:SetPoint("TOPLEFT", bg)
    _G.CharacterNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.UIPanelCloseButton(_G.CharacterFrameCloseButton)

    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab1)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab2)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab3)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab4)
    Skin.CharacterFrameTabButtonTemplate(_G.CharacterFrameTab5)
    Util.PositionRelative("TOPLEFT", bg, "BOTTOMLEFT", 20, -1, 1, "Right", {
        _G.CharacterFrameTab1,
        _G.CharacterFrameTab2,
        _G.CharacterFrameTab3,
        _G.CharacterFrameTab4,
        _G.CharacterFrameTab5,
    })
end
