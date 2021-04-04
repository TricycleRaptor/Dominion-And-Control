GAMESTAGE_BASEPLACE = 1
GAMESTAGE_BUILD = 2
GAMESTAGE_PLAY = 3

DAC:RegisterGameStage(GAMESTAGE_BASEPLACE, {
	name = "Base Selection",
	showOnHud = true,
	pvp = false,
	nextStage = nil,
	color = Color(0, 130, 255)
})

DAC:RegisterGameStage(GAMESTAGE_BUILD, {
	name = "Build",
	showOnHud = true,
	pvp = false,
	nextStage = GAMESTAGE_PLAY,
	duration = 10,
	color = Color(0, 255, 0)
})

DAC:RegisterGameStage(GAMESTAGE_PLAY, {
	name = "Play",
	showOnHud = false,
	pvp = true,
	nextStage = nil,
	color = Color(255, 0, 0)
})