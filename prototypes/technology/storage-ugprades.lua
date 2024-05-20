require("__heroic_library__.utilities")

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_limit = settings.startup["energy-research-limit"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_mimimum = settings.startup["energy-research-minimum"].value
local modules = data.raw["module"]

local f = {}

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