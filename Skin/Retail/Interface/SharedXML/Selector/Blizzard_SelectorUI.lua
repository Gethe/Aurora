local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ SharedXML\Selector\Blizzard_SelectorUI.lua ]]
--end

do --[[ SharedXML\Selector\Blizzard_SelectorUI.xml ]]
    function Skin.SelectorButtonTemplate(Button)
        local bg = Button:GetRegions()

        Base.CreateBackdrop(Button, {
            bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
            tile = false,
            offsets = {
                left = 1,
                right = 1,
                top = 1,
                bottom = 1,
            }
        }, {
            bg = bg
        })

        Base.CropIcon(bg)
        Button:SetBackdropColor(1, 1, 1, 0.75)
        Button:SetBackdropBorderColor(Color.frame, 1)

        local icon = Button.Icon
        icon:SetAllPoints()
        icon:SetPoint("TOPLEFT", bg, 1, -1)
        icon:SetPoint("BOTTOMRIGHT", bg, -1, 1)
        Base.CropIcon(icon)
    end
    function Skin.SelectorTemplate(Frame)
    end
end

function private.SharedXML.Blizzard_SelectorUI()
    ----====####$$$$%%%%$$$$####====----
    --              File              --
    ----====####$$$$%%%%$$$$####====----

    -------------
    -- Section --
    -------------
end
