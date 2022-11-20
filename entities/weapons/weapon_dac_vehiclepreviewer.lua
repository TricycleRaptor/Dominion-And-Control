AddCSLuaFile()

SWEP.Category = "DAC"
SWEP.Base = "weapon_base"
SWEP.PrintName = "VEHICLE PREVIEWER"
SWEP.Author = "Tricycle Raptor"
SWEP.Instructions = "Preview positioning for a selected vehicle from the shop menu."
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight	= 5
SWEP.AutoSwitchTo = falseuser
SWEP.AutoSwitchFrom = false

SWEP.Slot = 5
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.HoldType = "normal"

-- TO DO: Localize variables and wireframe preview object
-- Maybe add SWEP: or SELF: to the end of the custom functions that use the variables

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
    self.vehicleName = nil
    self.vehicleType = nil
    self.vehicleCategory = nil
    self.vehicleCost = nil
    self.vehicleIsFlagTransport = nil
    self.vehicleModel = nil
    self.vehicleListName = nil
    self.vehicleListKey = nil
    self.vehicleClass = nil
    self.vehicleSpawnOffset = nil
    self.validVehicleSpace = false
    self.user = nil
    self.userTeam = nil
    self.spawnPos = nil
    self.spawnAng = nil
    self.wireColor = Color(255,255,255,255)
end

function SWEP:TraceCheck()

    local ent = self.vehicleModelPreview
	local mins = ent:OBBMins()
	local maxs = ent:OBBMaxs()
	local startpos = ent:GetPos()
	local dir = ent:GetUp()
	local len = 2

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = {ent}
	} )

	if ( tr.Hit ) then
		self.wireColor = Color( 255, 0, 0, 255 )
        self.validVehicleSpace = false
    else
        self.wireColor = Color( 0, 255, 0, 255)
        self.validVehicleSpace = true
    end

end

function SWEP:Think()

    self.user = self:GetOwner()
    self.userTeam = self:GetOwner():Team()
    
    if SERVER then

        local Trace = self.Owner:GetEyeTrace()
        local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
    
        if Dist <= 650 and self.vehicleModel ~= nil then -- Maximum base place range, to prevent weirdness
    
            if !IsValid(self.vehicleModelPreview) then

                self.vehicleModelPreview = ents.Create("prop_physics")
                self.vehicleModelPreview:SetModel(self.vehicleModel)
                self.vehicleModelPreview:Spawn()
                self.vehicleModelPreview:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                self.vehicleModelPreview:DrawShadow(false)
                self.vehicleModelPreview:SetMaterial("models/wireframe")

            else

                -- If we're previewing an LFS vehicle, we need to make the height higher for helicopters to have ample spawn room
                if self.vehicleType == "lfs" then
                    self.spawnPos = Trace.HitPos + Trace.HitNormal * self.vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, self.user:EyeAngles().Y - 180, _)) -- Set the prop angles to face the vehicle toward the player, but maintain the Z axis
                else
                -- Ground vehicles need less space and vertical height
                    self.spawnPos = Trace.HitPos + Trace.HitNormal * self.vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, self.user:EyeAngles().Y - 90, _)) -- Set the prop angles to face the vehicle away from the player, but maintain the Z axis
                end

                self.vehicleModelPreview:SetModel(self.vehicleModel)
                self.vehicleModelPreview:SetPos(self.spawnPos)
                
                self.vehicleModelPreview:SetColor(self.wireColor)
                self.spawnAng = self.vehicleModelPreview:GetAngles()

                self:TraceCheck(self.vehicleModelPreview)

            end
    
        else
    
            if IsValid(self.vehicleModelPreview) then
                self.vehicleModelPreview:Remove()
            end

            self.validVehicleSpace = false

        end

        net.Receive("dac_sendvehicledata", function(len, ply)

            if ply == self.user then

                print("Players match, changing...")

                self.vehicleName = net.ReadString() -- Name
                self.vehicleType = net.ReadString() -- VehicleType
                self.vehicleCategory = net.ReadString() -- Category
                self.vehicleCost = net.ReadString() -- Cost
                self.vehicleIsFlagTransport = net.ReadBool() -- IsFlagTransport
                self.vehicleModel = net.ReadString() -- Model
                self.vehicleListName = net.ReadString() -- Listname
                self.vehicleClass = net.ReadString() -- Class
                self.vehicleSpawnOffset = net.ReadString() -- Class

            else

                print("Players differ, not changing...")

                self.vehicleName = self.vehicleName
                self.vehicleType = self.vehicleType 
                self.vehicleCategory = self.vehicleCategory
                self.vehicleCost = self.vehicleCost
                self.vehicleIsFlagTransport = self.vehicleIsFlagTransport
                self.vehicleModel = self.vehicleModel 
                self.vehicleListName = self.vehicleListName
                self.vehicleClass = self.vehicleClass 
                self.vehicleSpawnOffset = self.vehicleSpawnOffset

            end

            print("\n[DAC DEBUG]: Server received:\n"
            .. "Net Player: " ..tostring(ply) .. "\n" 
            .. "Name: " .. tostring(self.vehicleName) .. "\n" 
            .. "Type: " .. tostring(self.vehicleType) .. "\n"
            .. "Category: " .. tostring(self.vehicleCategory) .. "\n"
            .. "Cost: " .. tostring(self.vehicleCost) .. "\n"
            .. "FlagTransport: " .. tostring(self.vehicleIsFlagTransport) .. "\n"
            .. "Model: " .. tostring(self.vehicleModel) .. "\n"
            .. "List: " .. tostring(self.vehicleListName) .. "\n"
            .. "Class: " .. tostring(self.vehicleClass) .. "\n"
            )
            ply:EmitSound("buttons/combine_button3.wav")
        
        end)
        
        net.Receive("dac_vehicle_confirmation", function(len, ply)
        
            local confirmationBool = net.ReadBool()
            if confirmationBool == true then
                --print("[DAC DEBUG]: Server received confirmation message.")
                ply:SetNWInt("storeCredits", ply:GetNWInt("storeCredits") - self.vehicleCost)
                ply:EmitSound("ambient/levels/labs/coinslot1.wav") -- We want this serverside so other players can hear if the player buys something
            
                -- Pass in all the necessary data here for spawning a vehicle, including deducting credits from the player's balance
                if self.vehicleType == "simfphys" then
                    --print("[DAC DEBUG]: Spawning simfphys vehicle...")
                    local initalizedSimfphysVehicleList = list.Get(self.vehicleListName)
                    local initializedSimfphysVehicle = initalizedSimfphysVehicleList[self.vehicleClass]
                    local initializedSimfphysVehicleEntity = simfphys.SpawnVehicle_DAC(ply, self.vehicleIsFlagTransport, self.spawnPos, self.spawnAng, self.vehicleModel, self.vehicleClass, self.vehicleClass, initializedSimfphysVehicle)
                    --print("[DAC DEBUG]: Spawned vehicle entity ID is " .. tostring(initializedSimfphysVehicleEntity))
                    --print("[DAC DEBUG]: Initializing vehicle seat data... ")
                    --print("[DAC DEBUG]: Transport boolean is " .. tostring(self.vehicleIsFlagTransport))
            
                    local simfphysSeatTransportBool = self.vehicleIsFlagTransport
            
                    timer.Simple(0.5, function() -- This has to be staggered so the simfphys vehicle can fully initialize
            
                        if initializedSimfphysVehicleEntity:GetChildren() ~= nil then -- Check if the children are valid
            
                            for vehicleKey, vehicleChildren in pairs(initializedSimfphysVehicleEntity:GetChildren()) do -- Get the entity children first
                                if vehicleChildren:GetClass():lower() == "prop_vehicle_prisoner_pod" then -- Specify that we only want the seats, rather than the simfphys attachments
                                    --print(vehicleChildren)
                                    vehicleChildren:SetNWBool('FlagTransport', simfphysSeatTransportBool) -- Set each seat to their respective flag transport status
                                    vehicleChildren:SetNWInt('OwningTeam', ply:Team())
                                end
                            end
                            --print("[DAC DEBUG]: Initialized.")
            
                        else
                            print("[DAC DEBUG]: ERROR, FOUND NO SEAT DATA ON SIMFPHYS VEHICLE: " .. tostring(initializedSimfphysVehicleEntity))
                        end
            
                    end)
            
                else 
                    --print("[DAC DEBUG]: Spawning LFS vehicle...")
                    local initializedLFSVehicle = ents.Create(self.vehicleClass)
                    initializedLFSVehicle:SetPos(self.spawnPos)
                    initializedLFSVehicle:SetAngles(self.spawnAng)
                    initializedLFSVehicle:SetNWInt('OwningTeam', ply:Team())
                    initializedLFSVehicle:SetNWBool('IsLFSVehicle', true)
                    initializedLFSVehicle:Spawn()
                    initializedLFSVehicle:Activate()
            
                    if initializedLFSVehicle:GetChildren() ~= nil then
                        for vehicleKey, vehicleChildren in pairs(initializedLFSVehicle:GetChildren()) do
                            if vehicleChildren:GetClass():lower() == "prop_vehicle_prisoner_pod" then
                                vehicleChildren:SetNWBool('FlagTransport', self.vehicleIsFlagTransport)
                                vehicleChildren:SetNWInt('OwningTeam', ply:Team())
                                --v:SetNWInt("lfsAITeam", ply:Team())
                            end
                        end
                    else
                        print("[DAC DEBUG]: ERROR, FOUND NO SEAT DATA ON LFS VEHICLE: " .. tostring(initializedLFSVehicle))
                    end
            
            
                end
            
                self.vehicleName = nil
                self.vehicleType = nil
                self.vehicleCategory = nil
                self.vehicleCost = nil
                self.vehicleIsFlagTransport = nil
                self.vehicleModel = nil
                self.vehicleListName = nil
                self.vehicleListKey = nil
                self.vehicleClass = nil
            
                ply:SelectWeapon("weapon_physcannon")
                ply:StripWeapon("weapon_dac_vehiclepreviewer")
            end
        
        end)

    end

end

function SWEP:PrimaryAttack()

    if SERVER then

        if self.validVehicleSpace == true then

            net.Start("dac_validspace_vehiclesync")
                net.WriteBool(true)
            net.Send(self.user)

        else

            self:GetOwner():EmitSound("buttons/button8.wav") -- Teammates will hear this, too
            self:GetOwner():ChatPrint("[DAC]: Invalid vehicle position selected.")

        end
        
    end

end

function SWEP:SecondaryAttack()

    if SERVER then
        net.Start("dac_cancelvehiclepurchase")
            net.WriteBool(true)
        net.Send(self.user)
    end

end

function SWEP:Holster()

    if IsValid(self.vehicleModelPreview) then
        self.vehicleModelPreview:Remove()
    end

    self.validVehicleSpace = false

    return false

end

net.Receive("dac_vehicle_cancellation", function(len, ply)

    local confirmationBool = net.ReadBool()
    if confirmationBool == true then
        CancelVehiclePurchase(ply)
    end

end)

function CancelVehiclePurchase(ply)
    ply:SetNWBool("IsSpawningVehicle", false)
    ply:SelectWeapon("weapon_physcannon")
    ply:StripWeapon("weapon_dac_vehiclepreviewer")
end