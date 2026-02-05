local base_recipe = {
	type = "recipe",
	enabled = false,
	hidden = true,
	category = "crafting",
	unlock_results = true,
}

---@type data.ConstructionRobotPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local base_architect = data.raw["construction-robot"]["construction-robot"]
local base_architect_item = data.raw["item"]["construction-robot"]

---@type data.LogisticRobotPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local base_hauler = data.raw["logistic-robot"]["logistic-robot"]
local base_hauler_item = data.raw["item"]["logistic-robot"]

---@type data.RecipePrototype
architect_recipe = table.deepcopy(base_recipe)
architect_recipe.name = "architect-robot"
architect_recipe.results = { { type = "item", name = "architect-robot", amount = 1 } }
architect_recipe.ingredients = {
	{ type = "item", name = "construction-robot", amount = 1 },
	{ type = "item", name = "advanced-circuit", amount = 2 },
	{ type = "item", name = "flying-robot-frame", amount = 1 },
}

architect_entity = table.deepcopy(base_architect)
architect_item = table.deepcopy(base_architect_item)

architect_entity.name = "architect-robot"
architect_item.name = "architect-robot"
architect_item.place_result = architect_entity.name
architect_item.hidden = false
architect_entity.minable.result = architect_item.name

---@type data.RecipePrototype
hauler_recipe = table.deepcopy(base_recipe)
hauler_recipe.name = "hauler-robot"
hauler_recipe.results = { { type = "item", name = "hauler-robot", amount = 1 } }
hauler_recipe.ingredients = {
	{ type = "item", name = "logistic-robot", amount = 1 },
	{ type = "item", name = "electronic-circuit", amount = 2 },
	{ type = "item", name = "flying-robot-frame", amount = 1 },
}

hauler_entity = table.deepcopy(base_hauler)
hauler_item = table.deepcopy(base_hauler_item)

hauler_entity.name = "hauler-robot"
hauler_item.name = "hauler-robot"
hauler_item.place_result = hauler_entity.name
hauler_item.hidden = false
hauler_entity.minable.result = hauler_item.name

function add_base_robots()
	data:extend({ architect_item })
	data:extend({ architect_entity })
	data:extend({ architect_recipe })

	data:extend({ hauler_item })
	data:extend({ hauler_entity })
	data:extend({ hauler_recipe })
end
