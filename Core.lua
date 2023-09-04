local _, ns = ...

local function splitGold(sourceValue)
    local gold = math.floor(sourceValue / 10000)
    local silver = math.floor((sourceValue - (gold * 10000)) / 100)
    local copper = sourceValue - (gold * 10000) - (silver * 100)
    return gold, silver, copper
end


ns.ANGLER_DATA:loadPlayerData()

local UIConfig = CreateFrame("FRAME", "angler-root", UIParent, "BasicFrameTemplate")
UIConfig:SetFrameStrata("DIALOG")
UIConfig:SetSize(860, 490)
UIConfig:SetPoint("CENTER") -- Doesn't need to be ("CENTER", UIParent, "CENTER")
UIConfig:SetMovable(true)
UIConfig:EnableMouse(true)
UIConfig:RegisterForDrag("LeftButton")
UIConfig:Hide()
UIConfig:SetScript("OnDragStart", function(self)
    self:StartMoving()
  end)
UIConfig:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
  end)
UIConfig:SetScript("OnShow", function()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    PlaySound(SOUNDKIT.FISHING_REEL_IN, "Master");
    UIConfig:ReloadAll()
end)
UIConfig:SetScript("OnHide", function()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
end)

UIConfig:RegisterEvent("UNIT_INVENTORY_CHANGED")
UIConfig:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
UIConfig:RegisterEvent("SKILL_LINES_CHANGED")
UIConfig:SetScript("OnEvent", function (self, event)
    -- print("Event: "..event)
    if event == "UNIT_INVENTORY_CHANGED" or 
       event == "PLAYER_EQUIPMENT_CHANGED" or
       event == "SKILL_LINES_CHANGED" then
        UIConfig:Reload()
    end
end)

UIConfig.characterPortrait = CreateFrame("FRAME", "angler-character-portrait", UIConfig)
UIConfig.characterPortrait:SetSize(64, 64)
UIConfig.characterPortrait:SetPoint("CENTER", UIConfig, "TOPLEFT", 25, -21)
UIConfig.characterPortrait.texture = UIConfig.characterPortrait:CreateTexture(nil,'ARTWORK')
UIConfig.characterPortrait.texture:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
UIConfig.characterPortrait.texture:SetAllPoints()

UIConfig.characterPortrait.border = CreateFrame("FRAME", "angler-character-portrait-border", UIConfig.characterPortrait)
UIConfig.characterPortrait.border:SetSize(63*1.28, 63*1.28)
UIConfig.characterPortrait.border:SetPoint("TOPLEFT", UIConfig.characterPortrait, "TOPLEFT", -7.5, 1)
UIConfig.characterPortrait.border.texture = UIConfig.characterPortrait.border:CreateTexture(nil,'ARTWORK')
UIConfig.characterPortrait.border.texture:SetTexture("Interface\\FrameGeneral\\UI-Frame")
UIConfig.characterPortrait.border.texture:SetAllPoints()
UIConfig.characterPortrait.border.texture:SetTexCoord(0, 0.625, 0, 0.625)   


UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 60, 0)
UIConfig.title:SetText("|cFFDDFF00Angler Atlas")
UIConfig.title:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")

UIConfig.playerName = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.playerName:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 60, -46)
UIConfig.playerName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE")

UIConfig.playerInfo = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.playerInfo:SetPoint("BOTTOMLEFT", UIConfig.playerName, "BOTTOMRIGHT", 5, 1)
UIConfig.playerInfo:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")


UIConfig.bottomBanner = UIConfig:CreateTexture(nil,'ARTWORK')
UIConfig.bottomBanner:SetHorizTile(true)

UIConfig.bottomBanner:SetTexture("Interface\\COMMON\\UI-Goldborder-_tile", "REPEAT", "CLAMP", "LINEAR")
UIConfig.bottomBanner:SetSize(855, 64)
UIConfig.bottomBanner:SetPoint("TOP", UIConfig, "TOP", -1, -23)


local textColours = {
    ['green'] = "|cFF00FF00",
    ['red'] = "|cFFFF0000",
    ['white'] = "|cFFFFFFFF",
    ['yellow'] = "|cFFFFFF00",
    ['grey'] = "|cFF888888",
}

local function SkillLevelColor(lvl)
    if ns.ANGLER_DATA.SKILL.hasFishing then
        local pLvl = ns.ANGLER_DATA.SKILL.modLevel
        if lvl <= pLvl then
            return textColours.green
        elseif lvl > pLvl+75 then
            return textColours.red
        else
            return textColours.yellow
        end
    else
        return textColours.red
    end
end

local function CatchRateColor(rate)
    if rate <= 0.10 then
        return textColours.red
    elseif rate <= 0.3333 then
        return textColours.yellow
    else
        return textColours.green
    end
end

local ANGLER_DARK_FONT_COLOR = "|cFF222222"

-- Borders
local borderFiles = {
    ["UI-DialogBox-TestWatermark-Border"] = "Interface\\DialogFrame\\UI-DialogBox-TestWatermark-Border",
    ["UI-DialogBox-Border"] = "Interface\\DialogFrame\\UI-DialogBox-Border",
    ["UI-DialogBox-Gold-Border"] = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
    ["UI-Toast-Border"] = "Interface\\FriendsFrame\\UI-Toast-Border",
    ["UI-SliderBar-Border"] = "Interface\\Buttons\\UI-SliderBar-Border",
    ["UI-Arena-Border"] = "Interface\\ARENAENEMYFRAME\\UI-Arena-Border",
    ["ChatBubble-Backdrop"] = "Interface\\Tooltips\\ChatBubble-Backdrop",
    ["UI-Tooltip-Border"] = "Interface\\Tooltips\\UI-Tooltip-Border",
    ["UI-TalentFrame-Active"] = "Interface\\TALENTFRAME\\UI-TalentFrame-Active",
}

local backgroundFiles = {
    ["UI-Background-Rock"] = "Interface\\FrameGeneral\\UI-Background-Rock",
    ["UI-Background-Marble"] = "Interface\\FrameGeneral\\UI-Background-Marble",
    ["GarrisonMissionParchment"] = "Interface\\Garrison\\GarrisonMissionParchment",
    ["AdventureMapParchmentTile"] = "Interface\\AdventureMap\\AdventureMapParchmentTile",
    ["AdventureMapTileBg"] = "Interface\\AdventureMap\\AdventureMapTileBg",
    ["AdventureMapTileBg"] = "Interface\\AdventureMap\\AdventureMapTileBg",
    ["Bank-Background"] = "Interface\\BankFrame\\Bank-Background",
    ["UI-Party-Background"] = "Interface\\CharacterFrame\\UI-Party-Background",
    ["GarrisonLandingPageMiddleTile"] = "Interface\\Garrison\\GarrisonLandingPageMiddleTile",
    ["GarrisonMissionParchment"] = "Interface\\Garrison\\GarrisonMissionParchment",
    ["GarrisonMissionUIInfoBoxBackgroundTile"] = "Interface\\Garrison\\GarrisonMissionUIInfoBoxBackgroundTile",
    ["GarrisonShipMissionParchment"] = "Interface\\Garrison\\GarrisonShipMissionParchment",
    ["GarrisonUIBackground"] = "Interface\\Garrison\\GarrisonUIBackground",
    ["GarrisonUIBackground2"] = "Interface\\Garrison\\GarrisonUIBackground2",
    ["CollectionsBackgroundTile"] = "Interface\\Collections\\CollectionsBackgroundTile",
    ["BlackMarketBackground-Tile"] = "Interface\\BlackMarket\\BlackMarketBackground-Tile",
}

-- Backdrops
-- BACKDROP_ACHIEVEMENTS_0_64
-- BACKDROP_ARENA_32_32
-- BACKDROP_DIALOG_32_32
-- BACKDROP_DARK_DIALOG_32_32
-- BACKDROP_DIALOG_EDGE_32
-- BACKDROP_GOLD_DIALOG_32_32
-- BACKDROP_WATERMARK_DIALOG_0_16
-- BACKDROP_SLIDER_8_8
-- BACKDROP_PARTY_32_32
-- BACKDROP_TOAST_12_12
-- BACKDROP_CALLOUT_GLOW_0_16
-- BACKDROP_CALLOUT_GLOW_0_20
-- BACKDROP_TEXT_PANEL_0_16
-- BACKDROP_CHARACTER_CREATE_TOOLTIP_32_32
-- BACKDROP_TUTORIAL_16_16


local offset = 0

local validFish = {}
for k in pairs(ns.ANGLER_DATA.DATA.fish) do table.insert(validFish, k) end

local validZones = {}
for k in pairs(ns.ANGLER_DATA.DATA.zones) do table.insert(validZones, k) end


-- print("Building UI")

UIConfig.showButtonTab = CreateFrame("FRAME", "angler-show-button-tab", SpellBookSideTabsFrame)
UIConfig.showButtonTab:SetSize(62, 62)
UIConfig.showButtonTab:SetPoint("BOTTOMRIGHT", SpellBookSideTabsFrame, "BOTTOMRIGHT", 27, 80)
UIConfig.showButtonTab.texture = UIConfig.showButtonTab:CreateTexture(nil,'ARTWORK')
UIConfig.showButtonTab.texture:SetTexture("Interface\\SPELLBOOK\\SpellBook-SkillLineTab")
UIConfig.showButtonTab.texture:SetAllPoints()

UIConfig.showButtonTab.showButton = CreateFrame("BUTTON", "angler-show-button", UIConfig.showButtonTab, "ItemButtonTemplate")
UIConfig.showButtonTab.showButton:SetSize(32, 32)
-- -- print(UIConfig.showButton.NormalTexture)
-- UIConfig.showButton.NormalTexture:SetTexture("Interface\\Buttons\\UI-PlusButton-Up")
-- UIConfig.showButton.NormalTexture:SetSize(16, 16)
UIConfig.showButtonTab.showButton:SetPoint("TOPLEFT", UIConfig.showButtonTab, "TOPLEFT", 3, -10)


-- for k, v in pairs(UIConfig.showButtonTab.showButton) do
--     print(k)
-- end
_G[UIConfig.showButtonTab.showButton:GetName().."NormalTexture"]:SetSize(50, 50)


UIConfig.showButtonTab.showButton:SetScript("OnClick", function()
    UIConfig:Show()
end)
UIConfig.showButtonTab.showButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(UIConfig.showButtonTab.showButton, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Calpico's 'A Master's Guide to Fishing'")
    GameTooltip:Show()
end)

UIConfig.showButtonTab.showButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
SetItemButtonTexture(UIConfig.showButtonTab.showButton, GetItemIcon('19970')) 




-- local function isFishValid(fishId)
--     return ns.ANGLER_DATA.DATA.fish[fishId] ~= nil
-- end
local function updateFishInfo()
    if ns.ANGLER_DATA.STATE.selectedFish == nil then
        UIConfig.info.name:SetText("No fish selected")
        UIConfig.info.icon.texture:SetTexture(nil)
        UIConfig.info.itemLevel:SetText("")
        UIConfig.info.itemStackCount:SetText("")
        -- UIConfig.info.goldSellPrice:Hide()
        UIConfig.info.goldAuctionPrice:Hide()
        return
    end
    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
    itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
    expacID, setID, isCraftingReagent
        = GetItemInfo(ns.ANGLER_DATA.STATE.selectedFish)

    local fishData = ns.ANGLER_DATA.DATA.fish[ns.ANGLER_DATA.STATE.selectedFish]

    UIConfig.info.name:SetText(itemName)
    UIConfig.info.icon.texture:SetTexture(itemTexture)
    local levelColour = ns.ANGLER_DATA.PLAYER.level >= itemLevel and textColours.white or textColours.red
    UIConfig.info.itemLevel:SetText(levelColour.."Requires Level "..itemLevel)
    UIConfig.info.itemStackCount:SetText(itemStackCount)
    -- UIConfig.info.goldSellPrice:SetGold(sellPrice)
    -- UIConfig.info.goldSellPrice:Show()
    if Auctionator ~= nil then
        local auctionPrice = Auctionator.Database:GetPrice(tostring(ns.ANGLER_DATA.STATE.selectedFish))
        if auctionPrice ~= nil then
            UIConfig.info.goldAuctionPrice:SetGold(auctionPrice)
            UIConfig.info.goldAuctionPrice:Show()
        else
            UIConfig.info.goldAuctionPrice:Hide()
        end
    else
        -- print("Auctionator not loaded")
        UIConfig.info.goldAuctionPrice:Hide()
    end

    local isBuffFish = fishData.isBuffFish ~= nil and fishData.isBuffFish == true
    local isAlchemicFish = fishData.isAlchemicFish ~= nil and fishData.isAlchemicFish == true

    if isBuffFish then
        UIConfig.info.buffFish:Show()
    else
        UIConfig.info.buffFish:Hide()
    end

    if isAlchemicFish then
        UIConfig.info.alchemicFish:Show()
    else
        UIConfig.info.alchemicFish:Hide()
    end

    
    UIConfig.info.levelText:SetText("Min fishing level "..SkillLevelColor(fishData.minimumFishingLevel)..tostring(fishData.minimumFishingLevel).."|cFFFFFFFF, optimal fishing level "..SkillLevelColor(fishData.avoidGetawayLevel)..tostring(fishData.avoidGetawayLevel))

    local waterType = ""
    if fishData.type == "C" then
        waterType = "Can be caught in |cFF00FF00coastal|cFFFFFFFF waters."
    elseif fishData.type == "I" then
        waterType = "Can be caught in |cFF00FF00inland|cFFFFFFFF waters."
    else
        waterType = ""
    end
    UIConfig.info.waterType:SetText(waterType)

    if fishData.requirements ~= nil then
        for i = 1, #fishData.requirements do
            local req = fishData.requirements[i]
            local font = UIConfig.info.requirements[i]
            if font == nil then
                break
            end
            if req == nil then
                font:Hide()
            else
                font:Show()
                font:SetText(req)
            end
        end
    else
        for i = 1, #UIConfig.info.requirements do
            local font = UIConfig.info.requirements[i]
            if font == nil then
                break
            end
            font:Hide()
        end
    end
    -- UIConfig.info.requirements
end

local function getSortedZonesForFish(fishId)
    local sortedZones = {}
    for i = 1, #ns.ANGLER_DATA.DATA.fish[fishId].fishedIn do
        local zoneId = ns.ANGLER_DATA.DATA.fish[fishId].fishedIn[i]
        if ns.ANGLER_DATA.DATA.zones[zoneId] ~= nil then
            table.insert(sortedZones, ns.ANGLER_DATA.DATA.zones[zoneId])
        end
    end
    table.sort(sortedZones, function(a, b)
        local aPerct = a.fishStats[fishId].catchChance
        local bPerct = b.fishStats[fishId].catchChance
        return aPerct > bPerct
    end)
    return sortedZones
end

local function updateZoneList()
    if ns.ANGLER_DATA.STATE.selectedFish == nil then
        UIConfig.zones.scrollFrame:Hide()
        return
    end
    if ns.ANGLER_DATA.STATE.selectedZone == nil then
        UIConfig.zones.scrollFrame:Hide()
        return
    end
    UIConfig.zones.scrollFrame:Show()
    -- local fishId = ns.ANGLER_DATA.STATE.selectedFish
    -- local fishInfo = ns.ANGLER_DATA.DATA.fish[fishId]
    -- local fishStats = ns.ANGLER_DATA.DATA.zones[ns.ANGLER_DATA.STATE.selectedZone].fishStats[fishId]
    local sortedZones = getSortedZonesForFish(ns.ANGLER_DATA.STATE.selectedFish)
    for i = 1, #UIConfig.zones.zoneButtons do
        local zoneButton = UIConfig.zones.zoneButtons[i]
        if zoneButton == nil then
            break
        end
        local zoneData = sortedZones[i]
        if zoneData == nil then
            zoneButton:Hide()
        else
            zoneButton:Show()

            local zoneNameText = zoneData.name
            local zoneCatchRateText = CatchRateColor(zoneData.fishStats[ns.ANGLER_DATA.STATE.selectedFish].catchChance)..tostring(zoneData.fishStats[ns.ANGLER_DATA.STATE.selectedFish].catchChance*100).."%"
            local zoneFishingLevelText = SkillLevelColor(zoneData.fishingLevel)..tostring(zoneData.fishingLevel)

            -- print(zoneNameText)
            -- print(zoneCatchRateText)
            -- print(zoneFishingLevelText)
            zoneButton:SetZone(tostring(zoneData.id), zoneNameText, zoneCatchRateText, "")
        end
        
    end
    UIConfig.zones.scrollFrame.scrollChild:SetHeight(#sortedZones * 30 + 20)
    
    UIConfig.zones.scrollFrame:Show()
end

local function updateZoneInfo()
    if ns.ANGLER_DATA.STATE.selectedZone == nil then
        UIConfig.zoneinfo.name:SetText(ANGLER_DARK_FONT_COLOR.."No zone selected")
        UIConfig.zoneinfo.coastalInland:SetText("")
        UIConfig.zoneinfo.fishRates:Hide()
        return
    end
    local zoneData = ns.ANGLER_DATA.DATA.zones[ns.ANGLER_DATA.STATE.selectedZone]
    if zoneData == nil then
        UIConfig.zoneinfo.name:SetText(ANGLER_DARK_FONT_COLOR.."No zone selected")
        UIConfig.zoneinfo.coastalInland:SetText("")
        UIConfig.zoneinfo.fishRates:Hide()
        return
    end
    UIConfig.zoneinfo.name:SetText(ANGLER_DARK_FONT_COLOR..zoneData.name)
    
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
        local fishInfo = ns.ANGLER_DATA.DATA.fish[fish.id]
        if fishInfo == nil then
            break
        end
        table.insert(zoneFishData, {id = fish.id, minimumFishingLevel = fishInfo.minimumFishingLevel, avoidGetawayLevel = fishInfo.avoidGetawayLevel, waterType = fishInfo.type})
    end

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

    if hasCoastal and hasInland then
        UIConfig.zoneinfo.coastalInland:SetText(ANGLER_DARK_FONT_COLOR.."Has both |cFF00FF00coastal"..ANGLER_DARK_FONT_COLOR.." and |cFF00FF00inland"..ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasCoastal then
        UIConfig.zoneinfo.coastalInland:SetText(ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00coastal"..ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasInland then
        UIConfig.zoneinfo.coastalInland:SetText(ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00inland"..ANGLER_DARK_FONT_COLOR.." waters.")
    else
        UIConfig.zoneinfo.coastalInland:SetText(ANGLER_DARK_FONT_COLOR.."Has no |cFFFF0000coastal"..ANGLER_DARK_FONT_COLOR.." or |cFFFF0000inland"..ANGLER_DARK_FONT_COLOR.." waters.")
    end

    UIConfig.zoneinfo.fishingLevelMin:SetText(ANGLER_DARK_FONT_COLOR.."Min fishing level "..SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel))
    UIConfig.zoneinfo.fishingLevelMax:SetText(ANGLER_DARK_FONT_COLOR.."Max fishing level "..SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel)..ANGLER_DARK_FONT_COLOR.." (required to catch all fish in this zone)")


    UIConfig.zoneinfo.fishRates:Show()
    for i = 1, #UIConfig.zoneinfo.fishRates.icons do
        local fishIcon = UIConfig.zoneinfo.fishRates.icons[i]
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
end

local function updateFishGrid()
    for i = 1, #UIConfig.fishIcons do
        local fishIcon = UIConfig.fishIcons[i]
        if fishIcon == nil then
            break
        end
        local fishId = fishIcon.fishId
        if fishId ~= nil then
            local fishData = ns.ANGLER_DATA.DATA.fish[fishId]
            if fishData ~= nil then
                if ns.ANGLER_DATA.SKILL.hasFishing then
                    fishIcon.status:Show()
                    if fishData.avoidGetawayLevel <= ns.ANGLER_DATA.SKILL.modLevel then
                        fishIcon.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
                    elseif fishData.avoidGetawayLevel <= ns.ANGLER_DATA.SKILL.modLevel + 75 then
                        fishIcon.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Yellow")
                    else
                        fishIcon.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Red")
                    end
                else
                    fishIcon.status:Hide()
                end
            end
        end
    end
end

local function updateRecipes()
    if ns.ANGLER_DATA.STATE.selectedFish == nil then
        UIConfig.recipies.text:SetText(ANGLER_DARK_FONT_COLOR.."No fish selected")
        for i = 1, #UIConfig.recipies.recipeItems do
            local recipeFrame = UIConfig.recipies.recipeItems[i]
            if recipeFrame == nil then
                break
            end
            recipeFrame:Hide()
        end
        return
    end
    UIConfig.recipies.text:SetText(ANGLER_DARK_FONT_COLOR.."Recipies for "..ns.ANGLER_DATA.STATE.selectedFishData.name)
    for i = 1, #UIConfig.recipies.recipeItems do
        local recipeFrame = UIConfig.recipies.recipeItems[i]
        if recipeFrame == nil then
            break
        end
        local recipeData = ns.ANGLER_DATA.DATA.recipies[ns.ANGLER_DATA.STATE.selectedFish][i]
        if recipeData == nil then
            recipeFrame:Hide()
        else
            recipeFrame:Show()
            recipeFrame:SetRecipe(recipeData)
        end
    end
end

local function selectZone(zoneId, anglerFrame)
    if zoneId == nil then
        UIConfig.selectedZoneHighlight:Hide()

        return  
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    ns.ANGLER_DATA.STATE.selectedZone = zoneId
    
    -- print("Selected zone "..zoneId)
    UIConfig.selectedZoneHighlight:Show()
    UIConfig.selectedZoneHighlight:SetPoint("CENTER", anglerFrame, "CENTER", 0, 0)
    updateZoneList()
    updateZoneInfo()
end

local function selectFish(fishId, anglerFrame)
    if fishId == nil then
        UIConfig.selectedIcon:Hide()
        return
    end
    if ns.ANGLER_DATA.STATE.selectedFish == fishId then
        return
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");  -- Page turn
    PlaySound(1189, "Master") -- Meaty thwack
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    ns.ANGLER_DATA.STATE.selectedFish = fishId
    ns.ANGLER_DATA.STATE.selectedFishData = ns.ANGLER_DATA.DATA.fish[ns.ANGLER_DATA.STATE.selectedFish]
    UIConfig.selectedIcon:Show()
    UIConfig.selectedIcon:SetPoint("CENTER", anglerFrame, "CENTER", 0, 0)

    local zones = getSortedZonesForFish(ns.ANGLER_DATA.STATE.selectedFish)
    -- print("Zones for fish "..fishId)
    -- for i = 1, #zones do
    --     print(zones[i].name)
    -- end
    
    updateFishInfo()
    updateRecipes()
    selectZone(tostring(zones[1].id), UIConfig.zones.zoneButtons[1])

end



UIConfig.fishIcons = {}

local function CreateItemRow(itemIds, uiParent, itemSize, itemPadding)
    -- length of itemIds
    local length = #itemIds

    local width = itemSize * length + itemPadding * (length - 1)
    local stepSize = itemSize + itemPadding

    local row = CreateFrame("Frame", "angler-row", uiParent)
    row:SetSize(width, itemSize)
    row:SetPoint("CENTER", 0, 0)


    row.items = {}
    local stepCursor = -width * 0.5 + itemSize * 0.5
    for i = 1, #itemIds do
        local itemID = itemIds[i]
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
        itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        expacID, setID, isCraftingReagent
            = GetItemInfo(itemID)
        local itemFrame = CreateFrame("BUTTON", "angler-item-"..i, row, "ItemButtonTemplate");
        itemFrame:SetSize(itemSize, itemSize)
        itemFrame:SetPoint("CENTER", stepCursor, 0)
        -- print(itemName.." "..itemTexture.." "..GetItemIcon(itemID))
        itemFrame.texture = itemFrame:CreateTexture('fish-face','ARTWORK', nil, 1)
        -- print(itemFrame.texture)
        itemFrame.texture:SetAllPoints()
        -- itemFrame.texture:SetTexture(GetItemIcon(itemID)) -- replace with icon id of the respective poisons.
        SetItemButtonTexture(itemFrame, GetItemIcon(itemID))
        itemFrame.fishId = itemID

        _G[itemFrame:GetName().."NormalTexture"]:SetSize(itemSize*1.662, itemSize*1.662)

        -- Fish data for this item
        local fishData = ns.ANGLER_DATA.DATA.fish[itemID]
        itemFrame.itemID = itemID
        itemFrame.fishData = fishData

        itemFrame.status = CreateFrame("FRAME", "angler-item-status-"..itemID, itemFrame)
        itemFrame.status:SetSize(16, 16)
        itemFrame.status:SetPoint("BOTTOMLEFT", itemFrame, "BOTTOMLEFT", -6, -6)
        itemFrame.status.texture = itemFrame.status:CreateTexture(nil,'ARTWORK')
        itemFrame.status.texture:SetTexture("Interface\\COMMON\\portrait-ring-withbg")
        itemFrame.status.texture:SetAllPoints()
        itemFrame.status.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        itemFrame.status.indicator = CreateFrame("FRAME", "angler-item-status-indicator-"..itemID, itemFrame.status)
        itemFrame.status.indicator:SetSize(8, 8)
        itemFrame.status.indicator:SetPoint("CENTER", itemFrame.status, "CENTER", 0, 0)
        itemFrame.status.indicator.texture = itemFrame.status.indicator:CreateTexture(nil,'ARTWORK')
        itemFrame.status.indicator.texture:SetAllPoints()
        itemFrame.status.indicator.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)

        -- if fishData.avoidGetawayLevel <= ns.ANGLER_DATA.SKILL.level then
        --     itemFrame.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
        -- elseif fishData.avoidGetawayLevel <= ns.ANGLER_DATA.SKILL.level + 75 then
        --     itemFrame.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Yellow")
        -- else
        --     itemFrame.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Red")
        -- end

        itemFrame:SetScript("OnEnter", function()
            GameTooltip:SetOwner(itemFrame, "ANCHOR_LEFT")
            -- GameTooltip:AddLine(itemFrame.fishData.name)
            GameTooltip:SetItemByID(itemFrame.itemID)
            GameTooltip:Show()
        end)

        itemFrame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        itemFrame:SetScript("OnClick", function()
            selectFish(itemID, itemFrame)
        end)

        table.insert(row.items, itemFrame)
        table.insert(UIConfig.fishIcons, itemFrame)



        stepCursor = stepCursor + stepSize
    end

    return row
end

local function CreateItemGrid(itemIds, uiParent, itemSize, itemPadding, maxColumns, framePadding)
    local length = #itemIds
    local columns = length
    if columns > maxColumns then
        columns = maxColumns
    end 

    local rows = math.ceil(length / maxColumns)

    local width = itemSize * columns + itemPadding * (columns - 1)
    local height = itemSize * rows + itemPadding * (rows - 1)
    local stepSize = itemSize + itemPadding

    local grid = CreateFrame("FRAME", "angler-grid", uiParent, "BackdropTemplate")
    grid:SetBackdrop({
        bgFile = "Interface\\Garrison\\GarrisonUIBackground2", 
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
        tile = true, 
        tileSize = 100, 
        edgeSize = 24, 
        insets = { 
            left = 5, 
            right = 5, 
            top = 5, 
            bottom = 5 
        } 
    });
    grid:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    -- grid:SetBackdropBorderColor(0, 0, 0, 1);
    grid:SetSize(width + (framePadding * 2), height + (framePadding * 2))

    local stepCursorVertical = height * 0.5 - itemSize * 0.5
    local tmpRow = {}
    local counter = 1
    grid.rows = {}
    for i = 1, #itemIds do
        local itemID = itemIds[i]
        table.insert(tmpRow, itemID)
        if counter >= maxColumns or i == #itemIds then
            local row = CreateItemRow(tmpRow, grid, itemSize, itemPadding)
            row:SetPoint("CENTER", 0, stepCursorVertical)
            table.insert(grid.rows, row)
            counter = 0
            stepCursorVertical = stepCursorVertical - stepSize
            tmpRow = {}
        end
        counter = counter + 1
    end
    return grid
end

local function CreateGoldDisplay(uiParent, curencyType)
    local goldDisplay = CreateFrame("FRAME", "angler-gold-display", uiParent, "BackdropTemplate")
    goldDisplay:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", 
        tile = true, 
        tileSize = 24, 
        edgeSize = 8, 
        insets = { 
            left = 3, 
            right = 3, 
            top = 5, 
            bottom = 5 
        } 
    });
    goldDisplay:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    goldDisplay:SetSize(165, 26)
    goldDisplay:SetPoint("CENTER", 0, 0)

    goldDisplay.moneyType = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.moneyType:SetPoint("RIGHT", goldDisplay, "LEFT", -5, 0)
    goldDisplay.moneyType:SetText(curencyType)
    
    goldDisplay.copperIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.copperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")
    goldDisplay.copperIcon:SetSize(14, 14)
    goldDisplay.copperIcon:SetPoint("RIGHT", goldDisplay, "RIGHT", -4, 0)

    goldDisplay.copper = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.copper:SetPoint("RIGHT", goldDisplay.copperIcon, "LEFT", -1, 0)
    goldDisplay.copper:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.copper:SetText("99")

    goldDisplay.silverIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.silverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")
    goldDisplay.silverIcon:SetSize(14, 14)
    goldDisplay.silverIcon:SetPoint("RIGHT", goldDisplay.copper, "LEFT", -4, 0)

    goldDisplay.silver = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.silver:SetPoint("RIGHT", goldDisplay.silverIcon, "LEFT", -1, 0)
    goldDisplay.silver:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.silver:SetText("99")

    goldDisplay.goldIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.goldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")
    goldDisplay.goldIcon:SetSize(14, 14)
    goldDisplay.goldIcon:SetPoint("RIGHT", goldDisplay.silver, "LEFT", -4, 0)

    goldDisplay.gold = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.gold:SetPoint("RIGHT", goldDisplay.goldIcon, "LEFT", -1, 0)
    goldDisplay.gold:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.gold:SetText("9999999")
    goldDisplay.isNegative = false

    goldDisplay.SetGold = function(self, value)
        local fontColor = value < 0 and textColours.red or textColours.white
        if value < 0 then
            value = value * -1
        end
        local gold, silver, copper = splitGold(value)
        if gold <= 0 then
            self.goldIcon:Hide()
            self.gold:Hide()
        else
            self.goldIcon:Show()
            self.gold:Show()
        end
        self.gold:SetText(fontColor..tostring(gold))
        if silver <= 0 and gold <= 0 then
            self.silverIcon:Hide()
            self.silver:Hide()
        else
            self.silverIcon:Show()
            self.silver:Show()
        end
        self.silver:SetText(fontColor..tostring(silver))
        self.copper:SetText(fontColor..tostring(copper))
    end

    return goldDisplay
end

-- sort fish by fishing level
table.sort(validFish, function(a, b)
    if ns.ANGLER_DATA.DATA.fish[a].avoidGetawayLevel == ns.ANGLER_DATA.DATA.fish[b].avoidGetawayLevel then
        return ns.ANGLER_DATA.DATA.fish[a].minimumFishingLevel < ns.ANGLER_DATA.DATA.fish[b].minimumFishingLevel
    end
    return ns.ANGLER_DATA.DATA.fish[a].avoidGetawayLevel < ns.ANGLER_DATA.DATA.fish[b].avoidGetawayLevel
end)

UIConfig.grid = CreateItemGrid(validFish, UIConfig, 42, 6, 3, 15)
UIConfig.grid:SetPoint("TOPLEFT", 10, -70)



UIConfig.info = CreateFrame("FRAME", "angler-fish-info", UIConfig, "BackdropTemplate")
UIConfig.info:SetBackdrop({
    bgFile = "Interface\\FrameGeneral\\UI-Background-Marble",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-TestWatermark-Border",
    tile = true,
    tileSize = 150,
    edgeSize = 16,
    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    } 
})
UIConfig.info:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
UIConfig.info:SetSize(300, 200)
UIConfig.info:SetPoint("TOPLEFT", UIConfig.grid, "TOPRIGHT", 5, 0)

UIConfig.info.name = UIConfig.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info.name:SetPoint("TOPLEFT", UIConfig.info, "TOPLEFT", 55, -16)
UIConfig.info.name:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
-- UIConfig.info.name:SetText("Name")
UIConfig.info.icon = CreateFrame("BUTTON", "angler-fish-info-icon", UIConfig.info, "ItemButtonTemplate")
UIConfig.info.icon:SetSize(42, 42)
UIConfig.info.icon:SetPoint("TOPLEFT", UIConfig.info, "TOPLEFT", 10, -10)

UIConfig.info.icon.texture = UIConfig.info.icon:CreateTexture(nil,'ARTWORK')
UIConfig.info.icon.texture:SetAllPoints()

UIConfig.info.itemLevel = UIConfig.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info.itemLevel:SetPoint("TOPLEFT", UIConfig.info.name, "BOTTOMLEFT", 0, -6)

UIConfig.info.itemStackCount = UIConfig.info.icon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info.itemStackCount:SetPoint("BOTTOMRIGHT", UIConfig.info.icon, "BOTTOMRIGHT", -4, 4)
UIConfig.info.itemStackCount:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

UIConfig.info.goldAuctionPrice = CreateGoldDisplay(UIConfig.info, "Auction unit price")
UIConfig.info.goldAuctionPrice:SetPoint("BOTTOMRIGHT", UIConfig.info, "BOTTOMRIGHT", -8, 8)
UIConfig.info.goldAuctionPrice:Hide()

UIConfig.info.buffFish = CreateFrame("FRAME", "angler-fish-info-buff", UIConfig.info)
UIConfig.info.buffFish:SetSize(30, 30)
UIConfig.info.buffFish:SetPoint("TOPRIGHT", UIConfig.info, "TOPRIGHT", -8, -8)
UIConfig.info.buffFish.texture = UIConfig.info.buffFish:CreateTexture(nil,'ARTWORK')
UIConfig.info.buffFish.texture:SetTexture("Interface\\Icons\\Spell_Misc_Food")
UIConfig.info.buffFish.texture:SetAllPoints()
UIConfig.info.buffFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
UIConfig.info.buffFish:SetScript("OnEnter", function()
    GameTooltip:SetOwner(UIConfig.info.buffFish, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine("This fish can be cooked into a buff food")
    GameTooltip:Show()
end)
UIConfig.info.buffFish:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
UIConfig.info.buffFish:Hide()

UIConfig.info.alchemicFish = CreateFrame("FRAME", "angler-fish-info-alchemic", UIConfig.info)
UIConfig.info.alchemicFish:SetSize(30, 30)
UIConfig.info.alchemicFish:SetPoint("TOPRIGHT", UIConfig.info.buffFish, "BOTTOMRIGHT", 0, -4)
UIConfig.info.alchemicFish.texture = UIConfig.info.alchemicFish:CreateTexture(nil,'ARTWORK')
UIConfig.info.alchemicFish.texture:SetTexture("Interface\\Icons\\INV_Potion_93")
UIConfig.info.alchemicFish.texture:SetAllPoints()
UIConfig.info.alchemicFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
UIConfig.info.alchemicFish:SetScript("OnEnter", function()
    GameTooltip:SetOwner(UIConfig.info.alchemicFish, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine("This fish is used by alchemists")
    GameTooltip:Show()
end)
UIConfig.info.alchemicFish:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
UIConfig.info.alchemicFish:Hide()

UIConfig.info.levelText = UIConfig.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info.levelText:SetPoint("TOPLEFT", UIConfig.info.icon, "BOTTOMLEFT", 0, -10)
UIConfig.info.levelText:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")
-- UIConfig.info.levelText:SetText("Min fishing level "..SkillLevelColor(1).."1|cFFFFFFFF, optimal fishing level "..SkillLevelColor(455).."455")

UIConfig.info.waterType = UIConfig.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.info.waterType:SetPoint("TOPLEFT", UIConfig.info.levelText, "BOTTOMLEFT", 0, -5)
UIConfig.info.waterType:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

UIConfig.info.requirements = {}
local reqOffset = -15
for i = 1, 2 do
    local text = UIConfig.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", UIConfig.info.waterType, "BOTTOMLEFT", 0, reqOffset)
    reqOffset = reqOffset - 30
    text:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")
    text:SetWordWrap(true)
    text:SetWidth(280)
    text:SetJustifyH("LEFT")
    -- text:SetSpacing(10)
    
    -- text:SetText("Requirement "..i) 
    table.insert(UIConfig.info.requirements, text)
end


UIConfig.zones = CreateFrame("FRAME", "angler-fish-info", UIConfig, "BackdropTemplate")
UIConfig.zones:SetBackdrop({
    -- bgFile = "Interface\\AdventureMap\\AdventureMapParchmentTile", 
    bgFile = "Interface\\BankFrame\\Bank-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 160,
    edgeSize = 24,
    insets = {
        left = 5,
        right = 5,
        top = 2,
        bottom = 2
    }
})
UIConfig.zones:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
UIConfig.zones:SetSize(300, 203)
UIConfig.zones:SetPoint("TOPLEFT", UIConfig.info, "BOTTOMLEFT", 0, -5)

UIConfig.zones.scrollFrame = CreateFrame("ScrollFrame", nil, UIConfig.zones, "UIPanelScrollFrameTemplate")
UIConfig.zones.scrollFrame:SetPoint("TOPLEFT", 10, -10)
UIConfig.zones.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 8)

UIConfig.zones.scrollFrame.scrollChild = CreateFrame("Frame")
UIConfig.zones.scrollFrame:SetScrollChild(UIConfig.zones.scrollFrame.scrollChild)
UIConfig.zones.scrollFrame.scrollChild:SetWidth(260)
UIConfig.zones.scrollFrame.scrollChild:SetHeight(#validZones * 30)  -- 50 is the height of each button

UIConfig.zones.zoneButtons = {}

for i = 1, #validZones do
    local zone = ns.ANGLER_DATA.DATA.zones[validZones[i]]
    local zoneButton = CreateFrame("BUTTON", "angler-zone-button-"..i, UIConfig.zones.scrollFrame.scrollChild, "UIPanelButtonTemplate")
    zoneButton:SetSize(250, 30)
    zoneButton:SetPoint("TOP", UIConfig.zones.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 30)
    zoneButton:SetScript("OnClick", function()
        selectZone(zoneButton.zoneId, zoneButton)
    end)

    zoneButton.name = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneButton.name:SetPoint("LEFT", zoneButton, "LEFT", 10, 0)
    zoneButton.name:SetFont("Fonts\\FRIZQT__.ttf", 10)
    -- zoneButton.name:SetText(zone.name)

    -- zoneButton.zoneLevel = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    -- zoneButton.zoneLevel:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
    -- zoneButton.zoneLevel:SetFont("Fonts\\FRIZQT__.ttf", 10)
    -- zoneButton.zoneLevel:SetText(SkillLevelColor(zone.fishingLevel)..tostring(zone.fishingLevel))

    zoneButton.zoneCatchRate = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneButton.zoneCatchRate:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
    zoneButton.zoneCatchRate:SetFont("Fonts\\FRIZQT__.ttf", 10)
    --zoneButton.zoneCatchRate:SetText(textColours.white..tostring("50%"))

    function zoneButton:SetZone(zoneId, name, catchRate, level)
        self.zoneId = zoneId
        self.name:SetText(name)
        self.zoneCatchRate:SetText(catchRate)
        -- self.zoneLevel:SetText(level)
    end
    zoneButton:Hide()

    UIConfig.zones.zoneButtons[i] = zoneButton

end


UIConfig.zoneinfo = CreateFrame("FRAME", "angler-zone-info", UIConfig, "BackdropTemplate")
-- UIConfig.zoneinfo:SetBackdrop({
--     bgFile = "Interface\\FrameGeneral\\UI-Background-Marble", 
--     edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border", 
--     tile = true, 
--     tileSize = 200, 
--     edgeSize = 8, 
--     insets = { 
--         left = 3, 
--         right = 3, 
--         top = 1, 
--         bottom = 1 
--     } 
-- })
local backdrop = CopyTable(BACKDROP_ACHIEVEMENTS_0_64)
backdrop.bgFile = "Interface\\AdventureMap\\AdventureMapParchmentTile"
backdrop.insets = { left = 24, right = 24, top = 22, bottom = 24 }
UIConfig.zoneinfo:SetBackdrop(backdrop)

UIConfig.zoneinfo:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
UIConfig.zoneinfo:SetSize(300, 408)
UIConfig.zoneinfo:SetPoint("TOPLEFT", UIConfig.info, "TOPRIGHT", 5, 0)

UIConfig.zoneinfo.name = UIConfig.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.zoneinfo.name:SetPoint("TOPLEFT", UIConfig.zoneinfo, "TOPLEFT", 28, -30)
UIConfig.zoneinfo.name:SetFont("Fonts\\FRIZQT__.ttf", 18)
-- UIConfig.zoneinfo.name:SetText("Zone name")

UIConfig.zoneinfo.coastalInland = UIConfig.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.zoneinfo.coastalInland:SetPoint("TOPLEFT", UIConfig.zoneinfo.name, "BOTTOMLEFT", 0, -12)
UIConfig.zoneinfo.coastalInland:SetFont("Fonts\\FRIZQT__.ttf", 12)
UIConfig.zoneinfo.coastalInland:SetWordWrap(true)
UIConfig.zoneinfo.coastalInland:SetWidth(250)
UIConfig.zoneinfo.coastalInland:SetJustifyH("LEFT")
-- UIConfig.zoneinfo.coastalInland:SetText("Has coastal and inland fishing")

UIConfig.zoneinfo.fishingLevelMin = UIConfig.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.zoneinfo.fishingLevelMin:SetPoint("TOPLEFT", UIConfig.zoneinfo.coastalInland, "BOTTOMLEFT", 0, -7)
UIConfig.zoneinfo.fishingLevelMin:SetFont("Fonts\\FRIZQT__.ttf", 12)
UIConfig.zoneinfo.fishingLevelMin:SetWordWrap(true)
UIConfig.zoneinfo.fishingLevelMin:SetWidth(250)
UIConfig.zoneinfo.fishingLevelMin:SetJustifyH("LEFT")

UIConfig.zoneinfo.fishingLevelMax = UIConfig.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.zoneinfo.fishingLevelMax:SetPoint("TOPLEFT", UIConfig.zoneinfo.fishingLevelMin, "BOTTOMLEFT", 0, -7)
UIConfig.zoneinfo.fishingLevelMax:SetFont("Fonts\\FRIZQT__.ttf", 12)
UIConfig.zoneinfo.fishingLevelMax:SetWordWrap(true)
UIConfig.zoneinfo.fishingLevelMax:SetWidth(250)
UIConfig.zoneinfo.fishingLevelMax:SetJustifyH("LEFT")

UIConfig.zoneinfo.notes = UIConfig.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.zoneinfo.notes:SetPoint("TOPLEFT", UIConfig.zoneinfo.fishingLevelMax, "BOTTOMLEFT", 0, -7)
UIConfig.zoneinfo.notes:SetFont("Fonts\\FRIZQT__.ttf", 12)
UIConfig.zoneinfo.notes:SetWordWrap(true)
UIConfig.zoneinfo.notes:SetWidth(250)
UIConfig.zoneinfo.notes:SetJustifyH("LEFT")


local function buildZoneInfoUI(parent)
    parent.fishRates = CreateFrame("FRAME", "angler-zone-info-fish", parent, "BackdropTemplate") 
    parent.fishRates:SetBackdrop({
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
    parent.fishRates:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    parent.fishRates:SetSize(50, 408)
    parent.fishRates:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
    parent.fishRates.icons = {}
    for i = 1, 10 do
        local fishIcon = CreateFrame("BUTTON", "angler-zone-info-fish-icon-"..i, parent.fishRates, "ItemButtonTemplate")
        fishIcon:SetSize(37, 37)
        fishIcon:SetPoint("TOP", parent.fishRates, "TOP", 0, -6 - (i - 1) * 39)
        fishIcon:SetScript("OnClick", function()
            selectFish(nil, fishIcon)
        end)
        fishIcon.texture = fishIcon:CreateTexture(nil,'ARTWORK')
        fishIcon.texture:SetAllPoints()
        -- fishIcon:Hide()

        _G[fishIcon:GetName().."NormalTexture"]:SetSize(37*1.662, 37*1.662)

        -- Rate text
        fishIcon.rate = fishIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fishIcon.rate:SetPoint("BOTTOM", fishIcon, "BOTTOM", 0, 0)
        fishIcon.rate:SetFont("Fonts\\FRIZQT__.ttf", 14, "OUTLINE")
        fishIcon.rate:SetText("|cFF00FF00"..tostring(50).."%")

        fishIcon.data = {}
        fishIcon.data.name = "Fish name"
        fishIcon.data.rate = 0.5

        function fishIcon:SetFish(fishId, rate)
            fishIcon.data.name = ns.ANGLER_DATA.DATA.fish[fishId].name
            fishIcon.data.rate = rate
            fishIcon.data.id = fishId
            fishIcon.texture:SetTexture(GetItemIcon(fishId))
            fishIcon.rate:SetText(CatchRateColor(rate)..tostring(rate*100).."%")
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




        parent.fishRates.icons[i] = fishIcon
    end
    parent.fishRates:Hide()
end

buildZoneInfoUI(UIConfig.zoneinfo)




UIConfig.infoTabButtons = {}
UIConfig.infoTabs = {}
UIConfig.selectedTab = "default"

local function TabButton_selectTab(tabName)
    if UIConfig.selectedTab == tabName then
        return
    end
    -- print("Selecting tab "..tabName)
    for k, v in pairs(UIConfig.infoTabs) do
        if k == tabName then
            v:Show()
            if UIConfig.infoTabButtons[k] ~= nil then
                UIConfig.infoTabButtons[k]:SetSelected(true)
            end

        else
            v:Hide()
            if UIConfig.infoTabButtons[k] ~= nil then
                UIConfig.infoTabButtons[k]:SetSelected(false)
            end
        end
    end
    UIConfig.selectedTab = tabName
end


local function CreateTabButton(tabName, parent, tabSelectedText, tabDeselectedText)
    local tabButton = CreateFrame("BUTTON", "angler-tab-button-"..#UIConfig.infoTabButtons+1, parent, "UIPanelButtonTemplate")
    tabButton:SetSize(120, 20)
    tabButton.tabName = tabName
    tabButton.selected = false
    tabButton:SetText(tabSelectedText)
    tabButton.highlightTexture = tabButton:CreateTexture(nil,'ARTWORK')
    tabButton.highlightTexture:SetTexture("Interface\\UNITPOWERBARALT\\MetalBronze_Horizontal_Frame")
    tabButton.highlightTexture:SetSize(154, 35)
    tabButton.highlightTexture:SetPoint("CENTER", 0, 0)
    -- tabButton.highlightTexture:SetBlendMode("ADD")
    tabButton.highlightTexture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    tabButton.highlightTexture:Hide()
    tabButton:SetScript("OnClick", function()
        if tabButton.selected then
            TabButton_selectTab("default")
            return
        end
        TabButton_selectTab(tabButton.tabName)
    end)
    function tabButton:SetSelected(val)
        if val then
            self.selected = true
            self:SetText(tabDeselectedText)
            self.highlightTexture:Show()
        else
            self.selected = false
            self:SetText(tabSelectedText)
            self.highlightTexture:Hide()
        end
    end
    
    return tabButton
end


local function RegisterTab(tabName, tabButton, tabFrame)
    UIConfig.infoTabs[tabName] = tabFrame
    UIConfig.infoTabButtons[tabName] = tabButton
end


UIConfig.recipies = CreateFrame("FRAME", "angler-recipies-info", UIConfig, "BackdropTemplate")
UIConfig.recipies:Raise()
UIConfig.recipies:SetBackdrop(backdrop)
UIConfig.recipies:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
UIConfig.recipies:SetSize(355, 408)
UIConfig.recipies:SetPoint("TOPLEFT", UIConfig.zoneinfo, "TOPLEFT", 0, 0)
UIConfig.recipies:Hide()
-- On show hide
UIConfig.recipies:SetScript("OnShow", function()
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
end)
UIConfig.recipies:SetScript("OnHide", function()
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
end)



UIConfig.recipies.text = UIConfig.recipies:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
UIConfig.recipies.text:SetPoint("TOPLEFT", UIConfig.recipies, "TOPLEFT", 28, -25)
UIConfig.recipies.text:SetFont("Fonts\\FRIZQT__.ttf", 14)
UIConfig.recipies.text:SetText(ANGLER_DARK_FONT_COLOR.."Recipies for Raw Longjaw Mud Snapper")

UIConfig.recipies.scrollFrame = CreateFrame("ScrollFrame", nil, UIConfig.recipies, "UIPanelScrollFrameTemplate")
UIConfig.recipies.scrollFrame:SetPoint("TOPLEFT", 25, -43)
UIConfig.recipies.scrollFrame:SetPoint("BOTTOMRIGHT", -45, 25)

UIConfig.recipies.scrollFrame.scrollChild = CreateFrame("Frame")
UIConfig.recipies.scrollFrame:SetScrollChild(UIConfig.recipies.scrollFrame.scrollChild)
UIConfig.recipies.scrollFrame.scrollChild:SetWidth(280)
UIConfig.recipies.scrollFrame.scrollChild:SetHeight(510)  -- 100 is the height of each panel (5 panels) + padding

UIConfig.recipies.recipeItems = {}
for i = 1, 5 do
    local recipeItem = CreateFrame("FRAME", "angler-recipe-item-"..i, UIConfig.recipies.scrollFrame.scrollChild, "BackdropTemplate")
    local bd = CopyTable(BACKDROP_TEXT_PANEL_0_16)
    bd.bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"
    bd.insets = { left = 3, right = 3, top = 3, bottom = 3 }
    
    recipeItem:SetBackdrop(bd)
    recipeItem:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    recipeItem:SetSize(270, 100)
    recipeItem:SetPoint("TOP", UIConfig.recipies.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 102)

    recipeItem.data = {}
    recipeItem.data.recipeName = "Blackmouth Oil"
    recipeItem.data.productId = "6370"
    recipeItem.data.productQ = 1
    recipeItem.data.reagents = {}
    recipeItem.data.recipeItemId = "6661"

    recipeItem.productIcon = CreateFrame("BUTTON", "angler-recipe-product-icon-"..i, recipeItem, "ItemButtonTemplate")
    recipeItem.productIcon:SetSize(40, 40)
    recipeItem.productIcon:SetPoint("TOPLEFT", recipeItem, "TOPLEFT", 8, -6)
    -- recipeItem.productIcon:Hide()
    _G[recipeItem.productIcon:GetName().."NormalTexture"]:SetSize(40*1.662, 40*1.662)
    SetItemButtonTexture(recipeItem.productIcon, GetItemIcon(recipeItem.data.productId))

    recipeItem.productIcon.productQuantity = recipeItem.productIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    recipeItem.productIcon.productQuantity:SetPoint("BOTTOMRIGHT", recipeItem.productIcon, "BOTTOMRIGHT", -4, 4)
    recipeItem.productIcon.productQuantity:SetFont("Fonts\\FRIZQT__.ttf", 12    , "OUTLINE")
    recipeItem.productIcon.productQuantity:SetText("x1")

    -- Tooltip
    recipeItem.productIcon:SetScript("OnEnter", function()
        GameTooltip:SetOwner(recipeItem.productIcon, "ANCHOR_LEFT", 0, 0)
        GameTooltip:SetItemByID(recipeItem.data.productId)
        GameTooltip:Show()
    end)

    recipeItem.productIcon:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    recipeItem.recipeIcon = CreateFrame("BUTTON", "angler-recipe-icon-"..i, recipeItem, "ItemButtonTemplate")
    recipeItem.recipeIcon:SetSize(20, 20)
    recipeItem.recipeIcon:SetPoint("TOP", recipeItem.productIcon, "BOTTOM", 0, -5)
    SetItemButtonTexture(recipeItem.recipeIcon, GetItemIcon(recipeItem.data.recipeItemId))
    -- recipeItem.recipeIcon:Hide()
    _G[recipeItem.recipeIcon:GetName().."NormalTexture"]:SetSize(20*1.662, 20*1.662)

    -- Tooltip
    recipeItem.recipeIcon:SetScript("OnEnter", function()
        GameTooltip:SetOwner(recipeItem.recipeIcon, "ANCHOR_LEFT", 0, 0)
        GameTooltip:SetItemByID(recipeItem.data.recipeItemId)
        GameTooltip:Show()
    end)

    recipeItem.recipeIcon:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    recipeItem.productName = recipeItem:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    recipeItem.productName:SetPoint("TOPLEFT", recipeItem.productIcon, "TOPRIGHT", 5, -5)
    recipeItem.productName:SetFont("Fonts\\FRIZQT__.ttf", 12)
    recipeItem.productName:SetText(recipeItem.data.recipeName)

    recipeItem.craftValueGoldDisplay = CreateGoldDisplay(recipeItem, "Unit price")
    recipeItem.craftValueGoldDisplay:SetPoint("BOTTOMRIGHT", recipeItem, "BOTTOMRIGHT", -5, 4)
    recipeItem.craftValueGoldDisplay:SetGold(11111)
    

    recipeItem.reagents = {}

    for j = 1, 5 do
        local reagent = CreateFrame("BUTTON", "angler-recipe-reagent-"..i.."-"..j, recipeItem, "ItemButtonTemplate")
        reagent:SetSize(28, 28)
        reagent:SetPoint("TOPLEFT", recipeItem.productName, "BOTTOMLEFT", 10 + (j - 1) * 31, -6)
        reagent:SetScript("OnClick", function()
            selectFish(nil, reagent)
        end)
        SetItemButtonTexture(reagent, GetItemIcon(recipeItem.data.productId))
        -- reagent:Hide()
        _G[reagent:GetName().."NormalTexture"]:SetSize(28*1.662, 28*1.662)

        reagent.reagentQuantity = reagent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        reagent.reagentQuantity:SetPoint("BOTTOMRIGHT", reagent, "BOTTOMRIGHT", -3, 3)
        reagent.reagentQuantity:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
        reagent.reagentQuantity:SetText("x1")

        recipeItem.reagents[j] = reagent

        reagent.data = {}
        reagent.data.itemId = "6370"
        reagent.data.itemQ = 1
        function reagent:SetReagent(reagentData)
            reagent.data = reagentData
            SetItemButtonTexture(reagent, GetItemIcon(reagent.data.itemId))
            reagent.reagentQuantity:SetText("x"..tostring(reagent.data.itemQ))
        end

        -- Tooltip
        reagent:SetScript("OnEnter", function()
            GameTooltip:SetOwner(reagent, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(reagent.data.itemId)
            GameTooltip:Show()
        end)

        reagent:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    function recipeItem:SetRecipe(recipeData)
        self.data = recipeData
        self.productName:SetText(recipeData.recipeName)
        SetItemButtonTexture(self.productIcon, GetItemIcon(recipeData.productId))
        if recipeData.recipeItemId == nil then
            self.recipeIcon:Hide()
        else
            self.recipeIcon:Show()
            SetItemButtonTexture(self.recipeIcon, GetItemIcon(recipeData.recipeItemId))
        end
        self.productIcon.productQuantity:SetText("x"..tostring(recipeData.productQ))
        for j = 1, 5 do
            if recipeData.reagents[j] ~= nil then
                self.reagents[j]:SetReagent(recipeData.reagents[j])
                self.reagents[j]:Show()
            else
                self.reagents[j]:Hide()
            end
        end

        if Auctionator ~= nil then
            local auctionPrice = Auctionator.Database:GetPrice(tostring(recipeData.productId))
            if auctionPrice ~= nil then
                self.craftValueGoldDisplay:SetGold(auctionPrice)
                self.craftValueGoldDisplay:Show()
            else
                self.craftValueGoldDisplay:Hide()
            end

        end
    end

    UIConfig.recipies.recipeItems[i] = recipeItem
end

local equipmentUID = 1
local function buildEquipmentRow(parent, equipmentHeader, equipmentData)
    local equipmentRow = CreateFrame("FRAME", "angler-equipment-row-"..equipmentUID, parent)
    equipmentUID = equipmentUID + 1
    equipmentRow:SetSize(280, 65)

    equipmentRow.name = equipmentRow:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    equipmentRow.name:SetPoint("TOPLEFT", equipmentRow, "TOPLEFT", 0, 0)
    equipmentRow.name:SetFont("Fonts\\FRIZQT__.ttf", 15)
    equipmentRow.name:SetText(equipmentHeader)

    local prevAnchor = nil
    equipmentRow.items = {}
    for i = 1, #equipmentData do
        local data = equipmentData[i]
        local equipmentItem = CreateFrame("BUTTON", "angler-equipment-item-"..tostring(data.id), equipmentRow, "ItemButtonTemplate")
        equipmentItem:SetSize(37, 37)
        if prevAnchor == nil then
            equipmentItem:SetPoint("BOTTOMLEFT", equipmentRow, "BOTTOMLEFT", 1, 1)
        else
            equipmentItem:SetPoint("TOPLEFT", prevAnchor, "TOPRIGHT", 5, 0)
        end
        SetItemButtonTexture(equipmentItem, GetItemIcon(tostring(data.id)))
        _G[equipmentItem:GetName().."NormalTexture"]:SetSize(37*1.662, 37*1.662)
        -- Tooltip
        equipmentItem:SetScript("OnEnter", function()
            GameTooltip:SetOwner(equipmentItem, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(tostring(data.id))
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(data.desc)
            GameTooltip:Show()
        end)
        equipmentItem:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        prevAnchor = equipmentItem
        equipmentRow.items[i] = equipmentItem
    end

    return equipmentRow
end

UIConfig.equipment = CreateFrame("FRAME", "angler-equipment-info", UIConfig, "BackdropTemplate")
UIConfig.equipment:Raise()
UIConfig.equipment:SetBackdrop(BACKDROP_GOLD_DIALOG_32_32)
UIConfig.equipment:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
UIConfig.equipment:SetSize(355, 408)
UIConfig.equipment:SetPoint("TOPLEFT", UIConfig.zoneinfo, "TOPLEFT", 0, 0)
UIConfig.equipment:Hide()
-- On show hide
UIConfig.equipment:SetScript("OnShow", function()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
end)
UIConfig.equipment:SetScript("OnHide", function()
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
end)

UIConfig.equipment.gear = buildEquipmentRow(UIConfig.equipment, "Gear", ns.ANGLER_DATA.DATA.equipment.gear)
UIConfig.equipment.gear:SetPoint("TOPLEFT", UIConfig.equipment, "TOPLEFT", 25, -25)

UIConfig.equipment.rods = buildEquipmentRow(UIConfig.equipment, "Rods", ns.ANGLER_DATA.DATA.equipment.rods)
UIConfig.equipment.rods:SetPoint("TOPLEFT", UIConfig.equipment.gear, "BOTTOMLEFT", 0, -20)

UIConfig.equipment.lures = buildEquipmentRow(UIConfig.equipment, "Lures", ns.ANGLER_DATA.DATA.equipment.lures)
UIConfig.equipment.lures:SetPoint("TOPLEFT", UIConfig.equipment.rods, "BOTTOMLEFT", 0, -20)

UIConfig.equipment.other = buildEquipmentRow(UIConfig.equipment, "Other", ns.ANGLER_DATA.DATA.equipment.other)
UIConfig.equipment.other:SetPoint("TOPLEFT", UIConfig.equipment.lures, "BOTTOMLEFT", 0, -20)

UIConfig.recipiesToggleButton = CreateTabButton("recipies", UIConfig, "Recipies", "Recipies")
UIConfig.recipiesToggleButton:SetPoint("TOPRIGHT", UIConfig, "TOPRIGHT", -18, -45)

UIConfig.equipmentToggleButton = CreateTabButton("equipment", UIConfig, "Equipment", "Equipment")
UIConfig.equipmentToggleButton:SetPoint("RIGHT", UIConfig.recipiesToggleButton, "LEFT", -5, 0)

RegisterTab('default', nil, UIConfig.zoneinfo)
RegisterTab('recipies', UIConfig.recipiesToggleButton, UIConfig.recipies)
RegisterTab('equipment', UIConfig.equipmentToggleButton, UIConfig.equipment)


UIConfig.selectedIcon = CreateFrame("FRAME", "angler-grid-selected-icon", UIConfig.grid.rows[1].items[1])
UIConfig.selectedIcon:SetSize(37, 37)
UIConfig.selectedIcon:SetPoint("CENTER", 0, 0)

UIConfig.selectedIcon.texture = UIConfig.selectedIcon:CreateTexture(nil,'ARTWORK')
UIConfig.selectedIcon.texture:SetTexture("Interface\\Store\\store-item-highlight")
UIConfig.selectedIcon.texture:SetSize(64, 64)
UIConfig.selectedIcon.texture:SetPoint("CENTER", 0, 0)
UIConfig.selectedIcon.texture:SetBlendMode("ADD")
UIConfig.selectedIcon:Hide()

UIConfig.selectedZoneHighlight = CreateFrame("FRAME", "angler-zone-selected-icon", UIConfig.zones.zoneButtons[1])
UIConfig.selectedZoneHighlight:SetSize(250, 30)
UIConfig.selectedZoneHighlight:SetPoint("CENTER", 0, 0)

UIConfig.selectedZoneHighlight.texture = UIConfig.selectedZoneHighlight:CreateTexture(nil,'ARTWORK')
UIConfig.selectedZoneHighlight.texture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
UIConfig.selectedZoneHighlight.texture:SetSize(380, 34)
UIConfig.selectedZoneHighlight.texture:SetPoint("CENTER", 0, 0)
UIConfig.selectedZoneHighlight.texture:SetBlendMode("ADD")
UIConfig.selectedZoneHighlight:Hide()

function UIConfig:Reload()
    ns.ANGLER_DATA:loadPlayerData()
    if ns.ANGLER_DATA.SKILL.hasFishing then
        local skillMod = ns.ANGLER_DATA.SKILL.skillModifier > 0 and "(|cFF00FF00+"..ns.ANGLER_DATA.SKILL.skillModifier.."|cFFFFFFFF) " or ""
        UIConfig.playerInfo:SetText("level "..ns.ANGLER_DATA.SKILL.level.." "..skillMod..ns.ANGLER_DATA.SKILL.rankName.." angler")
    else
        UIConfig.playerInfo:SetText("needs to find a fishing trainer")
    end
    updateFishGrid()
    updateFishInfo()
    updateZoneList()
    updateZoneInfo()
end

function UIConfig:ReloadAll()
    UIConfig:Reload()
    -- TabButton_selectTab("recipies")
    updateRecipes()
    SetPortraitTexture(UIConfig.characterPortrait.texture, "player");
    UIConfig.playerName:SetText(ns.ANGLER_DATA.PLAYER.name)
end

local function init()
    -- printGreeting()
    
    selectFish(nil)
    -- UIConfig:Show()
end

init()

