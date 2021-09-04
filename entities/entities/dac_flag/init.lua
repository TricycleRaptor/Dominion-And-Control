AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	local ParentBase = nil
	self:SetName("dac_flag")

	self:SetModel("models/ctf_flag/ctf_flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true) -- Make this triggerable for a touchpoint condition

	-- Set a base condition for the networked vars
	-- The flag starts attached to the base, so adjust these values accordingly
	self:SetOnBase(true)
	self:SetHeld(false)
	self:SetCarrier(nil)
	self:SetDropTime(0)

	-- Check the spawning player's team and set the value of the flag to the player's team. This will change later to coordinate from a SWEP rather than the spawn menu
	--self:SetTeam(1)

end

function ENT:StartTouch(entity)

	-- Debugging network vars
	if (entity:IsPlayer()) then
		print("[DAC]: " .. entity:Nick() .. " interacted with a flag!")
		print("[DAC]: " .. entity:Nick() .. "'s team ID is " .. entity:Team() .. " and the flag's team ID is " .. self:GetTeam() .. ".")
	end

	if entity:IsValid() and entity:IsPlayer() and entity:Alive() and entity:Team() != self:GetTeam() then -- Consider adding a condition to check against spectators, come back to this later
		
		-- Can't set this in the entity initialization hook for some reason, so I have to fucking do it here
		if(self:GetOnBase() == true and self:GetHeld() == false) then
			self.ParentBase = self:GetParent()
		end
		
		-- Broadcast flag pickup
		self:SetOnBase(false)
		self:SetHeld(true)
		self:SetCarrier(entity)
		self.ParentBase:SetHasFlag(false)

		-- Setup angles
		local angles = entity:GetAngles()
		angles.p = 0
		angles.r = 0

		-- Setup collision
		self.Entity:SetPos(entity:GetPos() - angles:Forward() * 10)
		self.Entity:SetParent(entity)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	elseif entity:IsValid() and entity:IsPlayer() and entity:Alive() and entity:Team() == self:GetTeam() and self:GetHeld() == false and self:GetOnBase() == false then -- Team member touched the flag
		
		-- Network that the flag has been returned
		--print("[DAC]: " .. entity:Nick() .. " returned the flag.")
		self.Entity:ReturnFlag()
		
	end

end

function ENT:ReturnFlag()

	--print("[DAC]: Return function called. Parent base is " .. tostring(self.ParentBase))

	self:SetParent(self.ParentBase)
	self:SetPos(self.ParentBase:GetPos() + self.ParentBase:GetUp() * 10)
	self:SetAngles(self.ParentBase:GetAngles())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetOnBase(true)
	self:SetHeld(false)
	self:SetCarrier(NULL)
	self.ParentBase:SetHasFlag(true)

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end