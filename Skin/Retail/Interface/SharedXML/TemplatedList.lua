local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select xpcall

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color, Util = Aurora.Color, Aurora.Util

do --[[ SharedXML\TemplatedList.lua ]]
    local function GetElementFrame(list)
        local index = 0
        local count = list:GetNumElementFrames()

        return function()
            index = index + 1
            if index <= count then
                return list:GetElementFrame(index)
            end
        end
    end

    Hook.TemplatedListMixin = {}
    function Hook.TemplatedListMixin:RefreshListDisplay()
        if not self.elementTemplate then return end

        Util.CheckTemplate(GetElementFrame(self), "TemplatedListMixin",  (", "):split(self.elementTemplate))
    end
    function Hook.TemplatedListMixin:UpdatedSelectedHighlight()
        local selectedHighlight = self:GetSelectedHighlight()
        if selectedHighlight:IsShown() then
            local _, button = selectedHighlight:GetPoint()
            selectedHighlight:ClearAllPoints()
            selectedHighlight:SetAllPoints(button)
        end
    end
end

do --[[ SharedXML\TemplatedList.xml ]]
    function Skin.TemplatedListTemplate(Frame)
        local selectedHighlight = Frame:GetSelectedHighlight()
        selectedHighlight:SetColorTexture(Color.highlight:GetRGB())
        selectedHighlight:SetAlpha(0.2)
    end
end

function private.SharedXML.TemplatedList()
    Util.Mixin(_G.TemplatedListMixin, Hook.TemplatedListMixin)
end
