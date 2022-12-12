AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_crossbow = ents.Create("item_ammo_crossbow")
	self.ammo_crossbow:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_crossbow:SetAngles(self:GetAngles())
	self.ammo_crossbow:Spawn()
	self.ammo_crossbow:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crossbow) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crossbow) then
		self.ammo_crossbow:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end