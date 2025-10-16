require("vars.strings")


function add_hauler_recipes()
    for c=0, robot_cargo_research_limit do
        for s=0, robot_speed_research_limit do
            for e=0, robot_energy_research_limit do
                ---@type data.RecipePrototype
                local recipe = table.deepcopy(hauler_recipe)
                local suffix = get_robot_suffix{
                    cargo = c,
                    speed = s,
                    energy = e
                }
                recipe.name = combine{HaulerRobotLeveled, suffix}
                recipe.results = {
                    {type= Item, name = recipe.name, amount = 1},
                }
                recipe.hidden = true
                data:extend({recipe})
            end
        end
    end
end
