AddCSLuaFile()

SWEP.Category = "Dominion and Control"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 53
SWEP.Weight = 42
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "physgun"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

if (CLIENT) then
	SWEP.PrintName = "Vehicle Maintenance Tool"
	SWEP.Purpose = "Repair and restock vehicles"
	SWEP.Instructions = "Primary repair, secondary restock"
	SWEP.Author	= "Blu, Tricycle Raptor"
	SWEP.Slot = 4
	SWEP.SlotPos = 9
	SWEP.IconLetter = "k"
	
	SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/s_repair" ) 

end

function SWEP:Initialize()
	self.Weapon:SetHoldType( self.HoldType )
end

function SWEP:OwnerChanged()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )	
	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	
	if !IsValid(ent) then return end

	local entityClass = ent:GetClass():lower()
	local IsLFSVehicle = false
	local IsSimfphysVehicle = false

	if(string.match(entityClass,"lfs_") or string.match(entityClass,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif(string.match(entityClass,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	end
	
	if (IsSimfphysVehicle or IsLFSVehicle) then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
		
		if (Dist <= 100) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if (SERVER) then
				local MaxHealth = nil 
				local Health = nil
				local HealthIndexAmount = nil

				if(IsSimfphysVehicle) then
					MaxHealth = ent:GetMaxHealth()
					Health = ent:GetCurHealth()
					HealthIndexAmount = math.floor(MaxHealth / 120)
				elseif(IsLFSVehicle) then
					MaxHealth = ent:GetMaxHP()
					Health = ent:GetHP()
					HealthIndexAmount = math.floor(MaxHealth / 120)
				end
				
				if Health < MaxHealth then
					local NewHealth = math.min(Health + HealthIndexAmount,MaxHealth)
					
					if NewHealth > (MaxHealth * 0.6) and IsSimfphysVehicle then
						ent:SetOnFire( false )
						ent:SetOnSmoke( false )
					end
				
					if NewHealth > (MaxHealth * 0.3) and IsSimfphysVehicle then
						ent:SetOnFire( false )
						if NewHealth <= (MaxHealth * 0.6) then
							ent:SetOnSmoke( true )
						end
					end
					
					if(IsSimfphysVehicle) then
						ent:SetCurHealth( NewHealth )
					else
						ent:SetHP( NewHealth )
					end
					
					
					local effect = ents.Create("env_spark")
						effect:SetKeyValue("targetname", "target")
						effect:SetPos( Trace.HitPos + Trace.HitNormal * 2 )
						effect:SetAngles( Trace.HitNormal:Angle() )
						effect:Spawn()
						effect:SetKeyValue("spawnflags","128")
						effect:SetKeyValue("Magnitude",1)
						effect:SetKeyValue("TrailLength",0.2)
						effect:Fire( "SparkOnce" )
						effect:Fire("kill","",0.08)
				else 
					self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
					
					--sound.Play(Sound( "buttons/button10.wav" ), self:GetPos(), 75)
					
					net.Start( "simfphys_lightsfixall" )
						net.WriteEntity( ent )
					net.Broadcast()
					
					if istable(ent.Wheels) then
						for i = 1, table.Count( ent.Wheels ) do
							local Wheel = ent.Wheels[ i ]
							if IsValid(Wheel) then
								Wheel:SetDamaged( false )
							end
						end
					end
				end
			end
		end
	elseif IsWheel then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
		
		if (Dist <= 100) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if (SERVER) then
				if ent:GetDamaged() then
					
					ent:SetDamaged( false )
					
					local effect = ents.Create("env_spark")
						effect:SetKeyValue("targetname", "target")
						effect:SetPos( Trace.HitPos + Trace.HitNormal * 2 )
						effect:SetAngles( Trace.HitNormal:Angle() )
						effect:Spawn()
						effect:SetKeyValue("spawnflags","128")
						effect:SetKeyValue("Magnitude",1)
						effect:SetKeyValue("TrailLength",0.2)
						effect:Fire( "SparkOnce" )
						effect:Fire("kill","",0.08)
				else 
					self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
					--sound.Play(Sound( "buttons/button10.wav" ), self:GetPos(), 75)
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.5 )	
	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	
	if !IsValid(ent) then return end

	local entityClass = ent:GetClass():lower()
	local IsLFSVehicle = false
	local IsSimfphysVehicle = false

	if(string.match(entityClass,"lfs_") or string.match(entityClass,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif(string.match(entityClass,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	end
	
	if (IsLFSVehicle and not IsSimfphysVehicle) then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
		
		if (Dist <= 100) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if (SERVER) then
				
				local primaryFilled = false
				local secondaryFilled = false
				local tertiaryFilled = false

				local PrimaryAmmoMax = ent.MaxPrimaryAmmo
				local PrimaryAmmo = nil
				local PrimaryRestockValue = nil

				if(PrimaryAmmoMax ~= nil) then
					PrimaryAmmo = ent:GetAmmoPrimary()
					PrimaryRestockValue = math.floor(PrimaryAmmoMax / 6)
				end

				if(PrimaryAmmo ~= nil and PrimaryAmmoMax ~= nil) then
					if(PrimaryAmmo == PrimaryAmmoMax) then
						primaryFilled = true
					else
						primaryFilled = false
					end
				end

				local SecondaryAmmoMax = ent.MaxSecondaryAmmo
				local SecondaryAmmo = nil
				local SecondaryRestockValue = nil

				if(SecondaryAmmoMax ~= nil) then
					SecondaryAmmo = ent:GetAmmoSecondary()
					SecondaryRestockValue = math.floor(SecondaryAmmoMax / 8)
				end

				if(SecondaryAmmo ~= nil and SecondaryAmmoMax ~= nil) then
					if(SecondaryAmmo == SecondaryAmmoMax) then
						secondaryFilled = true
					else
						secondaryFilled = false
					end
				end

				local TertiaryAmmoMax = ent.MaxTertiaryAmmo
				local TertiaryAmmo = nil
				local TertiaryRestockValue = nil

				if(TertiaryAmmoMax ~= nil) then
					TertiaryAmmo = ent:GetAmmoTertiary()
					TertiaryRestockValue = math.floor(TertiaryAmmoMax / 10)
				end

				if(TertiaryAmmo ~= nil and TertiaryAmmoMax ~= nil) then
					if(TertiaryAmmo == TertiaryAmmoMax) then
						tertiaryFilled = true
					else
						tertiaryFilled = false
					end
				end

				--if(primaryFilled == true and secondaryFilled == true and tertiaryFilled == true) then
					--self.Weapon:SetNextSecondaryFire( CurTime() + 1.5 )
					--sound.Play(Sound( "buttons/button10.wav" ), self:GetPos(), 75)
				--end

				-- Primary ammo restock
				if (PrimaryAmmo ~= nil and PrimaryAmmoMax ~= nil and primaryFilled == false) then

					if(!string.match(entityClass,"lunasflightschool_combineheli")) then -- Again, Combine heli weirdness

						if(PrimaryAmmo < PrimaryAmmoMax) then
							local NewPrimaryAmmo = math.min(PrimaryAmmo + PrimaryRestockValue,PrimaryAmmoMax)
							ent:SetAmmoPrimary( NewPrimaryAmmo )
							sound.Play(Sound( "items/ammocrate_open.wav" ), self:GetPos(), 75)
							sound.Play(Sound( "items/ammo_pickup.wav" ), self:GetPos(), 75)

							local effect = ents.Create("env_dustpuff")
								effect:SetKeyValue("targetname", "target")
								effect:SetPos( Trace.HitPos)
								effect:SetAngles( Trace.HitNormal:Angle() )
								effect:Spawn()
								effect:SetKeyValue("Scale",20)
								effect:Fire( "SpawnDust" )
								effect:Fire("kill","",1)

						end

					end

				end

				-- Secondary ammo restock
				if (SecondaryAmmo ~= nil and SecondaryAmmoMax ~= nil and primaryFilled == true and secondaryFilled == false) then

					if(SecondaryAmmo < SecondaryAmmoMax) then

						local NewSecondaryAmmo = math.min(SecondaryAmmo + SecondaryRestockValue,SecondaryAmmoMax)
						ent:SetAmmoSecondary( NewSecondaryAmmo )
						sound.Play(Sound( "items/ammocrate_open.wav" ), self:GetPos(), 75)
						sound.Play(Sound( "items/ammo_pickup.wav" ), self:GetPos(), 75)

						local effect = ents.Create("env_dustpuff")
							effect:SetKeyValue("targetname", "target")
							effect:SetPos( Trace.HitPos)
							effect:SetAngles( Trace.HitNormal:Angle() )
							effect:Spawn()
							effect:SetKeyValue("Scale",20)
							effect:Fire( "SpawnDust" )
							effect:Fire("kill","",1)

					end

				end
				
				if(TertiaryAmmo ~= nil and TertiaryAmmoMax ~= nil and primaryFilled == true and secondaryFilled == true and tertiaryFilled == false) then

					if(TertiaryAmmo < TertiaryAmmoMax) then

						local NewTertiaryAmmo = math.min(TertiaryAmmo + TertiaryRestockValue,TertiaryAmmoMax)
						ent:SetAmmoTertiary( NewTertiaryAmmo )
						sound.Play(Sound( "items/ammocrate_open.wav" ), self:GetPos(), 75)
						sound.Play(Sound( "items/ammo_pickup.wav" ), self:GetPos(), 75)

						local effect = ents.Create("env_dustpuff")
							effect:SetKeyValue("targetname", "target")
							effect:SetPos( Trace.HitPos)
							effect:SetAngles( Trace.HitNormal:Angle() )
							effect:Spawn()
							effect:SetKeyValue("Scale",20)
							effect:Fire( "SpawnDust" )
							effect:Fire("kill","",1)

					end

				end
			end
		end
	end
end

function SWEP:DrawHUD()
	if (LocalPlayer():InVehicle()) then return end
	
	local screenw = ScrW()
	local screenh = ScrH()
	local Widescreen = (screenw / screenh) > (4 / 3)
	local sizex = screenw * (Widescreen and 1 or 1.32)
	local sizey = screenh
	local xpos = sizex * 0.04
	local ypos = sizey * 0.77

	local xPosPrimary = sizex * 0.04
	local yPosPrimary = sizey * 0.80

	local xPosSecondary = sizex * 0.04
	local yPosSecondary = sizey * 0.83

	local xPosTertiary = sizex * 0.04
	local yPosTertiary = sizey * 0.86
	
	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	
	if (!IsValid(ent)) then return end
	
	local entityClass = ent:GetClass():lower()
	local IsLFSVehicle = false
	local IsSimfphysVehicle = false

	if(string.match(entityClass,"lfs_") or string.match(entityClass,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif(string.match(entityClass,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	end
	
	if (IsSimfphysVehicle or IsLFSVehicle) then

		local MaxHealth = nil 
		local Health = nil

		if(IsSimfphysVehicle) then
			MaxHealth = ent:GetMaxHealth()
			Health = ent:GetCurHealth()
		elseif(IsLFSVehicle) then
			MaxHealth = ent:GetMaxHP()
			Health = ent:GetHP()
		end

		--Title
		draw.RoundedBox( 8, xpos * 0.20, ypos * 0.948, sizex * 0.16, sizey * 0.03, Color( 0, 0, 0, 240 ) )
		draw.SimpleText("VEHICLE REPAIR TOOL", "simfphysfont", xpos * 0.65 + sizex * 0.059, ypos + sizey * -0.026, Color( 255, 255, 255, 255 ), 1, 1 )
		--Border box
		draw.RoundedBox( 8, xpos * 0.20, ypos * 0.987, sizex * 0.16, sizey * 0.13, Color( 0, 0, 0, 240 ) )
		
		-- Health
		draw.RoundedBox( 8, xpos, ypos, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
		draw.RoundedBox( 8, xpos, ypos, ((sizex * 0.118) / MaxHealth) * Health, sizey * 0.02, Color( (Health < MaxHealth * 0.6) and 255 or 0, (Health >= MaxHealth * 0.3) and 255 or 0, 0, 255 ) )
		draw.SimpleText( math.Round(Health).." / "..MaxHealth, "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 0, 0, 0, 255 ), 1, 1 )
		draw.SimpleText( "HP:", "simfphysfont", xpos * -0.9 + sizex * 0.059, ypos + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

		if(IsLFSVehicle and not IsSimfphysVehicle) then
			
			local PrimaryAmmoMax = ent.MaxPrimaryAmmo
			local PrimaryAmmo = nil
			if(PrimaryAmmoMax ~= nil) then
				PrimaryAmmo = ent:GetAmmoPrimary()
			end

			local SecondaryAmmoMax = ent.MaxSecondaryAmmo
			local SecondaryAmmo = nil
			if(SecondaryAmmoMax ~= nil) then
				SecondaryAmmo = ent:GetAmmoSecondary()
			end

			local TertiaryAmmoMax = ent.MaxTertiaryAmmo
			local TertiaryAmmo = nil
			if(TertiaryAmmoMax ~= nil) then
				TertiaryAmmo = ent:GetAmmoTertiary()
			end

			-- Primary ammo
			if(PrimaryAmmoMax ~= nil and PrimaryAmmoMax > 0 and PrimaryAmmo ~= nil) then
				if(!string.match(entityClass,"lunasflightschool_combineheli")) then -- Combine heli primary ammo weirdness, just check ahead of time

					draw.RoundedBox( 8, xPosPrimary, yPosPrimary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
					draw.RoundedBox( 8, xPosPrimary , yPosPrimary, ((sizex * 0.118) / PrimaryAmmoMax) * PrimaryAmmo, sizey * 0.02, Color( (PrimaryAmmo < PrimaryAmmoMax * 0.6) and 255 or 0, (PrimaryAmmo >= PrimaryAmmoMax * 0.3) and 255 or 0, 0, 255 ) )
					draw.SimpleText( PrimaryAmmo.." / "..PrimaryAmmoMax, "simfphysfont", xPosPrimary + sizex * 0.059, yPosPrimary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
					draw.SimpleText( "AM1:", "simfphysfont", xPosPrimary * -0.9 + sizex * 0.06, yPosPrimary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

				else

					draw.RoundedBox( 8, xPosPrimary, yPosPrimary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
					draw.SimpleText( "INFINITE", "simfphysfont", xPosPrimary + sizex * 0.059, yPosPrimary + sizey * 0.008, Color( 0, 255, 255, 255 ), 1, 1 )
					draw.SimpleText( "AM1:", "simfphysfont", xPosPrimary * -0.9 + sizex * 0.06, yPosPrimary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

				end
			else

				draw.RoundedBox( 8, xPosPrimary, yPosPrimary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
				draw.SimpleText( "UNAVAILABLE", "simfphysfont", xPosPrimary + sizex * 0.059, yPosPrimary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
				draw.SimpleText( "AM1:", "simfphysfont", xPosPrimary * -0.9 + sizex * 0.06, yPosPrimary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			end
			-- Secondary Ammo
			if(SecondaryAmmoMax ~= nil and SecondaryAmmoMax > 0 and SecondaryAmmo ~= nil) then

				draw.RoundedBox( 8, xPosSecondary, yPosSecondary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
				draw.RoundedBox( 8, xPosSecondary , yPosSecondary, ((sizex * 0.118) / SecondaryAmmoMax) * SecondaryAmmo, sizey * 0.02, Color( (SecondaryAmmo < SecondaryAmmoMax * 0.6) and 255 or 0, (SecondaryAmmo >= SecondaryAmmoMax * 0.3) and 255 or 0, 0, 255 ) )
				draw.SimpleText( SecondaryAmmo.." / "..SecondaryAmmoMax, "simfphysfont", xPosSecondary + sizex * 0.059, yPosSecondary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
				draw.SimpleText( "AM2:", "simfphysfont", xPosSecondary * -0.9 + sizex * 0.06, yPosSecondary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			else

				draw.RoundedBox( 8, xPosSecondary, yPosSecondary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
				draw.SimpleText( "UNAVAILABLE", "simfphysfont", xPosSecondary + sizex * 0.059, yPosSecondary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
				draw.SimpleText( "AM2:", "simfphysfont", xPosSecondary * -0.9 + sizex * 0.06, yPosSecondary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			end
			-- Tertiary Ammo
			if(TertiaryAmmoMax ~= nil and TertiaryAmmoMax > 0 and TertiaryAmmo ~= nil) then

				draw.RoundedBox( 8, xPosTertiary, yPosTertiary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
				draw.RoundedBox( 8, xPosTertiary, yPosTertiary, ((sizex * 0.118) / TertiaryAmmoMax) * TertiaryAmmo, sizey * 0.02, Color( (TertiaryAmmo < TertiaryAmmoMax * 0.6) and 255 or 0, (TertiaryAmmo >= TertiaryAmmoMax * 0.3) and 255 or 0, 0, 255 ) )
				draw.SimpleText( TertiaryAmmo.." / "..TertiaryAmmoMax, "simfphysfont", xPosTertiary + sizex * 0.059, yPosTertiary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
				draw.SimpleText( "AM3:", "simfphysfont", xPosTertiary * -0.9 + sizex * 0.06, yPosTertiary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			else

				draw.RoundedBox( 8, xPosTertiary, yPosTertiary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
				draw.SimpleText( "UNAVAILABLE", "simfphysfont", xPosTertiary + sizex * 0.059, yPosTertiary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
				draw.SimpleText( "AM3:", "simfphysfont", xPosTertiary * -0.9 + sizex * 0.06, yPosTertiary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			end

		elseif(IsSimfphysVehicle) then

			--Primary ammo
			draw.RoundedBox( 8, xPosPrimary, yPosPrimary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
			draw.SimpleText( "INFINITE", "simfphysfont", xPosPrimary + sizex * 0.059, yPosPrimary + sizey * 0.008, Color( 0, 255, 255, 255 ), 1, 1 )
			draw.SimpleText( "AM1:", "simfphysfont", xPosPrimary * -0.9 + sizex * 0.06, yPosPrimary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )
			

			--Secondary ammo
			draw.RoundedBox( 8, xPosSecondary, yPosSecondary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
			draw.SimpleText( "UNAVAILABLE", "simfphysfont", xPosSecondary + sizex * 0.059, yPosSecondary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
			draw.SimpleText( "AM2:", "simfphysfont", xPosSecondary * -0.9 + sizex * 0.06, yPosSecondary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

			--Tertiary ammo
			draw.RoundedBox( 8, xPosTertiary, yPosTertiary, sizex * 0.118, sizey * 0.02, Color( 100, 100, 100, 200 ) ) -- Background box
			draw.SimpleText( "UNAVAILABLE", "simfphysfont", xPosTertiary + sizex * 0.059, yPosTertiary + sizey * 0.008, Color( 0, 0, 0, 255 ), 1, 1 )
			draw.SimpleText( "AM3:", "simfphysfont", xPosTertiary * -0.9 + sizex * 0.06, yPosTertiary + sizey * 0.01, Color( 255, 255, 255, 255 ), 1, 1 )

		end

	end

	
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Holster()
	return true
end