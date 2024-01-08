function DAC_SpawnLVSVehicle(Player, Transport, Pos, Ang, ClassName)
    local ent = ents.Create( ClassName )
    ent:StoreCPPI( ply )
    ent:SetAngles( Ang )
    ent:SetPos( Pos )

    ent:Spawn()
    ent:Activate()

    ent:SetNWInt('OwningTeam', Player:Team())
    ent:SetNWBool('FlagTransport', Transport)
    ent:SetAITEAM(Player:Team())

    for k, v in pairs( ent:GetPassengerSeats() ) do
        print(v)
        v:SetNWInt('OwningTeam', Player:Team())
        v:SetNWBool('FlagTransport', Transport)
    end

    return ent
end