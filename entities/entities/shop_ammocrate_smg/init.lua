AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)
	
	self.ammo_crate_smg = ents.Create("item_ammo_crate")
	self.ammo_crate_smg:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_smg:SetAngles(self:GetAngles())
	self.ammo_crate_smg:SetKeyValue("AmmoType", 1) -- 1 is the index for SMG ammo
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_smg:Spawn()
	self.ammo_crate_smg:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_smg) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_smg) then
		self.ammo_crate_smg:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end