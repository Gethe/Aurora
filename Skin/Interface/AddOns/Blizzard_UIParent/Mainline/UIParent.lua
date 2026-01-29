local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals _G next type

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\UIParent.lua ]]
    function Hook.SetPortraitToTexture(texture, path)
        texture = _G[texture] or texture
        if not texture:IsForbidden() and texture._auroraResetPortrait then
            texture:SetTexture(path)
        end
    end
    function Hook.BuildIconArray(parent, baseName, template, rowSize, numRows, onButtonCreated)
        if Skin[template] then
            for i = 1, rowSize * numRows do
                Skin[template](_G[baseName..i])
            end
        end
    end
end

function private.FrameXML.UIParent()
    -- Code replaced with SetTexture functions.....
    if type(_G.SetPortraitToTexture) == "function" then
        _G.hooksecurefunc("SetPortraitToTexture", Hook.SetPortraitToTexture)
    end
    -- this one is still around :)
    if type(_G.BuildIconArray) == "function" then
        _G.hooksecurefunc("BuildIconArray", Hook.BuildIconArray)
    end
end
