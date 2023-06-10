AddCSLuaFile()

SWEP.Category = "DAC"
SWEP.Base = "weapon_base"
SWEP.PrintName = "VEHICLE PREVIEWER"
SWEP.Author = "Tricycle Raptor"
SWEP.Purpose = "Preview positioning for a selected vehicle from the shop menu."
SWEP.Instructions = "Primary to confirm position\nSecondary to cancel purchase"
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
    
        if Dist <= 650 and self.user.vehicleModel ~= nil then -- Maximum base place range, to prevent weirdness
    
            if !IsValid(self.vehicleModelPreview) then

                self.vehicleModelPreview = ents.Create("prop_physics")
                self.vehicleModelPreview:SetModel(self.user.vehicleModel)
                self.vehicleModelPreview:Spawn()
                self.vehicleModelPreview:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                self.vehicleModelPreview:DrawShadow(false)
                self.vehicleModelPreview:SetMaterial("models/wireframe")

            else

                -- If we're previewing an LFS vehicle, we need to make the height higher for helicopters to have ample spawn room
                if self.user.vehicleType == "lfs" then
                    self.user.vehicleSpawnPos = Trace.HitPos + Trace.HitNormal * self.user.vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, self.user:EyeAngles().Y - 180, _)) -- Set the prop angles to face the vehicle toward the player, but maintain the Z axis
                else
                -- Ground vehicles need less space and vertical height
                    self.user.vehicleSpawnPos = Trace.HitPos + Trace.HitNormal * self.user.vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, self.user:EyeAngles().Y - 90, _)) -- Set the prop angles to face the vehicle away from the player, but maintain the Z axis
                end

                self.vehicleModelPreview:SetModel(self.user.vehicleModel)
                self.vehicleModelPreview:SetPos(self.user.vehicleSpawnPos)
                
                self.vehicleModelPreview:SetColor(self.wireColor)
                self.user.vehicleSpawnAng = self.vehicleModelPreview:GetAngles()

                self:TraceCheck(self.vehicleModelPreview)

            end
    
        else
    
            if IsValid(self.vehicleModelPreview) then
                self.vehicleModelPreview:Remove()
            end

            self.validVehicleSpace = false

        end

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
            --self:GetOwner():ChatPrint("[DAC]: Invalid vehicle position selected.")
            self:GetOwner():ChatMessage_Basic("Invalid vehicle position selected!")

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

net.Receive("dac_sendvehicledata", function(len, ply)

    ply.vehicleName = net.ReadString() -- Name
    ply.vehicleType = net.ReadString() -- VehicleType
    ply.vehicleCategory = net.ReadString() -- Category
    ply.vehicleCost = net.ReadString() -- Cost
    ply.vehicleIsFlagTransport = net.ReadBool() -- IsFlagTransport
    ply.vehicleModel = net.ReadString() -- Model
    ply.vehicleListName = net.ReadString() -- Listname
    ply.vehicleClass = net.ReadString() -- Class
    ply.vehicleSpawnOffset = net.ReadString() -- Class

    --[[print("\n[DAC DEBUG]: Server received:\n"
    .. "Sending Player: " ..tostring(ply:Nick()) .. "\n" 
    .. "Name: " .. tostring(ply.vehicleName) .. "\n" 
    .. "Type: " .. tostring(ply.vehicleType) .. "\n"
    .. "Category: " .. tostring(ply.vehicleCategory) .. "\n"
    .. "Cost: " .. tostring(ply.vehicleCost) .. "\n"
    .. "FlagTransport: " .. tostring(ply.vehicleIsFlagTransport) .. "\n"
    .. "Model: " .. tostring(ply.vehicleModel) .. "\n"
    .. "List: " .. tostring(ply.vehicleListName) .. "\n"
    .. "Class: " .. tostring(ply.vehicleClass) .. "\n"
    )]]

    ply:EmitSound("buttons/combine_button3.wav")

end)

net.Receive("dac_vehicle_confirmation", function(len, ply)
        
    local confirmationBool = net.ReadBool()

    if confirmationBool == true then
        --print("[DAC DEBUG]: Server received confirmation message.")

        --print("[DAC DEBUG]: Vehicle class " .. tostring(ply.vehicleClass))
    
        -- Pass in all the necessary data here for spawning a vehicle, including deducting credits from the player's balance
        if ply.vehicleType == "simfphys" then
            --print("[DAC DEBUG]: Spawning simfphys vehicle...")
            local initalizedSimfphysVehicleList = list.Get(ply.vehicleListName)
            local initializedSimfphysVehicle = initalizedSimfphysVehicleList[ply.vehicleClass]
            local initializedSimfphysVehicleEntity = simfphys.SpawnVehicle_DAC(ply, ply.vehicleIsFlagTransport, ply.vehicleSpawnPos, ply.vehicleSpawnAng, ply.vehicleModel, ply.vehicleClass, ply.vehicleClass, initializedSimfphysVehicle)
            --print("[DAC DEBUG]: Spawned vehicle entity ID is " .. tostring(initializedSimfphysVehicleEntity))
            --print("[DAC DEBUG]: Initializing vehicle seat data... ")
            --print("[DAC DEBUG]: Transport boolean is " .. tostring(self.vehicleIsFlagTransport))
    
            local simfphysSeatTransportBool = ply.vehicleIsFlagTransport
    
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
            local initializedLFSVehicle = ents.Create(ply.vehicleClass)
            initializedLFSVehicle:SetPos(ply.vehicleSpawnPos) -- ADJUST
            initializedLFSVehicle:SetAngles(ply.vehicleSpawnAng) -- ADJUST
            initializedLFSVehicle:SetNWInt('OwningTeam', ply:Team())
            initializedLFSVehicle:SetNWBool('IsLFSVehicle', true)
            initializedLFSVehicle:Spawn()
            initializedLFSVehicle:Activate()
    
            if initializedLFSVehicle:GetChildren() ~= nil then
                for vehicleKey, vehicleChildren in pairs(initializedLFSVehicle:GetChildren()) do
                    if vehicleChildren:GetClass():lower() == "prop_vehicle_prisoner_pod" then
                        vehicleChildren:SetNWBool('FlagTransport', ply.vehicleIsFlagTransport)
                        vehicleChildren:SetNWInt('OwningTeam', ply:Team())
                        --v:SetNWInt("lfsAITeam", ply:Team())
                    end
                end
            else
                print("[DAC DEBUG]: ERROR, FOUND NO SEAT DATA ON LFS VEHICLE: " .. tostring(initializedLFSVehicle))
            end
    
    
        end

        ply:SetNWInt("storeCredits", ply:GetNWInt("storeCredits") - ply.vehicleCost)
        ply:EmitSound("ambient/levels/labs/coinslot1.wav") -- We want this serverside so other players can hear if the player buys something
    
        ply.vehicleName = nil
        ply.vehicleType = nil
        ply.vehicleCategory = nil
        ply.vehicleCost = nil
        ply.vehicleIsFlagTransport = nil
        ply.vehicleModel = nil
        ply.vehicleListName = nil
        ply.vehicleClass = nil
        ply.vehicleSpawnOffset = nil
        ply.vehicleSpawnPos = nil
        ply.vehicleSpawnAng = nil
    
        ply:SelectWeapon("weapon_physcannon")
        ply:StripWeapon("weapon_dac_vehiclepreviewer")
    end

end)

function CancelVehiclePurchase(ply)

    ply.vehicleName = nil
    ply.vehicleType = nil
    ply.vehicleCategory = nil
    ply.vehicleCost = nil
    ply.vehicleIsFlagTransport = nil
    ply.vehicleModel = nil
    ply.vehicleListName = nil
    ply.vehicleClass = nil
    ply.vehicleSpawnOffset = nil
    ply.vehicleSpawnPos = nil
    ply.vehicleSpawnAng = nil

    ply:SetNWBool("IsSpawningVehicle", false)
    ply:SelectWeapon("weapon_physcannon")
    ply:StripWeapon("weapon_dac_vehiclepreviewer")
end