local deathRagdolls = {}

hook.Add( "CreateClientsideRagdoll", "RemoveClientRagdoll", function( entity, ragdoll )
	-- if DAC.ConVars.deathSound:GetBool() and entity:IsPlayer() then
	if DAC.ConVars.deathSound:GetBool() then
        sound.PlayFile("sound/spazter/death"..math.random(1,112)..".wav", "3d", function(channel)
            if IsValid(channel) then
                ragdoll.soundChannel = channel
                channel:Set3DFadeDistance(0, 4096)
                channel:SetVolume(2)
                channel:SetPlaybackRate(game.GetTimeScale())
                table.insert(deathRagdolls, ragdoll)
            end
        end)
    end
end )

hook.Add("Think", "DAC.DeathRagdollSound", function()
    for i, ragdoll in ipairs(deathRagdolls) do
        if IsValid(ragdoll) then
            if ragdoll.soundChannel then
                ragdoll.soundChannel:SetPos(ragdoll:GetPos())
            end
        else
            table.remove(deathRagdolls, i)
        end
    end
end)