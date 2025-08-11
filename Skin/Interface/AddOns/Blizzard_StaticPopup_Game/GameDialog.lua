local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals tinsert max

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ AddOns\Blizzard_StaticPopup_Game\GameDialog.lua ]]
--end

do --[[ AddOns\Blizzard_StaticPopup_Game\GameDialog.lua ]]
    function Skin.StaticPopupButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
    end

    local function CloseButton_SetNormalTexture(Button, texture)
        if Button._setNormal then return end
        Button._setNormal = true
        Button:ClearNormalTexture()
        if texture:find("Hide") then
            Button._auroraTextures[1]:Hide()
            Button._auroraTextures[2]:Hide()
            Button._auroraTextures[3]:Show()
        else
            Button._auroraTextures[1]:Show()
            Button._auroraTextures[2]:Show()
            Button._auroraTextures[3]:Hide()
        end
        Button._setNormal = nil
    end
    local function CloseButton_SetPushedTexture(Button, texture)
        if Button._setPushed then return end
        Button._setPushed = true
        Button:ClearPushedTexture()
        Button._setPushed = nil
    end
    function Skin.StaticPopupTemplate(Frame)
        if ((not Frame) and private.isDev) then
            _G.print("ReportError: Frame is nil in StaticPopupTemplate - Report to Aurora developers.")
            return
        end
        -- FIXLATER?
        local name = Frame:GetName()
        local background = Frame.BG
        -- background.Top:SetTexture("")
        background.Bottom:SetTexture("")
        -- Skin.DialogBorderTemplate(border)

        local ButtonContainer = Frame.ButtonContainer
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button1)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button2)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button3)
        Skin.StaticPopupButtonTemplate(ButtonContainer.Button4)

        Skin.StaticPopupButtonTemplate(Frame.ExtraButton)
        Skin.StaticPopupButtonTemplate(Frame.CloseButton)
        -- _G.hooksecurefunc(close, "SetNormalTexture", CloseButton_SetNormalTexture)
        -- _G.hooksecurefunc(close, "SetPushedTexture", CloseButton_SetPushedTexture)

        local Buttons = ButtonContainer.Buttons
        for i = 1, #Buttons do
            local Button = _G[name .. "Button" .. i]
            Skin.StaticPopupButtonTemplate(Buttons[i])
        end


        -- local EditBox = _G[name .. "EditBox"]
        -- EditBox.Left = _G[name .. "EditBoxLeft"]
        -- EditBox.Right = _G[name .. "EditBoxRight"]
        -- EditBox.Middle = _G[name .. "EditBoxMid"]
        -- Skin.InputBoxTemplate(EditBox) -- BlizzWTF: this should use InputBoxTemplate

        Skin.SmallMoneyFrameTemplate(Frame.MoneyFrame)
        Skin.MoneyInputFrameTemplate(Frame.MoneyInputFrame)

        local ItemFrame = Frame.ItemFrame
        local nameFrame = ItemFrame.NameFrame
        nameFrame:Hide()

        Skin.FrameTypeItemButton(ItemFrame.Item)

        local nameBG = _G.CreateFrame("Frame", nil, ItemFrame)
        nameBG:SetPoint("TOPLEFT", ItemFrame.icon, "TOPRIGHT", 2, 1)
        nameBG:SetPoint("BOTTOMLEFT", ItemFrame.icon, "BOTTOMRIGHT", 2, -1)
        nameBG:SetPoint("RIGHT", 120, 0)
        Base.SetBackdrop(nameBG, Color.frame)
    end
end

function private.FrameXML.Blizzard_StaticPopup_Game_GameDialog()
    -- FIXLATER it is moved in 11.2?
    _G.print("Skinning StaticPopup1")
    Skin.StaticPopupTemplate(_G.StaticPopup1)

    -- Skin.StaticPopupTemplate(_G.StaticPopup2)
    -- Skin.StaticPopupTemplate(_G.StaticPopup3)
    -- Skin.StaticPopupTemplate(_G.StaticPopup4)
end

