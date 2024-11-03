require("__heroic_library__.utilities")
require("vars.settings")

local robot_storage_limit = math.max(robot_storage_limit, research_minimum)
local material_storage_limit = math.max(material_storage_limit, research_minimum)
local construction_area_limit = math.max(construction_area_limit, research_minimum)
local logistic_area_limit = math.max(logistic_area_limit, research_minimum)


local function get_research_name(upgrade_name, level)
  return upgrade_name .. utils.get_level_suffix(level)
end

local function get_research_prerequisites(upgrade_name, level)
  local prerequisites = nil

  if level == 1 then
    prerequisites = {
      "logistic-robotics"
    }
  else
    prerequisites = {
      get_research_name(upgrade_name, level-1)
    }
  end
  return prerequisites
end

local function get_tech_sprite(module_type, level)
    return {
      {
        icon = "__base__/graphics/technology/robotics.png",
        icon_size = 256, icon_mipmaps = 4
      }
    }
end

local function get_research_localized_name(upgrade_name, level)
  return "roboport " .. upgrade_name .. " upgrade " .. level
end

local function get_effect_description(upgrade_name)
  return "Upgrade the " .. upgrade_name .. " of a logistical roboport"
end

local function get_research_ingredients(upgrade_type, level)
  local prereq = get_research_prerequisites(upgrade_type, level)
  local name = prereq[1]
  local techno = table.deepcopy(data.raw["technology"][name])

  if techno == nil then
    -- return default set of ingredients
    return {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      {"chemical-science-pack", 1},
      {"utility-science-pack", 1},
    }
  end
  return techno.unit.ingredients
end


local function get_research_limit (upgrade_type)
  local limit = 999999
  if upgrade_type == RoboportRobotStorage then
    limit = robot_storage_limit
  elseif upgrade_type == RoboportMaterialStorage then
    limit = material_storage_limit
  elseif upgrade_type == RoboportConstructionArea then
    limit = construction_area_limit
  elseif upgrade_type == RoboportLogisticsArea then
    limit = logistic_area_limit
  end
  return math.max(research_minimum, math.min(limit, energy_research_limit))
end

local function add_researches()
  local upgrade_names = {RoboportConstructionArea, RoboportLogisticsArea, RoboportRobotStorage, RoboportMaterialStorage}

  table.insert(data.raw["technology"]["logistic-robotics"].effects, {type = "unlock-recipe", recipe = "logistical-roboport"})

  for _, upgrade_type in pairs(upgrade_names) do
    limit = get_research_limit(upgrade_type)

    for i=1, limit do
      data:extend(
        {
          {
            type = "technology",
            name = get_research_name(upgrade_type, i),
            localised_name = get_research_localized_name(upgrade_type, i),
            icon_size = 256,
            icon_mipmaps = 4,
            icons = get_tech_sprite(upgrade_type, i),
            upgrade = true,
            order = "c-k-f-a",
            prerequisites = get_research_prerequisites(upgrade_type, i),
            effects = {
              {
                type = "nothing",
                effect_description = get_effect_description(upgrade_type),
              }
            },
            unit = {
              count_formula = research_upgrade_cost .. "*(L)",
              time = research_upgrade_time,
              ingredients = get_research_ingredients(upgrade_type, i)
            },
          }
        }
      )
    end
  end
end

add_researches()
