local UI = AnglerAtlas.MM:GetModule("UI")

local STATE = AnglerAtlas.MM:GetModule("STATE")

local DATA = AnglerAtlas.MM:GetModule("DATA")

local FrameDecorations = AnglerAtlas.MM:GetModule("FrameDecorations")

local ShowButtons = AnglerAtlas.MM:GetModule("ShowButtons")

local FishGrid = AnglerAtlas.MM:GetModule("FishGrid")

local FishInfo = AnglerAtlas.MM:GetModule("FishInfo")

local ZonesList = AnglerAtlas.MM:GetModule("ZonesList")

local ZoneInfo = AnglerAtlas.MM:GetModule("ZoneInfo")

local Resipes = AnglerAtlas.MM:GetModule("Resipes")

local RightSideInformationPanel = AnglerAtlas.MM:GetModule("RightSideInformationPanel")

local SettingsAA = AnglerAtlas.MM:GetModule("SettingsAA")

local MapFishRates = AnglerAtlas.MM:GetModule("MapFishRates")


-------------------------------------------------
-- Battle plans:
-------------------------------------------------

-- Get the UI local to be assigned to the UI in the Core.lua

-- Pull out the UI Initialization code from the Data.lua and place it in this file

-- Create a function UI:Build() that will build the UI this file will 
-- be using AnglerAtlasLoader to grab all the UI components

-- Create a function UI:ToggleUI() that will toggle the UI

-- Create a function UI:Refresh() that will update the fish

local isInitialised = false

function UI:Build()
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
    UI.fd = FrameDecorations:Create(UI)

    -- Make the Fish grid
    UI.grid = FishGrid:Create(DATA:GetSortedFishByCatchLevel(), UI, 42, 6, 3, 15)
    UI.grid:SetPoint("TOPLEFT", 10, -70)

    -- Make the fish info panel
    FishInfo:Create(UI)
    
    -- Make the zones list
    UI.zones = ZonesList:Create(UI)
    
    RightSideInformationPanel:Create(UI)

    SettingsAA:Create(UI)

    MapFishRates:Create()

    isInitialised = true
end


function UI:ToggleUI()
    if not isInitialised then
        return
    end
    if UI:IsShown() then
        UI:Hide()
    else
        UI:Show()
    end
end

function UI:SelectZone(zoneId, incSF)
    if not isInitialised then
        return
    end

    if zoneId == nil then
        ZonesList:HideSelected()
        return  
    end
    
    if STATE.selectedZone ~= zoneId then
        STATE.selectedZone = zoneId
    end

    if STATE.mode == "pools" then
        if DATA.zones[STATE.selectedZone].fishingPools == nil then
            STATE.mode = "openwater"
        end
    end

    incSF = incSF or false
    if not incSF then
        PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    end

    ZonesList:Update()
    ZoneInfo:Update()

    
end


function UI:SelectFish(fishId, skipZoneSelect)
    if not isInitialised then
        return
    end
    if fishId == nil then
        FishGrid:HideSelected()
        return
    end
    if STATE.selectedFish == fishId then
        return
    end
    skipZoneSelect = skipZoneSelect or false

    PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");  -- Page turn
    PlaySound(1189, "Master") -- Meaty thwack
    -- PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN, "Master");
    STATE.selectedFish = fishId
    STATE.selectedFishData = DATA.fish[STATE.selectedFish]

    if STATE.mode == "pools" then
        if DATA.pools[fishId] == nil then
            STATE.mode = "openwater"
        end
    end

    local zones = DATA:GetSortedZonesForFish(STATE.selectedFish)
    
    -- Check if the zones for the new fish contains the currently selected zone
    local zoneFound = false
    for i = 1, #zones do
        if tostring(zones[i].id) == STATE.selectedZone then
            zoneFound = true
            break
        end
    end

    FishGrid:Update()
    FishInfo:Update()
    Resipes:Update()
    MapFishRates:Update()
    if not skipZoneSelect then
        UI:SelectZone(tostring(zones[1].id), true)

        -- if not zoneFound then
        --     -- print("Selecting zone "..zones[1].id)
        --     -- set incSF to true to avoid double page turning sounds
        --     UI:SelectZone(tostring(zones[1].id), true)
        -- else
        --     -- print("No zone skipping ayways")
        --     ZonesList:Update()
        --     ZoneInfo:Update()
        -- end 
    else
        ZonesList:Update()
        ZoneInfo:Update()
    end
end

function UI:SelectMode(mode)
    if mode ~= "openwater" and mode ~= "pools" then
        return
    end
    if STATE.mode == mode then
        return
    end
    STATE.mode = mode
    UI:Reload()
end

function UI:Reload()
    if not isInitialised then
        return
    end
    DATA:LoadPlayerData()
    if DATA.playerSkill.hasFishing then
        local skillMod = DATA.playerSkill.skillModifier > 0 and "("..DATA.textColours.green.."+"..DATA.playerSkill.skillModifier..DATA.textColours.white..") " or ""
        UI.playerInfo:SetText("level "..DATA.playerSkill.level.." "..skillMod..DATA.playerSkill.rankName.." angler")
    else
        UI.playerInfo:SetText("needs to find a fishing trainer")
    end
    FishGrid:Update()
    FishInfo:Update()
    ZonesList:Update()
    ZoneInfo:Update()
    MapFishRates:Update()

end

function UI:ReloadAll()
    if not isInitialised then
        return
    end
    UI:Reload()
    Resipes:Update()
    SetPortraitTexture(UI.fd.characterPortrait.texture, "player");
    UI.playerName:SetText(DATA.playerInfo.name)
end