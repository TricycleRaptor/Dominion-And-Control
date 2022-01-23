AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	GetConVar("sbox_weapons"):SetBool(false)
	RunConsoleCommand("mp_falldamage", "1")

	for teamKey, teamData in pairs(GAMEMODE.Teams) do -- Sort through team indexes (There are only two)
		teamData.basePos = Vector(0,0,0)
		teamData.baseSet = false
	end
end

function GM:PlayerSpawnNPC(ply, npc, wep)
	if not ply:IsAdmin() then return false end
	return true
end

function GM:PlayerGiveSWEP(ply, wep, info)
	if not ply:IsAdmin() then return false end
	return true
end

function GM:PlayerSpawnEffect(ply, model)
	if not ply:IsAdmin() then return false end
	return true
end

function GM:PlayerSpawnVehicle(ply, veh)
	if not ply:IsAdmin() then return false end
	return true
end

function GM:PlayerSpawnRagdoll(ply, model)
	if not ply:IsAdmin() then return false end
	return true
end

function GM:PlayerSpawnSENT(ply, class)
	if not ply:IsAdmin() then return false end
	return true
end

function BuildArea(ply, team, spawnPos, flagPos)

	SpawnPlatform = ents.Create("dac_spawnplatform")
	SpawnPlatform:SetPos(spawnPos)
	SpawnPlatform:Spawn()
	SpawnPlatform:SetTeam(team)
	SpawnPlatform:SetGravity(0)

	FlagPlatform = ents.Create("dac_flagpoint")
	FlagPlatform:SetPos(flagPos)
	FlagPlatform:Spawn()
	FlagPlatform:SetTeam(team)
	FlagPlatform:SetGravity(0)

	BuildSphere = ents.Create("dac_buildsphere")
	BuildSphere:SetPos(flagPos)
	BuildSphere:Spawn()
	BuildSphere:SetTeam(team)
	BuildSphere:SetGravity(0)

	local otherTeam = nil

	for teamKey, teamData in pairs(GAMEMODE.Teams) do
		if teamKey != team then
			otherTeam = teamKey
		end
	end

	if GAMEMODE.Teams[team].baseSet == true and GAMEMODE.Teams[otherTeam].baseSet == true then
		local buildStage = DAC.GameStage.New(2) -- 2 is the ENUM for the build phase
		DAC:SetGameStage(buildStage) 
		DAC:SyncGameStage()
	end

end