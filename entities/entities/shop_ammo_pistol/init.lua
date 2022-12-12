AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_pistol = ents.Create("item_ammo_pistol")
	self.ammo_pistol:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_pistol:SetAngles(self:GetAngles())
	self.ammo_pistol:Spawn()
	self.ammo_pistol:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_pistol) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_pistol) then
		self.ammo_pistol:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end