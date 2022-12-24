AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)
	
	self.ammo_crate_shotgun = ents.Create("item_ammo_crate")
	self.ammo_crate_shotgun:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_shotgun:SetAngles(self:GetAngles())
	self.ammo_crate_shotgun:SetKeyValue("AmmoType", 4) -- 4 is the index for shotgun ammo
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_shotgun:Spawn()
	self.ammo_crate_shotgun:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_shotgun) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_shotgun) then
		self.ammo_crate_shotgun:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end