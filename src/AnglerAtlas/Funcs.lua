function AnglerAtlas:SplitGold(sourceCopperValue)
    local gold = math.floor(sourceCopperValue / 10000)
    local silver = math.floor((sourceCopperValue - (gold * 10000)) / 100)
    local copper = sourceCopperValue - (gold * 10000) - (silver * 100)
    return gold, silver, copper
end

function AnglerAtlas:getRankNameForLevel(level)
    for i = 1, #AnglerAtlas.skillRankNames do
        if level <= AnglerAtlas.skillRankNames[i].rank then
            return AnglerAtlas.skillRankNames[i].name
        end
    end
    return "Apprentice"
end

function AnglerAtlas:loadPlayerData()
    -- print("Loading player data...")
    -- load player name and realm
    AnglerAtlas.PLAYER.name, AnglerAtlas.PLAYER.realm = UnitName("player")
    -- load player level
    AnglerAtlas.PLAYER.level = UnitLevel("player")

    AnglerAtlas.SKILL.hasFishing = false
    for skillIndex = 1, GetNumSkillLines() do
        -- skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription
        local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(skillIndex)

        if skillName == "Fishing" then
            AnglerAtlas.SKILL.hasFishing = true
            -- print("---SKILL DATA---")
            -- print("skillName: " .. skillName)
            -- print("isExpanded: " .. tostring(isExpanded))
            -- print("skillRank: " .. skillRank)
            -- print("numTempPoints: " .. numTempPoints)
            -- print("skillModifier: " .. skillModifier)
            -- print("skillMaxRank: " .. skillMaxRank)
            -- print("isAbandonable: " .. tostring(isAbandonable))
            -- print("minLevel: " .. minLevel)
            -- print("skillCostType: " .. skillCostType)
            -- print("skillDescription: " .. skillDescription)
            -- print("----------------")
            AnglerAtlas.SKILL.level = skillRank
            AnglerAtlas.SKILL.maxLevel = skillMaxRank
            AnglerAtlas.SKILL.rankName = AnglerAtlas:getRankNameForLevel(skillRank)
            AnglerAtlas.SKILL.skillModifier = skillModifier
            AnglerAtlas.SKILL.modLevel = skillRank + skillModifier
        end
    end
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

function AnglerAtlas:GetSortedFishByCatchLevel()
    local sortedFish = {}
    for i = 0, #AnglerAtlas.DATA.validFish do
        table.insert(sortedFish, AnglerAtlas.DATA.validFish[i])
    end
    table.sort(sortedFish, function(a, b)
        if AnglerAtlas.DATA.fish[a].avoidGetawayLevel == AnglerAtlas.DATA.fish[b].avoidGetawayLevel then
            return AnglerAtlas.DATA.fish[a].minimumFishingLevel < AnglerAtlas.DATA.fish[b].minimumFishingLevel
        end
        return AnglerAtlas.DATA.fish[a].avoidGetawayLevel < AnglerAtlas.DATA.fish[b].avoidGetawayLevel
    end)
    return sortedFish
end

