local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\RaidFrame.lua ]]
--end

do --[[ FrameXML\RaidFrame.xml ]]
    function Skin.RaidInfoHeaderTemplate(Frame)
        Frame:DisableDrawLayer("BACKGROUND")
    end
end

function private.FrameXML.RaidFrame()
    Skin.UICheckButtonTemplate(_G.RaidFrameAllAssistCheckButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameConvertToRaidButton)
    Skin.UIPanelButtonTemplate(_G.RaidFrameRaidInfoButton)

    -------------------
    -- RaidInfoFrame --
    -------------------
    Skin.DialogBorderDarkTemplate(_G.RaidInfoFrame)
    _G.RaidInfoFrame:SetPoint("TOPLEFT", _G.RaidFrame, "TOPRIGHT", 1, -28)
    local bg = _G.RaidInfoFrame:GetBackdropTexture("bg")

    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailCorner:Hide()
    _G.RaidInfoFrameHeader:Hide()
    _G.RaidInfoHeader:ClearAllPoints()
    _G.RaidInfoHeader:SetPoint("TOPLEFT", bg)
    _G.RaidInfoHeader:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

    Skin.RaidInfoHeaderTemplate(_G.RaidInfoInstanceLabel)
    Skin.RaidInfoHeaderTemplate(_G.RaidInfoIDLabel)
    Skin.UIPanelCloseButton(_G.RaidInfoCloseButton)
    Skin.UIPanelScrollFrameTemplate(_G.RaidInfoScrollFrame)
    _G.RaidInfoScrollFrameTop:Hide()
    _G.RaidInfoScrollFrameBottom:Hide()
    Skin.UIPanelButtonTemplate(_G.RaidInfoCancelButton)
end
