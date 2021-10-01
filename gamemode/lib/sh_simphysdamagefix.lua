-- Reduce RPG damage given to players in vehicles
hook.Add("EntityTakeDamage", "DAC.ExplosionModifiers", function(target, dmginfo)
	if (
		target:IsPlayer()
		and target:InVehicle()
		and IsValid(target)
		and dmginfo:IsExplosionDamage()
		and dmginfo:GetDamage() >= 100
	) then
		dmginfo:ScaleDamage(0.1) -- Significantly reduce damage in vehicles
	elseif (
		target:IsPlayer()
		and not target:InVehicle()
		and IsValid(target)
		and dmginfo:IsExplosionDamage()
		and dmginfo:GetDamage() >= 80
	) then
		dmginfo:ScaleDamage(0.25) -- Scale damage down to 25% of its original
	end
end)