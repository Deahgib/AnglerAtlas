local Recipes = {}

local UI = AnglerAtlas.MM:GetModule("UI")
local STATE = AnglerAtlas.MM:GetModule("STATE")
local DATA = AnglerAtlas.MM:GetModule("DATA")

local GoldDisplay = AnglerAtlas.MM:GetModule("GoldDisplay")

local recipesFrame = nil

function Recipes:Create(uiParent, anchor)
    recipesFrame = CreateFrame("FRAME", "angler-recipes-info", uiParent, "BackdropTemplate")
    recipesFrame:Raise()
    recipesFrame:SetBackdrop(UI.ANGLER_BACKDROP)
    recipesFrame:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    recipesFrame:SetSize(355, 408)
    recipesFrame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
    recipesFrame:Hide()
    -- On show hide
    recipesFrame:SetScript("OnShow", function()
        PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    end)
    recipesFrame:SetScript("OnHide", function()
        PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN, "Master");
    end)



    recipesFrame.text = recipesFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    recipesFrame.text:SetPoint("TOPLEFT", recipesFrame, "TOPLEFT", 28, -25)
    recipesFrame.text:SetFont("Fonts\\FRIZQT__.ttf", 14)
    recipesFrame.text:SetText(DATA.textColours.dark.."Recipes for Raw Longjaw Mud Snapper")

    recipesFrame.scrollFrame = CreateFrame("ScrollFrame", nil, recipesFrame, "UIPanelScrollFrameTemplate")
    recipesFrame.scrollFrame:SetPoint("TOPLEFT", 25, -43)
    recipesFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -45, 25)

    recipesFrame.scrollFrame.scrollChild = CreateFrame("Frame")
    recipesFrame.scrollFrame:SetScrollChild(recipesFrame.scrollFrame.scrollChild)
    recipesFrame.scrollFrame.scrollChild:SetWidth(280)
    recipesFrame.scrollFrame.scrollChild:SetHeight(510)  -- 100 is the height of each panel (5 panels) + padding

    recipesFrame.recipeItems = {}
    for i = 1, 5 do
        local recipeItem = CreateFrame("FRAME", "angler-recipe-item-"..i, recipesFrame.scrollFrame.scrollChild, "BackdropTemplate")
        local bd = CopyTable(BACKDROP_TEXT_PANEL_0_16)
        bd.bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"
        bd.insets = { left = 3, right = 3, top = 3, bottom = 3 }
        
        recipeItem:SetBackdrop(bd)
        recipeItem:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
        recipeItem:SetSize(270, 100)
        recipeItem:SetPoint("TOP", recipesFrame.scrollFrame.scrollChild, "TOP", 0, -10 - (i - 1) * 102)

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

        recipeItem.craftValueGoldDisplay = GoldDisplay:Create(recipeItem, "Unit price")
        recipeItem.craftValueGoldDisplay:SetPoint("BOTTOMRIGHT", recipeItem, "BOTTOMRIGHT", -5, 4)
        recipeItem.craftValueGoldDisplay:SetGold(11111)
        

        recipeItem.reagents = {}

        for j = 1, 5 do
            local reagent = CreateFrame("BUTTON", "angler-recipe-reagent-"..i.."-"..j, recipeItem, "ItemButtonTemplate")
            reagent:SetSize(28, 28)
            reagent:SetPoint("TOPLEFT", recipeItem.productName, "BOTTOMLEFT", 10 + (j - 1) * 31, -6)
            reagent:SetScript("OnClick", function()
                UI:SelectFish(nil, reagent)
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

        recipesFrame.recipeItems[i] = recipeItem
    end

    return recipesFrame
end


function Recipes:Update()
    if recipesFrame == nil then
        error("Recipes frame not created")
        return
    end
    if STATE.selectedFish == nil then
        recipesFrame.text:SetText(DATA.textColours.dark.."No fish selected")
        for i = 1, #recipesFrame.recipeItems do
            local recipeFrame = recipesFrame.recipeItems[i]
            if recipeFrame == nil then
                break
            end
            recipeFrame:Hide()
        end
        return
    end
    recipesFrame.text:SetText(DATA.textColours.dark.."Recipes for "..STATE.selectedFishData.name)
    for i = 1, #recipesFrame.recipeItems do
        local recipeFrame = recipesFrame.recipeItems[i]
        if recipeFrame == nil then
            break
        end
        local recipeData = DATA.recipes[STATE.selectedFish][i]
        if recipeData == nil then
            recipeFrame:Hide()
        else
            recipeFrame:Show()
            recipeFrame:SetRecipe(recipeData)
        end
    end
end

AnglerAtlas.MM:RegisterModule("Recipes", Recipes)