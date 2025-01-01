require("vars.words")
require("vars.strings")
require("vars.settings")

local function get_research_localized_name(upgrade_name, level)
  return "architect " .. upgrade_name .. " upgrade " .. level
end

local function get_effect_description(upgrade_name)
  return "Upgrade the " .. upgrade_name .. " of an architect robot"
end


local function get_research_name(upgrade_name, level)
  return upgrade_name .. utilities.get_level_suffix(level)
end

---@return table<TechnologyID>
local function get_SA_prerequisites(upgrade_name, level)
  ---@type table<TechnologyID>
  local prerequisites = {}

  if upgrade_name == RobotSpeedResearch then
    table.insert(prerequisites, MetallurgicSciencePack)
  elseif upgrade_name == RobotEnergyResearch then
    table.insert(prerequisites, ElectromagneticSciencePack)
  elseif upgrade_name == RobotCargoResearch then
    table.insert(prerequisites, AgriculturalSciencePack)
  end

  if level >= 2 then
    table.insert(prerequisites, CryogenicSciencePack)
  end

  if level >= 3 then
    table.insert(prerequisites, PromethiumSciencePack)
  end
  return prerequisites
end


---@return table<TechnologyID>
local function get_research_prerequisites(upgrade_name, level)
  ---@type table<TechnologyID>
  local prerequisites = {}

  if level == 1 then
    prerequisites = {
      "logistic-robotics"
    }
  else
    prerequisites = {
      get_research_name(upgrade_name, level - 1)
    }
  end
  if mods["space-age"] then
    table.extend(prerequisites, get_SA_prerequisites(upgrade_name, level))
  end
  return prerequisites
end

local function get_tech_sprite(type, level)
  return {
    {
      icon = "__base__/graphics/technology/robotics.png",
      icon_size = 256, icon_mipmaps = 4
    }
  }
end

---@param upgrade_type data.TechnologyPrototype
---@param level number
---@param ingredients data.IngredientPrototype
local function add_SA_ingredients(upgrade_type, level, ingredients)
  if mods["space-age"] then
    if upgrade_type == RobotSpeedResearch then
      table.insert(ingredients, { MetallurgicSciencePack, 1 })
    elseif upgrade_type == RobotEnergyResearch then
      table.insert(ingredients, { ElectromagneticSciencePack, 1 })
    elseif upgrade_type == RobotCargoResearch then
      table.insert(ingredients, { AgriculturalSciencePack, 1 })
    end

    if level >= 2 then
      table.insert(ingredients, { CryogenicSciencePack, 1 })
    end

    if level >= 3 then
      table.insert(ingredients, { PromethiumSciencePack, 1 })
    end
  end
end

local function get_research_ingredients(upgrade_type, level)
  local researchPrerequisites = get_research_prerequisites(upgrade_type, level)
  local ingredients = combined_ingredients(
    researchPrerequisites,
    {
      { "automation-science-pack", 1 },
      { "logistic-science-pack",   1 },
      { "chemical-science-pack",   1 },
      { "production-science-pack", 1 },
      { "utility-science-pack",    1 },
    }
  )

  add_SA_ingredients(upgrade_type, level, ingredients)
  return table.unique_kv(ingredients)
end

local function get_research_limit(upgrade_type)
  local limit = 999999
  if upgrade_type == RobotCargoResearch then
    limit = robot_storage_limit
  elseif upgrade_type == RobotSpeedResearch then
    limit = material_storage_limit
  elseif upgrade_type == RobotEnergyResearch then
    limit = construction_area_limit
  end
  return math.max(research_minimum, math.min(limit, research_maximum))
end

local function add_researches()
  local upgrade_names = { RobotCargoResearch, RobotSpeedResearch, RobotEnergyResearch }

  for _, robot in pairs({Architect, Hauler}) do end
  for _, upgrade_type in pairs(upgrade_names) do
    limit = get_research_limit(upgrade_type)
    for i = 1, limit do
      data:extend(
        {
          {
            type = "technology",
            name = get_research_name(upgrade_type, i),
            icon_size = 256,
            icon_mipmaps = 4,
            icons = get_tech_sprite(upgrade_type, i),
            upgrade = true,
            order = "c-k-f-a",
            prerequisites = get_research_prerequisites(upgrade_type, i),
            effects = {
              {
                type = "nothing",
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
