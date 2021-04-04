local deathSoundRagdolls = {}

hook.Add( "CreateClientsideRagdoll", "RemoveClientRagdoll", function( entity, ragdoll )
	-- if DAC.ConVars.deathSound:GetBool() and entity:IsPlayer() then

    print(table.Count(deathSoundRagdolls))

	if DAC.ConVars.deathSound:GetBool() and table.Count(deathSoundRagdolls) < 16 then
        sound.PlayFile("sound/spazter/death"..math.random(1,112)..".wav", "3d", function(channel)
            if IsValid(channel) then
                ragdoll.deathSoundChannel = channel

                local distance = EyePos():Distance(ragdoll:GetPos()) > 1024 and 8000 or 4096

                channel:Set3DFadeDistance(0, distance)
                channel:SetVolume(6)
                channel:SetPlaybackRate(game.GetTimeScale())
                ragdoll.deathSoundEnd = SysTime() + channel:GetLength()
                table.insert(deathSoundRagdolls, ragdoll)
            end
        end)
    end
end )

hook.Add("Think", "DAC.deathSoundRagdollsound", function()
    for i, ragdoll in ipairs(deathSoundRagdolls) do
        if IsValid(ragdoll) and ragdoll.deathSoundChannel and SysTime() <= ragdoll.deathSoundEnd then
            ragdoll.deathSoundChannel:SetPos(ragdoll:GetPos())
        else
            if IsValid(ragdoll) then
                ragdoll.deathSoundChannel = nil
            end
            table.remove(deathSoundRagdolls, i)
        end
    end
end)