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
		--attacker:ChatPrint("[DAC]: Damage is disabled while the game stage is "..data.name)
		dmginfo:ScaleDamage(0)
		return true
	end
end)

hook.Add("PlayerSpawnObject", "DAC.PlayerSpawnProp", function(ply, model, ent)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		ply:ChatPrint("[DAC]: Cannot spawn props during the " .. data.name .. " stage.")
		return false
	end
end)

hook.Add("PlayerSpawnVehicle", "DAC.PlayerSpawnVehicle", function(ply, model, name, table)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		--ply:ChatPrint("[DAC]: Cannot spawn vehicles during the " .. data.name .. " stage.")
		return false
	end
end)

hook.Add("PlayerSpawnSWEP", "DAC.PlayerSpawnSWEP", function(ply, class, info) -- This isn't working for some reason, kinda sus
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		--ply:ChatPrint("[DAC]: Cannot spawn weapons during the " .. data.name .. " stage.")
		return false
	end
end)

hook.Add("PlayerSpawnNPC", "DAC.PlayerSpawnNPC", function(ply, npc_type, weapon)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		--ply:ChatPrint("[DAC]: Cannot spawn NPCs during the " .. data.name .. " stage.")
		return false
	end
end)


hook.Add("PlayerSpawnSENT", "DAC.PlayerSpawnSENT", function(ply, class)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
	-- if not data.allowBuilding and not ply:IsAdmin() then
		--ply:ChatPrint("[DAC]: Cannot spawn entities during the " .. data.name .. " stage.")
		return false
	end
end)

hook.Add("PhysgunPickup", "DAC.DenyFlagPhysgun", function( ply, ent )
	if ent:GetName() == "dac_flag" then return false end
end )