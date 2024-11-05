local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin =  Aurora.Skin
-- local Base = Aurora.Base
-- local Hook, Skin = Aurora.Hook, Aurora.Skin
-- local Color = Aurora.Color
do --[[ Blizzard_Menu\DropdownButton.lua ]]
    do --[[ DropdownButton.lua ]]
        function Skin.DropdownButton(Frame, Width)
            _G.print("Skin.DropdownButton")
            -- if not Width then
            --     Width = 155
            -- end
            -- if Frame.Arrow then
            --     Frame.Arrow:SetAlpha(0)
            -- end
            -- if Frame.Left then
            --     Frame.Left:SetAlpha(0)
            -- end
            -- if Frame.Middle then
            --     Frame.Middle:SetAlpha(0)
            -- end
            -- if Frame.Right then
            --     Frame.Right:SetAlpha(0)
            -- end
            -- Frame.backdrop:Point('TOPLEFT', 0, -2)
            -- Frame.backdrop:Point('BOTTOMRIGHT', 0, 2)
            local tex = Frame:CreateTexture(nil, 'ARTWORK')
            tex:SetTexture([[Interface\AddOns\Aurora\media\arrow-down-active]])
            tex:SetRotation(3.14)
            -- tex:Point('RIGHT', Frame.backdrop, -3, 0)
            -- tex:Size(14)
        end
    end
end


function private.BlizzAddOns.DropdownButton()

end
