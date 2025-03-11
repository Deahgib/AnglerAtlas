local TabManager = {}

function TabManager:Create()
    return {
        infoTabButtons={},
        infoTabs={},
        selectedTab="",
        Select = function (self, tabName)
            if self.selectedTab == tabName then
                return
            end
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
        CreateTabButton = function(self, tabName, parent, iconID, tooltipText)
            local tabBackground = CreateFrame("FRAME", "angler-tab-"..tabName, parent)
            tabBackground.selected = false
            tabBackground:SetSize(50, 50)
            tabBackground.texture = tabBackground:CreateTexture(nil,'ARTWORK')
            tabBackground.texture:SetRotation(math.pi * 0.5)
            tabBackground.texture:SetTexture("Interface\\SPELLBOOK\\SpellBook-SkillLineTab")
            tabBackground.texture:SetAllPoints()

            local tabButton = CreateFrame("BUTTON", "angler-tab-button-"..tabName, tabBackground, "ItemButtonTemplate")
            tabButton:SetSize(24, 24)
            tabButton:SetPoint("TOPLEFT", tabBackground, "TOPLEFT", 9, -23)
            _G[tabButton:GetName().."NormalTexture"]:SetSize(24*1.662, 24*1.662)
            tabButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(tabButton, "ANCHOR_TOP")
                GameTooltip:AddLine(tooltipText)
                GameTooltip:Show()
            end)
        
            tabButton:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            SetItemButtonTexture(tabButton, GetItemIcon(iconID)) 
            tabButton.tabName = tabName
            tabButton:SetText(tabDeselectedText)
            tabButton.highlightTexture = tabButton:CreateTexture(nil,'ARTWORK')
            tabButton.highlightTexture:SetTexture("Interface\\Transmogrify\\Transmogrify")
            tabButton.highlightTexture:SetSize(30, 30)
            tabButton.highlightTexture:SetPoint("CENTER", 0, 0)
            tabButton.highlightTexture:SetVertexColor(1.0, 1.0, 1.0, 1.0)
            tabButton.highlightTexture:SetTexCoord(0.463, 0.553, 0.0, 0.088)
            tabButton.highlightTexture:SetBlendMode("ADD")
            tabButton.highlightTexture:Hide()
            tabButton:SetScript("OnClick", function()
                if tabBackground.selected then
                    self:Select("default")
                    return
                end
                self:Select(tabButton.tabName)
            end)

            function tabBackground:SetSelected(selected)
                if selected then
                    tabBackground.selected = true
                    tabButton.highlightTexture:Show()
                else
                    tabBackground.selected = false
                    tabButton.highlightTexture:Hide()
                end
            end
            
            return tabBackground
        end,
        Register = function(self, tabName, tabButton, tabFrame)
            self.infoTabButtons[tabName] = tabButton
            self.infoTabs[tabName] = tabFrame
        end
    }
end

AnglerAtlas.MM:RegisterModule("TabManager", TabManager)
