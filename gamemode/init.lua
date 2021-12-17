AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	GetConVar("sbox_weapons"):SetBool(false)
	RunConsoleCommand("mp_falldamage", "1")
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
    print("[DAC DEBUG]: Build function called, received values are as follows: " .. tostring(ply) .. ", " .. tostring(team) .. ", " .. tostring(spawnPos) .. ", " .. tostring(flagPos))
		-- TO DO: Make funny bases spawn now
end