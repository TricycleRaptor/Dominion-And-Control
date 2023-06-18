concommand.Add( "dac_changeteam", function( pl, cmd, args )

	hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber( args[ 1 ] ) ) 
	
end )

concommand.Add("dac_set_gamestage", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local stage = tonumber(args[1])
	if not DAC.GameStages[stage] then
		--ply:ChatPrint("[DAC]: Invalid stage ID: "..stage)
		return
	end

	local newStage = DAC.GameStage.New(stage)
	DAC:SetGameStage(newStage)
	DAC:SyncGameStage()
	--ply:ChatPrint("[DAC]: Setting game stage to "..newStage:GetData().name)
end)