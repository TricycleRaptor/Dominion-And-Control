AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.woodencrate = ents.Create("prop_physics")
	self.woodencrate:SetModel("models/props_junk/wood_crate001a.mdl")
	self.woodencrate:SetPos(self:GetPos() + Vector(0,0,25))
	self.woodencrate:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.woodencrate:Spawn()
	self.woodencrate:Activate()

end

function ENT:Think()

	if !IsValid (self.woodencrate) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.woodencrate) then
		self.woodencrate:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end