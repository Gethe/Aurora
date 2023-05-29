local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals floor max ipairs select

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

local function SetTexture(texture, anchor, left, right, top, bottom)
    if left then
        texture:SetTexCoord(left, right, top, bottom)
    end
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", anchor, 1, -1)
    texture:SetPoint("BOTTOMRIGHT", anchor, -1, 1)
end

local microButtonPrefix = [[Interface\Buttons\UI-MicroButton-]]
local microButtonNames = {
    Achievement = true,
    Quest = true,
    LFG = true,
    Socials = true,
}
local function SetMicroButton(button, file, left, right, top, bottom)
    local bg = button:GetBackdropTexture("bg")

    if microButtonNames[file] then
        left, right, top, bottom = 0.1875, 0.8125, 0.46875, 0.90625

        button:SetNormalTexture(microButtonPrefix..file.."-Up")
        SetTexture(button:GetNormalTexture(), bg, left, right, top, bottom)

        button:SetPushedTexture(microButtonPrefix..file.."-Down")
        SetTexture(button:GetPushedTexture(), bg, left, right, top, bottom)

        button:SetDisabledTexture(microButtonPrefix..file.."-Disabled")
        SetTexture(button:GetDisabledTexture(), bg, left, right, top, bottom)
    else
        if not left then
            left, right, top, bottom = 0.2, 0.8, 0.08, 0.92
        end

        button:SetNormalTexture(file)
        SetTexture(button:GetNormalTexture(), bg, left, right - 0.04, top + 0.04, bottom)

        button:SetPushedTexture(file)
        button:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5)
        SetTexture(button:GetPushedTexture(), bg, left + 0.04, right, top, bottom - 0.04)

        button:SetDisabledTexture(file)
        button:GetDisabledTexture():SetDesaturated(true)
        SetTexture(button:GetDisabledTexture(), bg, left, right, top, bottom)
    end
end

do --[[ FrameXML\ActionBarController.lua ]]
    do --[[ MainMenuBarMicroButtons.lua ]]
        local anchors = {
            MicroButtonAndBagsBar = 11
        }
        function Hook.MoveMicroButtons(anchor, anchorTo, relAnchor, x, y, isStacked)
            _G.CharacterMicroButton:ClearAllPoints()
            _G.CharacterMicroButton:SetPoint(anchor, anchorTo, relAnchor, _G[anchors[anchorTo]], y)
            _G.LFDMicroButton:ClearAllPoints()
            if isStacked then
                _G.LFDMicroButton:SetPoint("TOPLEFT", _G.CharacterMicroButton, "BOTTOMLEFT", 0, -1)
            else
                _G.LFDMicroButton:SetPoint("BOTTOMLEFT", _G.GuildMicroButton, "BOTTOMRIGHT", 1, 0)
            end
        end

        Hook.GuildMicroButtonMixin = {}
        function Hook.GuildMicroButtonMixin:UpdateTabard(forceUpdate)
            local emblemFilename = select(10, _G.GetGuildLogoInfo())
            if emblemFilename then
                self:ClearNormalTexture()
                self:ClearPushedTexture()
                self:ClearDisabledTexture()
            else
                SetMicroButton(self, "Socials")
            end
        end

        local status
        Hook.MainMenuMicroButtonMixin = {}
        function Hook.MainMenuMicroButtonMixin:OnUpdate(elapsed)
            if self.updateInterval == _G.PERFORMANCEBAR_UPDATE_INTERVAL then
                --print("OnUpdate", self.updateInterval)
                status = _G.GetFileStreamingStatus()
                if status == 0 then
                    status = _G.GetBackgroundLoadingStatus() ~= 0 and 1 or 0
                end

                if status == 0 then
                    SetMicroButton(self, [[Interface\Icons\INV_Misc_QuestionMark]])
                else
                    self:ClearNormalTexture()
                    self:ClearPushedTexture()
                    self:ClearDisabledTexture()
                end
            end
        end
    end
    do --[[ StatusTrackingManager.lua ]]
        Hook.StatusTrackingManagerMixin = {}
        function Hook.StatusTrackingManagerMixin:UpdateBarTicks()
            for i, barContainer in ipairs(self.barContainers) do
                local shownBar = barContainer.bars[barContainer.shownBarIndex];
                if shownBar then
                    Util.PositionBarTicks(shownBar.StatusBar, 10, Color.frame)
                end
            end
        end
    end
    do --[[ ExpBar.xml ]]
        Hook.ExhaustionTickMixin = {}
        function Hook.ExhaustionTickMixin:UpdateTickPosition()
            if self:IsShown() then
                local playerCurrXP = _G.UnitXP("player")
                local playerMaxXP = _G.UnitXPMax("player")
                local exhaustionThreshold = _G.GetXPExhaustion()
                local exhaustionStateID = _G.GetRestState()

                local parent = self:GetParent()
                if exhaustionStateID and exhaustionStateID >= 3 then
                    self.Normal:SetPoint("LEFT", parent , "RIGHT", 0, 0)
                end

                if exhaustionThreshold then
                    local parentWidth = parent:GetWidth()
                    local exhaustionTickSet = max(((playerCurrXP + exhaustionThreshold) / playerMaxXP) * parentWidth, 0)
                    exhaustionTickSet = _G.Round(exhaustionTickSet - 1)
                    if exhaustionTickSet < parentWidth then
                        self.Normal:SetPoint("LEFT", parent, "LEFT", exhaustionTickSet, 0)
                    end
                end
            end
        end
    end
    do --[[ MainMenuBar.lua ]]
        function Hook.MainMenuTrackingBar_Configure(frame, isOnTop)
            if isOnTop then
                frame.StatusBar:SetHeight(7)
            else
                frame.StatusBar:SetHeight(9)
            end
        end
        function Hook.UpdateMicroButtons()
            if _G.UnitLevel("player") >= _G.SHOW_SPEC_LEVEL then
                _G.QuestLogMicroButton:SetPoint("BOTTOMLEFT", _G.TalentMicroButton, "BOTTOMRIGHT", 2, 0);
            end
        end
    end
end

do --[[ FrameXML\ActionBarController.xml ]]
    do --[[ MainMenuBarMicroButtons.xml ]]
        function Skin.MainMenuBarMicroButton(Button)
            Button:SetHitRectInsets(2, 2, 1, 1)
            Skin.FrameTypeButton(Button)
            Button:SetBackdropOption("offsets", {
                left = 2,
                right = 2,
                top = 1,
                bottom = 1,
            })

            local bg = Button:GetBackdropTexture("bg")
            Button.Flash:SetPoint("TOPLEFT", bg, 1, -1)
            Button.Flash:SetPoint("BOTTOMRIGHT", bg, -1, 1)
            Button.Flash:SetTexCoord(.1818, .7879, .175, .875)
        end
        function Skin.MicroButtonAlertTemplate(Frame)
            Skin.GlowBoxTemplate(Frame)
            Skin.UIPanelCloseButton(Frame.CloseButton)
            Skin.GlowBoxArrowTemplate(Frame.Arrow)
        end
        function Skin.MainMenuBarWatchBarTemplate(Frame)
            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)
            StatusBar:SetHeight(9)

            StatusBar.WatchBarTexture0:SetAlpha(0)
            StatusBar.WatchBarTexture1:SetAlpha(0)
            StatusBar.WatchBarTexture2:SetAlpha(0)
            StatusBar.WatchBarTexture3:SetAlpha(0)

            StatusBar.XPBarTexture0:SetAlpha(0)
            StatusBar.XPBarTexture1:SetAlpha(0)
            StatusBar.XPBarTexture2:SetAlpha(0)
            StatusBar.XPBarTexture3:SetAlpha(0)

            Util.PositionBarTicks(StatusBar, 20)
            Frame.OverlayFrame.Text:SetPoint("CENTER")
        end
    end
    do --[[ StatusTrackingBarTemplate.xml ]]
        local statusBarMap = {
            "ReputationStatusBarTemplate",
            "HonorStatusBarTemplate",
            "ArtifactStatusBarTemplate",
            "ExpStatusBarTemplate",
            "AzeriteBarTemplate",
        }
        function Skin.StatusTrackingBarTemplate(Frame)
            _G.hooksecurefunc(Frame, "Hide", function(self)
                Util.ReleaseBarTicks(self.StatusBar)
            end)

            local StatusBar = Frame.StatusBar
            Skin.FrameTypeStatusBar(StatusBar)
            Base.SetBackdropColor(StatusBar, Color.frame)

            StatusBar.Background:Hide()
            StatusBar.Underlay:Hide()
            StatusBar.Overlay:Hide()
        end
        function Skin.StatusTrackingBarContainerTemplate(Frame)
            Frame.BarFrameTexture:Hide()
            for i, bar in ipairs(Frame.bars) do
                Skin[statusBarMap[i]](bar)
            end
        end
    end
    do --[[ ExpBar.xml ]]
        function Skin.ExpStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
            Frame.ExhaustionLevelFillBar:SetPoint("BOTTOMLEFT")

            --[[
            ]]
            local tick = Frame.ExhaustionTick
            Util.Mixin(tick, Hook.ExhaustionTickMixin)
            local texture = tick.Normal
            texture:SetColorTexture(Color.white:GetRGB())
            texture:ClearAllPoints()
            texture:SetPoint("TOP", Frame)
            texture:SetPoint("BOTTOM", Frame)
            texture:SetWidth(2)

            local diamond = tick:CreateTexture(nil, "BORDER")
            diamond:SetPoint("BOTTOMLEFT", texture, "TOPLEFT", -3, -1)
            diamond:SetSize(9, 9)
            Base.SetTexture(diamond, "shapeDiamond")

            local highlight = tick.Highlight
            highlight:ClearAllPoints()
            highlight:SetPoint("TOPLEFT", diamond, -2, 2)
            highlight:SetPoint("BOTTOMRIGHT", diamond, 2, -2)
            Base.SetTexture(highlight, "shapeDiamond")
        end
    end
    do --[[ ReputationBar.xml ]]
        function Skin.ReputationStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ AzeriteBar.xml ]]
        function Skin.AzeriteBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ ArtifactBar.xml ]]
        function Skin.ArtifactStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ HonorBar.xml ]]
        function Skin.HonorStatusBarTemplate(Frame)
            Skin.StatusTrackingBarTemplate(Frame)
        end
    end
    do --[[ ActionButtonTemplate.xml ]]
        function Skin.ActionButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon)

            CheckButton.Flash:SetColorTexture(1, 0, 0, 0.5)
            CheckButton.NewActionTexture:SetAllPoints()
            CheckButton.NewActionTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            CheckButton.SpellHighlightTexture:SetAllPoints()
            CheckButton.SpellHighlightTexture:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            CheckButton.AutoCastable:SetAllPoints()
            CheckButton.AutoCastable:SetTexCoord(0.21875, 0.765625, 0.21875, 0.765625)
            CheckButton.AutoCastShine:ClearAllPoints()
            CheckButton.AutoCastShine:SetPoint("TOPLEFT", 2, -2)
            CheckButton.AutoCastShine:SetPoint("BOTTOMRIGHT", -2, 2)

            CheckButton:ClearNormalTexture()
            Base.CropIcon(CheckButton:GetPushedTexture())
            Base.CropIcon(CheckButton:GetHighlightTexture())
            Base.CropIcon(CheckButton:GetCheckedTexture())
        end
        function Skin.ActionBarButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        end
    end
    do --[[ ActionBarTemplate.xml ]]
        function Skin.ActionBarTemplate(Frame)
        end
        function Skin.EditModeActionBarTemplate(Frame)
            Skin.ActionBarTemplate(Frame)
        end
    end
    do --[[ MultiActionBars.xml ]]
        function Skin.MultiBarButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)
            Base.SetBackdrop(CheckButton, Color.frame, 0.2)
            CheckButton:SetBackdropOption("offsets", {
                left = -1,
                right = -1,
                top = -1,
                bottom = -1,
            })

            _G[CheckButton:GetName().."FloatingBG"]:SetTexture("")
        end
        Skin.MultiBar1ButtonTemplate = Skin.MultiBarButtonTemplate
        Skin.MultiBar2ButtonTemplate = Skin.MultiBarButtonTemplate
        function Skin.MultiBar2ButtonNoBackgroundTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))
        end
        Skin.MultiBar3ButtonTemplate = Skin.MultiBarButtonTemplate
        Skin.MultiBar4ButtonTemplate = Skin.MultiBarButtonTemplate

        function Skin.HorizontalMultiBar1(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar1ButtonTemplate(_G[name..i])
            end
        end
        function Skin.HorizontalMultiBar2(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 6 do
                Skin.MultiBar2ButtonNoBackgroundTemplate(_G[name..i])
            end
            for i = 7, 12 do
                Skin.MultiBar2ButtonTemplate(_G[name..i])
            end
        end
        function Skin.VerticalMultiBar3(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar3ButtonTemplate(_G[name..i])
            end
        end
        function Skin.VerticalMultiBar4(Frame)
            local name = Frame:GetName().."Button"
            for i = 1, 12 do
                Skin.MultiBar4ButtonTemplate(_G[name..i])
            end
        end
    end
    do --[[ StanceBar.xml ]]
        function Skin.StanceButtonTemplate(CheckButton)
            Skin.ActionButtonTemplate(CheckButton)

            Base.CreateBackdrop(CheckButton, {
                bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                tile = false,
                offsets = {
                    left = -1,
                    right = -1,
                    top = -1,
                    bottom = -1,
                }
            })
            CheckButton:SetBackdropColor(1, 1, 1, 0.75)
            CheckButton:SetBackdropBorderColor(Color.frame:GetRGB())
            Base.CropIcon(CheckButton:GetBackdropTexture("bg"))

            local name = CheckButton:GetName()
            _G[name.."NormalTexture2"]:Hide()
        end
    end
    do --[[ ExtraActionBar.xml ]]
        -- /run ActionButton_StartFlash(ExtraActionButton1)
        function Skin.ExtraActionButtonTemplate(CheckButton)
            Base.CropIcon(CheckButton.icon, CheckButton)

            CheckButton.HotKey:SetPoint("TOPLEFT", 5, -5)
            CheckButton.Count:SetPoint("TOPLEFT", -5, 5)
            CheckButton.style:Hide()

            CheckButton.cooldown:SetPoint("TOPLEFT")
            CheckButton.cooldown:SetPoint("BOTTOMRIGHT")

            CheckButton:ClearNormalTexture()
            Base.CropIcon(CheckButton:GetHighlightTexture())
            if not private.isPatch then
                Base.CropIcon(CheckButton:GetCheckedTexture())
            end
        end
    end
end

function private.FrameXML.ActionBarController()
    ----====####$$$$%%%%%$$$$####====----
    --     MainMenuBarMicroButtons     --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --    StatusTrackingBarTemplate    --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --             ExpBar             --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --          ReputationBar          --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --           AzeriteBar           --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --           ArtifactBar           --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --            HonorBar            --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --       ActionBarConstants       --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --          ActionButton          --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --      ActionButtonOverrides      --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --      ActionButtonTemplate      --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --        ActionBarTemplate        --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --         MultiActionBars         --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --           MainMenuBar           --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        local MainMenuBar = _G.MainMenuBar
        MainMenuBar.BorderArt:SetAlpha(0)
        MainMenuBar.Background:SetAlpha(0)
        MainMenuBar.EndCaps:SetAlpha(0)
    end

    ----====####$$$$%%%%%$$$$####====----
    --     CustomActionBarOverlays     --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --        StatusTrackingBar        --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        Util.Mixin(_G.StatusTrackingBarManager, Hook.StatusTrackingManagerMixin)
        Skin.StatusTrackingBarContainerTemplate(_G.MainStatusTrackingBarContainer)
        Skin.StatusTrackingBarContainerTemplate(_G.SecondaryStatusTrackingBarContainer)
    end

    ----====####$$$$%%%%%$$$$####====----
    --        OverrideActionBar        --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --            StanceBar            --
    ----====####$$$$%%%%%$$$$####====----

    ----====####$$$$%%%%$$$$####====----
    --         ExtraActionBar         --
    ----====####$$$$%%%%$$$$####====----
    Skin.ExtraActionButtonTemplate(_G.ExtraActionButton1)

    ----====####$$$$%%%%$$$$####====----
    --        PossessActionBar        --
    ----====####$$$$%%%%$$$$####====----

    ----====####$$$$%%%%%$$$$####====----
    --       ActionBarController       --
    ----====####$$$$%%%%%$$$$####====----
end
