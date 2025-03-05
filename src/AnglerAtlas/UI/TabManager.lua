local TabManager = {}

function TabManager:Create()
    return {
        infoTabButtons={},
        infoTabs={},
        selectedTab="default",
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

AnglerAtlas.MM:RegisterModule("TabManager", TabManager)
