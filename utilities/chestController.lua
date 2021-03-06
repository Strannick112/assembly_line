local std = require "stdlib/stdlib"
local itemsInfo = require("utilities/itemsInfo").itemsInfo
local chestController = std.class()

function chestController:new()
    local obj = std.parent(self):new()

    function obj:clearCache()
        self.slots = {}
        self.emptySlots = {}
        self.items = {}
        self.itemsCount = 0
        self.fullSlotsCount = 0
    end

    function obj:readChessIC(side, ic)
        self:clearCache()
        for i = 1, ic.getInventorySize(side), 1 do
            local item = ic.getStackInSlot(side, i)
            if(item ~= nil) then
                 -- name, label, count, type
                local ii = itemsInfo:new(item.name, item.label, item.size)
                self.fullSlotsCount = self.fullSlotsCount + 1
                self.itemsCount = self.itemsCount + ii.count
                self.slots[i] = ii
                if self.items[ii.name] ~= nil then
                    self.items[ii.name].count = self.items[ii.name].count + ii.count
                else
                    self.items[ii.name] = ii
                end
            else
                table.insert(self.emptySlots,i)
            end
        end
    end

    obj:clearCache()

    return obj
end

return {
    chestController = chestController
}