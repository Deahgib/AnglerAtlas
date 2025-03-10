local MapFishRates = {}
local DATA = AnglerAtlas.MM:GetModule("DATA")
local UI = AnglerAtlas.MM:GetModule("UI")
local mapFishRates = nil
local mapFishRatesText = nil

local currentMapID = -1

local function GetCurrentMapID()
    local mapID = WorldMapFrame:GetMapID()
    if not mapID then return end
    return mapID
end

local function GetZoneIDFromMapID(mapID)
    if not mapID then return end
    local zoneID = DATA.mapToZoneID[mapID]
    if not zoneID then
        if mapID == 947 or mapID == 1414 or mapID == 1415 then
            return
        end
        print("AnglerAtlas: No zone ID for map ID: "..mapID)
        return
    end
    return zoneID
end

function MapFishRates:OnZoneChanged()
    -- print("==================")
    -- print("Zone changed")
    -- print("==================")
    MapFishRates:Update()
end

function MapFishRates:OnMapOpened()
    -- print("==================")
    -- print("Map opened")
    -- print("==================")
    MapFishRates:Update()
end

function MapFishRates:Build()
    local map = WorldMapFrame
    if not map then return end

    -- Register event to hook into the map
    map:HookScript("OnShow", function()
        MapFishRates:OnMapOpened()
    end)

    -- Hook into the OnMapChanged function
    hooksecurefunc(map, "OnMapChanged", function()
        MapFishRates:OnZoneChanged()
    end)


    -- Add text in the bottomright corner
    mapFishRatesText = map:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mapFishRatesText:SetPoint("BOTTOMRIGHT", map, "BOTTOMRIGHT", -20, 10.5)
    mapFishRatesText:SetFont("Fonts\\FRIZQT__.ttf", 12)
    mapFishRatesText:SetText("")

    mapFishRates = CreateFrame("FRAME", "angler-map-zone-info-fish", map, "BackdropTemplate")
    mapFishRates:SetBackdrop({
        bgFile = "Interface\\Garrison\\GarrisonUIBackground2", 
        edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border", 
        tile = true, 
        tileSize = 120, 
        edgeSize = 8, 
        insets = { 
            left = 3, 
            right = 3, 
            top = 1, 
            bottom = 1 
        } 
    })
    mapFishRates:SetBackdropColor(1.0, 1.0, 1.0, 0.5);
    mapFishRates:SetSize(37, 408)
    mapFishRates:SetPoint("TOPLEFT", map, "TOPRIGHT", -5, -26)

    mapFishRates.icons = {}
    for i = 1, 14 do
        local fishIcon = CreateFrame("BUTTON", "angler-map-zone-info-fish-icon-"..i, mapFishRates, "ItemButtonTemplate")
        fishIcon:SetSize(24, 24)
        fishIcon:SetPoint("TOP", mapFishRates, "TOP", 0, -6 - (i - 1) * 26)
        fishIcon:SetScript("OnClick", function()
            UI:SelectFish(fishIcon.data.id)
            UI:Show()
            local zoneID = GetZoneIDFromMapID(GetCurrentMapID())
            if not zoneID then return end
            UI:SelectZone(zoneID)
            
        end)
        fishIcon.texture = fishIcon:CreateTexture(nil,'ARTWORK')
        fishIcon.texture:SetAllPoints()
        -- fishIcon:Hide()

        _G[fishIcon:GetName().."NormalTexture"]:SetSize(24*1.662, 24*1.662)

        -- Rate text
        fishIcon.rate = fishIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fishIcon.rate:SetPoint("BOTTOM", fishIcon, "BOTTOM", 0, 0)
        fishIcon.rate:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
        fishIcon.rate:SetText("|cFF00FF00"..tostring(50).."%")

        fishIcon.data = {}
        fishIcon.data.name = "Fish name"
        fishIcon.data.rate = 0.5

        function fishIcon:SetFish(fishId, rate)
            fishIcon.data.name = DATA.fish[fishId].name
            fishIcon.data.rate = rate
            fishIcon.data.id = fishId
            fishIcon.texture:SetTexture(GetItemIcon(fishId))
            fishIcon.rate:SetText(DATA:CatchRateColor(rate)..tostring(rate*100).."%")
        end

        -- Tooltip
        fishIcon:SetScript("OnEnter", function()
            GameTooltip:SetOwner(fishIcon, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(fishIcon.data.id)
            GameTooltip:Show()
        end)

        fishIcon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        table.insert(mapFishRates.icons, fishIcon)
    end
end

function MapFishRates:Update()
    if AnglerAtlasSettings.showMapZoneFishInfo == false then
        mapFishRates:Hide()
        mapFishRatesText:SetText("")
        return 
    end

    local mapID = GetCurrentMapID()
    -- print("ID: "..mapID.." | currentZoneID: "..currentMapID)
    if not mapID then return end
    if mapID == currentMapID then return end
    currentMapID = mapID
    -- print("New map ID: "..mapID)
    mapFishRates:Hide()
    mapFishRatesText:SetText("")

    local zoneID = GetZoneIDFromMapID(mapID)
    -- print("Zone ID: "..tostring(zoneID))

    if not DATA.zones[zoneID] then return end

    local zoneData = DATA.zones[zoneID]

    -- print("Map: "..DATA.zones[zoneID].name)

    local sortedFish = {}
    for k, v in pairs(zoneData.fishStats) do
        table.insert(sortedFish, {id = k, catchChance = v.catchChance})
    end
    table.sort(sortedFish, function(a, b)
        return a.catchChance > b.catchChance
    end)

    local zoneFishData = {}
    for i = 1, #sortedFish do
        local fish = sortedFish[i]
        if fish == nil then
            break
        end
        local fishInfo = DATA.fish[fish.id]
        if fishInfo == nil then
            break
        end
        table.insert(zoneFishData, {id = fish.id, minimumFishingLevel = fishInfo.minimumFishingLevel, avoidGetawayLevel = fishInfo.avoidGetawayLevel, waterType = fishInfo.type})
    end

    -- print("Number of fish: "..#zoneFishData)

    local zoneMinFishingLevel = 999
    local zoneMaxFishingLevel = 0
    local hasCoastal = false
    local hasInland = false

    for i = 1, #zoneFishData do
        local fishData = zoneFishData[i]
        if fishData == nil then
            break
        end
        if fishData.minimumFishingLevel < zoneMinFishingLevel then
            zoneMinFishingLevel = fishData.minimumFishingLevel
        end
        if fishData.avoidGetawayLevel > zoneMaxFishingLevel then
            zoneMaxFishingLevel = fishData.avoidGetawayLevel
        end

        if fishData.waterType == "C" then
            hasCoastal = true
        elseif fishData.waterType == "I" then
            hasInland = true
        end
    end

    mapFishRatesText:SetText("Fishing level "..DATA:SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel).." - "..DATA:SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel))

    mapFishRates:SetSize(37, 10 + 26 * #sortedFish)

    for i = 1, #mapFishRates.icons do
        local fishIcon = mapFishRates.icons[i]
        if fishIcon == nil then
            break
        end
        local fishData = sortedFish[i]
        if fishData == nil then
            fishIcon:Hide()
        else
            fishIcon:Show()
            fishIcon:SetFish(fishData.id, fishData.catchChance)
        end
    end

    mapFishRates:Show()

end

AnglerAtlas.MM:RegisterModule("MapFishRates", MapFishRates)
