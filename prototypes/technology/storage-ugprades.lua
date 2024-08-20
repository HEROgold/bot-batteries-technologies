require("__heroic_library__.utilities")

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_limit = settings.startup["energy-research-limit"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_mimimum = settings.startup["energy-research-minimum"].value
local modules = data.raw["module"]

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

end