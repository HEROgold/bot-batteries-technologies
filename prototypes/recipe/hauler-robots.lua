


function add_hauler_recipes()
    for c=0, robot_cargo_research_limit:get() do
        for s=0, robot_speed_research_limit:get() do
            for e=0, robot_energy_research_limit:get() do
                ---@type data.RecipePrototype
                local recipe = table.deepcopy(hauler_recipe)
                local suffix = get_robot_suffix{
                    cargo = c,
                    speed = s,
                    energy = e
                }
                recipe.name = "hauler-robot-mk-" .. suffix
                recipe.results = {
                    {type= "item", name = recipe.name, amount = 1},
                }
                recipe.hidden = true
                data:extend({recipe})
            end
        end
    end
end
