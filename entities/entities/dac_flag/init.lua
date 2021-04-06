AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.IsFlag = true
	self.CanMove = 0
	self:SetModel("models/ctf_flag/ctf_flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true)


end

function ENT:StartTouch(entity)



end

function ENT:ReturnFlag()

	local flagBase = self.flagBase
	if not flagBase then return end

	self:SetParent()
	self:SetPos(flagBase:GetPos() + flagBase:GetUp() * 10)
	self:SetAngles(flagBase:GetAngles())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end