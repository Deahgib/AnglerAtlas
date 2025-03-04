-- Create addon interface options tab for AnglerAtlas settings
if not LibStub then error("AnglerAtlas requires LibStub.") end

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

AnglerAtlasSettings = {}
AnglerAtlas = {}
AnglerAtlas.MM = {}

local modules = {}

function AnglerAtlas.MM:RegisterModule(name, module)
    if (not modules[name]) then
        modules[name] = module
        return modules[name]
    else
        error("Module "..name.." already exists")
    end
end

function AnglerAtlas.MM:GetModule(name)
    return modules[name]
end

AnglerAtlas.MM:RegisterModule("LibDBIcon", LibDBIcon)
AnglerAtlas.MM:RegisterModule("LDB", LDB)
