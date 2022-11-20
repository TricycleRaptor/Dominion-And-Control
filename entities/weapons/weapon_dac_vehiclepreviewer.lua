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
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 5
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.HoldType = "normal"

local user = nil
local userTeam = nil

local spawnPos = nil
local spawnAng = nil
local wireColor = Color(255,255,255,255)

local vehicleName = nil
local vehicleType = nil
local vehicleCategory = nil
local vehicleCost = nil
local vehicleIsFlagTransport = nil
local vehicleModel = nil
local vehicleListName = nil
local vehicleListKey = nil
local vehicleClass = nil
local vehicleSpawnOffset = nil

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
    vehicleName = nil
    vehicleType = nil
    vehicleCategory = nil
    vehicleCost = nil
    vehicleIsFlagTransport = nil
    vehicleModel = nil
    vehicleListName = nil
    vehicleListKey = nil
    vehicleClass = nil
    vehicleSpawnOffset = nil
    self.validVehicleSpace = false
end

function SWEP:TraceCheck(vehicleModelPreview)

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
		wireColor = Color( 255, 0, 0, 255 )
        self.validVehicleSpace = false
    else
        wireColor = Color( 0, 255, 0, 255)
        self.validVehicleSpace = true
    end

end

function SWEP:Think()

    user = self:GetOwner()
    userTeam = self:GetOwner():Team()
    
    if SERVER then

        local Trace = self.Owner:GetEyeTrace()
        local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
    
        if Dist <= 650 and vehicleModel ~= nil then -- Maximum base place range, to prevent weirdness
    
            if !IsValid(self.vehicleModelPreview) then

                self.vehicleModelPreview = ents.Create("prop_physics")
                self.vehicleModelPreview:SetModel(vehicleModel)
                self.vehicleModelPreview:Spawn()
                self.vehicleModelPreview:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                self.vehicleModelPreview:DrawShadow(false)
                self.vehicleModelPreview:SetMaterial("models/wireframe")

            else

                -- If we're previewing an LFS vehicle, we need to make the height higher for helicopters to have ample spawn room
                if vehicleType == "lfs" then
                    spawnPos = Trace.HitPos + Trace.HitNormal * vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, user:EyeAngles().Y - 180, _)) -- Set the prop angles to face the vehicle toward the player, but maintain the Z axis
                else
                -- Ground vehicles need less space and vertical height
                    spawnPos = Trace.HitPos + Trace.HitNormal * vehicleSpawnOffset
                    self.vehicleModelPreview:SetAngles(Angle(0, user:EyeAngles().Y - 90, _)) -- Set the prop angles to face the vehicle away from the player, but maintain the Z axis
                end

                self.vehicleModelPreview:SetModel(vehicleModel)
                self.vehicleModelPreview:SetPos(spawnPos)
                
                self.vehicleModelPreview:SetColor(wireColor)
                spawnAng = self.vehicleModelPreview:GetAngles()

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
            net.Send(user)

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
        net.Send(user)
    end

end

function SWEP:Holster()

    if IsValid(self.vehicleModelPreview) then
        self.vehicleModelPreview:Remove()
    end

    self.validVehicleSpace = false

    return false

end

net.Receive("dac_sendvehicledata", function(len, ply)

    if ply == user then -- This could override anyone previewing a vehicle in the server if we don't differentiate who sent it. We shouldn't parse it at all if they don't match.
            
        vehicleName = net.ReadString() -- Name
        vehicleType = net.ReadString() -- VehicleType
        vehicleCategory = net.ReadString() -- Category
        vehicleCost = net.ReadString() -- Cost
        vehicleIsFlagTransport = net.ReadBool() -- IsFlagTransport
        vehicleModel = net.ReadString() -- Model
        vehicleListName = net.ReadString() -- Listname
        vehicleClass = net.ReadString() -- Class
        vehicleSpawnOffset = net.ReadString() -- Class
        
        --[[print("\n[DAC DEBUG]: Server received:\n" 
        .. "Name: " .. tostring(vehicleName) .. "\n" 
        .. "Type: " .. tostring(vehicleType) .. "\n"
        .. "Category: " .. tostring(vehicleCategory) .. "\n"
        .. "Cost: " .. tostring(vehicleCost) .. "\n"
        .. "FlagTransport: " .. tostring(vehicleIsFlagTransport) .. "\n"
        .. "Model: " .. tostring(vehicleModel) .. "\n"
        .. "List: " .. tostring(vehicleListName) .. "\n"
        .. "Class: " .. tostring(vehicleClass) .. "\n"
        )]]

        ply:EmitSound("buttons/combine_button3.wav")

    end

end)

net.Receive("dac_vehicle_confirmation", function(len, ply)

    local confirmationBool = net.ReadBool()
    if confirmationBool == true then
        --print("[DAC DEBUG]: Server received confirmation message.")
        SpawnShopVehicle(ply)
    end

end)

function SpawnShopVehicle(ply)

    ply:SetNWInt("storeCredits", ply:GetNWInt("storeCredits") - vehicleCost)
    ply:EmitSound("ambient/levels/labs/coinslot1.wav") -- We want this serverside so other players can hear if the player buys something

    -- Pass in all the necessary data here for spawning a vehicle, including deducting credits from the player's balance
    if vehicleType == "simfphys" then
        --print("[DAC DEBUG]: Spawning simfphys vehicle...")
        local initalizedSimfphysVehicleList = list.Get(vehicleListName)
        local initializedSimfphysVehicle = initalizedSimfphysVehicleList[vehicleClass]
        local initializedSimfphysVehicleEntity = simfphys.SpawnVehicle_DAC(ply, vehicleIsFlagTransport, spawnPos, spawnAng, vehicleModel, vehicleClass, vehicleClass, initializedSimfphysVehicle)
        --print("[DAC DEBUG]: Spawned vehicle entity ID is " .. tostring(initializedSimfphysVehicleEntity))
        --print("[DAC DEBUG]: Initializing vehicle seat data... ")
        --print("[DAC DEBUG]: Transport boolean is " .. tostring(vehicleIsFlagTransport))

        local simfphysSeatTransportBool = vehicleIsFlagTransport

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
        local initializedLFSVehicle = ents.Create(vehicleClass)
        initializedLFSVehicle:SetPos(spawnPos)
        initializedLFSVehicle:SetAngles(spawnAng)
        initializedLFSVehicle:SetNWInt('OwningTeam', ply:Team())
        initializedLFSVehicle:SetNWBool('IsLFSVehicle', true)
        initializedLFSVehicle:Spawn()
        initializedLFSVehicle:Activate()

        if initializedLFSVehicle:GetChildren() ~= nil then
            for vehicleKey, vehicleChildren in pairs(initializedLFSVehicle:GetChildren()) do
                if vehicleChildren:GetClass():lower() == "prop_vehicle_prisoner_pod" then
                    vehicleChildren:SetNWBool('FlagTransport', vehicleIsFlagTransport)
                    vehicleChildren:SetNWInt('OwningTeam', ply:Team())
                    --v:SetNWInt("lfsAITeam", ply:Team())
                end
            end
        else
            print("[DAC DEBUG]: ERROR, FOUND NO SEAT DATA ON LFS VEHICLE: " .. tostring(initializedLFSVehicle))
        end


    end

    vehicleName = nil
    vehicleType = nil
    vehicleCategory = nil
    vehicleCost = nil
    vehicleIsFlagTransport = nil
    vehicleModel = nil
    vehicleListName = nil
    vehicleListKey = nil
    vehicleClass = nil

    ply:SelectWeapon("weapon_physcannon")
    ply:StripWeapon("weapon_dac_vehiclepreviewer")

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