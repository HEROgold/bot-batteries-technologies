require("vars.words")

-- TODO: Move func to library.
---Used to combine strings within '.. "-" ..' to avoid typos
---@param names string[]
---@return string
local function combine(names)
    local new = ""
    for i, name in pairs(names) do
        if i == 1 then
            new = name
        else
            new = new .. "-" .. name
        end
    end
    return new
end

-- Combined
SciencePack = combine{Science, Pack}
ResearchUpgrade = combine{Research, Upgrade}
RoboportMaterialStorage = combine{Roboport, Material, Storage}
RoboportRobotStorage = combine{Roboport, Robot, Storage}
RoboportEnergy = combine{Roboport, Energy}
RoboportEnergyLeveled = combine{RoboportEnergy, Mark}
RoboportLogisticalLeveled = combine{RoboportLogistical, Mark}
EntityGhost = combine{Entity, Ghost}
RoboportEfficiency = combine{Roboport, Efficiency}
RoboportProductivity = combine{Roboport, Productivity}
RoboportSpeed = combine{Roboport, Speed}
RoboportConstructionArea = combine{Roboport, Construction, Area}
RoboportLogisticsArea = combine{Roboport, Logistic, Area}
RoboportUpdater = combine{Roboport, Updater}
RoboportLogistical = combine{Roboport, Logistical}

-- Settings
RobotStorageLimit = combine{Robot, Storage, Limit}
ResearchMinimum =  combine{Research, Minimum}
EnergyResearchLimit = combine{Energy, Research, Limit}
InputFlowLimitModifier = combine{Input, Flow, Limit, Modifier}
BufferCapacityModifier = combine{Buffer, Capacity, Modifier}
RechargeMinimumModifier = combine{Recharge, Minimum, Modifier}
EnergyUsageModifier = combine{Energy, Usage, Modifier}
ChargingEnergyModifier = combine{Charging, Energy, Modifier}
ConstructionAreaLimit = combine{Construction, Area, Limit}
LogisticAreaLimit = combine{Logistic, Area, Limit}
MaterialStorageLimit = combine{Material, Storage, Limit}
RoboportResearchUpgradeCost = combine{Research, Upgrade, Cost}
RoboportResearchUpgradeTime = combine{Research, Upgrade, Time}
UpgradeTimer = combine{Upgrade, Timer}
ShowItems = combine{Show, Items}
