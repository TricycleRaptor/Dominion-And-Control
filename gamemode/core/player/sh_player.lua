function GM:PlayerSpawn(ply)
	DACSyncGameStage(ply)
	self.BaseClass:PlayerSpawn(ply)
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

	-- Here's an immediate respawn thing by default. If you want to
	-- re-create something more like CS or some shit you could probably
	-- change to a spectator or something while dead.
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