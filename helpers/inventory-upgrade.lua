require("__heroic-library__.inventories")
require("helpers.robot-upgrade")

local robot_upgrade = require("helpers.robot-upgrade")

--- Helper module for upgrading robots in inventories
local inventory_upgrade = {}

---@param entity LuaEntity
---@param inventory defines.inventory
function inventory_upgrade.upgrade_robots(entity, inventory)
	local inv = entity.get_inventory(inventory)
	if not inv then
		return
	end

	local contents = inventories.find(inv, robot_upgrade.is_upgradeable)

	for _, item in ipairs(contents) do
		local new_item = robot_upgrade.get_upgraded_item(item, entity.force)
		if new_item then
			inventories.replace(inv, item, new_item)
		end
	end
end

return inventory_upgrade
