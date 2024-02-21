require("lualib.utils")

---@type number
---@diagnostic disable-next-line: assign-type-mismatch
local research_limit = settings.startup["battery-roboport-energy-research-limit"].value
local research_mimimum = settings.startup["battery-roboport-energy-research-minimum"].value
local modules = data.raw["module"]

local f = {}
local module_names = {
  "effectivity",
  "productivity",
  "speed"
}



f.get_research_name = function(module_type, level)
  return "roboport-" .. module_type .. f.get_suffix_by_level(level)
end

f.get_research_localized_name = function(module_type, level)
  return "roboport " .. module_type .. " upgrade " .. level
end

f.get_effect_description = function(module_type)
  return "Upgrade the " .. module_type .. " of a roboport"
end

---@return number, number, number 
f.highest_module_number_by_name = function()
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
    
      if utils.starts_with(k, "effectivity-module") then
        if number > effectivity then
          effectivity = number
        end
      end
      if utils.starts_with(k, "productivity-module") then
        if number > productivity then
          productivity = number
        end
      end
      if utils.starts_with(k, "speed-module") then
        if number > speed then
          speed = number
        end
      end
    end
    return effectivity, productivity, speed
end

f.get_highest_module_number = function ()
  effectivity, productivity, speed = f.highest_module_number_by_name()
  
  -- the following mods don't can't be found using highest_module_number_by_name()
  -- we set the limits manually
  if mods["space-exploration"] then
    effectivity, productivity, speed = 9, 9, 9
  end

  return effectivity, productivity, speed
end

f.get_module_research_ingredients = function (module_type, level)
  local prereq = f.get_research_prerequisites(module_type, level)
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
  if i == 1 then
    module_name = ""
  else
    module_name = "-" .. i
  end
  return module_name
end


effectivity, productivity, speed = f.get_highest_module_number()

-- Respect the setting a user has provided
local effectivity_limit = math.min(research_limit, effectivity)
local productivity_limit = math.min(research_limit, productivity)
local speed_limit = math.min(research_limit, speed)

limits = {}
limits["effectivity"] = effectivity_limit
limits["productivity"] = productivity_limit
limits["speed"] = speed_limit

local module_count = limits["effectivity"] -- modules usually are paired, so should be fine like this.

-- the module technology is the 1st prerequisite
f.get_research_prerequisites = function(module_type, level)
  if level == 1 then
    prerequisites = {
      module_type .. "-module" .. f.get_suffix_by_level(level),
      "robotics"
    }
  elseif module_count < research_mimimum and level < research_limit then
    prerequisites = {
      f.get_research_name(module_type, level-1)
    }
  else
    prerequisites = {
      module_type .. "-module" .. f.get_suffix_by_level(level),
      f.get_research_name(module_type, level-1)
    }
  end
  return prerequisites
end

f.add_module_upgrade_research = function()
  for _, module_type in pairs(module_names) do
    limit = limits[module_type]

    for i=1, limit do
      data:extend(
        {
          {
            type = "technology",
            name = f.get_research_name(module_type, i),
            localised_name = f.get_research_localized_name(module_type, i),
            icon_size = 256,
            icon_mipmaps = 4,
            icons = utils.add_technology_icon_constant_battery("__base__/graphics/technology/worker-robots-speed.png"),
            upgrade = true,
            -- max_level = tostring(limit),
            order = "c-k-f-a",
            prerequisites = f.get_research_prerequisites(module_type, i),
            effects = {
              {
                type = "nothing",
                effect_description = f.get_effect_description(module_type),
              }
            },
            unit = {
              -- count_formula = "2(L-6)*10",
              count_formula = "250*(L)",
              time = 100,
              ingredients = f.get_module_research_ingredients(module_type, i)
            },
          }
        }
      )
    end
  end
end


f.add_module_upgrade_research()