net.Receive("dac_gamestage_sync", function()
	local gameStage = net.ReadGameStage()
	DAC:SetGameStage(gameStage)
end)