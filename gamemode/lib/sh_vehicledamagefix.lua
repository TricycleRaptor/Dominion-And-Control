-- Reduce explosion damage
hook.Add("EntityTakeDamage", "DAC.ExplosionModifiers", function(target, dmginfo)
	if (
		target:IsPlayer()
		and target:InVehicle()
		and IsValid(target)
		and dmginfo:IsExplosionDamage()
	) then
		dmginfo:ScaleDamage(0) -- Negate explosion damage in vehicles, this does not include vehicles inflicting damage onto the driver or passengers
	end
end)