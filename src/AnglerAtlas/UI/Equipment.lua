local Equipment = {}

local UI = AnglerAtlas.MM:GetModule("UI")
local DATA = AnglerAtlas.MM:GetModule("DATA")

function Equipment:Create(uiParent, anchor)
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
                GameTooltip:Show()
            end)
            equipmentItem:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            GameTooltip:HookScript("OnTooltipSetItem", function(self)
                if GameTooltip:GetOwner() == equipmentItem then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(data.desc)
                end
            end)
            prevAnchor = equipmentItem
            equipmentRow.items[i] = equipmentItem
        end

        return equipmentRow
    end

    local equipment = CreateFrame("FRAME", "angler-equipment-info", uiParent, "BackdropTemplate")
    equipment:Raise()
    equipment:SetBackdrop(BACKDROP_GOLD_DIALOG_32_32)
    equipment:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    equipment:SetSize(355, 408)
    equipment:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
    equipment:Hide()
    -- On show hide
    equipment:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    end)
    equipment:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
    end)

    equipment.gear = buildEquipmentRow(equipment, "Gear", DATA.equipment.gear)
    equipment.gear:SetPoint("TOPLEFT", equipment, "TOPLEFT", 25, -25)

    equipment.rods = buildEquipmentRow(equipment, "Rods", DATA.equipment.rods)
    equipment.rods:SetPoint("TOPLEFT", equipment.gear, "BOTTOMLEFT", 0, -20)

    equipment.lures = buildEquipmentRow(equipment, "Lures", DATA.equipment.lures)
    equipment.lures:SetPoint("TOPLEFT", equipment.rods, "BOTTOMLEFT", 0, -20)

    equipment.other = buildEquipmentRow(equipment, "Other", DATA.equipment.other)
    equipment.other:SetPoint("TOPLEFT", equipment.lures, "BOTTOMLEFT", 0, -20)
    
    return equipment
end

AnglerAtlas.MM:RegisterModule("Equipment", Equipment)
