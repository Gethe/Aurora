local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ AddOns\Blizzard_StaticPopup_Game\Mainline\StaticPopupSpecial.lua ]]
--end

--do --[[ AddOns\Blizzard_StaticPopup_Game\Mainline\StaticPopupSpecial.xml ]]
--end
-- FIXLATER

function private.AddOns.StaticPopupSpecial()
    if private.isRetail then
        local PetBattleQueueReadyFrame = _G.PetBattleQueueReadyFrame
        Skin.DialogBorderTemplate(PetBattleQueueReadyFrame.Border)
        Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.AcceptButton)
        Skin.UIPanelButtonTemplate(PetBattleQueueReadyFrame.DeclineButton)
    else
        local PlayerReportFrame = _G.PlayerReportFrame
        Skin.DialogBorderTemplate(PlayerReportFrame)

        local EditBox = PlayerReportFrame.Comment
        Base.CreateBackdrop(EditBox, private.backdrop, {
            tl = EditBox.TopLeft,
            tr = EditBox.TopRight,
            t = EditBox.Top,

            bl = EditBox.BottomLeft,
            br = EditBox.BottomRight,
            b = EditBox.Bottom,

            l = EditBox.Left,
            r = EditBox.Right,

            bg = EditBox.Middle
        })
        Skin.FrameTypeEditBox(EditBox)

        local scrollframe = EditBox.ScrollFrame
        Skin.UIPanelScrollFrameTemplate(scrollframe)

        scrollframe.ScrollBar:ClearAllPoints()
        scrollframe.ScrollBar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -18, -13)
        scrollframe.ScrollBar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -18, 13)

        scrollframe.ScrollBar.ScrollUpButton:SetPoint("BOTTOM", scrollframe.ScrollBar, "TOP")
        scrollframe.ScrollBar.ScrollDownButton:SetPoint("TOP", scrollframe.ScrollBar, "BOTTOM")

        Skin.UIPanelButtonTemplate(PlayerReportFrame.ReportButton)
        Skin.UIPanelButtonTemplate(PlayerReportFrame.CancelButton)
    end
end
