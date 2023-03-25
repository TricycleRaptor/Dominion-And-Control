ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Primary gamemode objective"
ENT.Category = "DAC"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Editable = false

function ENT:SetupDataTables()

    local teamList = {}

    for teamIndex, teamData in pairs(GAMEMODE.Teams) do
        teamList[teamData.name] = teamIndex
    end

    -- The second argument is a unique identifier slot in the backend
    -- You can have one of each data type in one slot
    -- Don't lose track of your shit, boss
    self:NetworkVar("Int", 0, "Team", {
        KeyName = "team",
        Edit = { -- Adds entity properties to the context menu for debug purposes
            type = "Combo",
            values = teamList -- Get team data from sh_teams.lua
        }
    })
    self:NetworkVar("Float", 1, "DropTime")
    self:NetworkVar("Bool", 0, "Held")
    self:NetworkVar("Bool", 1, "OnBase")
    self:NetworkVar("Entity", 0, "Carrier")
    self:NetworkVar("Bool", 2, "Available")

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end

function ENT:Think()

    if SERVER then -- Don't bother the client with this part

        if self.Entity:GetHeld() == true and self:GetCarrier():IsPlayer() and not self.Entity:GetCarrier():Alive() then -- This will trigger when the flag carrier dies

            net.Start("SendDroppedAudio")
			net.WriteFloat(self:GetCarrier():Team()) -- Pass in the flag carrier's team for networking behavior
			net.Broadcast() -- This sends to all players, not just the flag carrier

            net.Start("SendFlagHUDNotify") -- Notify the carrying player's HUD
            net.WriteEntity(self.Entity)
            net.WriteBool(false)
            net.Send(self:GetCarrier())

            self.Entity:SetPos(self.Entity:GetPos() + Vector(0, 0, 100)) -- Set the vector above the ground first

            self.Entity:SetAngles(Angle(0,0,0)) -- Set angles to zero
            local tr = util.TraceLine( {
                start = self.Entity:GetPos(),
                endpos = self.Entity:GetPos() + self.Entity:GetAngles():Up() * -10000, -- Perform a trace downward on a long single Y vector
                filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end -- Only hit the world and physics props
            } )
            self.Entity:SetPos(tr.HitPos) -- Set the flag's position to that trace result, kinda buggy

            self.Entity:SetDropTime(CurTime()) -- Flag has been dropped, initiate countdown, where curTime() is the precise moment it was dropped
            --print("[DAC DEBUG]: A flag was dropped!")

            self.Entity:SetHeld(false)
            self.Entity:GetCarrier():SetPlayerCarrierStatus(false) -- Send carrier boolean status to player entity
            --print("[DAC DEBUG]: Set " .. self.Entity:GetCarrier():Nick() .. "'s flag carrier status to " .. tostring(self.Entity:GetCarrier():GetPlayerCarrierStatus()) .. ".")
            self.Entity:SetCarrier(NULL)
            
            self.Entity:PhysWake()
            self.Entity:SetParent(NULL)
            self.Entity:SetAngles(Angle(0,90,0))
            self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

        elseif self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() > 20 then -- Return the flag after 20 seconds of inactivity

            self.Entity:ReturnFlag()

            net.Start("SendReturnedAudio")
            net.WriteFloat(self.Entity:GetTeam()) -- Pass team's flag into net message
            net.Broadcast() -- This sends to all players, not just the flag carrier

        end

        ----- BEGIN EXPERIMENTAL TIMED RECOVERY -----
        if self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() < 20 then -- Count down for when the flag was dropped
        
            for k,ent in pairs(player.GetAll()) do
                if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == self:GetTeam() and ent:GetPos():Distance(self.Entity:GetPos()) < 100 then
                    self.Entity:SetDropTime(self.Entity:GetDropTime() - 0.15)
                end
            end

        end
        ----- END EXPERIMENTAL TIMED RECOVERY -----

        if self.Entity:GetCarrier() == NULL or self.Entity:GetCarrier() == nil then -- Covering bases here, probably isn't necessary
            self.Entity:SetHeld(false)
        end

    end

end

function ENT:ReturnFlag()

	--print("[DAC DEBUG]: Return function called. Parent base is " .. tostring(self.ParentBase))
    self:SetParent(NULL)
    self:SetParent(self.ParentBase)

    self:SetPos(self.ParentBase:GetPos() + self.ParentBase:GetUp() * 10)
	self:SetAngles(self.ParentBase:GetAngles())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    self.Entity:SetDropTime(0)

    self:SetOnBase(true)
    self:SetHeld(false)
    self:SetCarrier(NULL)
    self.ParentBase:SetHasFlag(true)
	
end

function ENT:ScoreFlag(scoredTeam)

    if SERVER then
        if(self:GetParent():IsPlayer() == false and self:GetCarrier() == NULL and self:GetOnBase() == true and self:GetHeld() == false) then
            self.ParentBase = self:GetParent() -- We touched a flag as a carrier and the flag we touched is on the base, so we can assume the parent is the flag base.
            self.ParentBase:SetFlagScore(self.ParentBase:GetFlagScore() + 1) -- We're getting this from the networked variables on the flagpoint. We can use this for score keeping.
        else
            print("[DAC DEBUG]: Guard code for scoring was triggered. Check parent variables.")
        end
    end
    
    --print("[DAC DEBUG]: Local flagpoint " .. tostring(self.ParentBase) .. " has a score of " .. tostring(self.ParentBase:GetFlagScore()))

end

function ENT:ResetFlagScore()

    if SERVER then
        self.ParentBase:SetFlagScore(0)
    end
    
    --print("[DAC DEBUG]: Local flagpoint " .. tostring(self.ParentBase) .. "'s flag score has been reset.")

end