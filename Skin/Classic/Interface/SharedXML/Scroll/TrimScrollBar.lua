local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

--do --[[ SharedXML\TrimScrollBar.lua ]]
--end

do --[[ SharedXML\TrimScrollBar.xml ]]
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

        local tex = EventFrame.Backplate
        tex:SetPoint("TOPLEFT", 4, -20)
        tex:SetPoint("BOTTOMRIGHT", -3, 21)

        EventFrame.Background:Hide()
        EventFrame.Track:SetAllPoints(tex)
        Skin.WowTrimScrollBarThumbScripts(EventFrame.Track.Thumb)

        Skin.WowTrimScrollBarStepperScripts(EventFrame.Back)
        EventFrame.Back:SetPoint("TOPLEFT", 4, -2)
        Skin.WowTrimScrollBarStepperScripts(EventFrame.Forward)
        EventFrame.Forward:SetPoint("BOTTOMLEFT", 4, 2)
    end
end

--function private.SharedXML.TrimScrollBar()
--end
