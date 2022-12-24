AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.explosivebarrel = ents.Create("prop_physics")
	self.explosivebarrel:SetModel("models/props_c17/oildrum001_explosive.mdl")
	self.explosivebarrel:SetPos(self:GetPos() + Vector(0,0,6))
	self.explosivebarrel:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.explosivebarrel:Spawn()
	self.explosivebarrel:Activate()

end

function ENT:Think()

	if !IsValid (self.explosivebarrel) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.explosivebarrel) then
		self.explosivebarrel:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end