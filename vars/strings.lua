require("__heroic_library__.vars.strings")
require("vars.words")

ArchitectRobot = combine{Architect, Robot}
HaulerRobot = combine{Hauler, Robot}

RobotCargoUpgrade = combine{Robot, Cargo, Upgrade}
RobotSpeedUpgrade = combine{Robot, Speed, Upgrade}
RobotEnergyUpgrade = combine{Robot, Energy, Upgrade}
RobotCargoLimit = combine{Robot, Cargo, Limit}
RobotSpeedLimit = combine{Robot, Speed, Limit}
RobotEnergyLimit = combine{Robot, Energy, Limit}
RobotResearchMinimum = combine{Robot, Research, Minimum}
ResearchModifierCargo = combine{Research, Modifier, Cargo}
ResearchModifierSpeed = combine{Research, Modifier, Speed}
ResearchModifierEnergy = combine{Research, Modifier, Energy}
AdvancedCircuit = combine{Advanced, Circuit}
ElectronicCircuit = combine{Electronic, Circuit}
ArchitectRobotLeveled = combine{ArchitectRobot, Mark} .. "-"
HaulerRobotLeveled = combine{HaulerRobot, Mark} .. "-"
