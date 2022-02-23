ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Primary gamemode objective"
ENT.Category = "DAC"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Editable = true

local ringModel = NULL

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
    self:NetworkVar("Int", 1, "DropTime")
    self:NetworkVar("Bool", 0, "Held")
    self:NetworkVar("Bool", 1, "OnBase")
    self:NetworkVar("Entity", 0, "Carrier")

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end

function ENT:Think()

    if CLIENT then
        self:AnimateFlag() -- Call animation function

        if self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() < 20 then -- The flag is dropped, we can render objects on client here
            if ringModel == NULL  then
                ringModel = ents.CreateClientProp()
                ringModel:SetPos(self.Entity:GetPos())
                ringModel:SetModel("models/hunter/tubes/tube4x4x025.mdl")
                ringModel:SetMaterial("models/wireframe")
                ringModel:SetColor(team.GetColor(self.Entity:GetTeam()))
                ringModel:SetParent(self.Entity)
                ringModel:DrawShadow(false)
                ringModel:Spawn()
                
            elseif ringModel ~= NULL then
                ringModelAngles = ringModel:GetAngles()
                ringModelAngles:Add(Angle(0,0.02,0))
                ringModel:SetAngles(ringModelAngles)
            end
        else
            if ringModel ~= NULL then
                ringModel:Remove()
            end
        end
    end

    if SERVER then -- Don't bother the client with this part

        if self.Entity:GetHeld() == true and self:GetCarrier():IsPlayer() and not self.Entity:GetCarrier():Alive() then -- This will trigger when the flag carrier dies

            net.Start("SendDroppedAudio")
			net.WriteFloat(self:GetCarrier():Team()) -- Pass in the flag carrier's team for networking behavior
			net.Broadcast() -- This sends to all players, not just the flag carrier

            self.Entity:SetAngles(Angle(0,0,0)) -- Set angles to zero
            local tr = util.TraceLine( {
                start = self.Entity:GetPos(),
                endpos = self.Entity:GetPos() + self.Entity:GetAngles():Up() * -200000, -- Perform a trace downward on a long single Y vector
                filter = function( ent ) return ( ent:GetClass() == "prop_physics" ) end -- Only hit the world and physics props
            } )
            self.Entity:SetPos(tr.HitPos) -- Set the flag's position to that trace result

            --- TIMED RECOVERY TIMER FUNCTION ---
            if not timer.Exists("FlagPerimeterCheck") then
                timer.Create("FlagPerimeterCheck", 5, 1, function()
                    self.Entity:ReturnFlag()

                    net.Start("SendReturnedAudio")
                    net.WriteFloat(self.Entity:GetTeam()) -- Pass team's flag into net message
                    net.Broadcast() -- This sends to all players, not just the flag carrier

                    timer.Remove("FlagPerimeterCheck")
                    print("[DAC DEBUG]: Drop timer removed!")
                end)
                timer.Pause("FlagPerimeterCheck")
                print("[DAC DEBUG]: Drop timer created and paused!")
            end

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

            if timer.Exists("FlagPerimeterCheck") then
                timer.Remove("FlagPerimeterCheck")
                print("[DAC DEBUG]: Drop timer removed!")
            end

            net.Start("SendReturnedAudio")
            net.WriteFloat(self.Entity:GetTeam()) -- Pass team's flag into net message
            net.Broadcast() -- This sends to all players, not just the flag carrier

        end

        ----- BEGIN EXPERIMENTAL TIMED RECOVERY -----
        if self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() < 20 then -- Count down for when the flag was dropped

            local sphericalents = {} -- Empty list table
            for _, entInSphere in pairs(ents.FindInSphere(self.Entity:GetPos(),100)) do
                if entInSphere:IsValid() and entInSphere:IsPlayer() and entInSphere:Alive() and !entInSphere:InVehicle() and timer.Exists("FlagPerimeterCheck") then
                    if entInSphere:Team() == self.Entity:GetTeam() and entInSphere:Team() != 3 then
                        timer.UnPause("FlagPerimeterCheck")
                        print("[DAC DEBUG]: Drop timer unpaused!")
                    end
                    table.insert(sphericalents, entInSphere) -- Auto-populate that table with entities
                end
            end
        
            for _, playerEnt in pairs(player.GetAll()) do

                if playerEnt:IsPlayer() then
                    teamNum = playerEnt:Team()
                end
        
                if playerEnt:IsValid() and teamNum == self.Entity:GetTeam() and table.HasValue(sphericalents, playerEnt) == false then
                    if playerEnt:IsPlayer() then
                        timer.Pause("FlagPerimeterCheck")
                        print("[DAC DEBUG]: Drop timer paused!")
                    end
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

    self:SetOnBase(true)
	self:SetHeld(false)
	self:SetCarrier(NULL)

	self:SetParent(NULL)
	self:SetParent(self.ParentBase)
	self:SetPos(self.ParentBase:GetPos() + self.ParentBase:GetUp() * 10)
	self:SetAngles(self.ParentBase:GetAngles())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

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

function ENT:AnimateFlag()

    local numFrames = self.Entity:GetFlexNum()

	if numFrames == 0 then return end

	local totalTime = 2
	local frameTime = totalTime / numFrames

	local animTime = CurTime() % totalTime

	for i=0,(numFrames-1) do

		local progress = animTime / frameTime - i
		if progress <= 0 or progress > 1 then
			progress = 0
		end

		local prev = i - 1
		if prev < 0 then
			prev = numFrames - 1
		end

		self.Entity:SetFlexWeight(i, progress)

		if (progress > 0) then
			self.Entity:SetFlexWeight(prev, 1 - progress)
			return
		end
	end

end