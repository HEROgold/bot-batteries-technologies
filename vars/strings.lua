require("__heroic-library__.vars.strings")
require("vars.words")

ArchitectRobot = combine{Architect, Robot}
HaulerRobot = combine{Hauler, Robot}
ArchitectRobotLeveled = combine{ArchitectRobot, Mark}
HaulerRobotLeveled = combine{HaulerRobot, Mark}

RobotUpgrade = combine{Robot, Upgrade}
RobotUpgradeCargo = combine{RobotUpgrade, Cargo}
RobotUpgradeSpeed = combine{RobotUpgrade, Speed}
RobotUpgradeEnergy = combine{RobotUpgrade, Energy}

RobotLimit = combine{Robot, Limit}
RobotLimitCargo = combine{RobotLimit, Cargo}
RobotLimitSpeed = combine{RobotLimit, Speed}
RobotLimitEnergy = combine{RobotLimit, Energy}

RobotResearchMinimum = combine{Robot, Research, Minimum}
ResearchModifier = combine{Research, Modifier}
ResearchModifierCargo = combine{ResearchModifier, Cargo}
ResearchModifierSpeed = combine{ResearchModifier, Speed}
ResearchModifierEnergy = combine{ResearchModifier, Energy}

ModifierMaxPayloadSize = combine{Modifier, Max, Payload, Size}
ModifierSpeed = combine{Modifier, Max, Payload, Size}
ModifierMaxEnergy = combine{Modifier, Max, Payload, Size}
