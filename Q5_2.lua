local config = {
	amount = 5,
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

function executeEffect(position, count)
	if math.random(0, 1) == 1 then
		position:sendMagicEffect(CONST_ME_ICETORNADO)
	end

	if count < config.amount then
		count = count + 1
		addEvent(executeEffect, math.random(250, 1000), position, count)
	end
end

function onTargetTile(creature, position)
	executeEffect(position, 0)
end

config.combat:setArea(config.area)
config.combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(creature, variant, isHotkey)
	return config.combat:execute(creature, variant)
end
