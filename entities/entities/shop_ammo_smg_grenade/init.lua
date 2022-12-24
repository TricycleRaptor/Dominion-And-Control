AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_smg_grenade = ents.Create("item_ammo_smg1_grenade")
	self.ammo_smg_grenade:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_smg_grenade:SetAngles(self:GetAngles())
	self.ammo_smg_grenade:Spawn()
	self.ammo_smg_grenade:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_smg_grenade) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_smg_grenade) then
		self.ammo_smg_grenade:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end