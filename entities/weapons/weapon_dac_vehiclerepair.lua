AddCSLuaFile()

SWEP.Category			= "DAC"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/c_physcannon.mdl"
SWEP.WorldModel		= "models/weapons/w_physics.mdl"
SWEP.UseHands = true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 53
SWEP.Weight 			= 42
SWEP.AutoSwitchTo 		= true
SWEP.AutoSwitchFrom 		= true
SWEP.HoldType			= "physgun"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

if (CLIENT) then
	SWEP.PrintName			= "Vehicle Repair Tool"
	SWEP.Purpose			= "Repairs vehicles available from the buy menu."
	SWEP.Instructions		= "Primary to repair\nSecondary to restock ammo"
	SWEP.Author			= "Blu, TricycleRaptor"
	-- Credit to Blu for the original code, all I did was change the entity identification a bit and add an extra condition for LFS vehicles
	SWEP.Slot			= 5
	SWEP.SlotPos			= 9
	SWEP.IconLetter			= "k"
	
	SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/s_repair" ) 
	--SWEP.DrawWeaponInfoBox 	= false
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
	local class = ent:GetClass():lower()

	local IsLFSVehicle = false
	local IsSimfphysVehicle = false
	local IsWheel = false

	if (string.match(class,"lfs_") or string.match(class,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_wheel")) then
		IsWheel = true
	end
	
	if IsSimfphysVehicle then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
		
		if (Dist <= 150) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if (SERVER) then
				local MaxHealth = ent:GetMaxHealth()
				local Health = ent:GetCurHealth()
				
				if Health < MaxHealth then
					local NewHealth = math.min(Health + 15,MaxHealth)
					
					if NewHealth > (MaxHealth * 0.6) then
						ent:SetOnFire( false )
						ent:SetOnSmoke( false )
					end
				
					if NewHealth > (MaxHealth * 0.3) then
						ent:SetOnFire( false )
						if NewHealth <= (MaxHealth * 0.6) then
							ent:SetOnSmoke( true )
						end
					end
					
					ent:SetCurHealth( NewHealth )
					
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
					
					sound.Play(Sound( "hl1/fvox/beep.wav" ), self:GetPos(), 75)
					
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
		
		if (Dist <= 150) then
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
					
					sound.Play(Sound( "hl1/fvox/beep.wav" ), self:GetPos(), 75)
				end
			end
		end
	elseif IsLFSVehicle then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
		
		if (Dist <= 150) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			if (SERVER) then
				local MaxHealth = ent:GetMaxHP()
				local Health = ent:GetHP()
				
				if Health < MaxHealth then
					local NewHealth = math.min(Health + 15,MaxHealth)
					
					ent:SetHP( NewHealth )
					
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
					
					sound.Play(Sound( "hl1/fvox/beep.wav" ), self:GetPos(), 75)
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )	
	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	
	if !IsValid(ent) then return end
	local class = ent:GetClass():lower()

	local IsLFSVehicle = false
	local IsSimfphysVehicle = false
	local IsWheel = false

	if (string.match(class,"lfs_") or string.match(class,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_wheel")) then
		IsWheel = true
	end
	
	if (IsLFSVehicle ) then
		local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
	
		if (Dist <= 150) then
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
					PrimaryRestockValue = math.floor(PrimaryAmmoMax * 0.25)
				end

				if(PrimaryAmmo ~= nil and PrimaryAmmoMax ~= nil) then
					if (string.match(class,"lunasflightschool_combineheli")) then
						primaryFilled = true -- The Combine helicopter has infinite ammo, so it is always filled
					else
						if(PrimaryAmmo == PrimaryAmmoMax) then
							primaryFilled = true
						else
							primaryFilled = false
						end
					end
				end

				local SecondaryAmmoMax = ent.MaxSecondaryAmmo
				local SecondaryAmmo = nil
				local SecondaryRestockValue = nil

				if(SecondaryAmmoMax ~= nil) then
					SecondaryAmmo = ent:GetAmmoSecondary()
					SecondaryRestockValue = math.floor(SecondaryAmmoMax * 0.25)
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
					TertiaryRestockValue = math.floor(TertiaryAmmoMax * 0.25)
				end

				if(TertiaryAmmo ~= nil and TertiaryAmmoMax ~= nil) then
					if(TertiaryAmmo == TertiaryAmmoMax) then
						tertiaryFilled = true
					else
						tertiaryFilled = false
					end
				end

				--[[]
				print("Primary filled: " .. tostring(primaryFilled))
				print("Secondary filled: " .. tostring(secondaryFilled))
				print("Tertiary filled: " .. tostring(tertiaryFilled))
				print("\n")
				print("Primary max: " .. tostring(PrimaryAmmoMax))
				print("Secondary max: " .. tostring(SecondaryAmmoMax))
				print("Tertiary max: " .. tostring(TertiaryAmmoMax))
				print("\n")
				print("Primary restock value: " .. tostring(PrimaryRestockValue))
				print("Secondary restock value: " .. tostring(SecondaryRestockValue))
				print("Tertiary restock value: " .. tostring(TertiaryRestockValue))]]
				
				if ( primaryFilled == true and secondaryFilled == true and secondaryFilled == true ) then
					self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
					sound.Play(Sound( "hl1/fvox/blip.wav" ), self:GetPos(), 75)
					return
				end

				-- Primary ammo restock
				if (PrimaryAmmo ~= nil and PrimaryAmmoMax ~= nil and primaryFilled == false) then

					if(!string.match(class,"lunasflightschool_combineheli")) then -- Again, Combine heli weirdness

						--[[print("\n")
						print("Hit primary ammo condition")]]
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

					--[[print("\n")
					print("Hit secondary ammo condition")]]
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

					--[[print("\n")
					print("Hit tertiary ammo condition")]]
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
	local xpos = sizex * 0.02
	local ypos = sizey * 0.85
	
	local Trace = self.Owner:GetEyeTrace()
	local ent = Trace.Entity
	
	if (!IsValid(ent)) then
		draw.SimpleText( "0 / 0", "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 255, 235, 0, 255 ), 1, 1 )
		draw.RoundedBox( 0, xpos, ypos, sizex * 0.118, sizey * 0.02, Color( 0, 0, 0, 80 ) )
		return
	end

	local class = ent:GetClass():lower()
	
	local IsLFSVehicle = false
	local IsSimfphysVehicle = false
	local IsWheel = false

	if (string.match(class,"lfs_") or string.match(class,"lunasflightschool_")) then
		IsLFSVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_base")) then
		IsSimfphysVehicle = true
	elseif (string.match(class,"gmod_sent_vehicle_fphysics_wheel")) then
		IsWheel = true
	end
	
	if (IsSimfphysVehicle) then
		local MaxHealth = ent:GetMaxHealth()
		local Health = ent:GetCurHealth()
		
		draw.RoundedBox( 0, xpos, ypos, ((sizex * 0.118) / MaxHealth) * Health, sizey * 0.02, Color( (Health < MaxHealth * 0.6) and 255 or 0, (Health >= MaxHealth * 0.3) and 255 or 0, 0, 100 ) )
		draw.SimpleText( Health.." / "..MaxHealth, "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 255, 235, 0, 255 ), 1, 1 )
	elseif (IsLFSVehicle) then
		local MaxHealth = ent:GetMaxHP()
		local Health = ent:GetHP()
		
		draw.RoundedBox( 0, xpos, ypos, ((sizex * 0.118) / MaxHealth) * Health, sizey * 0.02, Color( (Health < MaxHealth * 0.6) and 255 or 0, (Health >= MaxHealth * 0.3) and 255 or 0, 0, 100 ) )
		draw.SimpleText( Health.." / "..MaxHealth, "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 255, 235, 0, 255 ), 1, 1 )
	else
		draw.SimpleText( "0 / 0", "simfphysfont", xpos + sizex * 0.059, ypos + sizey * 0.01, Color( 255, 235, 0, 255 ), 1, 1 )
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Holster()
	return true
end