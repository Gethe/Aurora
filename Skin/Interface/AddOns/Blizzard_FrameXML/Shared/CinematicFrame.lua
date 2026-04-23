local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\CinematicFrame.lua ]]
    function Hook.CinematicFrameCloseDialog_OnShow(self)
        self:SetScale(_G.UIParent:GetScale())
    end
end

do --[[ FrameXML\CinematicFrame.xml ]]
    function Skin.CinematicDialogButtonTemplate(Button)
        -- 12.0.5: CinematicDialogButtonTemplate now inherits SharedButtonSmallTemplate (Mainline)
        if private.isRetail then
            Skin.SharedButtonSmallTemplate(Button)
        else
            Skin.FrameTypeButton(Button)
        end
    end
end

function private.FrameXML.CinematicFrame()
    _G.CinematicFrame.closeDialog:HookScript("OnShow", Hook.CinematicFrameCloseDialog_OnShow)

    if private.isRetail then
        Skin.DialogBorderTemplate(_G.CinematicFrame.closeDialog.Border)
    else
        Skin.DialogBorderTemplate(_G.CinematicFrame.closeDialog)
    end
    Skin.CinematicDialogButtonTemplate(_G.CinematicFrameCloseDialogConfirmButton)
    Skin.CinematicDialogButtonTemplate(_G.CinematicFrameCloseDialogResumeButton)
end
