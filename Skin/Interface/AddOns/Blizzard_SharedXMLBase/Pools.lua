local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals select tostring

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
        print("Acquire", template)
        Util.CheckTemplate(EnumerateActive(self), "ObjectPoolMixin", (", "):split(template))
    end


    local function FramePoolCollection_GetPoolKey(template, specialization)
        return template..tostring(specialization);
    end

    Hook.FramePoolCollectionMixin = {}
    function Hook.FramePoolCollectionMixin:CreateUnsecuredFramePool(frameType, parent, template, resetterFunc, forbidden, specialization)
        local poolKey = FramePoolCollection_GetPoolKey(template, specialization)
        Util.Mixin(self.pools[poolKey], Hook.ObjectPoolMixin)
    end
end


function private.SharedXML.Pools()
    --- If different frames are used for specialized cases even though they have the same template,
    --- supply a specialization key to differentiate. If specialization is a function, it will be
    --- called the first time a frame is acquired. If specialization is a table, it will be mixed
    --- in with FrameUtil.SpecializeFrameWithMixins.
    -- FIXLATER
    -- Util.Mixin(_G.objectPool, Hook.ObjectPoolMixin) -- removed in 11.0.0
    -- Util.Mixin(_G.ObjectPoolMixin, Hook.ObjectPoolMixin) -- removed in 11.0.0
    -- Util.Mixin(_G.FramePoolMixin, Hook.ObjectPoolMixin) -- removed in 11.0.0
    -- Util.Mixin(_G.TexturePoolMixin, Hook.ObjectPoolMixin)  -- removed in 11.0.0
    -- Util.Mixin(_G.FontStringPoolMixin, Hook.ObjectPoolMixin)  -- removed in 11.0.0
    -- Util.Mixin(_G.ActorPoolMixin, Hook.ObjectPoolMixin)  -- removed in 11.0.0
    -- Util.Mixin(_G.FramePoolCollectionMixin, Hook.FramePoolCollectionMixin) -- removed in 11.0.0
end
