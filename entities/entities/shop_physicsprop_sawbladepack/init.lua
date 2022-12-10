AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.sawblade1 = ents.Create("prop_physics")
	self.sawblade1:SetModel("models/props_junk/sawblade001a.mdl")
	self.sawblade1:SetPos(self:GetPos() + Vector(0,0,6))
	self.sawblade1:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.sawblade1:Spawn()
	self.sawblade1:Activate()


	self.sawblade2 = ents.Create("prop_physics")
	self.sawblade2:SetModel("models/props_junk/sawblade001a.mdl")
	self.sawblade2:SetPos(self:GetPos() + Vector(0,0,18))
	self.sawblade2:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.sawblade2:Spawn()
	self.sawblade2:Activate()


	self.sawblade3 = ents.Create("prop_physics")
	self.sawblade3:SetModel("models/props_junk/sawblade001a.mdl")
	self.sawblade3:SetPos(self:GetPos() + Vector(0,0,30))
	self.sawblade3:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.sawblade3:Spawn()
	self.sawblade3:Activate()

end

function ENT:Think()

	if !IsValid (self.sawblade1) then
		self:Remove()
	end

	if !IsValid (self.sawblade2) then
		self:Remove()
	end

	if !IsValid (self.sawblade3) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.sawblade1) then
		self.sawblade1:Remove()
	end

	if IsValid (self.sawblade2) then
		self.sawblade2:Remove()
	end

	if IsValid (self.sawblade3) then
		self.sawblade3:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end