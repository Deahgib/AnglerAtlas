function AnglerAtlas:SplitGold(sourceCopperValue)
    local gold = math.floor(sourceCopperValue / 10000)
    local silver = math.floor((sourceCopperValue - (gold * 10000)) / 100)
    local copper = sourceCopperValue - (gold * 10000) - (silver * 100)
    return gold, silver, copper
end


function AnglerAtlas:GetSortedZonesForFish(fishId)
    local sortedZones = {}
    for i = 1, #AnglerAtlas.DATA.fish[fishId].fishedIn do
        local zoneId = AnglerAtlas.DATA.fish[fishId].fishedIn[i]
        if AnglerAtlas.DATA.zones[zoneId] ~= nil then
            table.insert(sortedZones, AnglerAtlas.DATA.zones[zoneId])
        end
    end
    table.sort(sortedZones, function(a, b)
        local aPerct = a.fishStats[fishId].catchChance
        local bPerct = b.fishStats[fishId].catchChance
        return aPerct > bPerct
    end)
    return sortedZones
end


