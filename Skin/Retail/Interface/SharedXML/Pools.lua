local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Hook = Aurora.Hook
local Util = Aurora.Util

do --[[ SharedXML\Pools.lua ]]
    local function EnumerateActive(pool)
        return function()
            return pool:EnumerateActive()
        end
    end

    Hook.ObjectPoolMixin = {}
    function Hook.ObjectPoolMixin:Acquire()
        local template = self.frameTemplate or self.textureTemplate or self.fontStringTemplate or self.actorTemplate
        if not template then return end

        --local templates = {(", "):split(template)}
        --print("Acquire", template)
        Util.CheckTemplate(EnumerateActive(self), "ObjectPoolMixin", (", "):split(template))
    end


    local function FramePoolCollection_GetPoolKey(template, specialization)
        return template..tostring(specialization);
    end

    Hook.FramePoolCollectionMixin = {}
    function Hook.FramePoolCollectionMixin:CreatePool(frameType, parent, template, resetterFunc, forbidden, specialization)
        local poolKey = FramePoolCollection_GetPoolKey(template, specialization)
        Util.Mixin(self.pools[poolKey], Hook.ObjectPoolMixin)
    end
end


function private.SharedXML.Pools()
    --Util.Mixin(objectPool, Hook.ObjectPoolMixin)
    Util.Mixin(_G.ObjectPoolMixin, Hook.ObjectPoolMixin)

    Util.Mixin(_G.FramePoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.TexturePoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.FontStringPoolMixin, Hook.ObjectPoolMixin)
    Util.Mixin(_G.ActorPoolMixin, Hook.ObjectPoolMixin)

    Util.Mixin(_G.FramePoolCollectionMixin, Hook.FramePoolCollectionMixin)
end
