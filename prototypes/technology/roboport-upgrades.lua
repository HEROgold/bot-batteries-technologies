require("__heroic_library__.utilities")
require("vars.settings")

local modules = data.raw["module"]

local module_names = {
  "efficiency",
  "productivity",
  "speed"
}


local function get_research_name(module_type, level)
  return "roboport-" .. module_type .. utils.get_level_suffix(level)
end

local get_research_localized_name = function(module_type, level)
  return "roboport " .. module_type .. " upgrade " .. level
end

local get_effect_description = function(module_type)
  return "Upgrade the " .. module_type .. " of a energy roboport"
end

---@return number, number, number 
local function highest_module_number_by_name()
  local efficiency = 0
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
    
      if utilities.string_starts_with(k, "efficiency-module") then
        if number > efficiency then
          efficiency = number
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
    return efficiency, productivity, speed
end

local function get_highest_module_number()
  local efficiency, productivity, speed = highest_module_number_by_name()
  
  -- the following mods don't can't be found using highest_module_number_by_name()
  -- we set the limits manually
  if mods["space-exploration"] then
    efficiency, productivity, speed = 9, 9, 9
  end
  if mods["Module-Rebalance"] then
    efficiency, productivity, speed = 7, 7, 7
  end

  return efficiency, productivity, speed
end



local efficiency, productivity, speed = get_highest_module_number()

-- Respect the setting a user has provided
local efficiency_limit = math.min(energy_research_limit, efficiency)
local productivity_limit = math.min(energy_research_limit, productivity)
local speed_limit = math.min(energy_research_limit, speed)

Limits = {}
Limits["efficiency"] = efficiency_limit
Limits["productivity"] = productivity_limit
Limits["speed"] = speed_limit

local module_count = efficiency -- modules usually are paired, so should be fine like this.

-- the module technology is the 1st prerequisite
local function get_research_prerequisites(module_type, level)
  local prerequisites = nil

  if level == 1 then
    prerequisites = {
      module_type .. "-module" .. utils.get_level_suffix(level),
      "construction-robotics"
    }
  elseif module_count < research_minimum and level <= energy_research_limit and level > module_count then
    prerequisites = {
      get_research_name(module_type, level-1)
    }
  else
    prerequisites = {
      module_type .. "-module" .. utils.get_level_suffix(level),
      get_research_name(module_type, level-1)
    }
  end
  return prerequisites
end

local get_tech_sprite = function (module_type, level)
  -- if mods["space-exploration-graphics"] then
  --   return utilities.technology_sprite_add_item_icon(
  --     "__base__/graphics/technology/robotics.png",
  --     "__space-exploration-graphics__/graphics/icons/modules/"..module_type.."-module-"..level..".png" -- Needs testing
  --   )
  -- else
    return utilities.technology_sprite_add_item_icon(
      "__base__/graphics/technology/robotics.png",
      "__base__/graphics/icons/"..module_type.."-module-3.png"
    )
  -- end
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

local function add_module_upgrade_research()
  table.insert(data.raw["technology"]["construction-robotics"].effects, {type = "unlock-recipe", recipe = RoboportEnergy})

  for _, module_type in pairs(module_names) do
    local limit = math.max(Limits[module_type], research_minimum)

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
              count_formula = research_upgrade_cost .. "*(L)",
              time = research_upgrade_time,
              ingredients = get_module_research_ingredients(module_type, i)
            },
          }
        }
      )
    end
  end
end


add_module_upgrade_research()