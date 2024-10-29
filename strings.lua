---Used to combine strings within '.. "-" ..' to avoid typos
---@param names string[]
---@return string
local function combine(names)
    local new = ""
    for _, name in pairs(names) do
        new = new .. "-" .. name
    end
    return new
end

Research = "research"
Upgrade = "upgrade"
Modifier = "modifier"
Limit = "limit"
Minimum = "minimum"
Energy = "energy"
Entity = "entity"
Roboport = "roboport"
Storage = "storage"
Robot = "robot"
Material = "material"
Mark = "mk"
Science = "science"
Pack = "pack"


-- Combined
SciencePack = combine{Science, Pack}
RoboportResearch = combine{Roboport, Research}
RoboportResearchUpgrade = combine{RoboportResearch, Upgrade}
RoboportMaterialStorage = combine{Roboport, Material, Storage}
RoboportRobotStorage = combine{Roboport, Robot, Storage}
RoboportEnergy = combine{Roboport, Energy}
RoboportEnergyLeveled = combine{RoboportEnergy, Mark}
RoboportLogisticalLeveled = combine{RoboportLogistical, Mark}
EntityGhost = Entity .. "-ghost"
RoboportEfficiency = Roboport .. "-efficiency"
RoboportProductivity = Roboport .. "-productivity"
RoboportSpeed = Roboport .. "-speed"
RoboportConstructionArea = Roboport .. "-construction-area"
RoboportLogisticsArea = Roboport .. "-logistics-area"
RoboportUpdater = Roboport .. "-updater"
RoboportLogistical = Roboport .. "-logistical"

-- Settings
RobotStorageLimit = combine{Robot, Storage, Limit}
EnergyResearchMinimum =  combine{Energy, Research, Minimum}
EnergyResearchLimit = combine{Energy, Research, Limit}
InputFlowLimitModifier ="input-flow-" .. {Limit, Modifier}
BufferCapacityModifier ="buffer-capacity-" .. Modifier
RechargeMinimumModifier ="recharge-" .. {Minimum, Modifier}
EnergyUsageModifier = Energy .. "-usage-" .. Modifier
ChargingEnergyModifier ="charging-energy-" .. Modifier
ConstructionAreaLimit ="construction-area-" .. Limit
LogisticAreaLimit ="logistic-area-" .. Limit
MaterialStorageLimit ="material-storage-" .. Limit
RoboportResearchUpgradeCost = RoboportResearchUpgrade .. "cost"
RoboportResearchUpgradetime = RoboportResearchUpgrade .. "time"
UpgradeTimer = Upgrade .. "-timer"
ShowItems = "show-items"
