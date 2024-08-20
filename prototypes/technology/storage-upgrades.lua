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
    return utilities.technology_sprite_add_item_icon(
      "__base__/graphics/technology/robotics.png",
      "__space-exploration-graphics__/graphics/icons/modules/"..module_type.."-"..level..".png"
    )
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
  local upgrade_names = {"construction-area", "logistic-area", "robot-storage", "material-storage"}

  for _, upgrade_type in pairs(upgrade_names) do
    local limit = math.max(research_mimimum, research_limit) -- math.max(Limits[upgrade_type], research_mimimum)

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
              ingredients = f.get_module_research_ingredients(upgrade_type, i)
            },
          }
        }
      )
    end
  end
end

add_researches()
-- TODO: lock logistical-roboport behind research of logisitcal-robotics