
local GoldDisplay = {}

local DATA = AnglerAtlas.MM:GetModule("DATA")

function GoldDisplay:Create(uiParent, curencyType)
    local goldDisplay = CreateFrame("FRAME", "angler-gold-display", uiParent, "BackdropTemplate")
    goldDisplay:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
        edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", 
        tile = true, 
        tileSize = 24, 
        edgeSize = 8, 
        insets = { 
            left = 3, 
            right = 3, 
            top = 5, 
            bottom = 5 
        } 
    });
    goldDisplay:SetBackdropColor(1.0, 1.0, 1.0, 1.0);
    goldDisplay:SetSize(165, 26)
    goldDisplay:SetPoint("CENTER", 0, 0)

    goldDisplay.moneyType = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.moneyType:SetPoint("RIGHT", goldDisplay, "LEFT", -5, 0)
    goldDisplay.moneyType:SetText(curencyType)
    
    goldDisplay.copperIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.copperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")
    goldDisplay.copperIcon:SetSize(14, 14)
    goldDisplay.copperIcon:SetPoint("RIGHT", goldDisplay, "RIGHT", -4, 0)

    goldDisplay.copper = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.copper:SetPoint("RIGHT", goldDisplay.copperIcon, "LEFT", -1, 0)
    goldDisplay.copper:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.copper:SetText("99")

    goldDisplay.silverIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.silverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")
    goldDisplay.silverIcon:SetSize(14, 14)
    goldDisplay.silverIcon:SetPoint("RIGHT", goldDisplay.copper, "LEFT", -4, 0)

    goldDisplay.silver = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.silver:SetPoint("RIGHT", goldDisplay.silverIcon, "LEFT", -1, 0)
    goldDisplay.silver:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.silver:SetText("99")

    goldDisplay.goldIcon = goldDisplay:CreateTexture(nil,'ARTWORK')
    goldDisplay.goldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")
    goldDisplay.goldIcon:SetSize(14, 14)
    goldDisplay.goldIcon:SetPoint("RIGHT", goldDisplay.silver, "LEFT", -4, 0)

    goldDisplay.gold = goldDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    goldDisplay.gold:SetPoint("RIGHT", goldDisplay.goldIcon, "LEFT", -1, 0)
    goldDisplay.gold:SetFont("Fonts\\FRIZQT__.ttf", 12, "OUTLINE")
    goldDisplay.gold:SetText("9999999")
    goldDisplay.isNegative = false

    goldDisplay.SetGold = function(self, value)
        local fontColor = value < 0 and DATA.textColours.red or DATA.textColours.white
        if value < 0 then
            value = value * -1
        end
        local gold, silver, copper = DATA:SplitGold(value)
        if gold <= 0 then
            self.goldIcon:Hide()
            self.gold:Hide()
        else
            self.goldIcon:Show()
            self.gold:Show()
        end
        self.gold:SetText(fontColor..tostring(gold))
        if silver <= 0 and gold <= 0 then
            self.silverIcon:Hide()
            self.silver:Hide()
        else
            self.silverIcon:Show()
            self.silver:Show()
        end
        self.silver:SetText(fontColor..tostring(silver))
        self.copper:SetText(fontColor..tostring(copper))
    end

    return goldDisplay
end


AnglerAtlas.MM:RegisterModule("GoldDisplay", GoldDisplay)