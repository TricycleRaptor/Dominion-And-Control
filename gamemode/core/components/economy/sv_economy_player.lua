-- Give store credits to the player on initial spawn
hook.Add("PlayerInitialSpawn", "DAC.AssignDefaultBalance", function( ply )
	ply:SetNWInt("storeCredits", GetConVar("dac_income_balance"):GetInt()) -- Get the starting balance value from cVars
end)

-- Give store credits on a fixed interval
hook.Add("Think", "DAC.PassiveRewardTimer", function( ply )
    local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

    if data.name == "MATCH" or data.name == "OVERTIME" then

        if timer.Exists("DAC.timerSalary") then
            timer.UnPause("DAC.timerSalary")
        else
            timer.Create("DAC.timerSalary", GetConVar("dac_income_timer"):GetInt() * 60, 0, function()
		
                for _,ply in ipairs(player.GetAll()) do
                    local curMoney = ply:GetNWInt("storeCredits")
                    local newMoney = curMoney + GetConVar("dac_income_amount"):GetInt()
                    ply:SetNWInt("storeCredits", newMoney)
                    --ply:ChatPrint( "[DAC]: Passive income awarded.")
                    ply:ChatMessage_PassiveIncome()
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
                local curMoney = attacker:GetNWInt("storeCredits")
                local newMoney = curMoney + GetConVar("dac_kill_reward"):GetInt()
                attacker:SetNWInt("storeCredits", newMoney)
                --attacker:ChatPrint( "[DAC]: You earned " .. GetConVar("dac_kill_reward"):GetInt() .. "cR for killing " .. victim:Nick() .."!")
                attacker:ChatMessage_PlayerKill(victim, inflictor, attacker, GetConVar("dac_kill_reward"):GetInt())
            end
        end
    end
end )