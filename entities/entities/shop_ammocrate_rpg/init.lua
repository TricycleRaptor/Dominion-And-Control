AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)
	
	self.ammo_crate_rpg = ents.Create("item_ammo_crate")
	self.ammo_crate_rpg:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_rpg:SetAngles(self:GetAngles())
	self.ammo_crate_rpg:SetKeyValue("AmmoType", 3) -- 3 is the index for RPG ammo
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_rpg:Spawn()
	self.ammo_crate_rpg:Activate()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_rpg) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_rpg) then
		self.ammo_crate_rpg:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end