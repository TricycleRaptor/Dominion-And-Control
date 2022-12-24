AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.barrel = ents.Create("prop_physics")
	self.barrel:SetModel("models/props_c17/oildrum001.mdl")
	self.barrel:SetPos(self:GetPos() + Vector(0,0,6))
	self.barrel:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.barrel:Spawn()
	self.barrel:Activate()

end

function ENT:Think()

	if !IsValid (self.barrel) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.barrel) then
		self.barrel:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end