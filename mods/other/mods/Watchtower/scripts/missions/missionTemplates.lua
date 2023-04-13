-- BONUS_ASSET = 1	--NOT added manually!
-- BONUS_KILL = 2	--This is Pinnacle's "kill before retreat"
-- BONUS_GRID = 3
-- BONUS_MECHS = 4
-- BONUS_BLOCK = 5
-- BONUS_KILL_FIVE = 6
-- BONUS_DEBRIS = 7
-- BONUS_SELFDAMAGE = 8
-- BONUS_PACIFIST = 9


local this = {
	bonusAll = { 
		BONUS_GRID,
		BONUS_MECHS,
		BONUS_BLOCK,
		BONUS_KILL_FIVE,
		BONUS_DEBRIS,
		BONUS_SELFDAMAGE,
		BONUS_PACIFIST,
		--"tosx_bonus_rocks",
		},
	bonusNoMercy = {
		BONUS_GRID,
		BONUS_MECHS,
		BONUS_KILL_FIVE,
		BONUS_DEBRIS,
		BONUS_SELFDAMAGE,
		--"tosx_bonus_rocks",
		},
	bonusNoBlock = { 
		BONUS_GRID,
		BONUS_MECHS,
		BONUS_KILL_FIVE,
		BONUS_DEBRIS,
		BONUS_SELFDAMAGE,
		BONUS_PACIFIST,
		--"tosx_bonus_rocks",
		},
}

return this