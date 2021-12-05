local _, private = ...
if not private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\LootHistory.lua ]]
    function Hook.LootHistoryFrame_UpdateItemFrame(self, frame)
        local rollID, _, _, isDone, winnerIdx = _G.C_LootHistory.GetItem(frame.itemIdx)
        local expanded = self.expandedRolls[rollID]

        if not frame.styled then
            frame.Divider:Hide()
            frame.NameBorderLeft:Hide()
            frame.NameBorderRight:Hide()
            frame.NameBorderMid:Hide()
            frame.IconBorder:Hide()

            frame.WinnerRoll:SetTextColor(.9, .9, .9)
            frame.bg = Skin.CropIcon(frame.Icon, frame)

            Skin.ExpandOrCollapse(frame.ToggleButton)
            frame.styled = true
        end

        if isDone and not expanded and winnerIdx then
            local name, class = _G.C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
            if name then
                local colour = _G.CUSTOM_CLASS_COLORS[class]
                frame.WinnerName:SetVertexColor(colour.r, colour.g, colour.b)
            end
        end

        frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())
    end
    function Hook.LootHistoryFrame_UpdatePlayerFrame(self, playerFrame)
        if not playerFrame.styled then
            playerFrame.RollText:SetTextColor(.9, .9, .9)
            playerFrame.WinMark:SetDesaturated(true)

            playerFrame.styled = true
        end

        if playerFrame.playerIdx then
            local name, class, _, _, isWinner = _G.C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

            if name then
                local colour = _G.CUSTOM_CLASS_COLORS[class]
                playerFrame.PlayerName:SetTextColor(colour.r, colour.g, colour.b)

                if isWinner then
                    playerFrame.WinMark:SetVertexColor(colour.r, colour.g, colour.b)
                end
            end
        end
    end
end

--do --[[ FrameXML\LootHistory.xml ]]
--end

function private.FrameXML.LootHistory()
    _G.hooksecurefunc("LootHistoryFrame_UpdateItemFrame", Hook.LootHistoryFrame_UpdateItemFrame)
    _G.hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", Hook.LootHistoryFrame_UpdatePlayerFrame)

    local LootHistoryFrame = _G.LootHistoryFrame
    Skin.TooltipBackdropTemplate(LootHistoryFrame)

    LootHistoryFrame.LootIcon:Hide()
    LootHistoryFrame.Label:ClearAllPoints()
    LootHistoryFrame.Label:SetPoint("TOP", LootHistoryFrame, "TOP", 0, -8)
    LootHistoryFrame.Divider:SetAlpha(0)

    Skin.MinimizeButton(LootHistoryFrame.CloseButton)
    do -- [[ Resize button ]]
        LootHistoryFrame.ResizeButton:SetNormalTexture("")
        LootHistoryFrame.ResizeButton:SetHeight(8)

        local line1 = LootHistoryFrame.ResizeButton:CreateTexture()
        line1:SetColorTexture(1, 1, 1)
        line1:SetSize(30, 1)
        line1:SetPoint("TOP")

        local line2 = LootHistoryFrame.ResizeButton:CreateTexture()
        line2:SetColorTexture(1, 1, 1)
        line2:SetSize(30, 1)
        line2:SetPoint("TOP", 0, -3)

        LootHistoryFrame.ResizeButton:HookScript("OnEnter", function(self)
            line1:SetVertexColor(Color.highlight:GetRGB())
            line2:SetVertexColor(Color.highlight:GetRGB())
        end)

        LootHistoryFrame.ResizeButton:HookScript("OnLeave", function(self)
            line1:SetVertexColor(1, 1, 1)
            line2:SetVertexColor(1, 1, 1)
        end)
    end
    Skin.UIPanelScrollFrameTemplate(LootHistoryFrame.ScrollFrame)

    -- [[ Dropdown ]]
    _G.LootHistoryDropDown.initialize = function(self)
        local info = _G.UIDropDownMenu_CreateInfo()
        info.isTitle = 1
        info.text = _G.MASTER_LOOTER
        info.fontObject = _G.GameFontNormalLeft
        info.notCheckable = 1
        _G.UIDropDownMenu_AddButton(info)

        info = _G.UIDropDownMenu_CreateInfo()
        info.notCheckable = 1
        local name, class = _G.C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
        local colorStr = _G.CUSTOM_CLASS_COLORS[class].colorStr
        info.text = _G.MASTER_LOOTER_GIVE_TO:format(colorStr..name.."|r")
        info.func = _G.LootHistoryDropDown_OnClick
        _G.UIDropDownMenu_AddButton(info)
    end
end
