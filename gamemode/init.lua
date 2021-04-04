AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	local gameStage = DAC.GameStage.New(GAMESTAGE_BASEPLACE)
	DAC:SetGameStage(gameStage)

	GetConVar("sbox_weapons"):SetBool(false)
end