local FishGrid = {}

local UI = AnglerAtlas.MM:GetModule("UI")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local DATA = AnglerAtlas.MM:GetModule("DATA")

local fishIcons = {}
local rows = {}
local selectedIcon = nil

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
        -- local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType,
        -- itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType,
        -- expacID, setID, isCraftingReagent
        --     = GetItemInfo(itemID)
        local itemFrame = CreateFrame("BUTTON", "angler-item-"..i, row, "ItemButtonTemplate");
        itemFrame:SetSize(itemSize, itemSize)
        itemFrame:SetPoint("CENTER", stepCursor, 0)
        itemFrame.texture = itemFrame:CreateTexture('fish-face','ARTWORK', nil, 1)
        itemFrame.texture:SetAllPoints()
        -- itemFrame.texture:SetTexture(GetItemIcon(itemID)) -- replace with icon id of the respective poisons.
        SetItemButtonTexture(itemFrame, GetItemIcon(itemID))
        itemFrame.fishId = itemID

        _G[itemFrame:GetName().."NormalTexture"]:SetSize(itemSize*1.662, itemSize*1.662)

        -- Fish data for this item
        local fishData = DATA.fish[itemID]
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
            UI:SelectFish(itemID)
        end)

        table.insert(row.items, itemFrame)
        table.insert(fishIcons, itemFrame)

        stepCursor = stepCursor + stepSize
    end

    return row
end

function FishGrid:Create(itemIds, uiParent, itemSize, itemPadding, maxColumns, framePadding)
    local length = #itemIds
    local columns = length
    if columns > maxColumns then
        columns = maxColumns
    end 

    local rowsceil = math.ceil(length / maxColumns)

    local width = itemSize * columns + itemPadding * (columns - 1)
    local height = itemSize * rowsceil + itemPadding * (rowsceil - 1)
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
    for i = 1, #itemIds do
        local itemID = itemIds[i]
        table.insert(tmpRow, itemID)
        if counter >= maxColumns or i == #itemIds then
            local row = CreateItemRow(tmpRow, grid, itemSize, itemPadding)
            row:SetPoint("CENTER", 0, stepCursorVertical)
            table.insert(rows, row)
            counter = 0
            stepCursorVertical = stepCursorVertical - stepSize
            tmpRow = {}
        end
        counter = counter + 1
    end

    selectedIcon = CreateFrame("FRAME", "angler-grid-selected-icon", fishIcons[1])
    selectedIcon:SetSize(37, 37)
    selectedIcon:SetPoint("CENTER", 0, 0)

    selectedIcon.texture = selectedIcon:CreateTexture(nil,'OVERLAY')
    selectedIcon.texture:SetTexture("Interface\\Store\\store-item-highlight")
    selectedIcon.texture:SetSize(64, 64)
    selectedIcon.texture:SetPoint("CENTER", 0, 0)
    selectedIcon.texture:SetBlendMode("ADD")
    selectedIcon:Hide()

    return grid
end

function FishGrid:HideSelected()
    selectedIcon:Hide()
end

-- function FishGrid:SelectFish(id)
--     for i = 1, #fishIcons do
--         if fishIcons[i].itemID == id then
            
--             return
--         end
--     end
-- end

function FishGrid:Update()
    for i = 1, #fishIcons do
        local fishIcon = fishIcons[i]
        if fishIcon == nil then
            break
        end
        local fishId = fishIcon.fishId
        if fishId ~= nil then
            local fishData = DATA.fish[fishId]
            if fishId == STATE.selectedFish then
                selectedIcon:Show()
                selectedIcon:SetPoint("CENTER", fishIcon, "CENTER", 0, 0)
            end
            if fishData ~= nil then
                if DATA.playerSkill.hasFishing then
                    fishIcon.status:Show()
                    if fishData.avoidGetawayLevel <= DATA.playerSkill.modLevel then
                        fishIcon.status.indicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
                    elseif fishData.avoidGetawayLevel <= DATA.playerSkill.modLevel + 75 then
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

AnglerAtlas.MM:RegisterModule("FishGrid", FishGrid)
