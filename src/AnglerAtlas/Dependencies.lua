
local LibDBIcon = LibStub("LibDBIcon-1.0")
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("AnglerAtlas", {
    type = "launcher",
    icon = "Interface\\Icons\\INV_Fishingpole_01",
    OnClick = function(self, button)
        AnglerAtlas.UI:ToggleUI()
    end,
    OnTooltipShow = function(tooltip)
        tooltip:SetText("Angler Atlas")
    end,
})


AnglerAtlas.MM:RegisterModule("LibDBIcon", LibDBIcon)
AnglerAtlas.MM:RegisterModule("LDB", LDB)