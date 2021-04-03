GAMESTAGE_BUILD = 1
GAMESTAGE_PLAY = 2

DAC:RegisterGameStage(GAMESTAGE_BUILD, {
	name = "Build",
	pvp = false,
	timed = true
})

DAC:RegisterGameStage(GAMESTAGE_PLAY, {
	name = "Play",
	pvp = true,
	timed = false
})