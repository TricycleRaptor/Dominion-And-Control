AddCSLuaFile()

SWEP.Category = "DAC"
SWEP.Base = "weapon_base"
SWEP.PrintName = "BASE LOCATOR"
SWEP.Author = "Tricycle Raptor"
SWEP.Instructions = "Sets the designated build zone for your team's base. Left click to confirm desired location."
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
SWEP.SlotPos = 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true
SWEP.HoldType = "revolver"

local user = nil
local userTeam = nil

local spawnPos = nil
local flagPos = nil
local validSpace = false
local wireColor = Color(255,255,255,255)

local otherTeamPos = Vector(0,0,0)
local maxDistance = GetConVar("dac_zone_scale"):GetFloat() * 2000

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Think()

    user = self:GetOwner()
    userTeam = self:GetOwner():Team()
    
    if SERVER then -- Changed from client to server so other teammates can see the base placement

        local Trace = self.Owner:GetEyeTrace()
        local Dist = (Trace.HitPos - self.Owner:GetPos()):Length()
    
        if Dist <= 350 then -- Maximum base place range, to prevent weirdness
    
            if !IsValid(self.flagEnt) and !IsValid(self.flagEnt) then --Isn't valid, so let's go ahead and make it work

                self.spawnEnt = ents.Create("prop_physics")
                self.spawnEnt:SetModel("models/ctf_spawnarea/ctf_spawnarea.mdl")
                self.spawnEnt:Spawn()
                self.spawnEnt:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) -- Don't collide with anything, bitch
                self.spawnEnt:DrawShadow(false)
                self.spawnEnt:SetMaterial("models/wireframe")

                self.flagEnt = ents.Create("prop_physics")
                self.flagEnt:SetModel("models/ctf_flagbase/ctf_flagbase.mdl")
                self.flagEnt:Spawn()
                self.flagEnt:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                self.flagEnt:DrawShadow(false)
                self.flagEnt:SetMaterial("models/wireframe")

            else

                spawnPos = Trace.HitPos + Trace.HitNormal * 3
                flagPos = spawnPos + Vector(0,0,100)

                self.spawnEnt:SetPos(spawnPos)
                self.flagEnt:SetPos(flagPos)
                self.spawnEnt:SetColor(wireColor)
                self.flagEnt:SetColor(wireColor)

                self:TraceCheck(self.spawnEnt, self.flagEnt)

                --if (TeamLocations[otherTeam] != nil && (spawnPos - TeamLocations[otherTeam]):Length() < GetConVar("dac_zone_scale"):GetFloat() * 2000) then
                    --wireColor = Color( 255, 0, 0, 255 )
                    --validSpace = false    
                --end

            end
    
        else
    
            if IsValid(self.flagEnt) and IsValid(self.flagEnt) then
                self.spawnEnt:Remove()
                self.flagEnt:Remove()
            end

        end

    end

end

function SWEP:PrimaryAttack()

    if SERVER then

        if validSpace == true then

            for teamKey, teamData in pairs(GAMEMODE.Teams) do -- Special thanks to Joseph Tomlinson (@BizzClaw) for some pair programming to figure this out
                if teamKey != userTeam then -- ignore our team
                    local otherTeamPos = teamData.basePos

                    if (otherTeamPos and otherTeamPos != Vector(0,0,0) and spawnPos:Distance(otherTeamPos) < maxDistance) then -- Check the cVar for the build scale
                        self:GetOwner():EmitSound("buttons/button8.wav")
                        return false
                    else
                        net.Start("dac_validspace_sync")
                        net.WriteBool(true)
                        net.Send(user) -- This SHOULD only send to the player who clicks with the tool, but this will have to be tested with another player present
                    end

                end
            end

            GAMEMODE.Teams[userTeam].basePos = spawnPos
            GAMEMODE.Teams[userTeam].baseSet = true

        else
            self:GetOwner():EmitSound("buttons/button8.wav") -- Teammates will hear this, too
            self:GetOwner():ChatMessage_Basic("Invalid base location selected!")
        end
        
    end

end

function SWEP:Holster()

    if IsValid(self.flagEnt) and IsValid(self.flagEnt) then
        self.spawnEnt:Remove()
        self.flagEnt:Remove()
    end

    validSpace = false
    return true

end

function SWEP:TraceCheck(spawnEnt, flagEnt)

    local ent1 = self.spawnEnt
    local ent2 = self.flagEnt
	
	local mins1 = ent1:OBBMins()
	local maxs1 = ent1:OBBMaxs()
	local startpos1 = ent1:GetPos()
	local dir1 = ent1:GetUp()
	local len1 = 2

    local mins2 = ent2:OBBMins()
	local maxs2 = ent2:OBBMaxs()
	local startpos2 = ent2:GetPos()
	local dir2 = ent2:GetUp()
	local len2 = 2

	local tr1 = util.TraceHull( {
		start = startpos1,
		endpos = startpos1 + dir1 * len1,
		maxs = maxs1,
		mins = mins1,
		filter = ent1
	} )

    local tr2 = util.TraceHull( {
		start = startpos2,
		endpos = startpos2 + dir2 * len2,
		maxs = maxs2,
		mins = mins2,
		filter = ent2
	} )

	if ( tr1.Hit or tr2.Hit ) then
		wireColor = Color( 255, 0, 0, 255 )
        validSpace = false
    else
        wireColor = Color( 0, 255, 0, 255)
        validSpace = true
    end

    for teamKey, teamData in pairs(GAMEMODE.Teams) do
        if teamKey != userTeam then
            local otherTeamPos = teamData.basePos
            if (otherTeamPos and otherTeamPos != Vector(0,0,0) and spawnPos:Distance(otherTeamPos) < maxDistance) then
                wireColor = Color( 255, 0, 0, 255 )
                validSpace = false
            end
        end
    end

end

function SetupTeamArea()

    BuildArea(user, userTeam, spawnPos, flagPos) -- We should pass in the player, the player's team, and the flag/spawnpos

end

net.Receive("dac_sendbase_confirmation", function(len, ply)

	local confirmationBool = net.ReadBool()
	if confirmationBool == true then
        --print("[DAC DEBUG]: Server received confirmation message.")
        SetupTeamArea()
        --PrintTable(GAMEMODE.Teams)
    end

end)