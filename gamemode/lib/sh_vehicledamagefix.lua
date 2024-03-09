-- Reduce explosion damage
hook.Add("EntityTakeDamage", "DAC.ExplosionModifiers", function(target, dmginfo)
	if (target:IsPlayer() and IsValid(target)) then
		if target:InVehicle() then
			dmginfo:ScaleDamage(0.01) -- All damage received by players in vehicles reduced to 1% of original damage value
		end
	end
end)