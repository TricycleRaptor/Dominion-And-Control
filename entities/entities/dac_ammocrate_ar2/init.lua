AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/weapons/shell.mdl")
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	self.ammo_crate_ar2 = ents.Create("item_ammo_crate")
	self.ammo_crate_ar2:SetPos(self:GetPos() + Vector(0,0,6))
	self.ammo_crate_ar2:SetAngles(self:GetAngles())
	self.ammo_crate_ar2:SetKeyValue("AmmoType", 2)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self.ammo_crate_ar2:Spawn()
	self.ammo_crate_ar2:Activate()

	local ammo_crate_ar2_name = "ammo_crate_ar2" .. self.ammo_crate_ar2:EntIndex()
	self.ammo_crate_ar2:SetName( ammo_crate_ar2_name )

	-- I don't think these crates can be physics objects, boss
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	self:PhysWake()

end

function ENT:Think()

	if !IsValid (self.ammo_crate_ar2) then
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.ammo_crate_ar2) then
		self.ammo_crate_ar2:Remove()
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end