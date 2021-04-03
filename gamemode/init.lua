AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	local gameStage = DAC.GameStage.New()
	gameStage:SetStage(GAMESTAGE_BUILD)
	gameStage:SetDuration(10)
	gameStage:Start()
	DAC:SetGameStage(gameStage)
end