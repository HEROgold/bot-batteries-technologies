require("__heroic-library__.utilities")
require("__heroic-library__.technology")
require("__heroic-library__.number")
require("helpers.tech-prerequisites")
require("helpers.tech-ingredients")

local tech_prerequisites = require("helpers.tech-prerequisites")
local tech_ingredients = require("helpers.tech-ingredients")

function insert_research_unlocks()
    table.insert(
        data.raw["technology"]["construction-robotics"].effects,
        {type = "unlock-recipe", recipe = ArchitectRobot}
    )
    table.insert(
        data.raw["technology"]["logistic-robotics"].effects,
        {type = "unlock-recipe", recipe = HaulerRobot}
    )
    table.insert(
        data.raw["technology"]["logistic-robotics"].effects,
        {type = "unlock-recipe", recipe = TierSwitcherRoboport}
    )
end

---@param upgrade_name string
---@param level number
local function get_research_name(upgrade_name, level)
    return upgrade_name .. utilities.get_level_suffix(level)
end

---@return table<TechnologyID>
local function get_tech_sprite(type, level)
    return {
        {
            icon = "__base__/graphics/technology/robotics.png",
            icon_size = 256, icon_mipmaps = 4
        }
    }
end

local function get_research_limit(upgrade_type)
    local limit = 999999
    if upgrade_type == RobotUpgradeCargo then
        limit = robot_storage_limit
    elseif upgrade_type == RobotUpgradeSpeed then
        limit = material_storage_limit
    elseif upgrade_type == RobotUpgradeEnergy then
        limit = construction_area_limit
    end
    return math.max(research_minimum, math.min(limit, research_maximum))
end

function add_researches()
    local upgrade_names = { RobotUpgradeCargo, RobotUpgradeSpeed, RobotUpgradeEnergy }

    for _, upgrade_type in pairs(upgrade_names) do
        local limit = get_research_limit(upgrade_type)
        for i = 1, limit do
            local prerequisites = tech_prerequisites.get_all(upgrade_type, i)
            local ingredients = tech_ingredients.get_all(upgrade_type, i, prerequisites)
            
            data:extend({
                {
                    type = "technology",
                    name = get_research_name(upgrade_type, i),
                    icon_size = 256,
                    icon_mipmaps = 4,
                    icons = get_tech_sprite(upgrade_type, i),
                    upgrade = true,
                    order = "c-k-f-a",
                    prerequisites = prerequisites,
                    effects = {
                        {
                            type = "nothing",
                        }
                    },
                    unit = {
                        count_formula = research_upgrade_cost .. "*(L)",
                        time = research_upgrade_time,
                        ingredients = ingredients
                    },
                }
            })
        end
    end
end
