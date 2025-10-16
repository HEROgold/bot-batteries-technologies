local base_recipe = {
    type = Recipe,
    enabled = false,
    hidden = true,
    category = Crafting,
    unlock_results = true,
}

---@type data.ConstructionRobotPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local base_architect = data.raw[ConstructionRobot][ConstructionRobot]
local base_architect_item = data.raw[Item][ConstructionRobot]

---@type data.LogisticRobotPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local base_hauler = data.raw[LogisticRobot][LogisticRobot]
local base_hauler_item = data.raw[Item][LogisticRobot]


---@type data.RecipePrototype
architect_recipe = table.deepcopy(base_recipe)
architect_recipe.name = ArchitectRobot
architect_recipe.results = {{type = Item, name = ArchitectRobot, amount = 1},}
architect_recipe.ingredients = {
    {type = Item, name = ConstructionRobot, amount = 1},
    {type = Item, name = AdvancedCircuit, amount = 2},
    {type = Item, name = FlyingRobotFrame, amount = 1},
}

architect_entity = table.deepcopy(base_architect)
architect_item = table.deepcopy(base_architect_item)

architect_entity.name = ArchitectRobot
architect_item.name = ArchitectRobot
architect_item.place_result = architect_entity.name
architect_item.hidden = false
architect_entity.minable.result = architect_item.name


---@type data.RecipePrototype
hauler_recipe = table.deepcopy(base_recipe)
hauler_recipe.name = HaulerRobot
hauler_recipe.results = {{type = Item, name = HaulerRobot, amount = 1},}
hauler_recipe.ingredients = {
    {type = Item, name = LogisticRobot, amount = 1},
    {type = Item, name = ElectronicCircuit, amount = 2},
    {type = Item, name = FlyingRobotFrame, amount = 1},
}

hauler_entity = table.deepcopy(base_hauler)
hauler_item = table.deepcopy(base_hauler_item)

hauler_entity.name = HaulerRobot
hauler_item.name = HaulerRobot
hauler_item.place_result = hauler_entity.name
hauler_item.hidden = false
hauler_entity.minable.result = hauler_item.name


function add_base_robots()
    data:extend({architect_item})
    data:extend({architect_entity})
    data:extend({architect_recipe})

    data:extend({hauler_item})
    data:extend({hauler_entity})
    data:extend({hauler_recipe})
end