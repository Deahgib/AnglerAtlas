

function AnglerAtlas.UI:BuildAddonSettings()
    local panel = CreateFrame("Frame")
    panel.name = "AnglerAtlas"               -- see panel fields
    local category, layout
    category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name, panel.name);
    category.ID = panel.name
    Settings.RegisterAddOnCategory(category);

    -- add widgets to the panel as desired
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("AnglerAtlas")

    local subtitle = panel:CreateFontString("ARTWORK", nil, "GameFontHighlightSmall")
    subtitle:SetHeight(40)
    subtitle:SetPoint("TOPLEFT", 16, -32)
    subtitle:SetPoint("RIGHT", panel, -32, 0)
    subtitle:SetNonSpaceWrap(true)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetJustifyV("TOP")
    subtitle:SetText("AnglerAtlas is a fishing addon that shows you where to catch fish, what fish you can catch, and what fish are in season.")

    local info = panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
    info:SetHeight(40)
    info:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
    info:SetPoint("RIGHT", panel, -32, 0)
    info:SetNonSpaceWrap(true)
    info:SetJustifyH("LEFT")
    info:SetJustifyV("TOP")
    info:SetText("You can always use /aa /angler or /angleratlas to toggle the Angler Atlas main window.")

    local showSpellbookButton = CreateFrame("CheckButton", "AnglerAtlasShowSpellbookButton", panel, "InterfaceOptionsCheckButtonTemplate")
    showSpellbookButton:SetPoint("TOPLEFT", info, "BOTTOMLEFT", 0, -8)
    showSpellbookButton.text = showSpellbookButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showSpellbookButton.text:SetPoint("LEFT", showSpellbookButton, "RIGHT", 0, 3)
    showSpellbookButton.text:SetText("Show AnglerAtlas button in spellbook")
    showSpellbookButton.tooltipText = "Show AnglerAtlas button in spellbook"
    showSpellbookButton:SetScript("OnClick", function(self)
        AnglerAtlasSettings.showSpellbookButton = self:GetChecked()
        -- AnglerAtlas.UI:ShowSpellbookButton()
        if AnglerAtlasSettings.showSpellbookButton then
            AnglerAtlas.UI.showButtonTab:Show()
        else
            AnglerAtlas.UI.showButtonTab:Hide()
        end
    end)
    showSpellbookButton:SetChecked(AnglerAtlasSettings.showSpellbookButton)

    local showMinimapButton = CreateFrame("CheckButton", "AnglerAtlasShowMinimapButton", panel, "InterfaceOptionsCheckButtonTemplate")
    showMinimapButton:SetPoint("TOPLEFT", showSpellbookButton, "BOTTOMLEFT", 0, -8)
    showMinimapButton.text = showMinimapButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showMinimapButton.text:SetPoint("LEFT", showMinimapButton, "RIGHT", 0, 3)
    showMinimapButton.text:SetText("Show AnglerAtlas button on minimap")
    showMinimapButton.tooltipText = "Show AnglerAtlas button on minimap"
    showMinimapButton:SetScript("OnClick", function(self)
        AnglerAtlasSettings.miniMapIcon.hide = not self:GetChecked()
        LibDBIcon:Refresh("AnglerAtlas", AnglerAtlasSettings.miniMapIcon)
        -- AnglerAtlas.MM:ToggleMinimapButton()
    end)
    showMinimapButton:SetChecked(not AnglerAtlasSettings.miniMapIcon.hide)

end


local textColours = {
    ['green'] = "|cFF00FF00",
    ['red'] = "|cFFFF0000",
    ['white'] = "|cFFFFFFFF",
    ['yellow'] = "|cFFFFFF00",
    ['grey'] = "|cFF888888",
}

function AnglerAtlas.UI:SkillLevelColor(lvl)
    if AnglerAtlas.SKILL.hasFishing then
        local pLvl = AnglerAtlas.SKILL.modLevel
        if lvl <= pLvl then
            return textColours.green
        elseif lvl > pLvl+75 then
            return textColours.red
        else
            return textColours.yellow
        end
    else
        return textColours.red
    end
end

function AnglerAtlas.UI:CatchRateColor(rate)
    if rate <= 0.10 then
        return textColours.red
    elseif rate <= 0.3333 then
        return textColours.yellow
    else
        return textColours.green
    end
end

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






function AnglerAtlas.UI:BuildZonesList()
    AnglerAtlas.UI.zones = CreateFrame("FRAME", "angler-fish-info", AnglerAtlas.UI, "BackdropTemplate")
    AnglerAtlas.UI.zones:SetBackdrop({
        -- bgFile = "Interface\\AdventureMap\\AdventureMapParchmentTile", 
        bgFile = "Interface\\BankFrame\\Bank-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 160,
        edgeSize = 24,
        insets = {
            left = 5,
            right = 5,
            top = 2,
            bottom = 2
        }
    })
    AnglerAtlas.UI.zones:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    AnglerAtlas.UI.zones:SetSize(300, 203)
    AnglerAtlas.UI.zones:SetPoint("TOPLEFT", AnglerAtlas.UI.info, "BOTTOMLEFT", 0, -5)

    AnglerAtlas.UI.zones.scrollFrame = CreateFrame("ScrollFrame", nil, AnglerAtlas.UI.zones, "UIPanelScrollFrameTemplate")
    AnglerAtlas.UI.zones.scrollFrame:SetPoint("TOPLEFT", 10, -10)
    AnglerAtlas.UI.zones.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 8)

    AnglerAtlas.UI.zones.scrollFrame.scrollChild = CreateFrame("Frame")
    AnglerAtlas.UI.zones.scrollFrame:SetScrollChild(AnglerAtlas.UI.zones.scrollFrame.scrollChild)
    AnglerAtlas.UI.zones.scrollFrame.scrollChild:SetWidth(260)
    AnglerAtlas.UI.zones.scrollFrame.scrollChild:SetHeight(#AnglerAtlas.DATA.validZones * 30)  -- 50 is the height of each button

    AnglerAtlas.UI.zones.zoneButtons = {}

    for i = 1, #AnglerAtlas.DATA.validZones do
        local zone = AnglerAtlas.DATA.zones[AnglerAtlas.DATA.validZones[i]]
        local zoneButton = CreateFrame("BUTTON", "angler-zone-button-"..i, AnglerAtlas.UI.zones.scrollFrame.scrollChild, "UIPanelButtonTemplate")
        zoneButton:SetSize(250, 30)
        zoneButton:SetPoint("TOP", AnglerAtlas.UI.zones.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 30)
        zoneButton:SetScript("OnClick", function()
            AnglerAtlas.UI:SelectZone(zoneButton.zoneId)
        end)

        zoneButton.factionTexture = zoneButton:CreateTexture(nil,'ARTWORK')
        zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
        zoneButton.factionTexture:SetSize(20, 20)
        zoneButton.factionTexture:SetPoint("LEFT", zoneButton, "LEFT", 3, 0)



        zoneButton.name = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneButton.name:SetPoint("LEFT", zoneButton.factionTexture, "RIGHT", 10, 0)
        zoneButton.name:SetFont("Fonts\\FRIZQT__.ttf", 10)
        -- zoneButton.name:SetText(zone.name)

        -- zoneButton.zoneLevel = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        -- zoneButton.zoneLevel:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
        -- zoneButton.zoneLevel:SetFont("Fonts\\FRIZQT__.ttf", 10)
        -- zoneButton.zoneLevel:SetText(AnglerAtlas.UI:SkillLevelColor(zone.fishingLevel)..tostring(zone.fishingLevel))

        zoneButton.zoneCatchRate = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        zoneButton.zoneCatchRate:SetPoint("RIGHT", zoneButton, "RIGHT", -10, 0)
        zoneButton.zoneCatchRate:SetFont("Fonts\\FRIZQT__.ttf", 10)
        --zoneButton.zoneCatchRate:SetText(textColours.white..tostring("50%"))

        function zoneButton:SetZone(zoneId, name, catchRate, level)
            self.zoneId = zoneId
            self.name:SetText(name)
            self.zoneCatchRate:SetText(catchRate)
            -- self.zoneLevel:SetText(level)
        end
        zoneButton:Hide()

        AnglerAtlas.UI.zones.zoneButtons[i] = zoneButton

    end

    function AnglerAtlas.UI.zones:SelectItem(id)
        for i = 1, #self.zoneButtons do
            if self.zoneButtons[i].zoneId == id then
                AnglerAtlas.UI.selectedIcon:Show()
                AnglerAtlas.UI.selectedIcon:SetPoint("CENTER", self.zoneButtons[i], "CENTER", 0, 0)
            end
        end
    end
end

function AnglerAtlas.UI.BuildZoneInfoUI()
    AnglerAtlas.UI.zoneinfo = CreateFrame("FRAME", "angler-zone-info", AnglerAtlas.UI, "BackdropTemplate")
    -- AnglerAtlas.UI.zoneinfo:SetBackdrop({
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
    AnglerAtlas.UI.zoneinfo:SetBackdrop(AnglerAtlas.UI.ANGLER_BACKDROP)

    AnglerAtlas.UI.zoneinfo:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    AnglerAtlas.UI.zoneinfo:SetSize(300, 408)
    AnglerAtlas.UI.zoneinfo:SetPoint("TOPLEFT", AnglerAtlas.UI.info, "TOPRIGHT", 5, 0)

    AnglerAtlas.UI.zoneinfo.factionTexture = AnglerAtlas.UI.zoneinfo:CreateTexture(nil,'ARTWORK')
    AnglerAtlas.UI.zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
    AnglerAtlas.UI.zoneinfo.factionTexture:SetSize(32, 32)
    AnglerAtlas.UI.zoneinfo.factionTexture:SetPoint("TOPRIGHT", AnglerAtlas.UI.zoneinfo, "TOPRIGHT", -27, -30)
    AnglerAtlas.UI.zoneinfo.factionTexture:Hide()

    AnglerAtlas.UI.zoneinfo.name = AnglerAtlas.UI.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.zoneinfo.name:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo, "TOPLEFT", 28, -30)
    AnglerAtlas.UI.zoneinfo.name:SetFont("Fonts\\FRIZQT__.ttf", 18)
    -- AnglerAtlas.UI.zoneinfo.name:SetText("Zone name")

    AnglerAtlas.UI.zoneinfo.coastalInland = AnglerAtlas.UI.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.zoneinfo.coastalInland:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo.name, "BOTTOMLEFT", 0, -12)
    AnglerAtlas.UI.zoneinfo.coastalInland:SetFont("Fonts\\FRIZQT__.ttf", 12)
    AnglerAtlas.UI.zoneinfo.coastalInland:SetWordWrap(true)
    AnglerAtlas.UI.zoneinfo.coastalInland:SetWidth(250)
    AnglerAtlas.UI.zoneinfo.coastalInland:SetJustifyH("LEFT")
    -- AnglerAtlas.UI.zoneinfo.coastalInland:SetText("Has coastal and inland fishing")

    AnglerAtlas.UI.zoneinfo.fishingLevelMin = AnglerAtlas.UI.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo.coastalInland, "BOTTOMLEFT", 0, -7)
    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetFont("Fonts\\FRIZQT__.ttf", 12)
    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetWordWrap(true)
    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetWidth(250)
    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetJustifyH("LEFT")

    AnglerAtlas.UI.zoneinfo.fishingLevelMax = AnglerAtlas.UI.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo.fishingLevelMin, "BOTTOMLEFT", 0, -7)
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetFont("Fonts\\FRIZQT__.ttf", 12)
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetWordWrap(true)
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetWidth(250)
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetJustifyH("LEFT")

    AnglerAtlas.UI.zoneinfo.notes = AnglerAtlas.UI.zoneinfo:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.zoneinfo.notes:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo.fishingLevelMax, "BOTTOMLEFT", 0, -7)
    AnglerAtlas.UI.zoneinfo.notes:SetFont("Fonts\\FRIZQT__.ttf", 12)
    AnglerAtlas.UI.zoneinfo.notes:SetWordWrap(true)
    AnglerAtlas.UI.zoneinfo.notes:SetWidth(250)
    AnglerAtlas.UI.zoneinfo.notes:SetJustifyH("LEFT")

    AnglerAtlas.UI.zoneinfo.fishRates = CreateFrame("FRAME", "angler-zone-info-fish", AnglerAtlas.UI.zoneinfo, "BackdropTemplate") 
    AnglerAtlas.UI.zoneinfo.fishRates:SetBackdrop({
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
    AnglerAtlas.UI.zoneinfo.fishRates:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    AnglerAtlas.UI.zoneinfo.fishRates:SetSize(50, 408)
    AnglerAtlas.UI.zoneinfo.fishRates:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo, "TOPRIGHT", 0, 0)
    AnglerAtlas.UI.zoneinfo.fishRates.icons = {}
    for i = 1, 10 do
        local fishIcon = CreateFrame("BUTTON", "angler-zone-info-fish-icon-"..i, AnglerAtlas.UI.zoneinfo.fishRates, "ItemButtonTemplate")
        fishIcon:SetSize(37, 37)
        fishIcon:SetPoint("TOP", AnglerAtlas.UI.zoneinfo.fishRates, "TOP", 0, -6 - (i - 1) * 39)
        fishIcon:SetScript("OnClick", function()
            AnglerAtlas.UI:SelectFish(nil, fishIcon)
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
            fishIcon.data.name = AnglerAtlas.DATA.fish[fishId].name
            fishIcon.data.rate = rate
            fishIcon.data.id = fishId
            fishIcon.texture:SetTexture(GetItemIcon(fishId))
            fishIcon.rate:SetText(AnglerAtlas.UI:CatchRateColor(rate)..tostring(rate*100).."%")
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




        AnglerAtlas.UI.zoneinfo.fishRates.icons[i] = fishIcon
    end
    AnglerAtlas.UI.zoneinfo.fishRates:Hide()
end

function AnglerAtlas.UI:BuildRecipes()
    AnglerAtlas.UI.recipes = CreateFrame("FRAME", "angler-recipes-info", AnglerAtlas.UI, "BackdropTemplate")
    AnglerAtlas.UI.recipes:Raise()
    AnglerAtlas.UI.recipes:SetBackdrop(AnglerAtlas.UI.ANGLER_BACKDROP)
    AnglerAtlas.UI.recipes:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    AnglerAtlas.UI.recipes:SetSize(355, 408)
    AnglerAtlas.UI.recipes:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo, "TOPLEFT", 0, 0)
    AnglerAtlas.UI.recipes:Hide()
    -- On show hide
    AnglerAtlas.UI.recipes:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    end)
    AnglerAtlas.UI.recipes:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    end)



    AnglerAtlas.UI.recipes.text = AnglerAtlas.UI.recipes:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    AnglerAtlas.UI.recipes.text:SetPoint("TOPLEFT", AnglerAtlas.UI.recipes, "TOPLEFT", 28, -25)
    AnglerAtlas.UI.recipes.text:SetFont("Fonts\\FRIZQT__.ttf", 14)
    AnglerAtlas.UI.recipes.text:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Recipes for Raw Longjaw Mud Snapper")

    AnglerAtlas.UI.recipes.scrollFrame = CreateFrame("ScrollFrame", nil, AnglerAtlas.UI.recipes, "UIPanelScrollFrameTemplate")
    AnglerAtlas.UI.recipes.scrollFrame:SetPoint("TOPLEFT", 25, -43)
    AnglerAtlas.UI.recipes.scrollFrame:SetPoint("BOTTOMRIGHT", -45, 25)

    AnglerAtlas.UI.recipes.scrollFrame.scrollChild = CreateFrame("Frame")
    AnglerAtlas.UI.recipes.scrollFrame:SetScrollChild(AnglerAtlas.UI.recipes.scrollFrame.scrollChild)
    AnglerAtlas.UI.recipes.scrollFrame.scrollChild:SetWidth(280)
    AnglerAtlas.UI.recipes.scrollFrame.scrollChild:SetHeight(510)  -- 100 is the height of each panel (5 panels) + padding

    AnglerAtlas.UI.recipes.recipeItems = {}
    for i = 1, 5 do
        local recipeItem = CreateFrame("FRAME", "angler-recipe-item-"..i, AnglerAtlas.UI.recipes.scrollFrame.scrollChild, "BackdropTemplate")
        local bd = CopyTable(BACKDROP_TEXT_PANEL_0_16)
        bd.bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"
        bd.insets = { left = 3, right = 3, top = 3, bottom = 3 }
        
        recipeItem:SetBackdrop(bd)
        recipeItem:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
        recipeItem:SetSize(270, 100)
        recipeItem:SetPoint("TOP", AnglerAtlas.UI.recipes.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 102)

        recipeItem.data = {}
        recipeItem.data.recipeName = "Blackmouth Oil"
        recipeItem.data.productId = "6370"
        recipeItem.data.productQ = 1
        recipeItem.data.reagents = {}
        recipeItem.data.recipeItemId = "6661"

        recipeItem.productIcon = CreateFrame("BUTTON", "angler-recipe-product-icon-"..i, recipeItem, "ItemButtonTemplate")
        recipeItem.productIcon:SetSize(40, 40)
        recipeItem.productIcon:SetPoint("TOPLEFT", recipeItem, "TOPLEFT", 8, -6)
        -- recipeItem.productIcon:Hide()
        _G[recipeItem.productIcon:GetName().."NormalTexture"]:SetSize(40*1.662, 40*1.662)
        SetItemButtonTexture(recipeItem.productIcon, GetItemIcon(recipeItem.data.productId))

        recipeItem.productIcon.productQuantity = recipeItem.productIcon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        recipeItem.productIcon.productQuantity:SetPoint("BOTTOMRIGHT", recipeItem.productIcon, "BOTTOMRIGHT", -4, 4)
        recipeItem.productIcon.productQuantity:SetFont("Fonts\\FRIZQT__.ttf", 12    , "OUTLINE")
        recipeItem.productIcon.productQuantity:SetText("x1")

        -- Tooltip
        recipeItem.productIcon:SetScript("OnEnter", function()
            GameTooltip:SetOwner(recipeItem.productIcon, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(recipeItem.data.productId)
            GameTooltip:Show()
        end)

        recipeItem.productIcon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        recipeItem.recipeIcon = CreateFrame("BUTTON", "angler-recipe-icon-"..i, recipeItem, "ItemButtonTemplate")
        recipeItem.recipeIcon:SetSize(20, 20)
        recipeItem.recipeIcon:SetPoint("TOP", recipeItem.productIcon, "BOTTOM", 0, -5)
        SetItemButtonTexture(recipeItem.recipeIcon, GetItemIcon(recipeItem.data.recipeItemId))
        -- recipeItem.recipeIcon:Hide()
        _G[recipeItem.recipeIcon:GetName().."NormalTexture"]:SetSize(20*1.662, 20*1.662)

        -- Tooltip
        recipeItem.recipeIcon:SetScript("OnEnter", function()
            GameTooltip:SetOwner(recipeItem.recipeIcon, "ANCHOR_LEFT", 0, 0)
            GameTooltip:SetItemByID(recipeItem.data.recipeItemId)
            GameTooltip:Show()
        end)

        recipeItem.recipeIcon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        recipeItem.productName = recipeItem:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        recipeItem.productName:SetPoint("TOPLEFT", recipeItem.productIcon, "TOPRIGHT", 5, -5)
        recipeItem.productName:SetFont("Fonts\\FRIZQT__.ttf", 12)
        recipeItem.productName:SetText(recipeItem.data.recipeName)

        recipeItem.craftValueGoldDisplay = AnglerAtlas.UI:CreateGoldDisplay(recipeItem, "Unit price")
        recipeItem.craftValueGoldDisplay:SetPoint("BOTTOMRIGHT", recipeItem, "BOTTOMRIGHT", -5, 4)
        recipeItem.craftValueGoldDisplay:SetGold(11111)
        

        recipeItem.reagents = {}

        for j = 1, 5 do
            local reagent = CreateFrame("BUTTON", "angler-recipe-reagent-"..i.."-"..j, recipeItem, "ItemButtonTemplate")
            reagent:SetSize(28, 28)
            reagent:SetPoint("TOPLEFT", recipeItem.productName, "BOTTOMLEFT", 10 + (j - 1) * 31, -6)
            reagent:SetScript("OnClick", function()
                AnglerAtlas.UI:SelectFish(nil, reagent)
            end)
            SetItemButtonTexture(reagent, GetItemIcon(recipeItem.data.productId))
            -- reagent:Hide()
            _G[reagent:GetName().."NormalTexture"]:SetSize(28*1.662, 28*1.662)

            reagent.reagentQuantity = reagent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            reagent.reagentQuantity:SetPoint("BOTTOMRIGHT", reagent, "BOTTOMRIGHT", -3, 3)
            reagent.reagentQuantity:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
            reagent.reagentQuantity:SetText("x1")

            recipeItem.reagents[j] = reagent

            reagent.data = {}
            reagent.data.itemId = "6370"
            reagent.data.itemQ = 1
            function reagent:SetReagent(reagentData)
                reagent.data = reagentData
                SetItemButtonTexture(reagent, GetItemIcon(reagent.data.itemId))
                reagent.reagentQuantity:SetText("x"..tostring(reagent.data.itemQ))
            end

            -- Tooltip
            reagent:SetScript("OnEnter", function()
                GameTooltip:SetOwner(reagent, "ANCHOR_LEFT", 0, 0)
                GameTooltip:SetItemByID(reagent.data.itemId)
                GameTooltip:Show()
            end)

            reagent:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end

        function recipeItem:SetRecipe(recipeData)
            self.data = recipeData
            self.productName:SetText(recipeData.recipeName)
            SetItemButtonTexture(self.productIcon, GetItemIcon(recipeData.productId))
            if recipeData.recipeItemId == nil then
                self.recipeIcon:Hide()
            else
                self.recipeIcon:Show()
                SetItemButtonTexture(self.recipeIcon, GetItemIcon(recipeData.recipeItemId))
            end
            self.productIcon.productQuantity:SetText("x"..tostring(recipeData.productQ))
            for j = 1, 5 do
                if recipeData.reagents[j] ~= nil then
                    self.reagents[j]:SetReagent(recipeData.reagents[j])
                    self.reagents[j]:Show()
                else
                    self.reagents[j]:Hide()
                end
            end

            if Auctionator ~= nil then
                local auctionPrice = Auctionator.Database:GetPrice(tostring(recipeData.productId))
                if auctionPrice ~= nil then
                    self.craftValueGoldDisplay:SetGold(auctionPrice)
                    self.craftValueGoldDisplay:Show()
                else
                    self.craftValueGoldDisplay:Hide()
                end

            end
        end

        AnglerAtlas.UI.recipes.recipeItems[i] = recipeItem
    end
end

function AnglerAtlas.UI:BuildEquipment()
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
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(data.desc)
                GameTooltip:Show()
            end)
            equipmentItem:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            prevAnchor = equipmentItem
            equipmentRow.items[i] = equipmentItem
        end

        return equipmentRow
    end

    AnglerAtlas.UI.equipment = CreateFrame("FRAME", "angler-equipment-info", AnglerAtlas.UI, "BackdropTemplate")
    AnglerAtlas.UI.equipment:Raise()
    AnglerAtlas.UI.equipment:SetBackdrop(BACKDROP_GOLD_DIALOG_32_32)
    AnglerAtlas.UI.equipment:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    AnglerAtlas.UI.equipment:SetSize(355, 408)
    AnglerAtlas.UI.equipment:SetPoint("TOPLEFT", AnglerAtlas.UI.zoneinfo, "TOPLEFT", 0, 0)
    AnglerAtlas.UI.equipment:Hide()
    -- On show hide
    AnglerAtlas.UI.equipment:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    end)
    AnglerAtlas.UI.equipment:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE, "Master");
    end)

    AnglerAtlas.UI.equipment.gear = buildEquipmentRow(AnglerAtlas.UI.equipment, "Gear", AnglerAtlas.DATA.equipment.gear)
    AnglerAtlas.UI.equipment.gear:SetPoint("TOPLEFT", AnglerAtlas.UI.equipment, "TOPLEFT", 25, -25)

    AnglerAtlas.UI.equipment.rods = buildEquipmentRow(AnglerAtlas.UI.equipment, "Rods", AnglerAtlas.DATA.equipment.rods)
    AnglerAtlas.UI.equipment.rods:SetPoint("TOPLEFT", AnglerAtlas.UI.equipment.gear, "BOTTOMLEFT", 0, -20)

    AnglerAtlas.UI.equipment.lures = buildEquipmentRow(AnglerAtlas.UI.equipment, "Lures", AnglerAtlas.DATA.equipment.lures)
    AnglerAtlas.UI.equipment.lures:SetPoint("TOPLEFT", AnglerAtlas.UI.equipment.rods, "BOTTOMLEFT", 0, -20)

    AnglerAtlas.UI.equipment.other = buildEquipmentRow(AnglerAtlas.UI.equipment, "Other", AnglerAtlas.DATA.equipment.other)
    AnglerAtlas.UI.equipment.other:SetPoint("TOPLEFT", AnglerAtlas.UI.equipment.lures, "BOTTOMLEFT", 0, -20)
    
end

function AnglerAtlas.UI:CreateTabManager()
    return {
        infoTabButtons={},
        infoTabs={},
        selectedTab="default",
        Select = function (self, tabName)
            if self.selectedTab == tabName then
                return
            end
            -- print("Selecting tab "..tabName)
            for k, v in pairs(self.infoTabs) do
                if k == tabName then
                    v:Show()
                    if self.infoTabButtons[k] ~= nil then
                        self.infoTabButtons[k]:SetSelected(true)
                    end

                else
                    v:Hide()
                    if self.infoTabButtons[k] ~= nil then
                        self.infoTabButtons[k]:SetSelected(false)
                    end
                end
            end
            self.selectedTab = tabName
        end,
        CreateTabButton = function(self, tabName, parent, tabSelectedText, tabDeselectedText)
            local tabButton = CreateFrame("BUTTON", "angler-tab-button-"..#self.infoTabButtons+1, parent, "UIPanelButtonTemplate")
            tabButton:SetSize(120, 20)
            tabButton.tabName = tabName
            tabButton.selected = false
            tabButton:SetText(tabDeselectedText)
            tabButton.highlightTexture = tabButton:CreateTexture(nil,'ARTWORK')
            tabButton.highlightTexture:SetTexture("Interface\\UNITPOWERBARALT\\MetalBronze_Horizontal_Frame")
            tabButton.highlightTexture:SetSize(154, 35)
            tabButton.highlightTexture:SetPoint("CENTER", 0, 0)
            tabButton.highlightTexture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            tabButton.highlightTexture:Hide()
            tabButton:SetScript("OnClick", function()
                if tabButton.selected then
                    self:Select("default")
                    return
                end
                self:Select(tabButton.tabName)
            end)
            tabButton.SetSelected = function(self, selected)
                if selected then
                    self.selected = true
                    self:SetText(tabDeselectedText)
                    self.highlightTexture:Show()
                else
                    self.selected = false
                    self:SetText(tabSelectedText)
                    self.highlightTexture:Hide()
                end
            end
            return tabButton
        end,
        Register = function(self, tabName, tabButton, tabFrame)
            self.infoTabButtons[tabName] = tabButton
            self.infoTabs[tabName] = tabFrame
        end
    }
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- UI Updates


function AnglerAtlas.UI:UpdateZoneList()
    if AnglerAtlas.STATE.selectedFish == nil then
        AnglerAtlas.UI.zones.scrollFrame:Hide()
        return
    end
    if AnglerAtlas.STATE.selectedZone == nil then
        AnglerAtlas.UI.zones.scrollFrame:Hide()
        return
    end
    AnglerAtlas.UI.zones.scrollFrame:Show()
    -- local fishId = AnglerAtlas.STATE.selectedFish
    -- local fishInfo = AnglerAtlas.DATA.fish[fishId]
    -- local fishStats = AnglerAtlas.DATA.zones[AnglerAtlas.STATE.selectedZone].fishStats[fishId]
    local sortedZones = AnglerAtlas:GetSortedZonesForFish(AnglerAtlas.STATE.selectedFish)
    for i = 1, #AnglerAtlas.UI.zones.zoneButtons do
        local zoneButton = AnglerAtlas.UI.zones.zoneButtons[i]
        if zoneButton == nil then
            break
        end
        local zoneData = sortedZones[i]
        if zoneData == nil then
            zoneButton:Hide()
        else
            zoneButton:Show()

            local zoneNameText = zoneData.name
            local zoneCatchRateText = AnglerAtlas.UI:CatchRateColor(zoneData.fishStats[AnglerAtlas.STATE.selectedFish].catchChance)..tostring(zoneData.fishStats[AnglerAtlas.STATE.selectedFish].catchChance*100).."%"
            local zoneFishingLevelText = AnglerAtlas.UI:SkillLevelColor(zoneData.fishingLevel)..tostring(zoneData.fishingLevel)

            if zoneData.faction == "Contested" then
                zoneButton.factionTexture:Hide()
            else
                if zoneData.faction == "Horde" then
                    zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
                elseif zoneData.faction == "Alliance" then
                    zoneButton.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
                end
                
                zoneButton.factionTexture:Show()
            end
            

            -- print(zoneNameText)
            -- print(zoneCatchRateText)
            -- print(zoneFishingLevelText)
            zoneButton:SetZone(tostring(zoneData.id), zoneNameText, zoneCatchRateText, "")
        end
        
    end
    AnglerAtlas.UI.zones.scrollFrame.scrollChild:SetHeight(#sortedZones * 30 + 20)
    
    AnglerAtlas.UI.zones.scrollFrame:Show()
end

function AnglerAtlas.UI:UpdateZoneInfo()
    if AnglerAtlas.STATE.selectedZone == nil then
        AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText("")
        AnglerAtlas.UI.zoneinfo.fishRates:Hide()
        return
    end
    local zoneData = AnglerAtlas.DATA.zones[AnglerAtlas.STATE.selectedZone]
    if zoneData == nil then
        AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No zone selected")
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText("")
        AnglerAtlas.UI.zoneinfo.fishRates:Hide()
        return
    end
    AnglerAtlas.UI.zoneinfo.name:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR..zoneData.name)
    
    if zoneData.faction == "Contested" then
        AnglerAtlas.UI.zoneinfo.factionTexture:Hide()
    else
        AnglerAtlas.UI.zoneinfo.factionTexture:Show()
        if zoneData.faction == "Horde" then
            AnglerAtlas.UI.zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
        elseif zoneData.faction == "Alliance" then
            AnglerAtlas.UI.zoneinfo.factionTexture:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
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
        local fishInfo = AnglerAtlas.DATA.fish[fish.id]
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
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has both |cFF00FF00coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." and |cFF00FF00inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasCoastal then
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    elseif hasInland then
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has |cFF00FF00inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    else
        AnglerAtlas.UI.zoneinfo.coastalInland:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Has no |cFFFF0000coastal"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." or |cFFFF0000inland"..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." waters.")
    end

    AnglerAtlas.UI.zoneinfo.fishingLevelMin:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Min fishing level "..AnglerAtlas.UI:SkillLevelColor(zoneMinFishingLevel)..tostring(zoneMinFishingLevel))
    AnglerAtlas.UI.zoneinfo.fishingLevelMax:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Max fishing level "..AnglerAtlas.UI:SkillLevelColor(zoneMaxFishingLevel)..tostring(zoneMaxFishingLevel)..AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.." (required to catch all fish in this zone)")


    AnglerAtlas.UI.zoneinfo.fishRates:Show()
    for i = 1, #AnglerAtlas.UI.zoneinfo.fishRates.icons do
        local fishIcon = AnglerAtlas.UI.zoneinfo.fishRates.icons[i]
        if fishIcon == nil then
            break
        end
        local fishData = sortedFish[i]
        if fishData == nil then
            fishIcon:Hide()
        else
            fishIcon:Show()
            fishIcon:SetFish(fishData.id, fishData.catchChance)
        end
    end
end

function AnglerAtlas.UI:UpdateRecipes()
    if AnglerAtlas.STATE.selectedFish == nil then
        AnglerAtlas.UI.recipes.text:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."No fish selected")
        for i = 1, #AnglerAtlas.UI.recipes.recipeItems do
            local recipeFrame = AnglerAtlas.UI.recipes.recipeItems[i]
            if recipeFrame == nil then
                break
            end
            recipeFrame:Hide()
        end
        return
    end
    AnglerAtlas.UI.recipes.text:SetText(AnglerAtlas.UI.ANGLER_DARK_FONT_COLOR.."Recipes for "..AnglerAtlas.STATE.selectedFishData.name)
    for i = 1, #AnglerAtlas.UI.recipes.recipeItems do
        local recipeFrame = AnglerAtlas.UI.recipes.recipeItems[i]
        if recipeFrame == nil then
            break
        end
        local recipeData = AnglerAtlas.DATA.recipes[AnglerAtlas.STATE.selectedFish][i]
        if recipeData == nil then
            recipeFrame:Hide()
        else
            recipeFrame:Show()
            recipeFrame:SetRecipe(recipeData)
        end
    end
end
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