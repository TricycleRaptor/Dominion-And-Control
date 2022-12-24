AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.item_healthkit = ents.Create("item_healthkit")
	self.item_healthkit:SetPos(self:GetPos() + Vector(0,0,5))
	self.item_healthkit:SetAngles(self:GetAngles())
	self.item_healthkit:Spawn()
	self.item_healthkit:Activate()

end

function ENT:Think()

	if !IsValid (self.item_healthkit) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.item_healthkit) then
		self.item_healthkit:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end