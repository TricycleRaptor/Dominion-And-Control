concommand.Add( "DAC_changeteam", function( pl, cmd, args ) 
	hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber( args[ 1 ] ) ) 
end )