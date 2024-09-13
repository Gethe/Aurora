local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\UnitPopupCustomControls.lua ]]
--end

do --[[ FrameXML\UnitPopupCustomControls.xml ]]
    function Skin.UnitPopupVoiceToggleButtonTemplate(Button)
        Skin.VoiceToggleButtonTemplate(Button)
    end
    function Skin.UnitPopupVoiceSliderTemplate(Slider)
        Skin.UnitPopupSliderTemplate(Slider)
    end
end

function private.FrameXML.UnitPopupCustomControls()
    -- FIXLATER - disable for now
    if private.isRetail then return end
    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceSpeakerVolumeTemplate.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceSpeakerVolumeTemplate.Toggle)

    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceMicrophoneVolume.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceMicrophoneVolume.Toggle)

    Skin.UnitPopupVoiceSliderTemplate(_G.UnitPopupVoiceUserVolume.Slider)
    Skin.UnitPopupVoiceToggleButtonTemplate(_G.UnitPopupVoiceUserVolume.Toggle)
end
