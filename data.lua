mod_name = "heroic-robots"

-- Global requires
require("settings")

-- Base Functionality
require("prototypes.base")
add_base_robots()

require("prototypes.robot.architect-robots")
add_architect_robots()

require("prototypes.robot.hauler-robots")
add_hauler_robots()

require("prototypes.recipe.architect-robots")
add_architect_recipes()

require("prototypes.recipe.hauler-robots")
add_hauler_recipes()

require("prototypes.technology.robots")
insert_research_unlocks()
add_researches()

-- require("prototypes.tier-switcher")
-- add_tier_switcher_roboport()
