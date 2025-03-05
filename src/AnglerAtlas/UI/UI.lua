local UI = AnglerAtlas.MM:GetModule("UI")

local DATA = AnglerAtlas.MM:GetModule("DATA")

local FrameDecorations = AnglerAtlas.MM:GetModule("FrameDecorations")

local ShowButtons = AnglerAtlas.MM:GetModule("ShowButtons")

local FishGrid = AnglerAtlas.MM:GetModule("FishGrid")

local FishInfo = AnglerAtlas.MM:GetModule("FishInfo")

local ZonesList = AnglerAtlas.MM:GetModule("ZonesList")

local ZoneInfo = AnglerAtlas.MM:GetModule("ZoneInfo")

local TabManager = AnglerAtlas.MM:GetModule("TabManager")

local Resipes = AnglerAtlas.MM:GetModule("Resipes")

local Equipment = AnglerAtlas.MM:GetModule("Equipment")

local SettingsAA = AnglerAtlas.MM:GetModule("SettingsAA")

-------------------------------------------------
-- Battle plans:
-------------------------------------------------

-- Get the UI local to be assigned to the UI in the Core.lua

-- Pull out the UI Initialization code from the Data.lua and place it in this file

-- Create a function UI:Build() that will build the UI this file will 
-- be using AnglerAtlasLoader to grab all the UI components

-- Create a function UI:ToggleUI() that will toggle the UI

-- Create a function UI:Refresh() that will update the fish



function UI:Build()
    
    UI.ANGLER_DARK_FONT_COLOR = "|cFF222222"

    -- Backdrops
    UI.ANGLER_BACKDROP = CopyTable(BACKDROP_ACHIEVEMENTS_0_64)
    UI.ANGLER_BACKDROP.bgFile = "Interface\\AdventureMap\\AdventureMapParchmentTile"
    UI.ANGLER_BACKDROP.insets = { left = 24, right = 24, top = 22, bottom = 24 }

    UI:SetFrameStrata("DIALOG")
    UI:SetSize(860, 490)
    UI:SetPoint("CENTER")
    UI:SetMovable(true)
    UI:EnableMouse(true)
    UI:RegisterForDrag("LeftButton")
    UI:Hide()
    UI:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    UI:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)


    UI:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
        PlaySound(SOUNDKIT.FISHING_REEL_IN, "Master");
        UI:ReloadAll()
    end)
    UI:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
    end)

    -- Setup the show/hide button
    UI.showButtonTab = ShowButtons:Create(UI)

    -- Character Blurb
    UI.playerName = UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UI.playerName:SetPoint("TOPLEFT", UI, "TOPLEFT", 60, -46)
    UI.playerName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE")
    UI.playerInfo = UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    UI.playerInfo:SetPoint("BOTTOMLEFT", UI.playerName, "BOTTOMRIGHT", 5, 1)
    UI.playerInfo:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")

    -- Pretty up the frame
    local fd = FrameDecorations:Create(UI)
    UI.characterPortrait = fd.characterPortrait

    -- Make the Fish grid
    UI.grid = FishGrid:Create(DATA:GetSortedFishByCatchLevel(), UI, 42, 6, 3, 15)
    UI.grid:SetPoint("TOPLEFT", 10, -70)

    -- Make the fish info panel
    FishInfo:Create(UI)
    
    -- Make the zones list
    UI.zones = ZonesList:Create(UI)
    
    -- Make the zone info panel
    ZoneInfo:Create(UI)


    local tabManager = TabManager:Create()

    -- Make the recipes panel
    local resipesUI = Resipes:Create(UI)

    -- Make the equipment panel
    local equipmentUI = Equipment:Create(UI)

    -- Make the tab buttons
    local recipesToggleButton = tabManager:CreateTabButton("recipes", UI, "Recipes", "Recipes")
    recipesToggleButton:SetPoint("TOPRIGHT", UI, "TOPRIGHT", -18, -45)

    local equipmentToggleButton = tabManager:CreateTabButton("equipment", UI, "Equipment", "Equipment")
    equipmentToggleButton:SetPoint("RIGHT", recipesToggleButton, "LEFT", -5, 0)

    -- Register the tabs
    tabManager:Register('default', nil, UI.zoneinfo)
    tabManager:Register('recipes', recipesToggleButton, resipesUI)
    tabManager:Register('equipment', equipmentToggleButton, equipmentUI)
    
    
    UI.selectedIcon = CreateFrame("FRAME", "angler-grid-selected-icon", UI.grid.rows[1].items[1])
    UI.selectedIcon:SetSize(37, 37)
    UI.selectedIcon:SetPoint("CENTER", 0, 0)

    UI.selectedIcon.texture = UI.selectedIcon:CreateTexture(nil,'ARTWORK')
    UI.selectedIcon.texture:SetTexture("Interface\\Store\\store-item-highlight")
    UI.selectedIcon.texture:SetSize(64, 64)
    UI.selectedIcon.texture:SetPoint("CENTER", 0, 0)
    UI.selectedIcon.texture:SetBlendMode("ADD")
    UI.selectedIcon:Hide()

    UI.selectedZoneHighlight = CreateFrame("FRAME", "angler-zone-selected-icon", UI.zones.zoneButtons[1])
    UI.selectedZoneHighlight:SetSize(250, 30)
    UI.selectedZoneHighlight:SetPoint("CENTER", 0, 0)

    UI.selectedZoneHighlight.texture = UI.selectedZoneHighlight:CreateTexture(nil,'ARTWORK')
    UI.selectedZoneHighlight.texture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    UI.selectedZoneHighlight.texture:SetSize(380, 34)
    UI.selectedZoneHighlight.texture:SetPoint("CENTER", 0, 0)
    UI.selectedZoneHighlight.texture:SetBlendMode("ADD")
    UI.selectedZoneHighlight:Hide()

    SettingsAA:Create(UI)
end


function UI:ToggleUI()
    if UI:IsShown() then
        UI:Hide()
    else
        UI:Show()
    end
end

function UI:SelectZone(zoneId)
    if zoneId == nil then
        UI.selectedZoneHighlight:Hide()
        return  
    end
    
    if AnglerAtlas.STATE.selectedZone == zoneId then
        return
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    AnglerAtlas.STATE.selectedZone = zoneId
    
    -- print("Selected zone "..zoneId)
    ZonesList:Update()
    ZoneInfo:Update()
    UI.zones:SelectItem(zoneId)
end


function UI:SelectFish(fishId)
    if fishId == nil then
        UI.selectedIcon:Hide()
        return
    end
    if AnglerAtlas.STATE.selectedFish == fishId then
        return
    end
    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");  -- Page turn
    PlaySound(1189, "Master") -- Meaty thwack
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    AnglerAtlas.STATE.selectedFish = fishId
    AnglerAtlas.STATE.selectedFishData = DATA.fish[AnglerAtlas.STATE.selectedFish]

    local zones = DATA:GetSortedZonesForFish(AnglerAtlas.STATE.selectedFish)
    -- print("Zones for fish "..fishId)
    -- for i = 1, #zones do
    --     print(zones[i].name)
    -- end

    FishGrid:SelectFish(fishId)
    FishInfo:Update()
    Resipes:Update()
    UI:SelectZone(tostring(zones[1].id), UI.zones.zoneButtons[1])

end


function UI:Reload()
    DATA:LoadPlayerData()
    if AnglerAtlas.SKILL.hasFishing then
        local skillMod = AnglerAtlas.SKILL.skillModifier > 0 and "(|cFF00FF00+"..AnglerAtlas.SKILL.skillModifier.."|cFFFFFFFF) " or ""
        UI.playerInfo:SetText("level "..AnglerAtlas.SKILL.level.." "..skillMod..AnglerAtlas.SKILL.rankName.." angler")
    else
        UI.playerInfo:SetText("needs to find a fishing trainer")
    end
    FishGrid:Update()
    FishInfo:Update()
    ZonesList:Update()
    ZoneInfo:Update()

end

function UI:ReloadAll()
    UI:Reload()
    Resipes:Update()
    SetPortraitTexture(AnglerAtlas.UI.characterPortrait.texture, "player");
    UI.playerName:SetText(AnglerAtlas.PLAYER.name)
end