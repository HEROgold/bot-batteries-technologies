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
  return "Upgrade the " .. upgrade_name .. " of a roboport"
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

local function add_researches()
  local upgrade_names = {"construction-area", "logistics-area", "robot-storage", "material-storage"}

  table.insert(data.raw["technology"]["logistic-robotics"].effects, {type = "unlock-recipe", recipe = "logistical-roboport"})

  for _, upgrade_type in pairs(upgrade_names) do
    local limit = math.max(research_mimimum, research_limit)

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
