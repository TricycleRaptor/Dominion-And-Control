AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)
	
	self.ammo_crate_pistol = ents.Create("item_ammo_crate")
	self.ammo_crate_pistol:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_pistol:SetAngles(self:GetAngles())
	self.ammo_crate_pistol:SetKeyValue("AmmoType", 0) -- 0 is the index for Pistol ammo
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_pistol:Spawn()
	self.ammo_crate_pistol:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_pistol) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_pistol) then
		self.ammo_crate_pistol:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end