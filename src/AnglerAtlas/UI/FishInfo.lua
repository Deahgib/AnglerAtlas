
local FishInfo = {}

local STATE = AnglerAtlas.MM:GetModule("STATE")
local DATA = AnglerAtlas.MM:GetModule("DATA")
local GoldDisplay = AnglerAtlas.MM:GetModule("GoldDisplay")

local FishInfoBuffs = AnglerAtlas.MM:GetModule("FishInfoBuffs")

local info = nil

function FishInfo:Create(uiParent)
    info = CreateFrame("FRAME", "angler-fish-info", uiParent, "BackdropTemplate")
    info:SetBackdrop({
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
    info:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    info:SetSize(300, 200)
    info:SetPoint("TOPLEFT", uiParent.grid, "TOPRIGHT", 5, 0)

    info.name = info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    info.name:SetPoint("TOPLEFT", info, "TOPLEFT", 55, -16)
    info.name:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
    -- info.name:SetText("Name")
    info.icon = CreateFrame("BUTTON", "angler-fish-info-icon", info, "ItemButtonTemplate")
    info.icon:SetSize(42, 42)
    info.icon:SetPoint("TOPLEFT", info, "TOPLEFT", 10, -10)

    info.icon.texture = info.icon:CreateTexture(nil,'ARTWORK')
    info.icon.texture:SetAllPoints()

    info.itemLevel = info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    info.itemLevel:SetPoint("TOPLEFT", info.name, "BOTTOMLEFT", 0, -6)

    info.itemStackCount = info.icon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    info.itemStackCount:SetPoint("BOTTOMRIGHT", info.icon, "BOTTOMRIGHT", -4, 4)
    info.itemStackCount:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

    info.goldAuctionPrice = GoldDisplay:Create(info, "Auction unit price")
    info.goldAuctionPrice:SetPoint("BOTTOMRIGHT", info, "BOTTOMRIGHT", -8, 8)
    info.goldAuctionPrice:Hide()

    info.buffFish = CreateFrame("FRAME", "angler-fish-info-buff", info)
    info.buffFish:SetSize(28, 28)
    info.buffFish:SetPoint("TOPRIGHT", info, "TOPRIGHT", -8, -8)
    info.buffFish.texture = info.buffFish:CreateTexture(nil,'ARTWORK')
    info.buffFish.texture:SetTexture("Interface\\Icons\\Spell_Misc_Food")
    info.buffFish.texture:SetAllPoints()
    info.buffFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    info.buffFish:SetScript("OnEnter", function()
        GameTooltip:SetOwner(info.buffFish, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:AddLine("This fish can be cooked into a buff food")
        GameTooltip:Show()
    end)
    info.buffFish:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    info.buffFish:Hide()

    info.alchemicFish = CreateFrame("FRAME", "angler-fish-info-alchemic", info)
    info.alchemicFish:SetSize(28, 28)
    info.alchemicFish:SetPoint("TOPRIGHT", info.buffFish, "BOTTOMRIGHT", 0, -4)
    info.alchemicFish.texture = info.alchemicFish:CreateTexture(nil,'ARTWORK')
    info.alchemicFish.texture:SetTexture("Interface\\Icons\\INV_Potion_93")
    info.alchemicFish.texture:SetAllPoints()
    info.alchemicFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    info.alchemicFish:SetScript("OnEnter", function()
        GameTooltip:SetOwner(info.alchemicFish, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:AddLine("This fish is used by alchemists")
        GameTooltip:Show()
    end)
    info.alchemicFish:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    info.alchemicFish:Hide()

    info.poolsFish = CreateFrame("FRAME", "angler-fish-info-pools", info)
    info.poolsFish:SetSize(28, 28)
    info.poolsFish:SetPoint("TOPRIGHT", info.buffFish, "TOPLEFT", -4, 0)
    info.poolsFish.texture = info.poolsFish:CreateTexture(nil,'ARTWORK')
    info.poolsFish.texture:SetTexture("Interface\\ICONS\\Spell_Frost_Stun")
    info.poolsFish.texture:SetAllPoints()
    info.poolsFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    info.poolsFish:SetScript("OnEnter", function()
        GameTooltip:SetOwner(info.poolsFish, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:AddLine("Pools available for this fish")
        GameTooltip:Show()
    end)
    info.poolsFish:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    info.poolsFish:Hide()

    FishInfoBuffs:Create(info)
    FishInfoBuffs:RegisterBuff(info.poolsFish)
    FishInfoBuffs:RegisterBuff(info.buffFish)
    FishInfoBuffs:RegisterBuff(info.alchemicFish)

    info.levelText = info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    info.levelText:SetPoint("TOPLEFT", info.icon, "BOTTOMLEFT", 0, -10)
    info.levelText:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

    info.waterType = info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    info.waterType:SetPoint("TOPLEFT", info.levelText, "BOTTOMLEFT", 0, -5)
    info.waterType:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

    info.requirements = {}
    local reqOffset = -15
    for i = 1, 2 do
        local text = info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", info.waterType, "BOTTOMLEFT", 0, reqOffset)
        reqOffset = reqOffset - 30
        text:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")
        text:SetWordWrap(true)
        text:SetWidth(280)
        text:SetJustifyH("LEFT")
        -- text:SetSpacing(10)
        
        -- text:SetText("Requirement "..i) 
        table.insert(info.requirements, text)
    end

    uiParent.info = info
    return info
end



function FishInfo:Update()
    if info == nil then
        error("FishInfo not created")
        return
    end

    if STATE.selectedFish == nil then
        info.name:SetText("No fish selected")
        info.icon.texture:SetTexture(nil)
        info.itemLevel:SetText("")
        info.itemStackCount:SetText("")
        -- info.goldSellPrice:Hide()
        info.goldAuctionPrice:Hide()
        return
    end
    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
    itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
    expacID, setID, isCraftingReagent
        = GetItemInfo(STATE.selectedFish)

    local fishData = DATA.fish[STATE.selectedFish]

    info.name:SetText(itemName)
    info.icon.texture:SetTexture(itemTexture)
    local levelColour = DATA.playerInfo.level >= itemLevel and DATA.textColours.white or DATA.textColours.red
    info.itemLevel:SetText(levelColour.."Requires Level "..itemLevel)
    info.itemStackCount:SetText(itemStackCount)
    -- info.goldSellPrice:SetGold(sellPrice)
    -- info.goldSellPrice:Show()
    if Auctionator ~= nil then
        local auctionPrice = Auctionator.Database:GetPrice(tostring(STATE.selectedFish))
        if auctionPrice ~= nil then
            info.goldAuctionPrice:SetGold(auctionPrice)
            info.goldAuctionPrice:Show()
        else
            info.goldAuctionPrice:Hide()
        end
    else
        info.goldAuctionPrice:Hide()
    end

    local isBuffFish = fishData.isBuffFish ~= nil and fishData.isBuffFish == true
    if isBuffFish then
        info.buffFish:Show()
    else
        info.buffFish:Hide()
    end

    local isAlchemicFish = fishData.isAlchemicFish ~= nil and fishData.isAlchemicFish == true
    if isAlchemicFish then
        info.alchemicFish:Show()
    else
        info.alchemicFish:Hide()
    end

    if DATA.pools[STATE.selectedFish] ~= nil then
        info.poolsFish:Show()
    else
        info.poolsFish:Hide()
    end

    FishInfoBuffs:Update()

    
    info.levelText:SetText("Min fishing level "..DATA:SkillLevelColor(fishData.minimumFishingLevel)..tostring(fishData.minimumFishingLevel)..DATA.textColours.white..", optimal fishing level "..DATA:SkillLevelColor(fishData.avoidGetawayLevel)..tostring(fishData.avoidGetawayLevel))

    local waterType = ""
    if fishData.type == "C" then
        waterType = "Can be caught in "..DATA.textColours.green.."coastal"..DATA.textColours.white.." waters."
    elseif fishData.type == "I" then
        waterType = "Can be caught in "..DATA.textColours.green.."inland"..DATA.textColours.white.." waters."
    else
        waterType = ""
    end
    info.waterType:SetText(waterType)

    if fishData.requirements ~= nil then
        for i = 1, #fishData.requirements do
            local req = fishData.requirements[i]
            local font = info.requirements[i]
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
        for i = 1, #info.requirements do
            local font = info.requirements[i]
            if font == nil then
                break
            end
            font:Hide()
        end
    end
    -- info.requirements
end

AnglerAtlas.MM:RegisterModule("FishInfo", FishInfo)