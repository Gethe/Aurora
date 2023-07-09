local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

--do --[[ FrameXML\PetActionBar.lua ]]
--end

do --[[ FrameXML\PetActionBar.xml ]]
    function Skin.PetActionButtonTemplate(CheckButton)
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
        --Base.CropIcon(_G[name.."NormalTexture2"])
    end
end

--function private.FrameXML.PetActionBar()
--end
