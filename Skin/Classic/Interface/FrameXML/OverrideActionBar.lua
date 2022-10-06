local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ FrameXML\OverrideActionBar.lua ]]
    -- 534043 - Default
    function Hook.OverrideActionBar_SetSkin(skin)
        print("OverrideActionBar_SetSkin", skin)
        local OverrideActionBar = _G.OverrideActionBar
        OverrideActionBar.Divider2:SetColorTexture(1, 1, 1)
        OverrideActionBar.Divider3:SetColorTexture(1, 1, 1)
    end
    function Hook.OverrideActionBar_CalcSize()
        print("OverrideActionBar_CalcSize", OverrideActionBar.HasExit, OverrideActionBar.HasPitch)
        local OverrideActionBar = _G.OverrideActionBar
        local width, xpWidth, anchor, buttonAnchor;

        if OverrideActionBar.HasExit and OverrideActionBar.HasPitch then
            width, xpWidth, anchor, buttonAnchor = 1020, 580, 103, -234;
        elseif OverrideActionBar.HasPitch then
            width, xpWidth, anchor, buttonAnchor = 945, 500, 145, -192;
        elseif OverrideActionBar.HasExit then
            width, xpWidth, anchor, buttonAnchor = 930, 490, 60, -277;
        else
            width, xpWidth, anchor, buttonAnchor = 860, 460, 100, -237;
        end

        OverrideActionBar.Divider2:SetPoint("BOTTOM", anchor, 13)
        Util.PositionBarTicks(OverrideActionBar.xpBar, 20, Color.frame)
    end
end

--do --[[ FrameXML\OverrideActionBar.xml ]]
--end

function private.FrameXML.OverrideActionBar()
    _G.hooksecurefunc("OverrideActionBar_SetSkin", Hook.OverrideActionBar_SetSkin)
    _G.hooksecurefunc("OverrideActionBar_CalcSize", Hook.OverrideActionBar_CalcSize)

    local OverrideActionBar = _G.OverrideActionBar
    OverrideActionBar.EndCapL:Hide()
    OverrideActionBar.EndCapR:Hide()

    OverrideActionBar.Divider2:SetSize(1, 59)
 
    OverrideActionBar._BG:Hide()
    OverrideActionBar.MicroBGL:Hide()
    OverrideActionBar._MicroBGMid:Hide()
    OverrideActionBar.MicroBGR:Hide()
    OverrideActionBar.ButtonBGR:Hide()
    OverrideActionBar._ButtonBGMid:Hide()
    OverrideActionBar.ButtonBGL:Hide()
    OverrideActionBar._Border:Hide()

    local leaveFrame = OverrideActionBar.leaveFrame
    leaveFrame:ClearAllPoints()
    leaveFrame:SetPoint("BOTTOMRIGHT", -98, 0)
    leaveFrame.Divider3:ClearAllPoints()
    leaveFrame.Divider3:SetPoint("BOTTOMLEFT", -24, 13)
    leaveFrame.Divider3:SetSize(1, 59)
    leaveFrame.ExitBG:Hide()
    leaveFrame.LeaveButton:ClearAllPoints()
    leaveFrame.LeaveButton:SetPoint("CENTER", leaveFrame.Divider3, "RIGHT", 39, 0)

    local xpBar = OverrideActionBar.xpBar
    Skin.FrameTypeStatusBar(xpBar)
    Base.SetBackdropColor(xpBar, Color.frame, 0)
    xpBar:SetHeight(10)
    xpBar.XpMid:Hide()
    xpBar.XpL:Hide()
    xpBar.XpR:Hide()
    for i = 1, 19 do
        xpBar["XpDiv"..i]:Hide()
    end

    local healthBar = OverrideActionBar.healthBar
    Skin.FrameTypeStatusBar(healthBar)
    healthBar.HealthBarBG:Hide()
    healthBar.HealthBarOverlay:Hide()

    local powerBar = OverrideActionBar.powerBar
    Skin.FrameTypeStatusBar(powerBar)
    powerBar.PowerBarBG:Hide()
    powerBar.PowerBarOverlay:Hide()
end
