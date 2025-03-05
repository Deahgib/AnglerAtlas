




function AnglerAtlas.UI:BuildShowButtons()
        -- print("Building UI")

    AnglerAtlas.UI.showButtonTab = CreateFrame("FRAME", "angler-show-button-tab", SpellBookSideTabsFrame)
    AnglerAtlas.UI.showButtonTab:SetSize(62, 62)
    AnglerAtlas.UI.showButtonTab:SetPoint("BOTTOMRIGHT", SpellBookSideTabsFrame, "BOTTOMRIGHT", 27, 150)
    AnglerAtlas.UI.showButtonTab.texture = AnglerAtlas.UI.showButtonTab:CreateTexture(nil,'ARTWORK')
    AnglerAtlas.UI.showButtonTab.texture:SetTexture("Interface\\SPELLBOOK\\SpellBook-SkillLineTab")
    AnglerAtlas.UI.showButtonTab.texture:SetAllPoints()

    AnglerAtlas.UI.showButtonTab.showButton = CreateFrame("BUTTON", "angler-show-button", AnglerAtlas.UI.showButtonTab, "ItemButtonTemplate")
    AnglerAtlas.UI.showButtonTab.showButton:SetSize(32, 32)
    -- -- print(AnglerAtlas.UI.showButton.NormalTexture)
    -- AnglerAtlas.UI.showButton.NormalTexture:SetTexture("Interface\\Buttons\\UI-PlusButton-Up")
    -- AnglerAtlas.UI.showButton.NormalTexture:SetSize(16, 16)
    AnglerAtlas.UI.showButtonTab.showButton:SetPoint("TOPLEFT", AnglerAtlas.UI.showButtonTab, "TOPLEFT", 3, -10)


    -- for k, v in pairs(AnglerAtlas.UI.showButtonTab.showButton) do
    --     print(k)
    -- end
    _G[AnglerAtlas.UI.showButtonTab.showButton:GetName().."NormalTexture"]:SetSize(50, 50)


    AnglerAtlas.UI.showButtonTab.showButton:SetScript("OnClick", function()
        AnglerAtlas.UI:ToggleUI()
    end)
    AnglerAtlas.UI.showButtonTab.showButton:SetScript("OnEnter", function()
        GameTooltip:SetOwner(AnglerAtlas.UI.showButtonTab.showButton, "ANCHOR_RIGHT")
        GameTooltip:AddLine("Calpico's 'A Master's Guide to Fishing'")
        GameTooltip:Show()
    end)

    AnglerAtlas.UI.showButtonTab.showButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    SetItemButtonTexture(AnglerAtlas.UI.showButtonTab.showButton, GetItemIcon('19970')) 

    if not AnglerAtlasSettings.showSpellbookButton then
        AnglerAtlas.UI.showButtonTab:Hide()
    end

    -- Minimap icon
    LibDBIcon:Register("AnglerAtlas", LDB, AnglerAtlasSettings.miniMapIcon)
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- UI Updates



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- UI Build

function AnglerAtlas.UI:Build()
    AnglerAtlas.UI:SetFrameStrata("DIALOG")
    AnglerAtlas.UI:SetSize(860, 490)
    AnglerAtlas.UI:SetPoint("CENTER") -- Doesn't need to be ("CENTER", UIParent, "CENTER")
    AnglerAtlas.UI:SetMovable(true)
    AnglerAtlas.UI:EnableMouse(true)
    AnglerAtlas.UI:RegisterForDrag("LeftButton")
    function AnglerAtlas.UI:ToggleUI()
        if AnglerAtlas.UI:IsShown() then
            AnglerAtlas.UI:Hide()
        else
            AnglerAtlas.UI:Show()
        end
    end
    AnglerAtlas.UI:Hide()
    AnglerAtlas.UI:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    AnglerAtlas.UI:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)


    AnglerAtlas.UI:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
        PlaySound(SOUNDKIT.FISHING_REEL_IN, "Master");
        AnglerAtlas.UI:ReloadAll()
    end)
    AnglerAtlas.UI:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
    end)

    -- Setup the show/hide button
    AnglerAtlas.UI:BuildShowButtons()

    -- Character Blurb
    AnglerAtlas.UI.playerName = AnglerAtlas.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.playerName:SetPoint("TOPLEFT", AnglerAtlas.UI, "TOPLEFT", 60, -46)
    AnglerAtlas.UI.playerName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE")
    AnglerAtlas.UI.playerInfo = AnglerAtlas.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.playerInfo:SetPoint("BOTTOMLEFT", AnglerAtlas.UI.playerName, "BOTTOMRIGHT", 5, 1)
    AnglerAtlas.UI.playerInfo:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")

    -- Pretty up the frame
    AnglerAtlas.UI:BuildFrameDecorations()

    -- Make the Fish grid
    AnglerAtlas.UI.grid = AnglerAtlas.UI:CreateItemGrid(DATA:GetSortedFishByCatchLevel(), AnglerAtlas.UI, 42, 6, 3, 15)
    AnglerAtlas.UI.grid:SetPoint("TOPLEFT", 10, -70)

    -- Make the fish info panel
    AnglerAtlas.UI:BuildFishInfo()
    
    -- Make the zones list
    AnglerAtlas.UI:BuildZonesList()
    
    -- Make the zone info panel
    AnglerAtlas.UI.BuildZoneInfoUI()


    AnglerAtlas.UI.tabManager = AnglerAtlas.UI:CreateTabManager()

    -- Make the recipes panel
    AnglerAtlas.UI:BuildRecipes()

    -- Make the equipment panel
    AnglerAtlas.UI:BuildEquipment()

    -- Make the tab buttons
    AnglerAtlas.UI.recipesToggleButton = AnglerAtlas.UI.tabManager:CreateTabButton("recipes", AnglerAtlas.UI, "Recipes", "Recipes")
    AnglerAtlas.UI.recipesToggleButton:SetPoint("TOPRIGHT", AnglerAtlas.UI, "TOPRIGHT", -18, -45)

    AnglerAtlas.UI.equipmentToggleButton = AnglerAtlas.UI.tabManager:CreateTabButton("equipment", AnglerAtlas.UI, "Equipment", "Equipment")
    AnglerAtlas.UI.equipmentToggleButton:SetPoint("RIGHT", AnglerAtlas.UI.recipesToggleButton, "LEFT", -5, 0)

    -- Register the tabs
    AnglerAtlas.UI.tabManager:Register('default', nil, AnglerAtlas.UI.zoneinfo)
    AnglerAtlas.UI.tabManager:Register('recipes', AnglerAtlas.UI.recipesToggleButton, AnglerAtlas.UI.recipes)
    AnglerAtlas.UI.tabManager:Register('equipment', AnglerAtlas.UI.equipmentToggleButton, AnglerAtlas.UI.equipment)
    
    
    AnglerAtlas.UI.selectedIcon = CreateFrame("FRAME", "angler-grid-selected-icon", AnglerAtlas.UI.grid.rows[1].items[1])
    AnglerAtlas.UI.selectedIcon:SetSize(37, 37)
    AnglerAtlas.UI.selectedIcon:SetPoint("CENTER", 0, 0)

    AnglerAtlas.UI.selectedIcon.texture = AnglerAtlas.UI.selectedIcon:CreateTexture(nil,'ARTWORK')
    AnglerAtlas.UI.selectedIcon.texture:SetTexture("Interface\\Store\\store-item-highlight")
    AnglerAtlas.UI.selectedIcon.texture:SetSize(64, 64)
    AnglerAtlas.UI.selectedIcon.texture:SetPoint("CENTER", 0, 0)
    AnglerAtlas.UI.selectedIcon.texture:SetBlendMode("ADD")
    AnglerAtlas.UI.selectedIcon:Hide()

    AnglerAtlas.UI.selectedZoneHighlight = CreateFrame("FRAME", "angler-zone-selected-icon", AnglerAtlas.UI.zones.zoneButtons[1])
    AnglerAtlas.UI.selectedZoneHighlight:SetSize(250, 30)
    AnglerAtlas.UI.selectedZoneHighlight:SetPoint("CENTER", 0, 0)

    AnglerAtlas.UI.selectedZoneHighlight.texture = AnglerAtlas.UI.selectedZoneHighlight:CreateTexture(nil,'ARTWORK')
    AnglerAtlas.UI.selectedZoneHighlight.texture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    AnglerAtlas.UI.selectedZoneHighlight.texture:SetSize(380, 34)
    AnglerAtlas.UI.selectedZoneHighlight.texture:SetPoint("CENTER", 0, 0)
    AnglerAtlas.UI.selectedZoneHighlight.texture:SetBlendMode("ADD")
    AnglerAtlas.UI.selectedZoneHighlight:Hide()

    AnglerAtlas.UI:BuildAddonSettings()
end