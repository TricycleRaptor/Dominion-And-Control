GAMESTAGE_BASEPLACE = 1
GAMESTAGE_BUILD = 2
GAMESTAGE_PLAY = 3

DAC:RegisterGameStage(GAMESTAGE_BASEPLACE, {
	name = "Base Selection",
	showOnHud = true,
	pvp = false,
	timed = false,
	color = Color(0, 130, 255)
})

DAC:RegisterGameStage(GAMESTAGE_BUILD, {
	name = "Build",
	showOnHud = true,
	pvp = false,
	timed = true,
	color = Color(0, 255, 0)
})

DAC:RegisterGameStage(GAMESTAGE_PLAY, {
	name = "Play",
	showOnHud = false,
	pvp = true,
	timed = false,
	color = Color(255, 0, 0)
})