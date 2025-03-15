local FishInfoBuffs = {}

local rootAnchor = nil
local buffFrames = {}
function FishInfoBuffs:Create(uiParent)
    rootAnchor = CreateFrame("FRAME", "angler-fish-info-buffs", uiParent)
    rootAnchor:SetSize(1, 1)
    rootAnchor:SetPoint("TOPRIGHT", uiParent, "TOPRIGHT", -8, -4)
end

function FishInfoBuffs:RegisterBuff(frame)
    table.insert(buffFrames, frame)
end

function FishInfoBuffs:Update()
    local nextPos = rootAnchor
    for i = 1, #buffFrames do
        local frame = buffFrames[i]
        if frame == nil then
            break
        end

        if frame:IsVisible() then
            frame:SetPoint("TOPRIGHT", nextPos, "BOTTOMRIGHT", 0, -3)
            nextPos = frame
        end
    end
end

AnglerAtlas.MM:RegisterModule("FishInfoBuffs", FishInfoBuffs)