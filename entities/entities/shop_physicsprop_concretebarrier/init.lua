AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.concretebarrier = ents.Create("prop_physics")
	self.concretebarrier:SetModel("models/props_c17/concrete_barrier001a.mdl")
	self.concretebarrier:SetPos(self:GetPos() + Vector(0,0,6))
	self.concretebarrier:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.concretebarrier:Spawn()
	self.concretebarrier:Activate()

end

function ENT:Think()

	if !IsValid (self.concretebarrier) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.concretebarrier) then
		self.concretebarrier:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end