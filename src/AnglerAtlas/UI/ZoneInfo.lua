local ZoneInfo = {}

local UI = AnglerAtlas.MM:GetModule("UI")

local DATA = AnglerAtlas.MM:GetModule("DATA")

local ZoneInfoFishRates = AnglerAtlas.MM:GetModule("ZoneInfoFishRates")

local zoneinfo = nil

function ZoneInfo:Create(uiParent)
    zoneinfo = CreateFrame("FRAME", "angler-zone-info", uiParent, "BackdropTemplate")
    -- zoneinfo:SetBackdrop({
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
    zoneinfo:SetBackdrop(UI.ANGLER_BACKDROP)

    zoneinfo:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    zoneinfo:SetSize(300, 408)
    zoneinfo:SetPoint("TOPLEFT", UI.info, "TOPRIGHT", 5, 0)

    zoneinfo.factionTexture = zoneinfo:CreateTexture(nil,'ARTWORK')
    zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
    zoneinfo.factionTexture:SetSize(32, 32)
    zoneinfo.factionTexture:SetPoint("TOPRIGHT", zoneinfo, "TOPRIGHT", -27, -30)
    zoneinfo.factionTexture:Hide()

    zoneinfo.name = zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneinfo.name:SetPoint("TOPLEFT", zoneinfo, "TOPLEFT", 28, -30)
    zoneinfo.name:SetFont("Fonts\\FRIZQT__.ttf", 18)
    -- zoneinfo.name:SetText("Zone name")

    zoneinfo.coastalInland = zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneinfo.coastalInland:SetPoint("TOPLEFT", zoneinfo.name, "BOTTOMLEFT", 0, -12)
    zoneinfo.coastalInland:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneinfo.coastalInland:SetWordWrap(true)
    zoneinfo.coastalInland:SetWidth(250)
    zoneinfo.coastalInland:SetJustifyH("LEFT")
    -- zoneinfo.coastalInland:SetText("Has coastal and inland fishing")

    zoneinfo.fishingLevelMin = zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneinfo.fishingLevelMin:SetPoint("TOPLEFT", zoneinfo.coastalInland, "BOTTOMLEFT", 0, -7)
    zoneinfo.fishingLevelMin:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneinfo.fishingLevelMin:SetWordWrap(true)
    zoneinfo.fishingLevelMin:SetWidth(250)
    zoneinfo.fishingLevelMin:SetJustifyH("LEFT")

    zoneinfo.fishingLevelMax = zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneinfo.fishingLevelMax:SetPoint("TOPLEFT", zoneinfo.fishingLevelMin, "BOTTOMLEFT", 0, -7)
    zoneinfo.fishingLevelMax:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneinfo.fishingLevelMax:SetWordWrap(true)
    zoneinfo.fishingLevelMax:SetWidth(250)
    zoneinfo.fishingLevelMax:SetJustifyH("LEFT")

    zoneinfo.notes = zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneinfo.notes:SetPoint("TOPLEFT", zoneinfo.fishingLevelMax, "BOTTOMLEFT", 0, -7)
    zoneinfo.notes:SetFont("Fonts\\FRIZQT__.ttf", 12)
    zoneinfo.notes:SetWordWrap(true)
    zoneinfo.notes:SetWidth(250)
    zoneinfo.notes:SetJustifyH("LEFT")

    zoneinfo.fishRates = ZoneInfoFishRates:Create(zoneinfo)

    return zoneinfo
end


function ZoneInfo:Update()
    if zoneinfo == nil then
        error("ZoneInfo frame not created")
        return
    end

    if AnglerAtlas.STATE.selectedZone == nil then
        zoneinfo.name:SetText(UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        zoneinfo.coastalInland:SetText("")
        zoneinfo.fishRates:Hide()
        return
    end
    local zoneData = DATA.zones[AnglerAtlas.STATE.selectedZone]
    if zoneData == nil then
        zoneinfo.name:SetText(UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        zoneinfo.coastalInland:SetText("")
        zoneinfo.fishRates:Hide()
        return
    end
    zoneinfo.name:SetText(UI.ANGLER_DARK_FONT_COLOR..zoneData.name)
    
    if zoneData.faction == "Contested" then
        zoneinfo.factionTexture:Hide()
    else
        zoneinfo.factionTexture:Show()
        if zoneData.faction == "Horde" then
            zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
        elseif zoneData.faction == "Alliance" then
            zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
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
        zoneinfo.coastalInland:SetText(UI.ANGLER_DARK_FONT_COLOR.."Has both |cFF00FF00coastal"..UI.ANGLER_DARK_FONT_COLOR.." and |cFF00FF00inland"..UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasCoastal then
        zoneinfo.coastalInland:SetText(UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00coastal"..UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasInland then
        zoneinfo.coastalInland:SetText(UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00inland"..UI.ANGLER_DARK_FONT_COLOR.." waters.")
    else
        zoneinfo.coastalInland:SetText(UI.ANGLER_DARK_FONT_COLOR.."Has no |cFFFF0000coastal"..UI.ANGLER_DARK_FONT_COLOR.." or |cFFFF0000inland"..UI.ANGLER_DARK_FONT_COLOR.." waters.")
    end

    zoneinfo.fishingLevelMin:SetText(UI.ANGLER_DARK_FONT_COLOR.."Min fishing level "..DATA:SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel))
    zoneinfo.fishingLevelMax:SetText(UI.ANGLER_DARK_FONT_COLOR.."Max fishing level "..DATA:SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel)..UI.ANGLER_DARK_FONT_COLOR.." (required to catch all fish in this zone)")


    ZoneInfoFishRates:Update(sortedFish, zoneinfo)
end


AnglerAtlas.MM:RegisterModule("ZoneInfo", ZoneInfo)
