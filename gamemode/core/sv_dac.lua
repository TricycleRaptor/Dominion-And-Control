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

hook.Add("EntityTakeDamage", "DAC.GameStage.Damage", function(ent, dmginfo)
	local stage = DAC:GetGameStage()
	local attacker = dmginfo:GetAttacker()
	local data = stage:GetData()
	if not data.pvp and attacker:IsPlayer() and ent:IsPlayer() then
		attacker:ChatPrint("Damage is Disabled while the game stage is "..data.name)
		dmginfo:ScaleDamage(0)
		return true
	end
end)

hook.Add("PlayerSpawnObject", "DAC.PlayerSpawnedProp", function(ply, model, ent)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		ply:ChatPrint("Cannot build while the game stage is "..data.name)
		return false
	end
end)