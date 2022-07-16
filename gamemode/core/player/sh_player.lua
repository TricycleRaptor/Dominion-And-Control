hook.Add("PlayerInitialSpawn", "DAC.AssignDefaultWeapons", function(ply, transition) 
	ply:SetDefaultWeapons()
end)

function GM:PlayerSpawn(ply)

	--print("[DAC DEBUG]: " .. ply:Nick() .. "'s primary weapon is a " .. tostring(ply:GetPlayerWeapon()))
	--print("[DAC DEBUG]: " .. ply:Nick() .. "'s special item is a " .. tostring(ply:GetPlayerSpecial()))

	local gameStage = DAC:GetGameStage()
	local stageData = gameStage:GetData()
	local teamNum = ply:Team()

	self.BaseClass:PlayerSpawn(ply)
	DAC:SyncGameStage(ply)

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

function GM:PlayerFootstep(ply, pos, foot)

	if( ply:GetVelocity():Length2D() > 150 ) then
		return false
	else
		return true -- Silent footsteps when crouch walking
	end

	self.BaseClass:PlayerFootstep( ply, pos, foot, s, vol, rf );

end

function GM:PlayerSetModel(ply)
	self.BaseClass:PlayerSetModel(ply)
end

function GM:PlayerCanJoinTeam( ply, teamid )

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch and RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "[DAC]: Please wait %i seconds before trying to change teams.", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	-- Already on this team!
	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "[DAC]: You're already on that team." )
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
	if ( !team.Joinable( teamid ) ) then
		ply:ChatPrint( "[DAC]: You can't join that team." )
	return end

	-- This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
		-- Messages here should be outputted by this function
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

	PrintMessage( HUD_PRINTTALK, Format( "[DAC]: %s joined the %s!", ply:Nick(), team.GetName( newteam ) ) )

end

function GM:PlayerDisconnected(ply)

	local teamNum = ply:Team()

	if ply.IsCaptain then
		for _, v in pairs (team.GetPlayers(teamNum)) do
			if v != ply then
				v.IsCaptain = true
				if GAMEMODE.Teams[teamNum].baseSet == false then
					v:Give("weapon_dac_baseselector")
					v:ChatPrint( "[DAC]: You have been made team captain. Please select a location for your base." )
				end
			end
		end
	end
	
end