CurrentTarget = nil
local haloColor

timer.Create("dac_haloTargetEnt", 0.1, 0, function()
	if IsValid(LocalPlayer()) then
		local tr = LocalPlayer():GetEyeTrace()
		CurrentTarget = tr.Entity
	end

	if IsValid(CurrentTarget) then
		if (CurrentTarget:IsPlayer()) then
                haloColor = team.GetColor((CurrentTarget:Team()))
		elseif (CurrentTarget:IsVehicle() or CurrentTarget:GetNWBool('IsLFSVehicle') == true) then
            haloColor = team.GetColor(CurrentTarget:GetNWInt('OwningTeam'))
		else
			CurrentTarget = nil
		end
	else
		CurrentTarget = nil
	end

end)

hook.Add( "PreDrawHalos", "DAC.OutlineHalos", function()
	if (CurrentTarget and haloColor) then
		halo.Add( {CurrentTarget} , haloColor, 3, 3, 1 )
	end
end )