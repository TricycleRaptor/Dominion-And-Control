AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_smg = ents.Create("item_ammo_smg1")
	self.ammo_smg:SetPos(self:GetPos() + Vector(0,0,0))
	self.ammo_smg:SetAngles(self:GetAngles())
	self.ammo_smg:Spawn()
	self.ammo_smg:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_smg) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_smg) then
		self.ammo_smg:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end