-- Serverside Net

util.AddNetworkString("dac_gamestage_sync")
util.AddNetworkString("dac_validspace_sync")
util.AddNetworkString("dac_sendbase_confirmation") -- This message is caught in the weapon_dac_baseselector
util.AddNetworkString("dac_givevehicle_preview") -- Cached at the server to give the player a vehicle preview tool
util.AddNetworkString("dac_vehicle_confirmation") -- This message is caught in the weapon_dac_vehiclepreviewer
util.AddNetworkString("dac_vehicle_cancellation") -- This message is caught in the weapon_dac_vehiclepreviewer
util.AddNetworkString("dac_sendvehicledata") -- This message is caught in the weapon_dac_vehiclepreviewer
util.AddNetworkString("dac_validspace_vehiclesync")
util.AddNetworkString("dac_cancelvehiclepurchase")
util.AddNetworkString("dac_purchase_entity")

function DAC:SyncGameStage(ply)
	net.Start("dac_gamestage_sync")
	net.WriteGameStage(DAC:GetGameStage())
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

net.Receive("dac_givevehicle_preview", function(len, ply)

	local previewWeaponClass = net.ReadString()
	if previewWeaponClass == 'weapon_dac_vehiclepreviewer' then -- Security to prevent someone from passing in whatever weapon they want
		ply:Give(previewWeaponClass)
		ply:SelectWeapon(previewWeaponClass)
		ply:SetNWBool("IsSpawningVehicle", true)
	else return end

end)

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
			--ply:ChatPrint("[DAC]: Cannot spawn props during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn props during the " .. data.name .. " stage.")
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
			--ply:ChatPrint("[DAC]: Cannot spawn vehicles during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn vehicles during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			--ply:ChatPrint("[DAC]: Cannot spawn vehicles during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn vehicles during the " .. data.name .. " stage.")
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
			--ply:ChatPrint("[DAC]: Cannot spawn weapons during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn weapons during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			--ply:ChatPrint("[DAC]: Cannot spawn weapons during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn weapons during the " .. data.name .. " stage.")
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
			--ply:ChatPrint("[DAC]: Cannot spawn NPCs during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn NPCs during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			--ply:ChatPrint("[DAC]: Cannot spawn NPCs during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn NPCs during the " .. data.name .. " stage.")
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
			--ply:ChatPrint("[DAC]: Cannot spawn entities during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn entities during the " .. data.name .. " stage.")
			return false 
		else 
			return true 
		end
	else
		if not ply:IsAdmin() then 
			--ply:ChatPrint("[DAC]: Cannot spawn entities during the " .. data.name .. " stage.")
			ply:ChatMessage_Basic("Cannot spawn entities during the " .. data.name .. " stage.")
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
			--ply:ChatPrint("[DAC]: Cannot use noclip during the " .. data.name .. " stage.")
			return false
		else 
			return true 
		end
	else
		return true
	end
end )

--hook.Add("CanPlayerEnterVehicle", "DAC.VehicleRestrictions", function(ply, vehicleEnt, seatNum) 

	--[[if IsValid(vehicleEnt) then
		print("[DAC Debug]: " .. tostring(vehicleEnt) .. "'s transport status is " .. tostring(vehicleEnt:GetNWBool('FlagTransport')))
	end]]

	--[[if IsValid(vehicleEnt) then

		--print(tostring("Vehicle team: " .. vehicleEnt:GetNWInt('OwningTeam') .. " Player team: ".. ply:Team()))

		if vehicleEnt:GetNWInt('OwningTeam') == ply:Team() then
			
			if(ply:GetPlayerCarrierStatus() == true) then

				if (vehicleEnt:GetNWBool('FlagTransport') == true) then -- We should make this a property for each vehicle that is permitted to transport a flag carrier
					return true
				else
					--ply:ChatPrint("[DAC]: You cannot enter this vehicle while carrying a flag.")
					ply:ChatMessage_Basic("You cannot enter this vehicle while carrying a flag.")
					return false
				end

			else
				return true
			end

		else
			--ply:ChatPrint("[DAC]: You cannot enter the other team's vehicles.")
			ply:ChatMessage_Basic("You cannot vehicles that are not owned by your team.")
			return false
		end

	end


end)]]

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

	BuildSphere = ents.Create("dac_perimetersphere")
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
		ply:SetFrags(0)
		ply:SetDeaths(0)
		ply:ChatMessage_Basic("The match has begun!")
	end

	net.Start("SendBeginAudio")
	net.WriteBool(true)
	net.Broadcast()

end

function EndMatch(winningTeam) -- Pass in the winning team

	local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()
	local parseTimer = nil

    if data.name == "OVERTIME" then
		parseTimer = 0.1
	else
		parseTimer = 1
	end

	timer.Simple(parseTimer, function()

		for k, v in pairs(player.GetAll()) do
			v:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255), 3, 7)
		end

		net.Start("SendGameOverAudio")
		net.WriteInt(winningTeam, 32)
		net.Broadcast()

	end)

	-- Start a simple timer of seven seconds to give the logo time to display (not yet implemented)
	timer.Simple(8, function()

		game.CleanUpMap() -- Restore the map to its default state

		-- Reset team stats
		for teamKey, teamData in pairs(GAMEMODE.Teams) do
			GAMEMODE.Teams[teamKey].basePos = nil
			GAMEMODE.Teams[teamKey].baseSet = false
			team.SetScore(teamkey, 0)
		end

		for k,ply in pairs(player.GetAll()) do

			-- Reset player stats and respawn everyone to a base state
			ply:SetPlayerCarrierStatus(false)
			player_manager.RunClass(ply, "Loadout")
			ply:SetNWInt("storeCredits", GetConVar("dac_income_balance"):GetInt())
			ply:SetNWBool("IsSpawningVehicle", false)
			ply:SetNWBool("IsInBase", false)
			ply:SetFrags(0)
			ply:SetDeaths(0)
			ply:Spawn()

			--ply:ConCommand( "ctf_team" ) -- Call the team menu again
			
		end

		-- Reset the game stage back to setup
		local setupStage = DAC.GameStage.New(GAMESTAGE_SETUP)
		DAC:SetGameStage(setupStage)
		DAC:SyncGameStage()

	end) -- Call the reset world function above
	
end