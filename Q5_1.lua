local config = {
	amount = 3,
	tilesPerCycle = 3,
	combat = Combat(),
	area = createCombatArea({
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{0, 1, 1, 1, 1, 1, 0},
		{1, 1, 1, 3, 1, 1, 1},
		{0, 1, 1, 1, 1, 1, 0},
		{0, 0, 1, 1, 1, 0, 0},
		{0, 0, 0, 1, 0, 0, 0}
	})
}

function onTargetTile(creature, position)
	table.insert(config.positions, position)
end

config.combat:setArea(config.area)
config.combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function copyTable(fromTable)
	local toTable = {}
	for key, value in pairs(fromTable) do
		toTable[key] = value
	end
	return toTable
end

local function executeEffect(positions, positionsV2, counter)
	for i = 1, config.tilesPerCycle do
		local index = math.random(#positions)
		local position = positions[index]
		position:sendMagicEffect(CONST_ME_ICETORNADO)
		table.remove(positions, index)
		if #positions == 0 then
			if counter == 0 then
				return true
			end

			counter = counter - 1
			positions = copyTable(positionsV2)
		end
	end

	if #positions > 0 then
		addEvent(executeEffect, 150, positions, positionsV2, counter)
	end
end

function onCastSpell(creature, variant, isHotkey)
	config.positions = {}
	config.combat:execute(creature, variant)

	local positions = copyTable(config.positions)
	executeEffect(positions, copyTable(config.positions), config.amount)
end
