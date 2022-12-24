AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_shotgun = ents.Create("item_box_buckshot")
	self.ammo_shotgun:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_shotgun:SetAngles(self:GetAngles())
	self.ammo_shotgun:Spawn()
	self.ammo_shotgun:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_shotgun) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_shotgun) then
		self.ammo_shotgun:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end