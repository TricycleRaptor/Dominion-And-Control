hook.Add("OnPlayerHitGround", "DAC.Land", function(ply, inWater, onFloater, speed)
	local pingTime = ply:Ping() * 0.001
	local lockTime = math.max(0.1 - pingTime, 0.01) -- account for player ping weirdness
	ply._landingTime = CurTime() + lockTime
end)

hook.Add("StartCommand", "DAC.LandMovement", function(ply, cmd)
	if ply._landingTime then
		if CurTime() <= ply._landingTime then
			cmd:ClearMovement()
			cmd:RemoveKey(IN_JUMP)
		else
			ply._landingTime = nil
		end
	end
end)