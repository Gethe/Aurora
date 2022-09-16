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
    Quest = true,
    Socials = true,
    LFG = true,
    MainMenu = true,
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

--do --[[ MainMenuBarMicroButtons.lua ]]
--end

do --[[ MainMenuBarMicroButtons.xml ]]
    function Skin.MainMenuBarMicroButton(Button)
        Button:SetHitRectInsets(0, 5, 24, 0)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 0,
            right = 5,
            top = 24,
            bottom = 0,
        })

        local bg = Button:GetBackdropTexture("bg")
        Button.Flash:SetPoint("TOPLEFT", bg, 1, -1)
        Button.Flash:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        Button.Flash:SetTexCoord(.1818, .7879, .175, .875)
    end
    function Skin.MainMenuBarWatchBarTemplate(Frame)
        local StatusBar = Frame.StatusBar
        Skin.FrameTypeStatusBar(StatusBar)
        Base.SetBackdropColor(StatusBar, Color.frame)
        StatusBar:SetHeight(9)

        StatusBar.WatchBarTexture0:SetAlpha(0)
        StatusBar.WatchBarTexture1:SetAlpha(0)
        StatusBar.WatchBarTexture2:SetAlpha(0)
        StatusBar.WatchBarTexture3:SetAlpha(0)

        StatusBar.XPBarTexture0:SetAlpha(0)
        StatusBar.XPBarTexture1:SetAlpha(0)
        StatusBar.XPBarTexture2:SetAlpha(0)
        StatusBar.XPBarTexture3:SetAlpha(0)

        StatusBar.Background:Hide()

        Util.PositionBarTicks(StatusBar, 20, Color.frame)
        Frame.OverlayFrame.Text:SetPoint("CENTER")
    end
end

function private.FrameXML.MainMenuBarMicroButtons()
    ----====####$$$$%%%%%$$$$####====----
    --     MainMenuBarMicroButtons     --
    ----====####$$$$%%%%%$$$$####====----
    if not private.disabled.mainmenubar then
        _G.hooksecurefunc("UpdateMicroButtons", Hook.UpdateMicroButtons)

        for i, name in _G.ipairs(_G.MICRO_BUTTONS) do
            local button = _G[name]
            Skin.MainMenuBarMicroButton(button)
        end

        SetTexture(_G.MicroButtonPortrait, _G.CharacterMicroButton:GetBackdropTexture("bg"))
        SetMicroButton(_G.SpellbookMicroButton, [[Interface\Icons\INV_Misc_Book_09]])
        SetMicroButton(_G.TalentMicroButton, [[Interface\Icons\Ability_Marksmanship]])
        SetMicroButton(_G.QuestLogMicroButton, "Quest")
        SetMicroButton(_G.SocialsMicroButton, "Socials")
        if private.isBCC then
            SetMicroButton(_G.LFGMicroButton, "LFG")
        else
            SetMicroButton(_G.WorldMapMicroButton, [[Interface\WorldMap\WorldMap-Icon]], 0.21875, 0.6875, 0.109375, 0.8125)
        end
        SetMicroButton(_G.MainMenuMicroButton, "MainMenu")
        SetMicroButton(_G.HelpMicroButton, [[Interface\Icons\INV_Misc_QuestionMark]])

        Util.PositionRelative("BOTTOMLEFT", _G.MainMenuBarArtFrame, "BOTTOMLEFT", 552, 5, -2, "Right", {
            _G.CharacterMicroButton,
            _G.SpellbookMicroButton,
            _G.TalentMicroButton,
            _G.QuestLogMicroButton,
            _G.SocialsMicroButton,
            private.isBCC and _G.LFGMicroButton or _G.WorldMapMicroButton,
            _G.MainMenuMicroButton,
            _G.HelpMicroButton,
        })
    end
end
