local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
-- local Skin =  Aurora.Skin
local Base = Aurora.Base
-- local Hook = Aurora.Hook
local Skin = Aurora.Skin
local Color = Aurora.Color

do --[[ Blizzard_Menu\DropdownButton.lua ]]
    do --[[ DropdownButton.lua ]]
        function Skin.DropdownButton(Frame, Width)
            -- local rightOfs = -105
            if not Frame then
                -- _G.print("Skin.DropdownButton - Frame is nil")
                return
            end
            if not Width then
                Width = 155
            end
            if Frame.Left then
                Frame.Left:SetAlpha(0)
            end
            if Frame.Middle then
                Frame.Middle:SetAlpha(0)
            end
            if Frame.Right then
                Frame.Right:SetAlpha(0)
            end
            Frame._auroraWidth = nil
            Base.SetBackdrop(Frame, Color.button)
            if Frame.Arrow then

                Frame.Background:SetTexture(nil)
                Frame:SetFrameLevel(Frame:GetFrameLevel() + 2)
                Frame.Arrow:SetAlpha(0)
                if Frame.TabHighlight then Frame.TabHighlight:SetAlpha(0) end
                local tex = Frame:CreateTexture(nil, "ARTWORK")
                tex:SetPoint("RIGHT", Frame, -3, 0)
                tex:SetTexture([[Interface\AddOns\Aurora\media\arrow-down-active]])
                tex:SetSize(13,13)
                return
            end
        end
    end
end


function private.BlizzAddOns.DropdownButton()

end
