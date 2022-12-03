util.AddNetworkString("SendFlagHUDNotify")
util.AddNetworkString("SendPlayerDeathNotification")

function GM:PlayerDeathThink( ply )

	if ( ply.NextSpawnTime && ply.NextSpawnTime > CurTime() ) then return end

	if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
		ply:Spawn()
	end

end

function GM:PlayerDeath( ply, inflictor, attacker )

    local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

    if data.name == "MATCH" then
        ply.NextSpawnTime = CurTime() + GetConVar("dac_respawn_time"):GetFloat() -- Respawn delay based on what the server has set for the gamemode respawn time
    else
        ply.NextSpawnTime = CurTime() + 2 -- Standard 2 second delay otherwise
    end
	
	ply.DeathTime = CurTime()

	-- Send the player who died information on the time of death
	net.Start("SendPlayerDeathNotification")
	net.WriteFloat(ply.DeathTime)
	net.WriteFloat(ply.NextSpawnTime)
	net.Send(ply)
	ply:SetNWBool("IsSpawningVehicle", false)
	ply:SetNWBool("IsInBase", false)

	--print("Sent " .. ply.DeathTime .. " as death time.")
	--print("Sent " .. ply.NextSpawnTime .. " as respawn time.")

	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end

	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then

		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end

	end

	player_manager.RunClass( ply, "Death", inflictor, attacker )

	if ( attacker == ply ) then

		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()

		MsgAll( attacker:Nick() .. " suicided!\n" )

	return end

	if ( attacker:IsPlayer() ) then

		net.Start( "PlayerKilledByPlayer" )

			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )

		net.Broadcast()

		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )

	return end

	net.Start( "PlayerKilled" )

		net.WriteEntity( ply )
		net.WriteString( inflictor:GetClass() )
		net.WriteString( attacker:GetClass() )

	net.Broadcast()

	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )

end