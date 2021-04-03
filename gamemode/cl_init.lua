include( "shared.lua" )
function GM:HUDDrawTargetID()
-- Because this returns nothing, we won't get any information about other players like their name or health when looking at them
end

net.Receive("dac_gamestage_sync", function()
	local gameStage = net.ReadGameStage()
	GAMEMODE:SetGameStage(gameStage)
end)