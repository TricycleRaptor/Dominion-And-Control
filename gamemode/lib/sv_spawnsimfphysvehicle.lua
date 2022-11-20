function simfphys.SpawnVehicle_DAC( Player, Transport, Pos, Ang, Model, Class, VName, VTable, bNoOwner )

    if not file.Exists( Model, "GAME" ) then 
        Player:PrintMessage( HUD_PRINTTALK, "ERROR: \""..Model.."\" does not exist! (Class: "..VName..")")
        return
    end
    
    local Ent = ents.Create( "gmod_sent_vehicle_fphysics_base" )
    if not Ent then return NULL end
    
    Ent:SetModel( Model )
    Ent:SetAngles( Ang )
    Ent:SetPos( Pos )

    Ent:SetNWInt('OwningTeam', Player:Team())
    Ent:SetNWBool('FlagTransport', Transport)

    for k, v in pairs( Ent:GetPassengerSeats() ) do
        print(v)
        v:SetNWBool('FlagTransport', Transport)
    end

    Ent:Spawn()
    Ent:Activate()

    Ent.VehicleName = VName
    Ent.VehicleTable = VTable
    Ent.EntityOwner = Player
    Ent:SetSpawn_List( VName )

    if VTable.Members then
        table.Merge( Ent, VTable.Members )
        
        if Ent.ModelInfo then
            if Ent.ModelInfo.Bodygroups then
                for i = 1, table.Count( Ent.ModelInfo.Bodygroups ) do
                    Ent:SetBodygroup(i, Ent.ModelInfo.Bodygroups[i] ) 
                end
            end
            
            if Ent.ModelInfo.Skin then
                Ent:SetSkin( Ent.ModelInfo.Skin )
            end
            
            if Ent.ModelInfo.Color then
                Ent:SetColor( Ent.ModelInfo.Color )
                
                local Color = Ent.ModelInfo.Color
                local dot = Color.r * Color.g * Color.b * Color.a
                Ent.OldColor = dot
                
                local data = {
                    Color = Color,
                    RenderMode = 0,
                    RenderFX = 0
                }
                duplicator.StoreEntityModifier( Ent, "colour", data )
            end
        end
        
        Ent:SetTireSmokeColor(Vector(180,180,180) / 255)
        
        Ent.Turbocharged = Ent.Turbocharged or false
        Ent.Supercharged = Ent.Supercharged or false
        
        Ent:SetEngineSoundPreset( Ent.EngineSoundPreset )
        Ent:SetMaxTorque( Ent.PeakTorque )

        Ent:SetDifferentialGear( Ent.DifferentialGear )
        
        Ent:SetSteerSpeed( Ent.TurnSpeed )
        Ent:SetFastSteerConeFadeSpeed( Ent.SteeringFadeFastSpeed )
        Ent:SetFastSteerAngle( Ent.FastSteeringAngle )
        
        Ent:SetEfficiency( Ent.Efficiency )
        Ent:SetMaxTraction( Ent.MaxGrip )
        Ent:SetTractionBias( Ent.GripOffset / Ent.MaxGrip )
        Ent:SetPowerDistribution( Ent.PowerBias )
        
        Ent:SetBackFire( Ent.Backfire or false )
        Ent:SetDoNotStall( Ent.DoNotStall or false )
        
        Ent:SetIdleRPM( Ent.IdleRPM )
        Ent:SetLimitRPM( Ent.LimitRPM )
        Ent:SetRevlimiter( Ent.Revlimiter or false )
        Ent:SetPowerBandEnd( Ent.PowerbandEnd )
        Ent:SetPowerBandStart( Ent.PowerbandStart )
        
        Ent:SetTurboCharged( Ent.Turbocharged )
        Ent:SetSuperCharged( Ent.Supercharged )
        Ent:SetBrakePower( Ent.BrakePower )
        
        Ent:SetLights_List( Ent.LightsTable or "no_lights" )
        
        Ent:SetBulletProofTires( Ent.BulletProofTires or false )
        
        Ent:SetBackfireSound( Ent.snd_backfire or "" )
        
        if not simfphys.WeaponSystemRegister then
            if simfphys.ManagedVehicles then
                print("[SIMFPHYS ARMED] IS OUT OF DATE")
            end
        else
            timer.Simple( 0.2, function()
                simfphys.WeaponSystemRegister( Ent )
            end )
            
            if (simfphys.armedAutoRegister and not simfphys.armedAutoRegister()) or simfphys.RegisterEquipment then
                print("[SIMFPHYS ARMED]: ONE OF YOUR ADDITIONAL SIMFPHYS-ARMED PACKS IS CAUSING CONFLICTS!!!")
                print("[SIMFPHYS ARMED]: PRECAUTIONARY RESTORING FUNCTION:")
                print("[SIMFPHYS ARMED]: simfphys.FireHitScan")
                print("[SIMFPHYS ARMED]: simfphys.FirePhysProjectile")
                print("[SIMFPHYS ARMED]: simfphys.RegisterCrosshair")
                print("[SIMFPHYS ARMED]: simfphys.RegisterCamera")
                print("[SIMFPHYS ARMED]: simfphys.armedAutoRegister")
                print("[SIMFPHYS ARMED]: REMOVING FUNCTION:")
                print("[SIMFPHYS ARMED]: simfphys.RegisterEquipment")
                print("[SIMFPHYS ARMED]: CLEARING OUTDATED ''RegisterEquipment'' HOOK")
                print("[SIMFPHYS ARMED]: !!!FUNCTIONALITY IS NOT GUARANTEED!!!")
            
                simfphys.FireHitScan = function( data ) simfphys.FireBullet( data ) end
                simfphys.FirePhysProjectile = function( data ) simfphys.FirePhysBullet( data ) end
                simfphys.RegisterCrosshair = function( ent, data ) simfphys.xhairRegister( ent, data ) end
                simfphys.RegisterCamera = 
                    function( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment )
                        simfphys.CameraRegister( ent, offset_firstperson, offset_thirdperson, bLocalAng, attachment )
                    end
                
                hook.Remove( "PlayerSpawnedVehicle","simfphys_armedvehicles" )
                simfphys.RegisterEquipment = nil
                simfphys.armedAutoRegister = function( vehicle ) simfphys.WeaponSystemRegister( vehicle ) return true end
            end
        end
        
        duplicator.StoreEntityModifier( Ent, "VehicleMemDupe", VTable.Members )
    end
    
    return Ent
end