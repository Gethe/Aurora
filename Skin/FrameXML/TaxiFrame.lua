local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

function private.FrameXML.TaxiFrame()
    local TaxiFrame = _G.TaxiFrame
    if private.isRetail then
        local F = _G.unpack(Aurora)

        TaxiFrame:DisableDrawLayer("BORDER")
        TaxiFrame:DisableDrawLayer("OVERLAY")

        TaxiFrame.Bg:Hide()
        TaxiFrame.TitleBg:Hide()
        TaxiFrame.TopTileStreaks:Hide()

        F.SetBD(TaxiFrame, 3, -private.FRAME_TITLE_HEIGHT, -5, 3)

        F.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", _G.TaxiRouteMap, "TOPRIGHT", -6, -6)
    else
        Base.SetBackdrop(TaxiFrame)
        TaxiFrame:SetBackdropOption("offsets", {
            left = 14,
            right = 34,
            top = 14,
            bottom = 75,
        })

        local portrait, tl, tr, bl, br = TaxiFrame:GetRegions()
        portrait:Hide()
        tl:Hide()
        tr:Hide()
        bl:Hide()
        br:Hide()

        local bg = TaxiFrame:GetBackdropTexture("bg")
        _G.TaxiMerchant:ClearAllPoints()
        _G.TaxiMerchant:SetPoint("TOPLEFT", bg)
        _G.TaxiMerchant:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.UIPanelCloseButton(_G.TaxiCloseButton)
    end
end
