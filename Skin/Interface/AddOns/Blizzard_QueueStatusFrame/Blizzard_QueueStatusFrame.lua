local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals next tinsert

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Util = Aurora.Util
do --[[ AddOns\Blizzard_QueueStatusFrame\Blizzard_QueueStatusFrame.lua ]]
    function Hook.QueueStatusEntry_SetFullDisplay(entry, title, queuedTime, myWait, isTank, isHealer, isDPS, totalTanks, totalHealers, totalDPS, tankNeeds, healerNeeds, dpsNeeds, subTitle, extraText)
        local nextRoleIcon = 1
        if isDPS then
            local icon = entry["RoleIcon"..nextRoleIcon]
            Base.SetTexture(icon, "iconDAMAGER")
            icon._auroraBG:Show()
            nextRoleIcon = nextRoleIcon + 1
        end
        if isHealer then
            local icon = entry["RoleIcon"..nextRoleIcon]
            Base.SetTexture(icon, "iconHEALER")
            icon._auroraBG:Show()
            nextRoleIcon = nextRoleIcon + 1
        end
        if isTank then
            local icon = entry["RoleIcon"..nextRoleIcon]
            Base.SetTexture(icon, "iconTANK")
            icon._auroraBG:Show()
            nextRoleIcon = nextRoleIcon + 1
        end

        for i = nextRoleIcon, _G.LFD_NUM_ROLES do
            local icon = entry["RoleIcon"..i]
            if icon._auroraBG then
                icon._auroraBG:Hide()
            end
        end

        if entry.HealersFound:IsShown() then
            local point, anchor, relPoint, x, y = entry.HealersFound:GetPoint()
            entry.HealersFound:SetPoint(point, anchor, relPoint, x + 0.5, y)
        end
    end
end

do --[[ AddOns\Blizzard_QueueStatusFrame\Blizzard_QueueStatusFrame.xml ]]
    -- NEEDS REWORK...
    function Skin.QueueStatusRoleCountTemplate(Frame)
        local debugName = Frame:GetDebugName()
        if debugName:find("HealersFound") then
            Frame.RoleIcon:SetAtlas("UI-LFG-RoleIcon-Healer-Micro")
        elseif debugName:find("Tank") then
            Frame.RoleIcon:SetAtlas("UI-LFG-RoleIcon-Tank-Micro")
        elseif debugName:find("Damager") then
            Frame.RoleIcon:SetAtlas("UI-LFG-RoleIcon-DPS-Micro")
        end
    end
    function Skin.QueueStatusEntryTemplate(Frame)
        Util.PositionRelative("TOPRIGHT", Frame, "TOPRIGHT", -5, -5, 3, "Left", {
            Frame.RoleIcon1,
            Frame.RoleIcon2,
            Frame.RoleIcon3,
        })

        Frame.EntrySeparator:SetHeight(1)
        Skin.QueueStatusRoleCountTemplate(Frame.HealersFound)
        Skin.QueueStatusRoleCountTemplate(Frame.TanksFound)
        Skin.QueueStatusRoleCountTemplate(Frame.DamagersFound)
    end
end

function private.FrameXML.QueueStatusFrame()
     _G.hooksecurefunc("QueueStatusEntry_SetFullDisplay", Hook.QueueStatusEntry_SetFullDisplay)

    local QueueStatusFrame = _G.QueueStatusFrame
    Skin.TooltipBackdropTemplate(QueueStatusFrame)
    Util.Mixin(QueueStatusFrame.statusEntriesPool, Hook.ObjectPoolMixin)
end
