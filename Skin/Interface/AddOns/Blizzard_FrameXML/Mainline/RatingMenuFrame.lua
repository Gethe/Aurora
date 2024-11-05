local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\RatingMenuFrame.lua ]]
--end

--do --[[ FrameXML\RatingMenuFrame.xml ]]
--end

function private.FrameXML.RatingMenuFrame()
    local RatingMenuFrame = _G.RatingMenuFrame
    if private.isRetail then
        Skin.DialogBorderTemplate(RatingMenuFrame.Border)
        Skin.DialogHeaderTemplate(RatingMenuFrame.Header)
        Skin.UIPanelButtonTemplate(_G.RatingMenuButtonOkay)
    else
        Skin.DialogBorderTemplate(RatingMenuFrame)

        _G.RatingMenuFrameHeader:Hide()
        _G.RatingMenuFrameText:ClearAllPoints()
        _G.RatingMenuFrameText:SetPoint("TOPLEFT")
        _G.RatingMenuFrameText:SetPoint("BOTTOMRIGHT", _G.RatingMenuFrame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        Skin.OptionsButtonTemplate(_G.RatingMenuButtonOkay)
    end
end