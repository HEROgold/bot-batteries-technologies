require("__heroic-library__.table")
require("vars.strings")

--- Helper module for technology ingredient management
local tech_ingredients = {}

---@param upgrade_type string
---@param level number
---@param ingredients data.IngredientPrototype[]
function tech_ingredients.add_space_age_ingredients(upgrade_type, level, ingredients)
    if not mods["space-age"] then return end

    if level >= 1 then
        if upgrade_type == RobotUpgradeSpeed then
            table.insert(ingredients, { MetallurgicSciencePack, 1 })
        elseif upgrade_type == RobotUpgradeEnergy then
            table.insert(ingredients, { ElectromagneticSciencePack, 1 })
        elseif upgrade_type == RobotUpgradeCargo then
            table.insert(ingredients, { AgriculturalSciencePack, 1 })
        end
    end

    if level >= 2 then
        table.insert(ingredients, { CryogenicSciencePack, 1 })
    end
    
    if level >= 3 then
        table.insert(ingredients, { PromethiumSciencePack, 1 })
    end
end

---@param upgrade_type string
---@param level number
---@param prerequisites table<TechnologyID>
---@return data.IngredientPrototype[]
function tech_ingredients.get_all(upgrade_type, level, prerequisites)
    local ingredients = combined_ingredients(
        prerequisites,
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "utility-science-pack",    1 },
        }
    )

    tech_ingredients.add_space_age_ingredients(upgrade_type, level, ingredients)

    return table.unique_kv(ingredients)
end

return tech_ingredients
