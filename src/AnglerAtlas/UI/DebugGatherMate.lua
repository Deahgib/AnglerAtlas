local DebugGatherMate = {}

local DATA = AnglerAtlas.MM:GetModule("DATA")
    
local function OnCommand(msg)
    DebugGatherMate:PrintCounts()
end

SLASH_ANGLER_DEBUG1 = "/aadebug"
SlashCmdList["ANGLER_DEBUG"] = OnCommand


function DebugGatherMate:PrintCounts()
    print("GatherMate2")
    if GatherMate2FishDB == nil then
        print("GatherMate2FishDB is nil")
    else
        print("GatherMate2FishDB has "..#GatherMate2FishDB.." entries")
    end

    local angler_pool_data = {}
    
    local overall_pools = {}

    -- For all k, v pairs in GatherMate2FishDB
    for k, v in pairs(GatherMate2FishDB) do
        local zoneID = DATA.mapToZoneID[k]
        if zoneID == nil then
            print("No zone ID for map ID: "..k)
        end
        
        local zoneData = DATA.zones[zoneID]
        print("==== Key: "..k.." ("..zoneID..") ========== | "..zoneData.name)

        angler_pool_data[zoneID] = {}

        local uniqueFish = {}
        for k2, v2 in pairs(v) do
            if uniqueFish[v2] == nil then
                uniqueFish[v2] = 1
            else
                uniqueFish[v2] = uniqueFish[v2] + 1
            end
        end

        angler_pool_data[zoneID] = {
            id = zoneID,
            name = zoneData.name,
            fishingPools = {}
        }

        for k2, v2 in pairs(uniqueFish) do
            if DATA.fishIconToId[k2] ~= nil then
                local fishData = DATA.fish[DATA.fishIconToId[k2]]
                if fishData ~= nil then
                    print("| Fish: "..k2.." | Count: "..v2.." Name: "..fishData.name)
                    table.insert(angler_pool_data[zoneID].fishingPools, {
                        id = DATA.fishIconToId[k2],
                        count = v2
                    })
                    if overall_pools[DATA.fishIconToId[k2]] == nil then
                        overall_pools[DATA.fishIconToId[k2]] = {
                            count = v2,
                            name = fishData.name,
                            zones = {}
                        }
                        table.insert(overall_pools[DATA.fishIconToId[k2]].zones, zoneID)
                    else
                        table.insert(overall_pools[DATA.fishIconToId[k2]].zones, zoneID)
                        overall_pools[DATA.fishIconToId[k2]].count = overall_pools[DATA.fishIconToId[k2]].count + v2
                    end
                end
            end
        end




        -- print("Value: "..v)
    end
    
    if AnglerAtlasData == nil then
        AnglerAtlasData = {}
    end
    AnglerAtlasData["zones"] = angler_pool_data

    AnglerAtlasData["pools"] = overall_pools

    print("Overall pools")
    print("==============")
    print(AnglerAtlasData["zones"])
    print(AnglerAtlasData["pools"])
end

AnglerAtlas.MM:RegisterModule("DebugGatherMate", DebugGatherMate)