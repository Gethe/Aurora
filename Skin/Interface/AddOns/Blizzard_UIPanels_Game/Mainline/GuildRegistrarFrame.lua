local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\GuildRegistrarFrame.lua ]]
--end

--do --[[ FrameXML\GuildRegistrarFrame.xml ]]
--end

function private.FrameXML.GuildRegistrarFrame()
    local GuildRegistrarFrame = _G.GuildRegistrarFrame
    if private.isRetail then
        local frameBG, _, _, artBG = GuildRegistrarFrame:GetRegions()

        GuildRegistrarFrame.Bg = frameBG -- Bg from ButtonFrameTemplate
        Skin.ButtonFrameTemplate(GuildRegistrarFrame)
        artBG:Hide()

        -- BlizzWTF: This should use the title text included in the template
        _G.GuildRegistrarFrameNpcNameText:SetAllPoints(_G.GuildRegistrarFrame.TitleContainer)
        Skin.MinimalScrollBar(GuildRegistrarFrame.ScrollBar)
    else
        Skin.FrameTypeFrame(GuildRegistrarFrame)
        GuildRegistrarFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = GuildRegistrarFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        local bg = GuildRegistrarFrame:GetBackdropTexture("bg")
        _G.GuildRegistrarFrameNpcNameText:ClearAllPoints()
        _G.GuildRegistrarFrameNpcNameText:SetPoint("TOPLEFT", bg)
        _G.GuildRegistrarFrameNpcNameText:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

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
