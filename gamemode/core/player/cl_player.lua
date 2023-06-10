local function UpdateDeathInfo()

    local timeOfDeathTick = net.ReadFloat()
    local nextRespawnTick = net.ReadFloat()
    local timeNext = nextRespawnTick - timeOfDeathTick

    --print("Time of death (ticks) = " .. timeOfDeathTick)
    --print("Next respawn (ticks) = " .. nextRespawnTick)
    --print("Actual Respawn Time = " .. timeNext)

    hook.Add("HUDPaint", "DAC.PlayerRespawnTimer", function()

        -- Draw this only when the player is dead
        if !LocalPlayer():Alive() then

            -- timeNext is the actual delay in seconds. timeOfDeathtick is the server's internal account of when the player died, so we subtract the two values from the current tick
            local deathText = math.Round(timeNext - math.floor(CurTime() - timeOfDeathTick), 0) 
            
            deathText = "Respawn in " .. deathText -- Funny recursion
            if (CurTime() > nextRespawnTick) then
                deathText = "Respawn ready"
            end
        
            -- Draw function
            draw.SimpleTextOutlined(deathText, "DAC.GameStage", ScrW() / 2, ScrH() / 1.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
            
        end
    
    end)

end
net.Receive("SendPlayerDeathNotification", UpdateDeathInfo)

net.Receive("ChatMessage_Basic", function()
    local chatMessage = net.ReadString()
    chat.PlaySound()
    chat.AddText(Color(255, 255, 0), "[DAC]: ", Color(255,255,255), chatMessage)
end)

net.Receive("ChatMessage_TeamChangeNotice", function()
    local chatPlayer = net.ReadEntity()
    local chatPlayerOldTeam = net.ReadFloat()
    local chatPlayerNewTeam = net.ReadFloat()

    if chatPlayerNewTeam ~= 0 and chatPlayerNewTeam ~= 1001 and chatPlayerNewTeam ~= 1002 then
        chat.AddText(Color(255, 255, 0), "[DAC]: ", Color(255,221,169), chatPlayer:Nick(), Color(255,255,255), " joined ", team.GetColor(chatPlayerNewTeam), team.GetName(chatPlayerNewTeam), "!")
    end
end)

net.Receive("ChatMessage_PlayerKill", function()
    local chatVictim = net.ReadEntity(victim)
    local chatInflictor = net.ReadEntity(inflictor)
    local chatAttacker = net.ReadEntity(attacker)
    local chatReward = net.ReadFloat(reward)

    chat.PlaySound()
    chat.AddText(Color(255, 255, 0), "[DAC]: ", Color(255,255,255), "You earned ", Color(43,255,0), chatReward .. "cR", Color(255,255,255), " for killing ", team.GetColor(chatVictim:Team()), chatVictim:Nick(), "!")
end)

net.Receive("ChatMessage_PassiveIncome", function()
    chat.PlaySound()
    chat.AddText(Color(255, 255, 0), "[DAC]: ", Color(255,255,255), "Passive income of ", Color(43,255,0), GetConVar("dac_income_amount"):GetInt() .. "cR", Color(255,255,255), " awarded.")
end)

net.Receive("ChatMessage_FlagCapture", function()
    chat.PlaySound()
    chat.AddText(Color(255, 255, 0), "[DAC]:", Color(255,255,255), " You earned ", Color(43,255,0), GetConVar("dac_income_amount"):GetInt() * 2 .. "cR", Color(255,255,255), " for capturing a flag!")
end)