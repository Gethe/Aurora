local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\GuildRegistrarFrame.lua ]]
--end

--do --[[ FrameXML\GuildRegistrarFrame.xml ]]
--end

function private.FrameXML.GuildRegistrarFrame()
    local GuildRegistrarFrame = _G.GuildRegistrarFrame
    local frameBG, _, _, artBG = GuildRegistrarFrame:GetRegions()

    GuildRegistrarFrame.Bg = frameBG -- Bg from ButtonFrameTemplate
    Skin.ButtonFrameTemplate(GuildRegistrarFrame)
    artBG:Hide()

    -- BlizzWTF: This should use the title text included in the template
    _G.GuildRegistrarFrameNpcNameText:SetAllPoints(_G.GuildRegistrarFrame.TitleContainer)
    Skin.MinimalScrollBar(GuildRegistrarFrame.ScrollBar)

    -------------------
    -- GreetingFrame --
    -------------------
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameGoodbyeButton)

    -------------------
    -- PurchaseFrame --
    -------------------
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFrameCancelButton)
    Skin.UIPanelButtonTemplate(_G.GuildRegistrarFramePurchaseButton)

    Skin.FrameTypeEditBox(_G.GuildRegistrarFrameEditBox)
    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    local _, _, left, right = _G.GuildRegistrarFrameEditBox:GetRegions()
    left:Hide()
    right:Hide()
end
