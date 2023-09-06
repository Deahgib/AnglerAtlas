

AnglerAtlas:loadPlayerData()





AnglerAtlas.UI:SetFrameStrata("DIALOG")
AnglerAtlas.UI:SetSize(860, 490)
AnglerAtlas.UI:SetPoint("CENTER") -- Doesn't need to be ("CENTER", UIParent, "CENTER")
AnglerAtlas.UI:SetMovable(true)
AnglerAtlas.UI:EnableMouse(true)
AnglerAtlas.UI:RegisterForDrag("LeftButton")
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

AnglerAtlas.UI:RegisterEvent("UNIT_INVENTORY_CHANGED")
AnglerAtlas.UI:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
AnglerAtlas.UI:RegisterEvent("SKILL_LINES_CHANGED")
AnglerAtlas.UI:SetScript("OnEvent", function (self, event)
    -- print("Event: "..event)
    if event == "UNIT_INVENTORY_CHANGED" or 
       event == "PLAYER_EQUIPMENT_CHANGED" or
       event == "SKILL_LINES_CHANGED" then
        AnglerAtlas.UI:Reload()
    end
end)

AnglerAtlas.UI.characterPortrait = CreateFrame("FRAME", "angler-character-portrait", AnglerAtlas.UI)
AnglerAtlas.UI.characterPortrait:SetSize(64, 64)
AnglerAtlas.UI.characterPortrait:SetPoint("CENTER", AnglerAtlas.UI, "TOPLEFT", 25, -21)
AnglerAtlas.UI.characterPortrait.texture = AnglerAtlas.UI.characterPortrait:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.characterPortrait.texture:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
AnglerAtlas.UI.characterPortrait.texture:SetAllPoints()

AnglerAtlas.UI.characterPortrait.border = CreateFrame("FRAME", "angler-character-portrait-border", AnglerAtlas.UI.characterPortrait)
AnglerAtlas.UI.characterPortrait.border:SetSize(63*1.28, 63*1.28)
AnglerAtlas.UI.characterPortrait.border:SetPoint("TOPLEFT", AnglerAtlas.UI.characterPortrait, "TOPLEFT", -7.5, 1)
AnglerAtlas.UI.characterPortrait.border.texture = AnglerAtlas.UI.characterPortrait.border:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.characterPortrait.border.texture:SetTexture("Interface\\FrameGeneral\\UI-Frame")
AnglerAtlas.UI.characterPortrait.border.texture:SetAllPoints()
AnglerAtlas.UI.characterPortrait.border.texture:SetTexCoord(0, 0.625, 0, 0.625)   


AnglerAtlas.UI.title = AnglerAtlas.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.title:SetPoint("LEFT", AnglerAtlas.UI.TitleBg, "LEFT", 60, 0)
AnglerAtlas.UI.title:SetText("|cFFDDFF00Angler Atlas")
AnglerAtlas.UI.title:SetFont("Fonts\\FRIZQT__.ttf", 11, "OUTLINE")

AnglerAtlas.UI.playerName = AnglerAtlas.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.playerName:SetPoint("TOPLEFT", AnglerAtlas.UI, "TOPLEFT", 60, -46)
AnglerAtlas.UI.playerName:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE")

AnglerAtlas.UI.playerInfo = AnglerAtlas.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.playerInfo:SetPoint("BOTTOMLEFT", AnglerAtlas.UI.playerName, "BOTTOMRIGHT", 5, 1)
AnglerAtlas.UI.playerInfo:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")


AnglerAtlas.UI.bottomBanner = AnglerAtlas.UI:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.bottomBanner:SetHorizTile(true)

AnglerAtlas.UI.bottomBanner:SetTexture("Interface\\COMMON\\UI-Goldborder-_tile", "REPEAT", "CLAMP", "LINEAR")
AnglerAtlas.UI.bottomBanner:SetSize(855, 64)
AnglerAtlas.UI.bottomBanner:SetPoint("TOP", AnglerAtlas.UI, "TOP", -1, -23)





local offset = 0

local validFish = {}
for k in pairs(AnglerAtlas.DATA.fish) do table.insert(validFish, k) end

local validZones = {}
for k in pairs(AnglerAtlas.DATA.zones) do table.insert(validZones, k) end


-- print("Building UI")

AnglerAtlas.UI.showButtonTab = CreateFrame("FRAME", "angler-show-button-tab", SpellBookSideTabsFrame)
AnglerAtlas.UI.showButtonTab:SetSize(62, 62)
AnglerAtlas.UI.showButtonTab:SetPoint("BOTTOMRIGHT", SpellBookSideTabsFrame, "BOTTOMRIGHT", 27, 80)
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
    AnglerAtlas.UI:Show()
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




-- local function isFishValid(fishId)
--     return AnglerAtlas.DATA.fish[fishId] ~= nil
-- end

-- sort fish by fishing level
table.sort(validFish, function(a, b)
    if AnglerAtlas.DATA.fish[a].avoidGetawayLevel == AnglerAtlas.DATA.fish[b].avoidGetawayLevel then
        return AnglerAtlas.DATA.fish[a].minimumFishingLevel < AnglerAtlas.DATA.fish[b].minimumFishingLevel
    end
    return AnglerAtlas.DATA.fish[a].avoidGetawayLevel < AnglerAtlas.DATA.fish[b].avoidGetawayLevel
end)

AnglerAtlas.UI.grid = AnglerAtlas.UI:CreateItemGrid(validFish, AnglerAtlas.UI, 42, 6, 3, 15)
AnglerAtlas.UI.grid:SetPoint("TOPLEFT", 10, -70)



AnglerAtlas.UI.info = CreateFrame("FRAME", "angler-fish-info", AnglerAtlas.UI, "BackdropTemplate")
AnglerAtlas.UI.info:SetBackdrop({
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
AnglerAtlas.UI.info:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
AnglerAtlas.UI.info:SetSize(300, 200)
AnglerAtlas.UI.info:SetPoint("TOPLEFT", AnglerAtlas.UI.grid, "TOPRIGHT", 5, 0)

AnglerAtlas.UI.info.name = AnglerAtlas.UI.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.info.name:SetPoint("TOPLEFT", AnglerAtlas.UI.info, "TOPLEFT", 55, -16)
AnglerAtlas.UI.info.name:SetFont("Fonts\\FRIZQT__.ttf", 15, "OUTLINE")
-- AnglerAtlas.UI.info.name:SetText("Name")
AnglerAtlas.UI.info.icon = CreateFrame("BUTTON", "angler-fish-info-icon", AnglerAtlas.UI.info, "ItemButtonTemplate")
AnglerAtlas.UI.info.icon:SetSize(42, 42)
AnglerAtlas.UI.info.icon:SetPoint("TOPLEFT", AnglerAtlas.UI.info, "TOPLEFT", 10, -10)

AnglerAtlas.UI.info.icon.texture = AnglerAtlas.UI.info.icon:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.info.icon.texture:SetAllPoints()

AnglerAtlas.UI.info.itemLevel = AnglerAtlas.UI.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.info.itemLevel:SetPoint("TOPLEFT", AnglerAtlas.UI.info.name, "BOTTOMLEFT", 0, -6)

AnglerAtlas.UI.info.itemStackCount = AnglerAtlas.UI.info.icon:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.info.itemStackCount:SetPoint("BOTTOMRIGHT", AnglerAtlas.UI.info.icon, "BOTTOMRIGHT", -4, 4)
AnglerAtlas.UI.info.itemStackCount:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

AnglerAtlas.UI.info.goldAuctionPrice = AnglerAtlas.UI:CreateGoldDisplay(AnglerAtlas.UI.info, "Auction unit price")
AnglerAtlas.UI.info.goldAuctionPrice:SetPoint("BOTTOMRIGHT", AnglerAtlas.UI.info, "BOTTOMRIGHT", -8, 8)
AnglerAtlas.UI.info.goldAuctionPrice:Hide()

AnglerAtlas.UI.info.buffFish = CreateFrame("FRAME", "angler-fish-info-buff", AnglerAtlas.UI.info)
AnglerAtlas.UI.info.buffFish:SetSize(30, 30)
AnglerAtlas.UI.info.buffFish:SetPoint("TOPRIGHT", AnglerAtlas.UI.info, "TOPRIGHT", -8, -8)
AnglerAtlas.UI.info.buffFish.texture = AnglerAtlas.UI.info.buffFish:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.info.buffFish.texture:SetTexture("Interface\\Icons\\Spell_Misc_Food")
AnglerAtlas.UI.info.buffFish.texture:SetAllPoints()
AnglerAtlas.UI.info.buffFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
AnglerAtlas.UI.info.buffFish:SetScript("OnEnter", function()
    GameTooltip:SetOwner(AnglerAtlas.UI.info.buffFish, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine("This fish can be cooked into a buff food")
    GameTooltip:Show()
end)
AnglerAtlas.UI.info.buffFish:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
AnglerAtlas.UI.info.buffFish:Hide()

AnglerAtlas.UI.info.alchemicFish = CreateFrame("FRAME", "angler-fish-info-alchemic", AnglerAtlas.UI.info)
AnglerAtlas.UI.info.alchemicFish:SetSize(30, 30)
AnglerAtlas.UI.info.alchemicFish:SetPoint("TOPRIGHT", AnglerAtlas.UI.info.buffFish, "BOTTOMRIGHT", 0, -4)
AnglerAtlas.UI.info.alchemicFish.texture = AnglerAtlas.UI.info.alchemicFish:CreateTexture(nil,'ARTWORK')
AnglerAtlas.UI.info.alchemicFish.texture:SetTexture("Interface\\Icons\\INV_Potion_93")
AnglerAtlas.UI.info.alchemicFish.texture:SetAllPoints()
AnglerAtlas.UI.info.alchemicFish.texture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
AnglerAtlas.UI.info.alchemicFish:SetScript("OnEnter", function()
    GameTooltip:SetOwner(AnglerAtlas.UI.info.alchemicFish, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:AddLine("This fish is used by alchemists")
    GameTooltip:Show()
end)
AnglerAtlas.UI.info.alchemicFish:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
AnglerAtlas.UI.info.alchemicFish:Hide()

AnglerAtlas.UI.info.levelText = AnglerAtlas.UI.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.info.levelText:SetPoint("TOPLEFT", AnglerAtlas.UI.info.icon, "BOTTOMLEFT", 0, -10)
AnglerAtlas.UI.info.levelText:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")
-- AnglerAtlas.UI.info.levelText:SetText("Min fishing level "..AnglerAtlas.UI:SkillLevelColor(1).."1|cFFFFFFFF, optimal fishing level "..AnglerAtlas.UI:SkillLevelColor(455).."455")

AnglerAtlas.UI.info.waterType = AnglerAtlas.UI.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AnglerAtlas.UI.info.waterType:SetPoint("TOPLEFT", AnglerAtlas.UI.info.levelText, "BOTTOMLEFT", 0, -5)
AnglerAtlas.UI.info.waterType:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")

AnglerAtlas.UI.info.requirements = {}
local reqOffset = -15
for i = 1, 2 do
    local text = AnglerAtlas.UI.info:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", AnglerAtlas.UI.info.waterType, "BOTTOMLEFT", 0, reqOffset)
    reqOffset = reqOffset - 30
    text:SetFont("Fonts\\FRIZQT__.ttf", 10, "THINOUTLINE")
    text:SetWordWrap(true)
    text:SetWidth(280)
    text:SetJustifyH("LEFT")
    -- text:SetSpacing(10)
    
    -- text:SetText("Requirement "..i) 
    table.insert(AnglerAtlas.UI.info.requirements, text)
end


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
AnglerAtlas.UI.zones.scrollFrame.scrollChild:SetHeight(#validZones * 30)  -- 50 is the height of each button

AnglerAtlas.UI.zones.zoneButtons = {}

for i = 1, #validZones do
    local zone = AnglerAtlas.DATA.zones[validZones[i]]
    local zoneButton = CreateFrame("BUTTON", "angler-zone-button-"..i, AnglerAtlas.UI.zones.scrollFrame.scrollChild, "UIPanelButtonTemplate")
    zoneButton:SetSize(250, 30)
    zoneButton:SetPoint("TOP", AnglerAtlas.UI.zones.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 30)
    zoneButton:SetScript("OnClick", function()
        AnglerAtlas:SelectZone(zoneButton.zoneId, zoneButton)
    end)

    zoneButton.name = zoneButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    zoneButton.name:SetPoint("LEFT", zoneButton, "LEFT", 10, 0)
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
local backdrop = CopyTable(BACKDROP_ACHIEVEMENTS_0_64)
backdrop.bgFile = "Interface\\AdventureMap\\AdventureMapParchmentTile"
backdrop.insets = { left = 24, right = 24, top = 22, bottom = 24 }
AnglerAtlas.UI.zoneinfo:SetBackdrop(backdrop)

AnglerAtlas.UI.zoneinfo:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
AnglerAtlas.UI.zoneinfo:SetSize(300, 408)
AnglerAtlas.UI.zoneinfo:SetPoint("TOPLEFT", AnglerAtlas.UI.info, "TOPRIGHT", 5, 0)

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



AnglerAtlas.UI.BuildZoneInfoUI(AnglerAtlas.UI.zoneinfo)




AnglerAtlas.UI.infoTabButtons = {}
AnglerAtlas.UI.infoTabs = {}
AnglerAtlas.UI.selectedTab = "default"

local function TabButton_selectTab(tabName)
    if AnglerAtlas.UI.selectedTab == tabName then
        return
    end
    -- print("Selecting tab "..tabName)
    for k, v in pairs(AnglerAtlas.UI.infoTabs) do
        if k == tabName then
            v:Show()
            if AnglerAtlas.UI.infoTabButtons[k] ~= nil then
                AnglerAtlas.UI.infoTabButtons[k]:SetSelected(true)
            end

        else
            v:Hide()
            if AnglerAtlas.UI.infoTabButtons[k] ~= nil then
                AnglerAtlas.UI.infoTabButtons[k]:SetSelected(false)
            end
        end
    end
    AnglerAtlas.UI.selectedTab = tabName
end


local function CreateTabButton(tabName, parent, tabSelectedText, tabDeselectedText)
    local tabButton = CreateFrame("BUTTON", "angler-tab-button-"..#AnglerAtlas.UI.infoTabButtons+1, parent, "UIPanelButtonTemplate")
    tabButton:SetSize(120, 20)
    tabButton.tabName = tabName
    tabButton.selected = false
    tabButton:SetText(tabSelectedText)
    tabButton.highlightTexture = tabButton:CreateTexture(nil,'ARTWORK')
    tabButton.highlightTexture:SetTexture("Interface\\UNITPOWERBARALT\\MetalBronze_Horizontal_Frame")
    tabButton.highlightTexture:SetSize(154, 35)
    tabButton.highlightTexture:SetPoint("CENTER", 0, 0)
    -- tabButton.highlightTexture:SetBlendMode("ADD")
    tabButton.highlightTexture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
    tabButton.highlightTexture:Hide()
    tabButton:SetScript("OnClick", function()
        if tabButton.selected then
            TabButton_selectTab("default")
            return
        end
        TabButton_selectTab(tabButton.tabName)
    end)
    function tabButton:SetSelected(val)
        if val then
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
end


local function RegisterTab(tabName, tabButton, tabFrame)
    AnglerAtlas.UI.infoTabs[tabName] = tabFrame
    AnglerAtlas.UI.infoTabButtons[tabName] = tabButton
end


AnglerAtlas.UI.recipes = CreateFrame("FRAME", "angler-recipes-info", AnglerAtlas.UI, "BackdropTemplate")
AnglerAtlas.UI.recipes:Raise()
AnglerAtlas.UI.recipes:SetBackdrop(backdrop)
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
            AnglerAtlas:SelectFish(nil, reagent)
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

AnglerAtlas.UI.recipesToggleButton = CreateTabButton("recipes", AnglerAtlas.UI, "Recipes", "Recipes")
AnglerAtlas.UI.recipesToggleButton:SetPoint("TOPRIGHT", AnglerAtlas.UI, "TOPRIGHT", -18, -45)

AnglerAtlas.UI.equipmentToggleButton = CreateTabButton("equipment", AnglerAtlas.UI, "Equipment", "Equipment")
AnglerAtlas.UI.equipmentToggleButton:SetPoint("RIGHT", AnglerAtlas.UI.recipesToggleButton, "LEFT", -5, 0)

RegisterTab('default', nil, AnglerAtlas.UI.zoneinfo)
RegisterTab('recipes', AnglerAtlas.UI.recipesToggleButton, AnglerAtlas.UI.recipes)
RegisterTab('equipment', AnglerAtlas.UI.equipmentToggleButton, AnglerAtlas.UI.equipment)


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

function AnglerAtlas.UI:Reload()
    AnglerAtlas:loadPlayerData()
    if AnglerAtlas.SKILL.hasFishing then
        local skillMod = AnglerAtlas.SKILL.skillModifier > 0 and "(|cFF00FF00+"..AnglerAtlas.SKILL.skillModifier.."|cFFFFFFFF) " or ""
        AnglerAtlas.UI.playerInfo:SetText("level "..AnglerAtlas.SKILL.level.." "..skillMod..AnglerAtlas.SKILL.rankName.." angler")
    else
        AnglerAtlas.UI.playerInfo:SetText("needs to find a fishing trainer")
    end
    AnglerAtlas.UI:UpdateFishGrid()
    AnglerAtlas.UI:UpdateFishInfo()
    AnglerAtlas.UI:UpdateZoneList()
    AnglerAtlas.UI:UpdateZoneInfo()
end


local function init()
    -- printGreeting()
    
    AnglerAtlas:SelectFish(nil)
    -- AnglerAtlas.UI:Show()
end

init()

