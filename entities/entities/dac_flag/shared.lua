ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Primary gamemode objective"
ENT.Category = "DAC"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Editable = true

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

    self:AnimateFlag() -- Call animation function

    if SERVER then -- Don't bother the client with this part

        if self.Entity:GetHeld() == true and self:GetCarrier():IsPlayer() and not self.Entity:GetCarrier():Alive() then -- This will trigger when the flag carrier dies

            self.Entity:SetDropTime(CurTime()) -- Flag has been dropped, initiate countdown, where curTime() is the precise moment it was dropped
            print("[DAC DEBUG]: A flag was dropped!")

            self.Entity:SetHeld(false)
            self.Entity:GetCarrier():SetPlayerCarrierStatus(false) -- Send carrier boolean status to player entity
            print("[DAC DEBUG]: Set " .. self.Entity:GetCarrier():Nick() .. "'s flag carrier status to " .. tostring(self.Entity:GetCarrier():GetPlayerCarrierStatus()) .. ".")
            self.Entity:SetCarrier(NULL)
            
            self.Entity:PhysWake()
            self.Entity:SetParent(NULL)
            self.Entity:SetAngles(Angle(0,0,0))
            self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

        elseif self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() > 15 then -- Return the flag after 15 seconds of inactivity

            self.Entity:ReturnFlag()

        end

        if self.Entity:GetCarrier() == NULL or self.Entity:GetCarrier() == nil then -- Covering bases here, probably isn't necessary
            self.Entity:SetHeld(false)
        end

    end

end

function ENT:ReturnFlag()

	print("[DAC DEBUG]: Return function called. Parent base is " .. tostring(self.ParentBase))

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