-- Serverside Net

util.AddNetworkString("dac_gamestage_sync")
util.AddNetworkString("dac_validspace_sync")
util.AddNetworkString("dac_sendbase_confirmation") -- This message is caught in the weapon_dac_baseselector

function DAC:SyncGameStage(ply)
	net.Start("dac_gamestage_sync")
	net.WriteGameStage(DAC:GetGameStage())
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

-- Servside Net end

hook.Add("EntityTakeDamage", "DAC.GameStage.Damage", function(ent, dmginfo)
	local stage = DAC:GetGameStage()
	local attacker = dmginfo:GetAttacker()
	local data = stage:GetData()
	if not data.pvp and attacker:IsPlayer() and ent:IsPlayer() then
		--attacker:ChatPrint("[DAC]: Damage is disabled during the "..data.name .. " stage.")
		dmginfo:ScaleDamage(0)
		return true
	elseif data.pvp and attacker:IsPlayer() and ent:IsPlayer() then
		if attacker:Team() == ent:Team() then
			if attacker:Nick() ~= ent:Nick() then
				if GetConVar("dac_friendlyfire"):GetBool() == true then
					dmginfo:ScaleDamage(0.75) -- 25% friendly fire reduction
					return false
				else
					dmginfo:ScaleDamage(0)
					return true
				end
			else
				return false
			end
		else
			return false
		end
	end
end)

hook.Add("PlayerSpawnObject", "DAC.PlayerSpawnProp", function(ply, model, ent)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn props during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		return true 
	end
end)

hook.Add("PlayerSpawnVehicle", "DAC.PlayerSpawnVehicle", function(ply, model, name, table)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn vehicles during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn vehicles during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	end
end)

hook.Add("PlayerSpawnSWEP", "DAC.PlayerSpawnSWEP", function(ply, class, info) -- This isn't working for some reason, kinda sus
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn weapons during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn weapons during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	end
end)

hook.Add("PlayerSpawnNPC", "DAC.PlayerSpawnNPC", function(ply, npc_type, weapon)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn NPCs during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn NPCs during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	end
end)


hook.Add("PlayerSpawnSENT", "DAC.PlayerSpawnSENT", function(ply, class)
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn entities during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot spawn entities during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	end
end)

hook.Add("PhysgunPickup", "DAC.DenyFlagPhysgun", function( ply, ent )
	if ent.IsFlag then return false end -- Can't use the physgun on the flag entity
end )

hook.Add( "CanTool", "DAC.ToolgunPolicy", function( ply, tr, toolname, tool, button )
	local ent = tr.Entity
	if ent.IsFlag or ent.IsFlagBase or ent.IsSpawnRegion then -- Can't use the toolgun on gamemode entities
		return false
	else
		return true
	end
end )

hook.Add("PlayerNoClip", "DAC.NoclipPolicy", function( ply, desiredState )
	local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not ply:IsAdmin() then 
			ply:ChatPrint("[DAC]: Cannot use noclip during the " .. data.name .. " stage.")
			return false
		else 
			return true 
		end
	else
		return true
	end
end )

hook.Add("CanPlayerEnterVehicle", "DAC.VehicleRestrictions", function(ply, vehicleEnt, seatNum) 
	if(ply:GetPlayerCarrierStatus() == true and IsValid(vehicleEnt)) then
		if (vehicleEnt.IsFlagTransport == true) then -- We should make this a property for each vehicle that is permitted to transport a flag carrier
			return true
		else
			ply:ChatPrint("[DAC]: You cannot enter this vehicle while carrying a flag.")
			return false
		end
	else
		return true
	end
end)

function BuildArea(ply, team, spawnPos, flagPos)
	SpawnPlatform = ents.Create("dac_spawnplatform")
	SpawnPlatform:SetPos(spawnPos)
	SpawnPlatform:Spawn()
	SpawnPlatform:SetTeam(team)
	SpawnPlatform:SetGravity(0)

	FlagPlatform = ents.Create("dac_flagpoint")
	FlagPlatform:SetPos(flagPos)
	FlagPlatform:Spawn()
	FlagPlatform:SetTeam(team)
	FlagPlatform:SetGravity(0)

	BuildSphere = ents.Create("dac_buildsphere")
	BuildSphere:SetPos(flagPos)
	BuildSphere:Spawn()
	BuildSphere:SetTeam(team)
	BuildSphere:SetGravity(0)

	local otherTeam = nil

	for teamKey, teamData in pairs(GAMEMODE.Teams) do -- Do a comparison key for all team data. We use the player who passed in the build call from the base selector to do this
		if teamKey != team then
			otherTeam = teamKey
		elseif teamKey == team then
			userTeam = teamKey
		end
	end

	ply:SelectWeapon("weapon_physcannon")
	ply:StripWeapon("weapon_dac_baseselector") -- Strip the base selector from the player who passed in the message
	ply:Spawn()

	for i, v in ipairs(player.GetAll()) do
		if userTeam == v:Team() then
			v:Spawn() -- Respawn the players who belong to the team of the captain who confirmed and spawned their base location
		end
	end

	if GAMEMODE.Teams[userTeam].baseSet == true and GAMEMODE.Teams[otherTeam].baseSet == true then -- If both bases are placed, we'll initiate the build phase
		local buildStage = DAC.GameStage.New(2) -- 2 is the ENUM for the build phase
		DAC:SetGameStage(buildStage) 
		DAC:SyncGameStage()

		for _, players in pairs(player.GetAll()) do -- Edge case, since one team is already spawned at this point, they also need their tools for the build phase
			player_manager.RunClass(players, "GiveBuildTools")
		end
	end
end

function BeginMatch()

	for k,v in pairs(ents.GetAll()) do
		if v.IsSphere then
			v:Remove() -- Remove build spheres
		elseif v.IsFlagBase or v.IsSpawnRegion then
			v:GetPhysicsObject():EnableMotion(false) --Disable motion for the flag and spawn platforms
		end
	end

	for k, ply in pairs(player.GetAll()) do
		ply:Spawn()
		ply:ChatPrint("[DAC]: The match has begun!")
	end

	net.Start("SendBeginAudio")
	net.WriteBool(true)
	net.Broadcast()

end

function EndMatch(winningTeam) -- Pass in the winning team

	local winTeam = winningTeam

	--print("[DAC DEBUG]: Winning team index is " .. tostring(winTeam))

	timer.Simple(1, function()

		for k, v in pairs(player.GetAll()) do
			v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255), 3, 7)
		end

		net.Start("SendGameOverAudio")
		net.WriteFloat(winningTeam)
		net.Broadcast()

	end)

	-- Start a simple timer of seven seconds to give the logo time to display (not yet implemented)
	timer.Simple(8, function()

		game.CleanUpMap() -- Restore the map to its default state

		-- Reset team stats
		for teamKey, teamData in pairs(GAMEMODE.Teams) do
			GAMEMODE.Teams[teamKey].basePos = Vector(0,0,0)
			GAMEMODE.Teams[teamKey].baseSet = false
			team.SetScore(teamkey, 0)
		end

		for k,ply in pairs(player.GetAll()) do

			-- Reset player stats, unlock the player positions and respawn everyone to a base state
			ply:SetPlayerCarrierStatus(false)
			--ply:UnLock()
			ply:Spawn()
			player_manager.RunClass(ply, "Loadout")
			ply:SetNWInt("storeCredits", GetConVar("dac_income_balance"):GetInt())
			--ply:SetNWInt("playerMoney", 0)
			--ply:SetNWInt("playerMoney", ply:GetNWInt("playerMoney") + (GetConVar("ctf_startingbalance"):GetFloat()))

			--ply:ConCommand( "ctf_team" ) -- Call the team menu again
			
		end

		--PrintTable(GAMEMODE.Teams)
		-- Reset the game stage back to setup
		local setupStage = DAC.GameStage.New(1) -- 1 is the ENUM for the setup phase
		DAC:SetGameStage(setupStage)
		DAC:SyncGameStage()

	end) -- Call the reset world function above
	
end