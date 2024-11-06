require("__heroic_library__.utilities")
require("lualib.utils")
require("vars.settings")

local base_entity = data.raw[ConstructionRobot]
local base_robot_item = data.raw["item"][ConstructionRobot]

---@type data.ConstructionRobotPrototype
local robot_entity = table.deepcopy(base_entity)
local robot_item = table.deepcopy(base_robot_item)

local localised_name = "Architect Robot"

robot_name = ArchitectRobot
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
    -- enabled = true,
    ---@type data.IngredientPrototype[]
    ingredients = {
        {type = "item", name = ConstructionRobot, amount = 1},
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

                -- TODO: add the upgrades for each robot
                robot_entity.max_payload_size = base_entity.max_payload_size + c
                robot_entity.speed = base_entity.speed + s
                robot_entity.max_energy = base_entity.max_energy + e

                if settings.startup[ShowItems].value == true then
                    robot_item.subgroup = "br-roboports"
                    data:extend({robot_item})
                end
                data:extend({robot_entity})
            end
        end
    end
end

add_base_robot()
add_all_robots()