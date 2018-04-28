local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\GameTooltip.lua ]]
    function Hook.GameTooltip_OnHide(gametooltip)
        Base.SetBackdropColor(gametooltip)
    end
end

do --[[ SharedXML\GameTooltipTemplate.xml ]]
    function Skin.GameTooltipTemplate(GameTooltip)
        Base.SetBackdrop(GameTooltip)

        -- BlizzWTF: the global name for this frame conflicts with ReputationParagonTooltipStatusBar
        local status = GameTooltip:GetChildren()
        status:SetHeight(4)
        status:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 1, 0)
        status:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 0)
        Base.SetTexture(status:GetStatusBarTexture(), "gradientUp")

        local statusBG = status:CreateTexture(nil, "BACKGROUND")
        statusBG:SetColorTexture(0, 0, 0)
        statusBG:SetPoint("TOPLEFT", -1, 1)
        statusBG:SetPoint("BOTTOMRIGHT", 1, -1)
    end
    function Skin.ShoppingTooltipTemplate(GameTooltip)
        Base.SetBackdrop(GameTooltip)
    end
    function Skin.TooltipStatusBarTemplate(StatusBar)
    end
    function Skin.TooltipProgressBarTemplate(Frame)
        local bar = Frame.Bar
        Base.SetBackdrop(bar, Color.frame)
        bar:SetBackdropBorderColor(Color.button)

        local texture = bar:GetStatusBarTexture()
        Base.SetTexture(texture, "gradientUp")
        texture:SetDrawLayer("BORDER")

        bar.BorderLeft:Hide()
        bar.BorderRight:Hide()
        bar.BorderMid:Hide()

        local LeftDivider = bar.LeftDivider
        LeftDivider:SetColorTexture(Color.button:GetRGB())
        LeftDivider:SetSize(1, 15)
        LeftDivider:SetPoint("LEFT", 73, 0)

        local RightDivider = bar.RightDivider
        RightDivider:SetColorTexture(Color.button:GetRGB())
        RightDivider:SetSize(1, 15)
        RightDivider:SetPoint("RIGHT", -73, 0)

        _G.select(7, bar:GetRegions()):Hide()
    end
end

do --[[ FrameXML\GameTooltip.xml ]]
    function Skin.EmbeddedItemTooltip(Frame)
        Base.CropIcon(Frame.Icon)
        local bg = _G.CreateFrame("Frame", nil, Frame)
        bg:SetPoint("TOPLEFT", Frame.Icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", Frame.Icon, 1, -1)
        Base.SetBackdrop(bg, Color.black, 0)
        Frame._auroraIconBorder = bg
    end
end

function private.FrameXML.GameTooltip()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("GameTooltip_OnHide", Hook.GameTooltip_OnHide)

    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip2)
    Skin.GameTooltipTemplate(_G.GameTooltip)
end
