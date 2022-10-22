-- Give store credits to the player on initial spawn
hook.Add("PlayerInitialSpawn", "DAC.AssignDefaultBalance", function( ply )
	ply:SetNWInt("storeCredits", GetConVar("dac_income_balance"):GetInt()) -- Get the starting balance value from cVars
end)

-- Give store credits on a fixed interval
hook.Add("Think", "DAC.PassiveRewardTimer", function( ply )
    local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

    if data.name == "MATCH" then
        if timer.Exists("DAC.timerSalary") then
            timer.UnPause("DAC.timerSalary")
        else
            timer.Create("DAC.timerSalary", GetConVar("dac_income_timer"):GetInt(), 0, function()
		
                for _,ply in ipairs(player.GetAll()) do
                    local curMoney = ply:GetNWInt("storeCredits")
                    local newMoney = curMoney + GetConVar("dac_income_amount"):GetInt()
                    ply:SetNWInt("storeCredits", newMoney)
                    ply:ChatPrint( "[DAC]: Passive income awarded.")
                end
                
            end)
        end
    else
        if timer.Exists("DAC.timerSalary") then
            timer.Pause("DAC.timerSalary")
        else
            return
        end
    end

end)

--Give store credits to the player who killed another player
hook.Add("PlayerDeath", "DAC.RewardPlayerKill", function( victim, inflictor, attacker )
    if victim == attacker then
        return -- Player committed suicide, no further action required
    else
        if attacker:IsPlayer() then
            if victim:Team() ~= attacker:Team() then
                attacker:SetNWInt("storeCredits", attacker:GetNWInt("storeCredits" + GetConVar("dac_kill_reward"):GetInt())) -- Get the kill reward value from cVars
                attacker:ChatPrint( "[DAC]: You earned " .. GetConVar("dac_income_amount"):GetInt() .. "cR for killing " .. victim:Nick() .."!")
            end
        end
    end
end )