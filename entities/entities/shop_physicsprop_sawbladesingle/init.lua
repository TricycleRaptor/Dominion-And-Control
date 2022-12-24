AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.sawblade = ents.Create("prop_physics")
	self.sawblade:SetModel("models/props_junk/sawblade001a.mdl")
	self.sawblade:SetPos(self:GetPos() + Vector(0,0,6))
	self.sawblade:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.sawblade:Spawn()
	self.sawblade:Activate()

end

function ENT:Think()

	if !IsValid (self.sawblade) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.sawblade) then
		self.sawblade:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end