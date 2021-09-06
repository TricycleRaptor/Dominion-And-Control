local function player_death(ply)
	local pitch = 100 * GetConVarNumber("host_timescale")
	ply:EmitSound(Sound("death/death"..math.random(1,112)..".wav"),500,pitch)
end

hook.Add("PlayerDeath", "DAC.PlayerDeath", player_death)
hook.Add("PlayerDeathSound", "DAC.DeFlatline", function() return true end)
hook.Add("PlayerDeath", "DAC.NewDeathSound", function(vic,unused1,unused2) end)
hook.Add("OnDamagedByExplosion", "DAC.DisableSound", function() return true end)