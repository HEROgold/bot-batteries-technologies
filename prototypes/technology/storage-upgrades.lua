require("__heroic_library__.utilities")

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_count = settings.startup["roboport-research-upgrade-cost"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_time = settings.startup["roboport-research-upgrade-time"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_limit = settings.startup["energy-research-limit"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_mimimum = settings.startup["energy-research-minimum"].value

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local robot_storage_limit = tonumber(settings.startup["robot-storage-limit"].value)
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local material_storage_limit = tonumber(settings.startup["material-storage-limit"].value)
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local construction_area_limit = tonumber(settings.startup["construction-area-limit"].value)
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local logistic_area_limit = tonumber(settings.startup["logistic-area-limit"].value)

local robot_storage_limit = math.max(robot_storage_limit, research_mimimum)
local material_storage_limit = math.max(material_storage_limit, research_mimimum)
local construction_area_limit = math.max(construction_area_limit, research_mimimum)
local logistic_area_limit = math.max(logistic_area_limit, research_mimimum)

local f = {}

f.get_research_prerequisites = function(upgrade_name, level)
  local prerequisites = nil

  if level == 1 then
    prerequisites = {
      "logistic-robotics"
    }
  else
    prerequisites = {
      f.get_research_name(upgrade_name, level-1)
    }
  end
  return prerequisites
end

f.get_tech_sprite = function (module_type, level)
    return {
      {
        icon = "__base__/graphics/technology/robotics.png",
        icon_size = 256, icon_mipmaps = 4
      }
    }
end

f.get_research_name = function(upgrade_name, level)
  return "roboport-" .. upgrade_name .. f.get_suffix_by_level(level)
end

f.get_research_localized_name = function(upgrade_name, level)
  return "roboport " .. upgrade_name .. " upgrade " .. level
end

f.get_effect_description = function(upgrade_name)
  return "Upgrade the " .. upgrade_name .. " of a logistical roboport"
end

f.get_research_ingredients = function (upgrade_type, level)
  local prereq = f.get_research_prerequisites(upgrade_type, level)
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

f.get_suffix_by_level = function(i)
  local name = nil
  if i == 1 then
    name = ""
  else
    name = "-" .. i
  end
  return name
end

construction_area = "construction-area"
logistics_area = "logistics-area"
robot_storage = "robot-storage"
material_storage = "material-storage"

f.get_research_limit = function(upgrade_type)
  local limit = 999999
  if upgrade_type == robot_storage then
    limit = robot_storage_limit
  elseif upgrade_type == material_storage then
    limit = material_storage_limit
  elseif upgrade_type == construction_area then
    limit = construction_area_limit
  elseif upgrade_type == logistics_area then
    limit = logistic_area_limit
  end
  return math.max(research_mimimum, math.min(limit, research_limit))
end

local function add_researches()
  local upgrade_names = {construction_area, logistics_area, robot_storage, material_storage}

  table.insert(data.raw["technology"]["logistic-robotics"].effects, {type = "unlock-recipe", recipe = "logistical-roboport"})

  for _, upgrade_type in pairs(upgrade_names) do
    limit = f.get_research_limit(upgrade_type)

    for i=1, limit do
      data:extend(
        {
          {
            type = "technology",
            name = f.get_research_name(upgrade_type, i),
            localised_name = f.get_research_localized_name(upgrade_type, i),
            icon_size = 256,
            icon_mipmaps = 4,
            icons = f.get_tech_sprite(upgrade_type, i),
            upgrade = true,
            order = "c-k-f-a",
            prerequisites = f.get_research_prerequisites(upgrade_type, i),
            effects = {
              {
                type = "nothing",
                effect_description = f.get_effect_description(upgrade_type),
              }
            },
            unit = {
              count_formula = research_count .. "*(L)",
              time = research_time,
              ingredients = f.get_research_ingredients(upgrade_type, i)
            },
          }
        }
      )
    end
  end
end

add_researches()
