AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.ammo_ar2_ball = ents.Create("item_ammo_ar2_altfire")
	self.ammo_ar2_ball:SetPos(self:GetPos() + Vector(0,0,5))
	self.ammo_ar2_ball:SetAngles(self:GetAngles())
	self.ammo_ar2_ball:Spawn()
	self.ammo_ar2_ball:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_ar2_ball) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_ar2_ball) then
		self.ammo_ar2_ball:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end