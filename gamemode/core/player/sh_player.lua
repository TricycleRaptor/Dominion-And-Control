hook.Add("PlayerInitialSpawn", "DAC.AssignDefaultWeapons", function(ply, transition) 
	ply:SetDefaultWeapons()
end)

function GM:PlayerSpawn(ply)

	--print("[DAC DEBUG]: " .. ply:Nick() .. "'s primary weapon is a " .. tostring(ply:GetPlayerWeapon()))
	--print("[DAC DEBUG]: " .. ply:Nick() .. "'s special item is a " .. tostring(ply:GetPlayerSpecial()))

	local gameStage = DAC:GetGameStage()
	local stageData = gameStage:GetData()
	local teamNum = ply:Team()
	local teamColor = team.GetColor(teamNum)
	ply:SetNWBool("IsSpawningVehicle", false)
	ply:SetNWBool("IsInBase", false)
	ply:lvsGetAITeam(ply:Team())

	self.BaseClass:PlayerSpawn(ply)
	DAC:SyncGameStage(ply)

	-- Reset player variables used for previewing vehicles
	ply.vehicleName = nil
	ply.vehicleCategory = nil
	ply.vehicleCost = nil
	ply.vehicleIsFlagTransport = nil
	ply.vehicleModel = nil
	ply.vehicleListName = nil
	ply.vehicleClass = nil
	ply.vehicleSpawnOffset = nil
	ply.vehicleSpawnPos = nil
	ply.vehicleSpawnAng = nil

	-- Apply team colors after the base spawn function has been passed to override sandbox-defined player colors
	-- Changes player model colors, if the model has any, as well as the physgun
	ply:SetPlayerColor( Vector( teamColor.r / 255, teamColor.g / 255, teamColor.b / 255 ) )
	ply:SetWeaponColor( Vector( teamColor.r / 255, teamColor.g / 255, teamColor.b / 255 ) )

	-- Brief 5-second invulnerability when spawning
	if stageData.name ~= "SETUP" then 
		ply:GodEnable()
		timer.Simple(5, function() 
			ply:GodDisable()
		end)
	end

	-- Set up player configurations
	player_manager.SetPlayerClass(ply, "DAC_playerclass") -- Get the internal player settings from the DAC custom class
	player_manager.RunClass(ply, "Loadout") -- Get the player loadout
	player_manager.OnPlayerSpawn(ply) -- Apply all player changes
	ply:SetPlayerCarrierStatus(false) -- This should always be false since a player should never spawn with a flag. Probably not necessary but it's better to cover edge cases.

	-- Check for spawn platforms in the map, call the spawn platform's spawn function on the player if true
	for _, ent in pairs(ents.GetAll()) do 
		if (ent.IsSpawnRegion and ply:Team() == ent:GetTeam()) then
			ply:SetPos(ent:GetSpawnPos())
			break
		end
 	end

	-- If we're in the build stage, we'll call the class from the player manager to give players their physgun and toolgun (sh_player_class.lua)
	if stageData.name == "BUILD" then 
		player_manager.RunClass(ply, "GiveBuildTools")
	else
		player_manager.RunClass(ply, "RemoveBuildTools") -- dumb bitch
	end

	if ply.IsCaptain and GAMEMODE.Teams[teamNum].baseSet == false then
		ply:SelectWeapon("weapon_dac_baseselector")
	else
		ply:SelectWeapon("weapon_physcannon")
	end

end

--[[function GM:PlayerFootstep(ply, pos, foot)

	if( ply:GetVelocity():Length2D() > 150 ) then
		return false
	else
		return true -- Silent footsteps when crouch walking
	end

	self.BaseClass:PlayerFootstep( ply, pos, foot, s, vol, rf );

end]]

function GM:PlayerSetModel(ply)
	self.BaseClass:PlayerSetModel(ply)
end

function GM:PlayerCanJoinTeam( ply, teamid )

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch and RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		--ply:ChatPrint( Format( "[DAC]: Please wait %i seconds before trying to change teams.", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	-- Already on this team
	if ( ply:Team() == teamid ) then
		--ply:ChatPrint( "[DAC]: You're already on that team." )
		ply:ChatMessage_Basic("You're already on that team.")
		return false
	end

	-- Carrying a flag
	if ( ply:GetPlayerCarrierStatus() == true ) then
		--ply:ChatPrint( "[DAC]: You cannot change teams while carrying a flag." )
		ply:ChatMessage_Basic("You cannot change teams while carrying a flag.")
		return false
	end

	return true

end

function GM:PlayerHurt(victim, attacker, healthRemaining, damageTaken)
	local maxVictimHealth = victim:GetMaxHealth()
	if damageTaken > (maxVictimHealth * 0.25) then -- Trigger if the damage taken is above 25% of the player's max health
		victim:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.3, 0 ) -- Flash the victim's screen red to nothing over the course of 0.3 seconds
	end
end

function GM:PlayerRequestTeam( ply, teamid )

	-- This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
		--ply:ChatPrint( "[DAC]: You can't join that team." )
	return end

	if teamid ~= nil then
		local teamNum = teamid -- Pass in the team index

		if ply:Team() ~= teamNum then
			if team.NumPlayers(teamNum) < 1 and GAMEMODE.Teams[teamNum].baseSet == false then
				--ply:ChatPrint( "[DAC]: Please select a location for your base." )
				ply:ChatMessage_Basic("Please select a location for your base.")
				ply.IsCaptain = true
			elseif team.NumPlayers(teamNum) >= 1 and GAMEMODE.Teams[teamNum].baseSet == false then
				--ply:ChatPrint( "[DAC]: Please wait for your team captain to pick a base location." )
				ply:ChatMessage_Basic("Please wait for your team captain to pick a base location.")
				ply.IsCaptain = false
			end
		end

	else 
		print("[DAC DEBUG]: Guard code triggered.")
	return end

	GAMEMODE:PlayerJoinTeam( ply, teamid )

end

function GM:PlayerJoinTeam( ply, teamid )

	local iOldTeam = ply:Team()

	if ( ply:Alive() ) then
		if ( iOldTeam == TEAM_SPECTATOR || iOldTeam == TEAM_UNASSIGNED ) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()

	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )

end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	--[[if ply.IsCaptain == true and oldteam ~= nil then
		ply.IsCaptain = false
		for _, v in pairs (team.GetPlayers(oldteam)) do
			if v != ply and team.NumPlayers(oldteam) < 1 then
				v.IsCaptain = true
				if GAMEMODE.Teams[oldteam].baseSet == false then
					v:Give("weapon_dac_baseselector")
					--v:ChatPrint( "[DAC]: You have been made team captain. Please select a location for your base." )
					v:ChatMessage_Basic("You have been made team captain. Please select a location for your base.")
				end
			end
		end
	end ]]

	if ( newteam == TEAM_SPECTATOR ) then

		-- If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
		ply:Spectate(OBS_MODE_ROAMING)

	elseif ( oldteam == TEAM_SPECTATOR ) then

		-- If we're changing from spectator, join the game
		ply:UnSpectate()
		ply:Spawn()

	else

		-- If we're straight up changing teams just hang
		-- around until we're ready to respawn onto the
		-- team that we chose

	end

	--PrintMessage( HUD_PRINTTALK, Format( "[DAC]: %s joined the %s!", ply:Nick(), team.GetName( newteam ) ) )
	for playerNum, playerVal in pairs (player.GetAll()) do
		--playerVal:ChatMessage_Basic(ply:Nick() .. " joined " .. team.GetName(newteam) .. "!")
		playerVal:ChatMessage_TeamChangeNotice(ply, oldteam, newteam)
	end

	ply:SetNWBool("IsPreviewingVehicle", false)

end

function GM:PlayerDisconnected(ply)

	local teamNum = ply:Team()
	ply:SetNWBool("IsPreviewingVehicle", false)

	if ply.IsCaptain == true then
		ply.IsCaptain = false
		for _, v in pairs (team.GetPlayers(teamNum)) do
			if v != ply then
				v.IsCaptain = true
				if GAMEMODE.Teams[teamNum].baseSet == false then
					v:Give("weapon_dac_baseselector")
					--v:ChatPrint( "[DAC]: You have been made team captain. Please select a location for your base." )
					v:ChatMessage_Basic("You have been made team captain. Please select a location for your base.")
				end
			end
		end
	end

	ply:SetPlayerCarrierStatus(false)

	for _, child in pairs(ply:GetChildren()) do
		
		if (child:GetClass() == "dac_flag") then

			--print("[DAC DEBUG]: Child flag identified. Returning.")
			--print("[DAC DEBUG]: " .. tostring(child) .. "'s availability is " .. tostring(child:GetAvailable()))
			child:ReturnFlag()

			timer.Simple(3, function() -- Three second delay
				child:SetAvailable(true) -- Make the flag available for capture again
				--print("[DAC DEBUG]: " .. tostring(child) .. "'s availability is " .. tostring(child:GetAvailable()))
			end)

			net.Start("SendDroppedAudio")
			net.WriteFloat(child:GetCarrier():Team()) -- Pass in the flag carrier's team for networking behavior
			net.Broadcast() -- This sends to all players, not just the flag carrier

            net.Start("SendFlagHUDNotify") -- Notify the carrying player's HUD
            net.WriteEntity(child.Entity)
            net.WriteBool(false)
            net.Send(child:GetCarrier())

            child.Entity:SetPos(child.Entity:GetPos() + Vector(0, 0, 100)) -- Set the vector above the ground first

            child.Entity:SetAngles(Angle(0,0,0)) -- Set angles to zero
            local tr = util.TraceLine( {
                start = child.Entity:GetPos(),
                endpos = child.Entity:GetPos() + child.Entity:GetAngles():Up() * -10000, -- Perform a trace downward on a long single Y vector
                filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end -- Only hit the world and physics props
            } )
            child.Entity:SetPos(tr.HitPos) -- Set the flag's position to that trace result, kinda buggy

            child.Entity:SetDropTime(CurTime()) -- Flag has been dropped, initiate countdown, where curTime() is the precise moment it was dropped
            --print("[DAC DEBUG]: A flag was dropped!")

            child.Entity:SetHeld(false)
            --print("[DAC DEBUG]: Set " .. child.Entity:GetCarrier():Nick() .. "'s flag carrier status to " .. tostring(child.Entity:GetCarrier():GetPlayerCarrierStatus()) .. ".")
            child.Entity:SetCarrier(NULL)
            
            child.Entity:PhysWake()
            child.Entity:SetParent(NULL)
            child.Entity:SetAngles(Angle(0,90,0))
            child.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

			break -- Stop iterations after flag is identified
		end
	end
	
end