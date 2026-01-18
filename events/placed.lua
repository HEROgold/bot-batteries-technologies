require("__heroic-library__.entities")
require("helpers.robot-upgrade")
require("helpers.research")

local robot_upgrade = require("helpers.robot-upgrade")

--- @param recipe LuaRecipe
--- @param robot_type string
--- @return LuaRecipePrototype?
local function get_upgraded_robot_recipe(recipe, robot_type)
    if not recipe.valid then return end
    local levels = get_research_levels(recipe.force)
    local recipe_result_name = recipe.products[1].name
    local upgraded_robot_name = get_upgraded_robot_with_levels(recipe_result_name, levels)
    return game.recipe_prototypes[upgraded_robot_name]
end


--- @param recipe LuaRecipe
local function get_upgraded_recipe(recipe)
    if recipe.name == ArchitectRobot then 
        return get_upgraded_robot_recipe(recipe, Architect)
    end
    if recipe.name == HaulerRobot then
        return get_upgraded_robot_recipe(recipe, Hauler)
    end
end


--- @param entity LuaEntity
local function update_assembler_recipe(entity)
    -- Enable line below to ignore ghosts.
    -- if entity.type ~= AssemblingMachine then return end

    local recipe, quality = entity.get_recipe()
    if not recipe or not recipe.valid then return end

    local upgrade = get_upgraded_recipe(recipe)
    if not upgrade then return end

    entity.set_recipe(upgrade, quality)
end


script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity,
        defines.events.on_post_entity_died,
        defines.events.script_raised_built,
        defines.events.script_raised_revive,
    },
    ---@param event EventData.on_built_entity | EventData.on_robot_built_entity | EventData.on_post_entity_died | EventData.script_raised_built | EventData.script_raised_revive
    function (event)
        local entity = event.created_entity or event.entity
        if not entity or not entity.valid then return end
        if entities.is_type(entity, AssemblingMachine) then
            update_assembler_recipe(entity)
        end
        if entities.is_type(entity, "construction-robot") or entities.is_type(entity, LogisticRobot) then
            -- Update the flying robot entity itself
        end
        -- TODO: update ghost entities filters just like in the research event.
    end
)
