net.Receive("dac_gamestage_sync", function()
	local gameStage = net.ReadGameStage()

	local currentGameStage = DAC:GetGameStage()

	if not currentGameStage or currentGameStage.stage ~= gameStage.stage then
		DAC:SetGameStage(gameStage)
	end
end)