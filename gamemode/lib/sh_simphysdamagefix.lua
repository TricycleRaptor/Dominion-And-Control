-- Reduce RPG damage given to players in vehicles
hook.Add("EntityTakeDamage", "ExplosionModifiers", function(target, dmginfo)
	if (
		target:IsPlayer()
		and target:InVehicle()
		and IsValid(target)
		and dmginfo:IsExplosionDamage()
		and dmginfo:GetDamage() >= 76
	) then
		dmginfo:ScaleDamage(0.01) -- Scale damage down to 1% of its original
	end
end)
