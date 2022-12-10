AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.largewoodencrate = ents.Create("prop_physics")
	self.largewoodencrate:SetModel("models/props_junk/wood_crate002a.mdl")
	self.largewoodencrate:SetPos(self:GetPos() + Vector(0,0,25))
	self.largewoodencrate:SetAngles(self:GetAngles())
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.largewoodencrate:Spawn()
	self.largewoodencrate:Activate()

end

function ENT:Think()

	if !IsValid (self.largewoodencrate) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.largewoodencrate) then
		self.largewoodencrate:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end