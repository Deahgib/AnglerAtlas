local ZonesList = {}

local UI = AnglerAtlas.MM:GetModule("UI")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local DATA = AnglerAtlas.MM:GetModule("DATA")

local zones = nil
local selectedZoneHighlight = nil

local zoneButtons = {}

function ZonesList:Create(uiParent)
    zones = CreateFrame("FRAME", "angler-fish-info", uiParent, "BackdropTemplate")
    zones:SetBackdrop({
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
    zones:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    zones:SetSize(300, 203)
    zones:SetPoint("TOPLEFT", UI.info, "BOTTOMLEFT", 0, -5)

    zones.scrollFrame = CreateFrame("ScrollFrame", nil, zones, "UIPanelScrollFrameTemplate")
    zones.scrollFrame:SetPoint("TOPLEFT", 10, -10)
    zones.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 8)

    zones.scrollFrame.scrollChild = CreateFrame("Frame")
    zones.scrollFrame:SetScrollChild(zones.scrollFrame.scrollChild)
    zones.scrollFrame.scrollChild:SetWidth(260)
    zones.scrollFrame.scrollChild:SetHeight(#DATA.validZones * 30)  -- 50 is the height of each button

    zoneButtons = {}

    for i = 1, #DATA.validZones do
        local zone = DATA.zones[DATA.validZones[i]]
        local zoneButton = CreateFrame("BUTTON", "angler-zone-button-"..i, zones.scrollFrame.scrollChild, "UIPanelButtonTemplate")
        zoneButton:SetSize(250, 30)
        zoneButton:SetPoint("TOP", zones.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 30)
        zoneButton:SetScript("OnClick", function()
            UI:SelectZone(zoneButton.zoneId)
        end)

        zoneButton.factionTexture = zoneButton:CreateTexture(nil,'ARTWORK')
        zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
        zoneButton.factionTexture:SetSize(20, 20)
        zoneButton.factionTexture:SetPoint("LEFT", zoneButton, "LEFT", 3, 0)



        zoneButton.name = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneButton.name:SetPoint("LEFT", zoneButton.factionTexture, "RIGHT", 10, 0)
        zoneButton.name:SetFont("Fonts\\FRIZQT__.ttf", 11)
        -- zoneButton.name:SetText(zone.name)

        -- zoneButton.zoneLevel = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        -- zoneButton.zoneLevel:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
        -- zoneButton.zoneLevel:SetFont("Fonts\\FRIZQT__.ttf", 10)
        -- zoneButton.zoneLevel:SetText(DATA:SkillLevelColor(zone.fishingLevel)..tostring(zone.fishingLevel))

        zoneButton.zoneCatchRate = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneButton.zoneCatchRate:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
        zoneButton.zoneCatchRate:SetFont("Fonts\\FRIZQT__.ttf", 11)
        --zoneButton.zoneCatchRate:SetText(DATA.textColours.white..tostring("50%"))

        zoneButton.poolIndicator = zoneButton:CreateTexture(nil,'ARTWORK')
        zoneButton.poolIndicator:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
        zoneButton.poolIndicator:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
        zoneButton.poolIndicator:SetVertexColor(1.0, 1.0, 1.0, 1.0)
        zoneButton.poolIndicator:SetBlendMode("ADD")
        zoneButton.poolIndicator:SetSize(22, 22)
        zoneButton.poolIndicator:SetPoint("RIGHT", zoneButton, "RIGHT", -40, 0)
        zoneButton.poolIndicator:Show()

        zoneButton.poolCount = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneButton.poolCount:SetPoint("RIGHT", zoneButton, "RIGHT", -61, 0)
        zoneButton.poolCount:SetFont("Fonts\\FRIZQT__.ttf", 11)
        zoneButton.poolCount:SetText("")

        function zoneButton:SetZone(zoneId, name, catchRate, level)
            self.zoneId = zoneId
            self.name:SetText(name)
            self.zoneCatchRate:SetText(catchRate)
            -- self.zoneLevel:SetText(level)
        end
        zoneButton:Hide()

        zoneButtons[i] = zoneButton

    end

    selectedZoneHighlight = CreateFrame("FRAME", "angler-zone-selected-icon", zoneButtons[1])
    selectedZoneHighlight:SetSize(250, 30)
    selectedZoneHighlight:SetPoint("CENTER", 0, 0)
    
    selectedZoneHighlight.texture = selectedZoneHighlight:CreateTexture(nil,'OVERLAY')
    selectedZoneHighlight.texture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    selectedZoneHighlight.texture:SetSize(380, 34)
    selectedZoneHighlight.texture:SetPoint("CENTER", 0, 0)
    selectedZoneHighlight.texture:SetVertexColor(1.0, 1.0, 1.0, 0.8)
    selectedZoneHighlight.texture:SetBlendMode("ADD")
    selectedZoneHighlight:Hide()
    
    return zones
end

function ZonesList:HideSelected()
    selectedZoneHighlight:Hide()
end

function ZonesList:Update()
    if zones == nil then
        error("ZonesList not created")
        return
    end
    
    if STATE.selectedFish == nil then
        zones.scrollFrame:Hide()
        return
    end
    if STATE.selectedZone == nil then
        zones.scrollFrame:Hide()
        return
    end
    zones.scrollFrame:Show()
    -- local fishId = STATE.selectedFish
    -- local fishInfo = DATA.fish[fishId]
    -- local fishStats = DATA.zones[STATE.selectedZone].fishStats[fishId]
    local sortedZones = nil
    if STATE.mode == "openwater" then
        sortedZones = DATA:GetSortedZonesForFish(STATE.selectedFish)
    elseif STATE.mode == "pools" then
        sortedZones = DATA:GetSortedZonesForPool(STATE.selectedFish)
        if #sortedZones == 0 then
            sortedZones = DATA:GetSortedZonesForFish(STATE.selectedFish)
        end
    else
        error("Unknown mode: "..STATE.mode)
    end

    
    

    for i = 1, #zoneButtons do
        local zoneButton = zoneButtons[i]
        if zoneButton == nil then
            break
        end
        local zoneData = sortedZones[i]
        if zoneData == nil then
            zoneButton:Hide()
        else
            zoneButton:Show()

            local zoneNameText = zoneData.name
            local catchChance = 0
            local zoneCatchRateText = DATA:CatchRateColor(catchChance)..tostring(catchChance*100).."%"
            if zoneData.fishStats[STATE.selectedFish] == nil then
                zoneCatchRateText = ""
            else
                catchChance = zoneData.fishStats[STATE.selectedFish].catchChance
                zoneCatchRateText = DATA:CatchRateColor(catchChance)..tostring(catchChance*100).."%"
            end
            local zoneFishingLevelText = DATA:SkillLevelColor(zoneData.fishingLevel)..tostring(zoneData.fishingLevel)

            if zoneData.faction == "Contested" then
                zoneButton.factionTexture:Hide()
            else
                if zoneData.faction == "Horde" then
                    zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
                elseif zoneData.faction == "Alliance" then
                    zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
                end
                
                zoneButton.factionTexture:Show()
            end
        
            local poolData = DATA.pools[STATE.selectedFish]
            local isPoolZoneForSelected = false
            if poolData ~= nil then
                if DATA:IsInList(poolData.zones, tostring(zoneData.id)) then
                    isPoolZoneForSelected = true
                end
            end
            if isPoolZoneForSelected then
                zoneButton.poolIndicator:Show()
                local poolCount = DATA:GetCountForZoneTable(DATA.zones[tostring(zoneData.id)].fishingPools, STATE.selectedFish)
                zoneButton.poolCount:SetText(DATA.textColours.white..poolCount)
            else
                zoneButton.poolIndicator:Hide()
                zoneButton.poolCount:SetText("")
            end

            zoneButton:SetZone(tostring(zoneData.id), zoneNameText, zoneCatchRateText, "")
            if tostring(zoneData.id) == STATE.selectedZone then
                selectedZoneHighlight:SetPoint("CENTER", zoneButton,"CENTER", 0, 0)
                selectedZoneHighlight:Show()
            end
        end
        
    end
    zones.scrollFrame.scrollChild:SetHeight(#sortedZones * 30 + 20)
    
    zones.scrollFrame:Show()
end


AnglerAtlas.MM:RegisterModule("ZonesList", ZonesList)
