local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\VehicleLeaveButton.lua ]]
--end

do --[[ FrameXML\VehicleLeaveButton.xml ]]
    function Skin.VehicleLeaveButton(Button)
        if not Button then return end

        -- Set up Aurora-style backdrop (grey background with border)
        Base.SetBackdrop(Button, Aurora.Color.button, Aurora.Color.frame.a)

        -- Hide the original wooden background textures completely
        local normalTex = Button:GetNormalTexture()
        if normalTex then
            normalTex:Hide()
        end

        local pushedTex = Button:GetPushedTexture()
        if pushedTex then
            pushedTex:Hide()
        end

        -- Create a simple text-based icon
        if not Button._auroraIconText then
            Button._auroraIconText = Button:CreateFontString(nil, "ARTWORK")
            Button._auroraIconText:SetFont([[Fonts\FRIZQT__.TTF]], 18, "OUTLINE")
            Button._auroraIconText:SetText("X")  -- Exit symbol
            Button._auroraIconText:SetTextColor(1, 0, 0)  -- Red color
            Button._auroraIconText:SetPoint("CENTER", Button, "CENTER", 0, 0)
        end

        -- Crop the highlight texture
        if Button.Highlight then
            Base.CropIcon(Button.Highlight)
        end
    end
end

function private.FrameXML.VehicleLeaveButton()
    local button = _G.MainMenuBarVehicleLeaveButton

    -- Try both possible paths
    if not button then
        button = _G.MainActionBar and _G.MainActionBar.VehicleLeaveButton
    end

    if button then
        Skin.VehicleLeaveButton(button)
    end
end
