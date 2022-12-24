AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)
	
	self.ammo_crate_grenade = ents.Create("item_ammo_crate")
	self.ammo_crate_grenade:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_grenade:SetAngles(self:GetAngles())
	self.ammo_crate_grenade:SetKeyValue("AmmoType", 5) -- 5 is the index for grenade ammo
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_grenade:Spawn()
	self.ammo_crate_grenade:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_grenade) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_grenade) then
		self.ammo_crate_grenade:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end