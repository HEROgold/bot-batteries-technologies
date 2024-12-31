require("__heroic_library__.utilities")
require("vars.strings")
require("vars.settings")

local base_entity = data.raw[LogisticRobot][LogisticRobot]
local base_robot_item = data.raw["item"][LogisticRobot]

local robot_entity = table.deepcopy(base_entity)
local robot_item = table.deepcopy(base_robot_item)

local localised_name = "Hauler Robot"

robot_name = HaulerRobot
robot_entity.name = robot_name
robot_item.name = robot_name

robot_item.place_result = robot_entity.name
robot_item.localised_name = localised_name
robot_item.hidden = false

robot_entity.localised_name = localised_name
robot_entity.minable.result = robot_item.name

---@type data.RecipePrototype
local robot_recipe = {
    type = "recipe",
    name = robot_name,
    enabled = false,
    ---@type data.IngredientPrototype[]
    ingredients = {
        {type = "item", name = LogisticRobot, amount = 1},
        {type = "item", name = FlyingRobotFrame, amount = 1},
    },
    ---@type data.ItemProductPrototype[]
    results = {{type = "item", name = robot_item.name, amount = 1},},
    category = "crafting",
    unlock_results = true,
}

local function add_base_robot()
    data:extend({robot_item})
    data:extend({robot_recipe})
    data:extend({robot_entity})
end

local function add_all_robots()
    for c=0, robot_cargo_research_limit do
        for s=0, robot_speed_research_limit do
            for e=0, robot_energy_research_limit do
                local robot_item = table.deepcopy(robot_item)
                local robot_entity = table.deepcopy(robot_entity)

                local suffix = utils.get_energy_suffix(c, s, e)
                local name = robot_name .. "-mk-" .. suffix
                local localised_name = tostring(localised_name .. "Mk." .. c .. s .. e)

                robot_item.name = name
                robot_entity.name = name
                robot_entity.localised_name = localised_name
                robot_item.localised_name = localised_name
                robot_item.hidden = true

                robot_item.place_result = robot_entity.name
                robot_entity.fast_replaceable_group = ConstructionRobot
                robot_entity.minable = robot_entity.minable
                robot_entity.minable.result = robot_item.name

                robot_entity.max_payload_size = base_entity.max_payload_size + c
                robot_entity.speed = base_entity.speed + s

                local energy = tonumber(string.match(robot_entity.max_energy, "%d+"))
                local suffix = string.match(robot_entity.max_energy, "%a+")
                robot_entity.max_energy = energy + e .. suffix


                if settings.startup[ShowItems].value == true then
                    robot_item.subgroup = ItemSubGroupRobot
                    data:extend({robot_item})
                end
                data:extend({robot_entity})
            end
        end
    end
end

add_base_robot()
add_all_robots()