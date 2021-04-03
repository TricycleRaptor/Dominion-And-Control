--- Globals ---

TEAM_BLUE = 1
TEAM_RED = 2

local logoParams = "smooth"

GM.Teams = {
	[TEAM_BLUE] = {
		name = "Blue Team",
		color = Color(0, 130, 255, 255),
		joinable = true,
		logo = CLIENT and Material("dominion/ui/flag.png", logoParams)
	},
	[TEAM_RED]= {
		name = "Red Team",
		color = Color(255, 0, 0, 255),
		joinable = true,
		logo = CLIENT and Material("dominion/ui/flag.png", logoParams)
	}
}

function GM:CreateTeams()
	for teamKey, teamData in pairs(GAMEMODE.Teams) do
		team.SetUp(teamKey, teamData.name, teamData.color, teamData.joinable)
	end
end