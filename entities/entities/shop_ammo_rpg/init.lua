AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_rpg = ents.Create("item_rpg_round")
	self.ammo_rpg:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_rpg:SetAngles(self:GetAngles())
	self.ammo_rpg:Spawn()
	self.ammo_rpg:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_rpg) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_rpg) then
		self.ammo_rpg:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end