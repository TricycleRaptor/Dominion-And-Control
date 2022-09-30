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