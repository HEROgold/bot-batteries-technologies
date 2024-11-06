require("lualib.utils")
require("vars.strings")

function uninstall()
    for _, surface in pairs(game.surfaces) do
        for _, roboport in pairs(surface.find_entities_filtered { type = Roboport }) do
            if not roboport.valid then
                goto continue
            end

            if (
                    roboport.name == Roboport
                    or not utilities.string_starts_with(roboport.name, RoboportEnergy)
                    and not utilities.string_starts_with(roboport.name, RoboportLogistical)
                ) then
                goto continue
            end

            local old_energy = roboport.energy
            local created_rport = surface.create_entity {
                name = Roboport,
                position = roboport.position,
                force = roboport.force,
                fast_replace = true,
                spill = false,
                create_build_effect_smoke = false,
                raise_built = false
            }
            created_rport.energy = old_energy
            roboport.destroy()
            ::continue::
        end
    end
end

-- TODO: Move to library
---@param tech LuaTechnology
function recursive_unresearch_technology(tech)
    for _, i in pairs(tech.successors) do
        recursive_unresearch_technology(i)
    end
    tech.researched = false
end

function reset()
    game.print("Resetting mod")
    -- Reset related technologies
    storage.EfficiencyResearchLevel = 0
    storage.ProductivityResearchLevel = 0
    storage.SpeedResearchLevel = 0
    storage.ConstructionAreaResearchLevel = 0
    storage.LogisticAreaResearchLevel = 0
    storage.RobotStorageResearchLevel = 0
    storage.MaterialStorageResearchLevel = 0
    -- Reset all research levels
    for _, force in pairs(game.forces) do
        recursive_unresearch_technology(force.technologies[RoboportEfficiency])
        recursive_unresearch_technology(force.technologies[RoboportProductivity])
        recursive_unresearch_technology(force.technologies[RoboportSpeed])
        recursive_unresearch_technology(force.technologies[RoboportConstructionArea])
        recursive_unresearch_technology(force.technologies[RoboportLogisticsArea])
        recursive_unresearch_technology(force.technologies[RoboportRobotStorage])
        recursive_unresearch_technology(force.technologies[RoboportMaterialStorage])
    end
    -- Reset all related roboports
    for _, surface in pairs(game.surfaces) do
        for _, roboport in pairs(surface.find_entities_filtered { type = Roboport }) do
            if not roboport.valid then
                goto continue
            end

            if utilities.string_starts_with(roboport.name, RoboportEnergy) then
                local old_energy = roboport.energy
                local created_rport = surface.create_entity {
                    name = RoboportEnergy,
                    position = roboport.position,
                    force = roboport.force,
                    fast_replace = true,
                    spill = false,
                    create_build_effect_smoke = false,
                    raise_built = false
                }
                created_rport.energy = old_energy
                roboport.destroy()
            elseif utilities.string_starts_with(roboport.name, RoboportLogistical) then
                local old_energy = roboport.energy
                local created_rport = surface.create_entity {
                    name = RoboportLogistical,
                    position = roboport.position,
                    force = roboport.force,
                    fast_replace = true,
                    spill = false,
                    create_build_effect_smoke = false,
                    raise_built = false
                }
                created_rport.energy = old_energy
                roboport.destroy()
            end
            ::continue::
        end
    end
    game.print("Reset complete")
end

commands.add_command(
    "br-show",
    "Shows the current research levels",
    function()
        game.print("-- Energy --")
        game.print("efficiency: " .. storage.EfficiencyResearchLevel)
        game.print("Productivity: " .. storage.ProductivityResearchLevel)
        game.print("Speed: " .. storage.SpeedResearchLevel)
        game.print("-- Storage --")
        game.print("Construction Area: " .. storage.ConstructionAreaResearchLevel)
        game.print("Logistics Area: " .. storage.LogisticAreaResearchLevel)
        game.print("Robot Storage: " .. storage.RobotStorageResearchLevel)
        game.print("Material Storage: " .. storage.MaterialStorageResearchLevel)
    end
)
commands.add_command(
    "br-uninstall",
    "Forces roboports to be vanilla, usefull for uninstalling this mod",
    function()
        uninstall()
    end
)
commands.add_command(
    "br-reset",
    "Resets all roboports to 0, resets all research levels and technologies.",
    function()
        reset()
    end
)

commands.add_command(
    "br-test",
    "test",
    function()
        for _, force in pairs(game.forces) do
            game.print("Force: " .. force.name)
            for _, tech in pairs(force.technologies) do
                if utilities.string_starts_with(tech.name, Roboport) then
                    game.print("Tech: " .. tech.name)
                end
            end
        end
    end
)
