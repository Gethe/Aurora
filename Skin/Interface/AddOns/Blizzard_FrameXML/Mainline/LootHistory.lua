local _, private = ...

-- luacheck: globals _G

local Hook = private.Aurora.Hook

local pendingItemRefresh = setmetatable({}, {__mode = "k"})

do --[[ FrameXML\LootHistory.lua ]]
    function Hook.LootHistoryElementMixin_Init(self, dropInfo)
        if not dropInfo or not dropInfo.itemHyperlink then
            pendingItemRefresh[self] = nil
            return
        end

        local item = _G.Item:CreateFromItemLink(dropInfo.itemHyperlink)
        if item:GetItemName() and item:GetItemIcon() then
            pendingItemRefresh[self] = nil
            return
        end

        if pendingItemRefresh[self] == dropInfo.itemHyperlink then
            return
        end

        pendingItemRefresh[self] = dropInfo.itemHyperlink
        item:ContinueOnItemLoad(function()
            if pendingItemRefresh[self] ~= dropInfo.itemHyperlink then
                return
            end

            pendingItemRefresh[self] = nil

            if self.dropInfo and self.dropInfo.itemHyperlink == dropInfo.itemHyperlink then
                self:Init(self.dropInfo)
            end
        end)
    end
end

function private.FrameXML.LootHistory()
    _G.hooksecurefunc(_G.LootHistoryElementMixin, "Init", Hook.LootHistoryElementMixin_Init)
    local origLayout = _G.ResizeLayoutMixin.Layout
    _G.LootHistoryRollTooltipLineMixin.Layout = function(self)
        local ok = _G.pcall(origLayout, self)
        if not ok then
            self:SetSize(200, 14)
        end
        if self.MarkClean then
            self:MarkClean()
        end
    end
end
