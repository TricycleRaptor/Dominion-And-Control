AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.CurrentGameStage = nil

function GM:Initialize()
	local gameStage = DAC.GameStage.New()
	gameStage:SetStage(GAMESTAGE_BUILD)
	gameStage:SetDuration(10)
	gameStage:Start()
	self:SetGameStage(gameStage)
end

util.AddNetworkString("dac_gamestage_sync")
function GM:SyncGameStage(ply)
	net.Start("dac_gamestage_sync")
	net.WriteGameStage(self:GetGameStage())
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end