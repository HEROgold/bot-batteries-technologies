require("__heroic_library__.utilities")

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_limit = settings.startup["energy-research-limit"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_mimimum = settings.startup["energy-research-minimum"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_count = settings.startup["roboport-research-upgrade-cost"].value
---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_time = settings.startup["roboport-research-upgrade-time"].value
local modules = data.raw["module"]

local f = {}
local module_names = {
  "effectivity",
  "productivity",
  "speed"
}



local function get_research_name(module_type, level)
  return "roboport-" .. module_type .. get_suffix_by_level(level)
end

local get_research_localized_name = function(module_type, level)
  return "roboport " .. module_type .. " upgrade " .. level
end

local get_effect_description = function(module_type)
  return "Upgrade the " .. module_type .. " of a roboport"
end

---@return number, number, number 
local function highest_module_number_by_name()
  local effectivity = 0
  local productivity = 0
  local speed = 0

    for k, v in pairs(modules) do
      local ss = k.sub(k, -2, -1) 
      local n = tonumber(ss) -- "productivity-module-2" becomes '-2' when converting from string.
    
      if n == nil then -- level one modules don't seem to have a suffix. fix that here
        n = 1
      end
      if n < 0 then -- invert numbers to positive.
        n = -n
      end
    
      local number = math.max(n, 1)
    
      if utilities.string_starts_with(k, "effectivity-module") then
        if number > effectivity then
          effectivity = number
        end
      end
      if utilities.string_starts_with(k, "productivity-module") then
        if number > productivity then
          productivity = number
        end
      end
      if utilities.string_starts_with(k, "speed-module") then
        if number > speed then
          speed = number
        end
      end
    end
    return effectivity, productivity, speed
end

local function get_highest_module_number()
  local effectivity, productivity, speed = highest_module_number_by_name()
  
  -- the following mods don't can't be found using highest_module_number_by_name()
  -- we set the limits manually
  if mods["space-exploration"] then
    effectivity, productivity, speed = 9, 9, 9
  end
  if mods["Module-Rebalance"] then
    effectivity, productivity, speed = 7, 7, 7
  end

  return effectivity, productivity, speed
end

local function get_module_research_ingredients(module_type, level)
  local prereq = get_research_prerequisites(module_type, level)
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


local function get_suffix_by_level(i)
  local module_name = nil
  if i == 1 then
    module_name = ""
  else
    module_name = "-" .. i
  end
  return module_name
end


local effectivity, productivity, speed = get_highest_module_number()

-- Respect the setting a user has provided
local effectivity_limit = math.min(research_limit, effectivity)
local productivity_limit = math.min(research_limit, productivity)
local speed_limit = math.min(research_limit, speed)

Limits = {}
Limits["effectivity"] = effectivity_limit
Limits["productivity"] = productivity_limit
Limits["speed"] = speed_limit

local module_count = effectivity -- modules usually are paired, so should be fine like this.

-- the module technology is the 1st prerequisite
local function get_research_prerequisites(module_type, level)
  local prerequisites = nil

  if level == 1 then
    prerequisites = {
      module_type .. "-module" .. get_suffix_by_level(level),
      "construction-robotics"
    }
  elseif module_count < research_mimimum and level <= research_limit and level > module_count then
    prerequisites = {
      get_research_name(module_type, level-1)
    }
  else
    prerequisites = {
      module_type .. "-module" .. get_suffix_by_level(level),
      get_research_name(module_type, level-1)
    }
  end
  return prerequisites
end

local get_tech_sprite = function (module_type, level)
    return utilities.technology_sprite_add_item_icon(
      "__base__/graphics/technology/robotics.png",
      "__space-exploration-graphics__/graphics/icons/modules/"..module_type.."-"..level..".png"
    )
end

local function add_module_upgrade_research()
  for _, module_type in pairs(module_names) do
    local limit = math.max(Limits[module_type], research_mimimum)

    for i=1, limit do
      data:extend(
        {
          {
            type = "technology",
            name = get_research_name(module_type, i),
            localised_name = get_research_localized_name(module_type, i),
            icon_size = 256,
            icon_mipmaps = 4,
            icons = get_tech_sprite(module_type, i),
            upgrade = true,
            order = "c-k-f-a",
            prerequisites = get_research_prerequisites(module_type, i),
            effects = {
              {
                type = "nothing",
                effect_description = get_effect_description(module_type),
              }
            },
            unit = {
              count_formula = research_count .. "*(L)",
              time = research_time,
              ingredients = get_module_research_ingredients(module_type, i)
            },
          }
        }
      )
    end
  end
end


add_module_upgrade_research()