
local textColours = {
    ['green'] = "|cFF00FF00",
    ['red'] = "|cFFFF0000",
    ['white'] = "|cFFFFFFFF",
    ['yellow'] = "|cFFFFFF00",
    ['grey'] = "|cFF888888",
}

function AnglerAtlas.UI:SkillLevelColor(lvl)
    if AnglerAtlas.SKILL.hasFishing then
        local pLvl = AnglerAtlas.SKILL.modLevel
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

function AnglerAtlas.UI:CatchRateColor(rate)
    if rate <= 0.10 then
        return textColours.red
    elseif rate <= 0.3333 then
        return textColours.yellow
    else
        return textColours.green
    end
end

function AnglerAtlas:SplitGold(sourceValue)
    local gold = math.floor(sourceValue / 10000)
    local silver = math.floor((sourceValue - (gold * 10000)) / 100)
    local copper = sourceValue - (gold * 10000) - (silver * 100)
    return gold, silver, copper
end

function AnglerAtlas.UI:ReloadAll()
    AnglerAtlas.UI:Reload()
    -- TabButton_selectTab("recipes")
    AnglerAtlas.UI:UpdateRecipes()
    SetPortraitTexture(AnglerAtlas.UI.characterPortrait.texture, "player");
    AnglerAtlas.UI.playerName:SetText(AnglerAtlas.PLAYER.name)
end


function AnglerAtlas.UI:UpdateFishInfo()
    if AnglerAtlas.STATE.selectedFish == nil then
        AnglerAtlas.UI.info.name:SetText("No fish selected")
        AnglerAtlas.UI.info.icon.texture:SetTexture(nil)
        AnglerAtlas.UI.info.itemLevel:SetText("")
        AnglerAtlas.UI.info.itemStackCount:SetText("")
        -- AnglerAtlas.UI.info.goldSellPrice:Hide()
        AnglerAtlas.UI.info.goldAuctionPrice:Hide()
        return
    end
    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
    itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
    expacID, setID, isCraftingReagent
        = GetItemInfo(AnglerAtlas.STATE.selectedFish)

    local fishData = AnglerAtlas.DATA.fish[AnglerAtlas.STATE.selectedFish]

    AnglerAtlas.UI.info.name:SetText(itemName)
    AnglerAtlas.UI.info.icon.texture:SetTexture(itemTexture)
    local levelColour = AnglerAtlas.PLAYER.level >= itemLevel and textColours.white or textColours.red
    AnglerAtlas.UI.info.itemLevel:SetText(levelColour.."Requires Level "..itemLevel)
    AnglerAtlas.UI.info.itemStackCount:SetText(itemStackCount)
    -- AnglerAtlas.UI.info.goldSellPrice:SetGold(sellPrice)
    -- AnglerAtlas.UI.info.goldSellPrice:Show()
    if Auctionator ~= nil then
        local auctionPrice = Auctionator.Database:GetPrice(tostring(AnglerAtlas.STATE.selectedFish))
        if auctionPrice ~= nil then
            AnglerAtlas.UI.info.goldAuctionPrice:SetGold(auctionPrice)
            AnglerAtlas.UI.info.goldAuctionPrice:Show()
        else
            AnglerAtlas.UI.info.goldAuctionPrice:Hide()
        end
    else
        -- print("Auctionator not loaded")
        AnglerAtlas.UI.info.goldAuctionPrice:Hide()
    end

    local isBuffFish = fishData.isBuffFish ~= nil and fishData.isBuffFish == true
    local isAlchemicFish = fishData.isAlchemicFish ~= nil and fishData.isAlchemicFish == true

    if isBuffFish then
        AnglerAtlas.UI.info.buffFish:Show()
    else
        AnglerAtlas.UI.info.buffFish:Hide()
    end

    if isAlchemicFish then
        AnglerAtlas.UI.info.alchemicFish:Show()
    else
        AnglerAtlas.UI.info.alchemicFish:Hide()
    end

    
    AnglerAtlas.UI.info.levelText:SetText("Min fishing level "..AnglerAtlas.UI:SkillLevelColor(fishData.minimumFishingLevel)..tostring(fishData.minimumFishingLevel).."|cFFFFFFFF, optimal fishing level "..AnglerAtlas.UI:SkillLevelColor(fishData.avoidGetawayLevel)..tostring(fishData.avoidGetawayLevel))

    local waterType = ""
    if fishData.type == "C" then
        waterType = "Can be caught in |cFF00FF00coastal|cFFFFFFFF waters."
    elseif fishData.type == "I" then
        waterType = "Can be caught in |cFF00FF00inland|cFFFFFFFF waters."
    else
        waterType = ""
    end
    AnglerAtlas.UI.info.waterType:SetText(waterType)

    if fishData.requirements ~= nil then
        for i = 1, #fishData.requirements do
            local req = fishData.requirements[i]
            local font = AnglerAtlas.UI.info.requirements[i]
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
        for i = 1, #AnglerAtlas.UI.info.requirements do
            local font = AnglerAtlas.UI.info.requirements[i]
            if font == nil then
                break
            end
            font:Hide()
        end
    end
    -- AnglerAtlas.UI.info.requirements
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

function AnglerAtlas.UI:UpdateZoneList()
    if AnglerAtlas.STATE.selectedFish == nil then
        AnglerAtlas.UI.zones.scrollFrame:Hide()
        return
    end
    if AnglerAtlas.STATE.selectedZone == nil then
        AnglerAtlas.UI.zones.scrollFrame:Hide()
        return
    end
    AnglerAtlas.UI.zones.scrollFrame:Show()
    -- local fishId = AnglerAtlas.STATE.selectedFish
    -- local fishInfo = AnglerAtlas.DATA.fish[fishId]
    -- local fishStats = AnglerAtlas.DATA.zones[AnglerAtlas.STATE.selectedZone].fishStats[fishId]
    local sortedZones = AnglerAtlas:GetSortedZonesForFish(AnglerAtlas.STATE.selectedFish)
    for i = 1, #AnglerAtlas.UI.zones.zoneButtons do
        local zoneButton = AnglerAtlas.UI.zones.zoneButtons[i]
        if zoneButton == nil then
            break
        end
        local zoneData = sortedZones[i]
        if zoneData == nil then
            zoneButton:Hide()
        else
            zoneButton:Show()

            local zoneNameText = zoneData.name
            local zoneCatchRateText = AnglerAtlas.UI:CatchRateColor(zoneData.fishStats[AnglerAtlas.STATE.selectedFish].catchChance)..tostring(zoneData.fishStats[AnglerAtlas.STATE.selectedFish].catchChance*100).."%"
            local zoneFishingLevelText = AnglerAtlas.UI:SkillLevelColor(zoneData.fishingLevel)..tostring(zoneData.fishingLevel)

            -- print(zoneNameText)
            -- print(zoneCatchRateText)
            -- print(zoneFishingLevelText)
            zoneButton:SetZone(tostring(zoneData.id), zoneNameText, zoneCatchRateText, "")
        end
        
    end
    AnglerAtlas.UI.zones.scrollFrame.scrollChild:SetHeight(#sortedZones * 30 + 20)
    
    AnglerAtlas.UI.zones.scrollFrame:Show()
end

function AnglerAtlas.UI:UpdateZoneInfo()
    if AnglerAtlas.STATE.selectedZone == nil then
        AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText("")
        AnglerAtlas.UI.zoneinfo.fishRates:Hide()
        return
    end
    local zoneData = AnglerAtlas.DATA.zones[AnglerAtlas.STATE.selectedZone]
    if zoneData == nil then
        AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText("")
        AnglerAtlas.UI.zoneinfo.fishRates:Hide()
        return
    end
    AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR..zoneData.name)
    
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
        local fishInfo = AnglerAtlas.DATA.fish[fish.id]
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
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has both |cFF00FF00coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." and |cFF00FF00inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasCoastal then
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasInland then
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    else
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has no |cFFFF0000coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." or |cFFFF0000inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    end

    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Min fishing level "..AnglerAtlas.UI:SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel))
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Max fishing level "..AnglerAtlas.UI:SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel)..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." (required to catch all fish in this zone)")


    AnglerAtlas.UI.zoneinfo.fishRates:Show()
    for i = 1, #AnglerAtlas.UI.zoneinfo.fishRates.icons do
        local fishIcon = AnglerAtlas.UI.zoneinfo.fishRates.icons[i]
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

function AnglerAtlas.UI:UpdateFishGrid()
    for i = 1, #AnglerAtlas.UI.fishIcons do
        local fishIcon = AnglerAtlas.UI.fishIcons[i]
        if fishIcon == nil then
            break
        end
        local fishId = fishIcon.fishId
        if fishId ~= nil then
            local fishData = AnglerAtlas.DATA.fish[fishId]
            if fishData ~= nil then
                if AnglerAtlas.SKILL.hasFishing then
                    fishIcon.status:Show()
                    if fishData.avoidGetawayLevel <= AnglerAtlas.SKILL.modLevel then
                        fishIcon.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
                    elseif fishData.avoidGetawayLevel <= AnglerAtlas.SKILL.modLevel + 75 then
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

function AnglerAtlas.UI:UpdateRecipes()
    if AnglerAtlas.STATE.selectedFish == nil then
        AnglerAtlas.UI.recipes.text:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No fish selected")
        for i = 1, #AnglerAtlas.UI.recipes.recipeItems do
            local recipeFrame = AnglerAtlas.UI.recipes.recipeItems[i]
            if recipeFrame == nil then
                break
            end
            recipeFrame:Hide()
        end
        return
    end
    AnglerAtlas.UI.recipes.text:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Recipes for "..AnglerAtlas.STATE.selectedFishData.name)
    for i = 1, #AnglerAtlas.UI.recipes.recipeItems do
        local recipeFrame = AnglerAtlas.UI.recipes.recipeItems[i]
        if recipeFrame == nil then
            break
        end
        local recipeData = AnglerAtlas.DATA.recipes[AnglerAtlas.STATE.selectedFish][i]
        if recipeData == nil then
            recipeFrame:Hide()
        else
            recipeFrame:Show()
            recipeFrame:SetRecipe(recipeData)
        end
    end
end

function AnglerAtlas:SelectZone(zoneId, anglerFrame)
    if zoneId == nil then
        AnglerAtlas.UI.selectedZoneHighlight:Hide()

        return  
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    AnglerAtlas.STATE.selectedZone = zoneId
    
    -- print("Selected zone "..zoneId)
    AnglerAtlas.UI.selectedZoneHighlight:Show()
    AnglerAtlas.UI.selectedZoneHighlight:SetPoint("CENTER", anglerFrame, "CENTER", 0, 0)
    AnglerAtlas.UI:UpdateZoneList()
    AnglerAtlas.UI:UpdateZoneInfo()
end

function AnglerAtlas:SelectFish(fishId, anglerFrame)
    if fishId == nil then
        AnglerAtlas.UI.selectedIcon:Hide()
        return
    end
    if AnglerAtlas.STATE.selectedFish == fishId then
        return
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");  -- Page turn
    PlaySound(1189, "Master") -- Meaty thwack
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    AnglerAtlas.STATE.selectedFish = fishId
    AnglerAtlas.STATE.selectedFishData = AnglerAtlas.DATA.fish[AnglerAtlas.STATE.selectedFish]
    AnglerAtlas.UI.selectedIcon:Show()
    AnglerAtlas.UI.selectedIcon:SetPoint("CENTER", anglerFrame, "CENTER", 0, 0)

    local zones = AnglerAtlas:GetSortedZonesForFish(AnglerAtlas.STATE.selectedFish)
    -- print("Zones for fish "..fishId)
    -- for i = 1, #zones do
    --     print(zones[i].name)
    -- end
    
    AnglerAtlas.UI:UpdateFishInfo()
    AnglerAtlas.UI:UpdateRecipes()
    AnglerAtlas:SelectZone(tostring(zones[1].id), AnglerAtlas.UI.zones.zoneButtons[1])

end



AnglerAtlas.UI.fishIcons = {}

function AnglerAtlas.UI:CreateItemRow(itemIds, uiParent, itemSize, itemPadding)
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
        -- local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
        -- itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        -- expacID, setID, isCraftingReagent
        --     = GetItemInfo(itemID)
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
        local fishData = AnglerAtlas.DATA.fish[itemID]
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

        -- if fishData.avoidGetawayLevel <= AnglerAtlas.SKILL.level then
        --     itemFrame.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
        -- elseif fishData.avoidGetawayLevel <= AnglerAtlas.SKILL.level + 75 then
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
            AnglerAtlas:SelectFish(itemID, itemFrame)
        end)

        table.insert(row.items, itemFrame)
        table.insert(AnglerAtlas.UI.fishIcons, itemFrame)



        stepCursor = stepCursor + stepSize
    end

    return row
end

function AnglerAtlas.UI:CreateItemGrid(itemIds, uiParent, itemSize, itemPadding, maxColumns, framePadding)
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
            local row = AnglerAtlas.UI:CreateItemRow(tmpRow, grid, itemSize, itemPadding)
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

function AnglerAtlas.UI:CreateGoldDisplay(uiParent, curencyType)
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
        local gold, silver, copper = AnglerAtlas:SplitGold(value)
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


function AnglerAtlas.UI.BuildZoneInfoUI(parent)
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
            AnglerAtlas:SelectFish(nil, fishIcon)
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
            fishIcon.data.name = AnglerAtlas.DATA.fish[fishId].name
            fishIcon.data.rate = rate
            fishIcon.data.id = fishId
            fishIcon.texture:SetTexture(GetItemIcon(fishId))
            fishIcon.rate:SetText(AnglerAtlas.UI:CatchRateColor(rate)..tostring(rate*100).."%")
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
