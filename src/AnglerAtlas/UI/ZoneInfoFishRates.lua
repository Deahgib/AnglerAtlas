local ZoneInfoFishRates = {}

local DATA = AnglerAtlas.MM:GetModule("DATA")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local UI = AnglerAtlas.MM:GetModule("UI")

local selectedFishHighlight = nil

function ZoneInfoFishRates:Create(uiParent)
    
    local fishRates = CreateFrame("FRAME", "angler-zone-info-fish", uiParent, "BackdropTemplate") 
    fishRates:SetBackdrop({
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
    fishRates:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    fishRates:SetSize(50, 408)
    fishRates:SetPoint("TOPLEFT", uiParent, "TOPRIGHT", 0, 0)

    fishRates.icons = {}
    for i = 1, 10 do
        local fishIcon = CreateFrame("BUTTON", "angler-zone-info-fish-icon-"..i, fishRates, "ItemButtonTemplate")
        fishIcon:SetSize(37, 37)
        fishIcon:SetPoint("TOP", fishRates, "TOP", 0, -6 - (i - 1) * 39)
        fishIcon:SetScript("OnClick", function()
            UI:SelectFish(fishIcon.data.id, true)
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

        -- fishRates.icons[i] = fishIcon
        table.insert(fishRates.icons, fishIcon)
    end
    
    selectedFishHighlight = CreateFrame("FRAME", "angler-zone-selected-icon", fishRates)
    selectedFishHighlight:SetSize(30, 30)
    selectedFishHighlight:SetPoint("CENTER", 0, 0)
    
    selectedFishHighlight.texture = selectedFishHighlight:CreateTexture(nil,'OVERLAY')
    selectedFishHighlight.texture:SetTexture("Interface\\Transmogrify\\transmog-tooltip-arrow")
    selectedFishHighlight.texture:SetSize(10, 10)
    selectedFishHighlight.texture:SetRotation(math.pi)
    selectedFishHighlight.texture:SetPoint("CENTER", 18, 0)
    selectedFishHighlight.texture:SetBlendMode("ADD")

    selectedFishHighlight.flareTexture = selectedFishHighlight:CreateTexture(nil,'OVERLAY')
    selectedFishHighlight.flareTexture:SetTexture("Interface\\CURSOR\\FishingCursor")
    selectedFishHighlight.flareTexture:SetSize(17, 17)
    selectedFishHighlight.flareTexture:SetRotation(math.pi*0.23)
    selectedFishHighlight.flareTexture:SetPoint("CENTER", 30, 0)
    -- selectedFishHighlight.flareTexture:SetBlendMode("ADD")

    selectedFishHighlight:Hide()

    fishRates:Hide()

    return fishRates
end

function ZoneInfoFishRates:Update(sortedFish, zoneinfo)
    zoneinfo.fishRates:Show()
    selectedFishHighlight:Hide()
    for i = 1, #zoneinfo.fishRates.icons do
        local fishIcon = zoneinfo.fishRates.icons[i]
        if fishIcon == nil then
            break
        end
        local fishData = sortedFish[i]
        if fishData == nil then
            fishIcon:Hide()
        else
            fishIcon:Show()
            fishIcon:SetFish(fishData.id, fishData.catchChance)

            if STATE.selectedFish == fishData.id then
                selectedFishHighlight:SetPoint("CENTER", fishIcon, "CENTER", 0, 0)
                selectedFishHighlight:Show()
            end
        end
    end
end

AnglerAtlas.MM:RegisterModule("ZoneInfoFishRates", ZoneInfoFishRates)