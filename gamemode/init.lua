AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	GetConVar("sbox_weapons"):SetBool(false)
	RunConsoleCommand("mp_falldamage", "1") -- Realistic fall damage
	RunConsoleCommand("sv_alltalk", "2") -- Proximity voice chat
	RunConsoleCommand("lvs_teampassenger", "1") -- Only teammates can enter LVS vehicles
	RunConsoleCommand("lvs_force_forceindicator", "1") -- Hide LVS vehicle team/health identifiers
	RunConsoleCommand("sk_plr_dmg_crowbar", "25") -- Buff crowbar damage

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

function GM:ShowSpare1(ply) -- Override F3 keypress
	ply:ConCommand("dac_multimenu")
end