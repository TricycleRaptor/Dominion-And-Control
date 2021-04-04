AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	local gameStage = DAC.GameStage.New(GAMESTAGE_BASEPLACE)
	DAC:SetGameStage(gameStage)

	GetConVar("sbox_weapons"):SetBool(false)
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