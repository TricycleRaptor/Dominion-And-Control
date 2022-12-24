AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.battery = ents.Create("item_battery")
	self.battery:SetPos(self:GetPos() + Vector(0,0,5))
	self.battery:SetAngles(self:GetAngles())
	self.battery:Spawn()
	self.battery:Activate()

end

function ENT:Think()

	if !IsValid (self.battery) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.battery) then
		self.battery:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end