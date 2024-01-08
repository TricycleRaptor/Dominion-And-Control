-- Reduce explosion damage
--[[hook.Add("EntityTakeDamage", "DAC.ExplosionModifiers", function(target, dmginfo)
	if (
		target:IsPlayer()
		and target:InVehicle()
		and IsValid(target)
		and dmginfo:IsExplosionDamage()
	) then
		dmginfo:ScaleDamage(0) -- Negate explosion damage in vehicles, this does not include vehicles inflicting damage onto the driver or passengers
		--print("[DAC DEBUG]: Vehicle explosion modifier triggered. Damage reduced.")
	else if (
			target:IsPlayer()
			and not target:InVehicle() -- On foot
			and IsValid(target)
			and dmginfo:IsExplosionDamage()
		) then
			dmginfo:ScaleDamage(0.25) -- Negate 75% of damage from explosions on foot
			--print("[DAC DEBUG]: Standard explosion modifier triggered. Damage reduced.")
		end
	end
end)]]