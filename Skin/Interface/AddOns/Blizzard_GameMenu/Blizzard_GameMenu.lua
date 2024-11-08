local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util

do
    do
        Hook.GameMenuFrameMixin = {}
        function Hook.GameMenuFrameMixin:OnShow()
        end
        function Hook.GameMenuFrameMixin:OnHide()
        end
        function Hook.GameMenuFrameMixin:OnEvent()
        end
        function Hook.GameMenuInitButtons(menu)
            if not menu.buttonPool then return end
            for button in menu.buttonPool:EnumerateActive() do
                if not button._auroraSkinned then
                    Base.CreateBackdrop(button, {
                        bgFile = [[Interface\PaperDoll\UI-Backpack-EmptySlot]],
                        tile = false,
                        offsets = {
                            left = -1,
                            right = -1,
                            top = -1,
                            bottom = -1,
                        }
                    })
                    Skin.UIPanelButtonTemplate(button)
                    button._auroraSkinned = true
                end
            end
        end
    end
end

do
    do
        function Skin.GameMenuFrameTemplate(Frame)
            if not Frame then
                return
            end
            Skin.DialogBorderTemplate(Frame.Border)
            Skin.DialogHeaderTemplate(Frame.Header)
        end
    end
end

function private.FrameXML.GameMenuFrame()
    local GameMenuFrame = _G.GameMenuFrame
    _G.hooksecurefunc(GameMenuFrame,"InitButtons", Hook.GameMenuInitButtons)
    Util.Mixin(GameMenuFrame, Hook.GameMenuFrameMixin)
    Skin.GameMenuFrameTemplate(GameMenuFrame)
end
