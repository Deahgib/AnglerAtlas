local ZoneInfo = {}

local UI = AnglerAtlas.MM:GetModule("UI")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local DATA = AnglerAtlas.MM:GetModule("DATA")

local ZoneInfoFishRates = AnglerAtlas.MM:GetModule("ZoneInfoFishRates")

local zoneInfoFrame = nil

function ZoneInfo:Create(uiParent)
    zoneInfoFrame = CreateFrame("FRAME", "angler-zone-info", uiParent, "BackdropTemplate")

    zoneInfoFrame:SetBackdrop(UI.ANGLER_BACKDROP)

    zoneInfoFrame:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    zoneInfoFrame:SetSize(300, 408)
    zoneInfoFrame:SetPoint("TOPLEFT", UI.info, "TOPRIGHT", 5, 0)

    zoneInfoFrame.factionTexture = zoneInfoFrame:CreateTexture(nil,'ARTWORK')
    zoneInfoFrame.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
    zoneInfoFrame.factionTexture:SetSize(32, 32)
    zoneInfoFrame.factionTexture:SetPoint("TOPRIGHT", zoneInfoFrame, "TOPRIGHT", -27, -30)
    zoneInfoFrame.factionTexture:Hide()

    zoneInfoFrame.name = zoneInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneInfoFrame.name:SetPoint("TOPLEFT", zoneInfoFrame, "TOPLEFT", 28, -30)
    zoneInfoFrame.name:SetFont("Fonts\\FRIZQT__.ttf", 18)
    -- zoneinfo.name:SetText("Zone name")

    zoneInfoFrame.coastalInland = zoneInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneInfoFrame.coastalInland:SetPoint("TOPLEFT", zoneInfoFrame.name, "BOTTOMLEFT", 0, -12)
    zoneInfoFrame.coastalInland:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneInfoFrame.coastalInland:SetWordWrap(true)
    zoneInfoFrame.coastalInland:SetWidth(250)
    zoneInfoFrame.coastalInland:SetJustifyH("LEFT")
    -- zoneinfo.coastalInland:SetText("Has coastal and inland fishing")

    zoneInfoFrame.fishingLevelMin = zoneInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneInfoFrame.fishingLevelMin:SetPoint("TOPLEFT", zoneInfoFrame.coastalInland, "BOTTOMLEFT", 0, -7)
    zoneInfoFrame.fishingLevelMin:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneInfoFrame.fishingLevelMin:SetWordWrap(true)
    zoneInfoFrame.fishingLevelMin:SetWidth(250)
    zoneInfoFrame.fishingLevelMin:SetJustifyH("LEFT")

    zoneInfoFrame.fishingLevelMax = zoneInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneInfoFrame.fishingLevelMax:SetPoint("TOPLEFT", zoneInfoFrame.fishingLevelMin, "BOTTOMLEFT", 0, -7)
    zoneInfoFrame.fishingLevelMax:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneInfoFrame.fishingLevelMax:SetWordWrap(true)
    zoneInfoFrame.fishingLevelMax:SetWidth(250)
    zoneInfoFrame.fishingLevelMax:SetJustifyH("LEFT")

    zoneInfoFrame.notes = zoneInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneInfoFrame.notes:SetPoint("TOPLEFT", zoneInfoFrame.fishingLevelMax, "BOTTOMLEFT", 0, -7)
    zoneInfoFrame.notes:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneInfoFrame.notes:SetWordWrap(true)
    zoneInfoFrame.notes:SetWidth(250)
    zoneInfoFrame.notes:SetJustifyH("LEFT")

    zoneInfoFrame.fishRates = ZoneInfoFishRates:Create(zoneInfoFrame)

    return zoneInfoFrame
end


function ZoneInfo:Update()
    if zoneInfoFrame == nil then
        error("ZoneInfo frame not created")
        return
    end

    if STATE.selectedZone == nil then
        zoneInfoFrame.name:SetText(DATA.textColours.dark.."No zone selected")
        zoneInfoFrame.coastalInland:SetText("")
        zoneInfoFrame.fishRates:Hide()
        return
    end
    local zoneData = DATA.zones[STATE.selectedZone]
    if zoneData == nil then
        zoneInfoFrame.name:SetText(DATA.textColours.dark.."No zone selected")
        zoneInfoFrame.coastalInland:SetText("")
        zoneInfoFrame.fishRates:Hide()
        return
    end
    zoneInfoFrame.name:SetText(DATA.textColours.dark..zoneData.name)
    
    if zoneData.faction == "Contested" then
        zoneInfoFrame.factionTexture:Hide()
    else
        zoneInfoFrame.factionTexture:Show()
        if zoneData.faction == "Horde" then
            zoneInfoFrame.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
        elseif zoneData.faction == "Alliance" then
            zoneInfoFrame.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
        end
    end

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
        zoneInfoFrame.coastalInland:SetText(DATA.textColours.dark.."Has both "..DATA.textColours.green.."coastal"..DATA.textColours.dark.." and "..DATA.textColours.green.."inland"..DATA.textColours.dark.." waters.")
    elseif hasCoastal then
        zoneInfoFrame.coastalInland:SetText(DATA.textColours.dark.."Has "..DATA.textColours.green.."coastal"..DATA.textColours.dark.." waters.")
    elseif hasInland then
        zoneInfoFrame.coastalInland:SetText(DATA.textColours.dark.."Has "..DATA.textColours.green.."inland"..DATA.textColours.dark.." waters.")
    else
        zoneInfoFrame.coastalInland:SetText(DATA.textColours.dark.."Has no "..DATA.textColours.red.."coastal"..DATA.textColours.dark.." or "..DATA.textColours.red.."inland"..DATA.textColours.dark.." waters.")
    end

    zoneInfoFrame.fishingLevelMin:SetText(DATA.textColours.dark.."Min fishing level "..DATA:SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel))
    zoneInfoFrame.fishingLevelMax:SetText(DATA.textColours.dark.."Max fishing level "..DATA:SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel)..DATA.textColours.dark.." (required to catch all fish in this zone)")


    ZoneInfoFishRates:Update(sortedFish, zoneInfoFrame)
end


AnglerAtlas.MM:RegisterModule("ZoneInfo", ZoneInfo)
