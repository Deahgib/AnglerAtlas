local RightSideInformationPanel = {}

local UI = AnglerAtlas.MM:GetModule("UI")

local TabManager = AnglerAtlas.MM:GetModule("TabManager")
local ZoneInfo = AnglerAtlas.MM:GetModule("ZoneInfo")
local Recipes = AnglerAtlas.MM:GetModule("Recipes")
local Equipment = AnglerAtlas.MM:GetModule("Equipment")

function RightSideInformationPanel:Create(uiParent)

    local container = CreateFrame("FRAME", "angler-right-side-information-panel", uiParent)
    container:SetSize(300, 408)
    container:SetPoint("TOPLEFT", UI.info, "TOPRIGHT", 5, 0)
    
    local tabManager = TabManager:Create()


    -- Make the zone info panel
    local zoneInfo = ZoneInfo:Create(container)

    -- Make the recipes panel
    local RecipesUI = Recipes:Create(container, zoneInfo)

    -- Make the equipment panel
    local equipmentUI = Equipment:Create(container, zoneInfo)

    -- Make the tab buttons
    local defaultToggleButton = tabManager:CreateTabButton("default", container, '203750', "Zone Info")
    defaultToggleButton:SetPoint("BOTTOMLEFT", container, "TOPLEFT", 12, -3)

    local recipesToggleButton = tabManager:CreateTabButton("recipes", container, '21742', "Recipes")
    recipesToggleButton:SetPoint("LEFT", defaultToggleButton, "RIGHT", -5, 0)

    local equipmentToggleButton = tabManager:CreateTabButton("equipment", container, '19972', "Equipment")
    equipmentToggleButton:SetPoint("LEFT", recipesToggleButton, "RIGHT", -5, 0)

    -- Register the tabs
    tabManager:Register('default', defaultToggleButton, zoneInfo)
    tabManager:Register('recipes', recipesToggleButton, RecipesUI)
    tabManager:Register('equipment', equipmentToggleButton, equipmentUI)

    tabManager:Select('default')

end

AnglerAtlas.MM:RegisterModule("RightSideInformationPanel", RightSideInformationPanel)