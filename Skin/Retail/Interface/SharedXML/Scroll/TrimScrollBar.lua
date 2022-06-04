local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ FrameXML\TrimScrollBar.lua ]]
--end

do --[[ FrameXML\TrimScrollBar.xml ]]
    function Skin.WowTrimScrollBarStepperScripts(Frame)
        Skin.FrameTypeButton(Frame)
        Frame.Texture:Hide()
        Frame.Overlay:SetAlpha(0)

        local bg = Frame:GetBackdropTexture("bg")
        local arrow = Frame:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", bg, 3, -5)
        arrow:SetPoint("BOTTOMRIGHT", bg, -3, 5)
        if Frame.direction < 0 then
            Base.SetTexture(arrow, "arrowUp")
        else
            Base.SetTexture(arrow, "arrowDown")
        end
        Frame._auroraTextures = {arrow}
    end
    function Skin.WowTrimScrollBarThumbScripts(Frame)
        Skin.FrameTypeButton(Frame)
        Frame.Begin:Hide()
        Frame.End:Hide()
        Frame.Middle:Hide()
    end

    function Skin.WowTrimScrollBar(EventFrame)
        Skin.VerticalScrollBarTemplate(EventFrame)

        local tex = EventFrame:GetRegions()
        tex:SetPoint("TOPLEFT", 0, 3)
        tex:SetPoint("BOTTOMRIGHT", 0, 0)

        EventFrame.Background:Hide()
        EventFrame.Track:SetPoint("TOPLEFT", 4, -17)
        EventFrame.Track:SetPoint("BOTTOMRIGHT", -4, 20)
        Skin.WowTrimScrollBarThumbScripts(EventFrame.Track.Thumb)

        Skin.WowTrimScrollBarStepperScripts(EventFrame.Back)
        EventFrame.Back:SetPoint("TOPLEFT", 4, 1)
        Skin.WowTrimScrollBarStepperScripts(EventFrame.Forward)
        EventFrame.Forward:SetPoint("BOTTOMLEFT", 4, 2)
    end
end

--function private.SharedXML.TrimScrollBar()
--end
