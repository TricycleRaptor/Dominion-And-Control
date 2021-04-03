util.AddNetworkString("dac_gamestage_sync")
function DAC:SyncGameStage(ply)
	net.Start("dac_gamestage_sync")
	net.WriteGameStage(DAC:GetGameStage())
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end