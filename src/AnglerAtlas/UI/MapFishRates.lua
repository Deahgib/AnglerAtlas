local MapFishRates = {}
local DATA = AnglerAtlas.MM:GetModule("DATA")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local UI = AnglerAtlas.MM:GetModule("UI")
local mapFishRates = nil
local mapFishRatesText = nil
local fishHighlight = nil

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

function MapFishRates:Create()
    -- print("MapFishRates:Create()")
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

    local modeButtonSize = 18
    local flareModSize = 2.0
    mapFishRates.flare = CreateFrame("FRAME", "angler-zone-info-fish-mode-button-flare", mapFishRates)
    mapFishRates.flare:SetSize(modeButtonSize*flareModSize, modeButtonSize*flareModSize)
    mapFishRates.flare:SetPoint("TOPRIGHT", mapFishRates, "TOPRIGHT", -3, -3)

    mapFishRates.flare.texture = mapFishRates.flare:CreateTexture(nil,'ARTWORK')
    mapFishRates.flare.texture:SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-Tab")
    mapFishRates.flare.texture:SetRotation(-math.pi*0.5)
    mapFishRates.flare.texture:SetVertexColor(0.6, 0.6, 0.6, 1.0)
    mapFishRates.flare.texture:SetAllPoints()

    mapFishRates.modeButton = CreateFrame("BUTTON", "angler-map-info-fish-mode-button", mapFishRates.flare, "ItemButtonTemplate")
    mapFishRates.modeButton:SetSize(modeButtonSize, modeButtonSize)
    mapFishRates.modeButton:SetPoint("TOP", mapFishRates, "TOP", 0, -6)

    mapFishRates.modeButton.normalTexture = _G[mapFishRates.modeButton:GetName().."NormalTexture"]
    mapFishRates.modeButton.normalTexture:SetSize(modeButtonSize*1.662, modeButtonSize*1.662)

    mapFishRates.modeButton.texture = mapFishRates.modeButton:CreateTexture(nil,'ARTWORK')
    mapFishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
    mapFishRates.modeButton.texture:SetAllPoints()

    local function SetToolTipText()
        GameTooltip:SetOwner(mapFishRates.modeButton, "ANCHOR_LEFT", 0, 0)
        if STATE.mode == "openwater" then
            GameTooltip:SetText("Switch to Pools")
        else
            GameTooltip:SetText("Switch to Open Water")
        end
        GameTooltip:Show()
    end

    mapFishRates.modeButton:SetScript("OnClick", function()
        if STATE.mode == "openwater" then
            local mapID = GetCurrentMapID()
            if not mapID then return end
            local zoneID = GetZoneIDFromMapID(mapID)
            if zoneID == nil then return end
            local zoneData = DATA.zones[zoneID]
            if zoneData.fishingPools ~= nil then
                UI:SelectMode("pools")
                GameTooltip:Hide()
                SetToolTipText()
            end
        else
            UI:SelectMode("openwater")
            GameTooltip:Hide()
            SetToolTipText()
        end
    end)
    mapFishRates.modeButton:SetScript("OnEnter", function()
        SetToolTipText()
    end)
    mapFishRates.modeButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    mapFishRates.icons = {}
    for i = 1, 14 do
        local fishIcon = CreateFrame("BUTTON", "angler-map-zone-info-fish-icon-"..i, mapFishRates, "ItemButtonTemplate")
        fishIcon:SetSize(24, 24)
        fishIcon:SetPoint("TOP", mapFishRates, "TOP", 0, -31 - (i - 1) * 26)
        fishIcon:SetScript("OnClick", function()
            UI:SelectFish(fishIcon.data.id)
            UI:Show()
            local zoneID = GetZoneIDFromMapID(GetCurrentMapID())
            if not zoneID then return end
            UI:SelectZone(zoneID)
        end)
        fishIcon.texture = fishIcon:CreateTexture(nil,'ARTWORK')
        fishIcon.texture:SetAllPoints()

        _G[fishIcon:GetName().."NormalTexture"]:SetSize(24*1.662, 24*1.662)

        -- Rate text
        fishIcon.rate = fishIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fishIcon.rate:SetPoint("BOTTOM", fishIcon, "BOTTOM", 0, 0)
        fishIcon.rate:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
        fishIcon.rate:SetText(DATA.textColours.green..tostring(50).."%")

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

        local GetWaterType = function(fishId)
            local fishData = DATA.fish[fishId]
            if fishData.type == "C" then
                return DATA.textColours.white.."Can be caught in "..DATA.textColours.green.."coastal"..DATA.textColours.white.." waters."
            elseif fishData.type == "I" then
                return DATA.textColours.white.."Can be caught in "..DATA.textColours.green.."inland"..DATA.textColours.white.." waters."
            else
                return ""
            end
        end

        GameTooltip:HookScript("OnTooltipSetItem", function(self)
            if GameTooltip:GetOwner() == fishIcon then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(GetWaterType(fishIcon.data.id))
            end
        end)

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

    
    fishHighlight = CreateFrame("FRAME", "angler-map-fish-selected-icon", mapFishRates.icons[1])
    fishHighlight:SetSize(24, 24)
    fishHighlight:SetPoint("CENTER", 0, 0)
    
    fishHighlight.texture = fishHighlight:CreateTexture(nil,'OVERLAY')
    fishHighlight.texture:SetTexture("Interface\\Transmogrify\\transmog-tooltip-arrow")
    fishHighlight.texture:SetSize(8, 8)
    fishHighlight.texture:SetRotation(math.pi)
    fishHighlight.texture:SetPoint("CENTER", 13, 0)
    -- fishHighlight.texture:SetBlendMode("ADD")
    
    fishHighlight.flareTexture = fishHighlight:CreateTexture(nil,'OVERLAY')
    fishHighlight.flareTexture:SetTexture("Interface\\CURSOR\\FishingCursor")
    fishHighlight.flareTexture:SetSize(12, 12)
    fishHighlight.flareTexture:SetRotation(math.pi*0.23)
    fishHighlight.flareTexture:SetPoint("CENTER", 22, 0)
    -- print("MapFishRates:Create() done")
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
    -- if mapID == currentMapID then 
    --     return 
    -- end
    currentMapID = mapID
    -- print("New map ID: "..mapID)
    mapFishRates:Hide()
    mapFishRatesText:SetText("")
    fishHighlight:Hide()
    

    local zoneID = GetZoneIDFromMapID(mapID)
    -- print("Zone ID: "..tostring(zoneID))

    if not DATA.zones[zoneID] then return end

    local zoneData = DATA.zones[zoneID]

    
    if zoneData.fishingPools == nil then
        mapFishRates.modeButton.texture:SetVertexColor(0.4, 0.4, 0.4, 1.0)
        mapFishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
        mapFishRates.modeButton:Disable()
    else
        mapFishRates.modeButton:Enable()
        mapFishRates.modeButton.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    end

    -- print("Map: "..DATA.zones[zoneID].name)

    local sortedFish = {}
    if STATE.mode == "openwater" then
        mapFishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
        for k, v in pairs(zoneData.fishStats) do
            table.insert(sortedFish, {id = k, catchChance = v.catchChance})
        end
    elseif STATE.mode == "pools" then
        
        if zoneData.fishingPools == nil then
            mapFishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
            for k, v in pairs(zoneData.fishStats) do
                table.insert(sortedFish, {id = k, catchChance = v.catchChance})
            end
        else
            mapFishRates.modeButton.texture:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportStormWind")
            for k, v in pairs(zoneData.fishingPools) do
                table.insert(sortedFish, {id = v.id, count = v.count})
            end
        end
    end

    table.sort(sortedFish, function(a, b)
        if STATE.mode == "pools" and zoneData.fishingPools ~= nil then
            return a.count > b.count
        end
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

    mapFishRates:SetSize(37, 35 + 26 * #sortedFish)


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
            fishIcon.texture:SetTexture(GetItemIcon(fishData.id))
            fishIcon.data.id = fishData.id

            if STATE.mode == "openwater" then
                fishIcon.rate:SetText(DATA:CatchRateColor(fishData.catchChance)..tostring(fishData.catchChance*100).."%")
            elseif STATE.mode == "pools" then
                if zoneData.fishingPools ~= nil then
                    fishIcon.rate:SetText(DATA.textColours.white..fishData.count)
                else
                    fishIcon.rate:SetText(DATA:CatchRateColor(fishData.catchChance)..tostring(fishData.catchChance*100).."%")
                end
            end

            if STATE.selectedFish == fishData.id then
                fishHighlight:SetPoint("CENTER", fishIcon, "CENTER", 0, 0)
                fishHighlight:Show()
            end
        end
    end

    mapFishRates:Show()
end

AnglerAtlas.MM:RegisterModule("MapFishRates", MapFishRates)
