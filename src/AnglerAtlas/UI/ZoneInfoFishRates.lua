local ZoneInfoFishRates = {}

local DATA = AnglerAtlas.MM:GetModule("DATA")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local UI = AnglerAtlas.MM:GetModule("UI")

local selectedFishHighlight = nil
local fishRates = nil

local uiIcons = {}

function ZoneInfoFishRates:Create(uiParent)
    
    fishRates = CreateFrame("FRAME", "angler-zone-info-fish", uiParent, "BackdropTemplate") 
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

    local modeButtonSize = 25
    local flareModSize = 2.0
    fishRates.flare = CreateFrame("FRAME", "angler-zone-info-fish-mode-button-flare", fishRates)
    fishRates.flare:SetSize(modeButtonSize*flareModSize, modeButtonSize*flareModSize)
    fishRates.flare:SetPoint("TOPRIGHT", fishRates, "TOPRIGHT", -5, -3)

    fishRates.flare.texture = fishRates.flare:CreateTexture(nil,'ARTWORK')
    fishRates.flare.texture:SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-Tab")
    fishRates.flare.texture:SetRotation(-math.pi*0.5)
    fishRates.flare.texture:SetVertexColor(0.6, 0.6, 0.6, 1.0)
    fishRates.flare.texture:SetAllPoints()

    fishRates.modeButton = CreateFrame("BUTTON", "angler-zone-info-fish-mode-button", fishRates.flare, "ItemButtonTemplate")
    fishRates.modeButton:SetSize(modeButtonSize, modeButtonSize)
    fishRates.modeButton:SetPoint("TOP", fishRates, "TOP", 0, -6)

    fishRates.modeButton.normalTexture = _G[fishRates.modeButton:GetName().."NormalTexture"]
    fishRates.modeButton.normalTexture:SetSize(modeButtonSize*1.662, modeButtonSize*1.662)

    fishRates.modeButton.texture = fishRates.modeButton:CreateTexture(nil,'ARTWORK')
    fishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
    fishRates.modeButton.texture:SetAllPoints()

    local function SetToolTipText()
        GameTooltip:SetOwner(fishRates.modeButton, "ANCHOR_LEFT", 0, 0)
        if STATE.mode == "openwater" then
            GameTooltip:SetText("Switch to Pools")
        else
            GameTooltip:SetText("Switch to Open Water")
        end
        GameTooltip:Show()
    end

    fishRates.modeButton:SetScript("OnClick", function()
        if STATE.mode == "openwater" then
            if STATE.selectedZone == nil then return end
            local zoneData = DATA.zones[STATE.selectedZone]
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
    fishRates.modeButton:SetScript("OnEnter", function()
        SetToolTipText()
    end)
    fishRates.modeButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    uiIcons = {}
    for i = 1, 9 do
        local fishIcon = CreateFrame("BUTTON", "angler-zone-info-fish-icon-"..i, fishRates, "ItemButtonTemplate")
        fishIcon:SetSize(37, 37)
        fishIcon:SetPoint("TOP", fishRates, "TOP", 0, -46 - (i - 1) * 39)
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
        fishIcon.rate:SetText(DATA.textColours.green..tostring(50).."%")

        fishIcon.data = {}
        fishIcon.data.name = "Fish name"

        -- Tooltip
        fishIcon:SetScript("OnEnter", function()
            GameTooltip:SetOwner(fishIcon, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(fishIcon.data.id)
            GameTooltip:Show()
        end)

        fishIcon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        -- uiIcons[i] = fishIcon
        table.insert(uiIcons, fishIcon)
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

function ZoneInfoFishRates:Update(sortedFish)
    fishRates:Show()
    selectedFishHighlight:Hide()
    if STATE.mode == "openwater" then
        fishRates.modeButton.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
    elseif STATE.mode == "pools" then
        fishRates.modeButton.texture:SetTexture("Interface\\Icons\\Spell_Arcane_TeleportStormWind")
    end

    if STATE.selectedZone == nil then
        return
    end
    local zoneData = DATA.zones[STATE.selectedZone]
    if zoneData == nil then
        return
    end

    if zoneData.fishingPools == nil then
        fishRates.modeButton:Disable()
        fishRates.modeButton.texture:SetVertexColor(0.4, 0.4, 0.4, 1.0)
    else
        fishRates.modeButton:Enable()
        fishRates.modeButton.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    end

    for i = 1, #uiIcons do
        local fishIcon = uiIcons[i]
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
                fishIcon.rate:SetText(DATA.textColours.white..fishData.count)
            end

            if STATE.selectedFish == fishData.id then
                selectedFishHighlight:SetPoint("CENTER", fishIcon, "CENTER", 0, 0)
                selectedFishHighlight:Show()
            end
        end
    end
end

AnglerAtlas.MM:RegisterModule("ZoneInfoFishRates", ZoneInfoFishRates)