local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ SharedXML\ClassicTrimScrollBar.lua ]]
--end

do --[[ SharedXML\ClassicTrimScrollBar.xml ]]
    function Skin.WowClassicScrollBarThumbScripts(Frame)
        Skin.FrameTypeButton(Frame)
        Frame.thumbTexture:Hide()
    end
    function Skin.WowClassicScrollBar(EventFrame)
        Skin.VerticalScrollBarTemplate(EventFrame)

        local tex = EventFrame:GetRegions()
        tex:SetPoint("TOPLEFT", 0, 3)
        tex:SetPoint("BOTTOMRIGHT", 0, 0)

        EventFrame.Background:Hide()
        EventFrame.Track:SetPoint("TOPLEFT", 4, -17)
        EventFrame.Track:SetPoint("BOTTOMRIGHT", -4, 20)
        Skin.WowClassicScrollBarThumbScripts(EventFrame.Track.Thumb)

        Skin.WowTrimScrollBarStepperScripts(EventFrame.Back)
        EventFrame.Back:SetPoint("TOPLEFT", 4, 1)
        Skin.WowTrimScrollBarStepperScripts(EventFrame.Forward)
        EventFrame.Forward:SetPoint("BOTTOMLEFT", 4, 2)
    end
end

--function private.SharedXML.ClassicTrimScrollBar()
--end
