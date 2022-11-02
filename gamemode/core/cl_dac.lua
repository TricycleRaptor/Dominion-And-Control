-- Client Net

net.Receive("dac_gamestage_sync", function()
	local gameStage = net.ReadGameStage()

	local currentGameStage = DAC:GetGameStage()

	if not currentGameStage or currentGameStage.stage ~= gameStage.stage then
		DAC:SetGameStage(gameStage)
	end
end)

net.Receive("dac_validspace_sync", function()

    local bool = net.ReadBool()
    if bool == false then return end
    DrawConfirmationBox()

end )

net.Receive("dac_validspace_vehiclesync", function()

    local bool = net.ReadBool()
    if bool == false then return end
    DrawVehicleConfirmationBox()

end )

net.Receive("dac_cancelvehiclepurchase", function()

    local bool = net.ReadBool()
    if bool == false then return end
    DrawVehicleCancellationBox()

end )