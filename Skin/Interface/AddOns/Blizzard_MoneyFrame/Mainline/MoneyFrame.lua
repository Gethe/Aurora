local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals type floor mod

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\MoneyFrame.lua ]]
--end

do --[[ FrameXML\MoneyFrame.xml ]]
    Skin.SmallMoneyFrameTemplate = private.nop
    function Skin.SmallDenominationTemplate(Button)
        local name = Button:GetName()
        -- TAINT-SAFE: Only crop the icon texture coords; do NOT pass
        -- the Button as parent.  Base.CropIcon(texture, parent) creates
        -- a new texture on the parent and calls SetPoint, which taints
        -- the button's geometry.  MoneyFrame_Update then does arithmetic
        -- on GetTextWidth() + iconWidth, hitting "attempt to perform
        -- arithmetic on a secret number value".
        Base.CropIcon(_G[name.."Texture"])
    end
    function Skin.SmallAlternateCurrencyFrameTemplate(Frame)
        local name = Frame:GetName()
        Skin.SmallDenominationTemplate(_G[name.."Item1"])
        Skin.SmallDenominationTemplate(_G[name.."Item2"])
        Skin.SmallDenominationTemplate(_G[name.."Item3"])
    end
end

--function private.FrameXML.MoneyFrame()
--end
