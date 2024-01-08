AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.scale = GetConVar("dac_zone_scale"):GetFloat()
	self.baseSize = 1000 * self.scale
	self.Entity:DrawShadow(false)
	self.Entity:SetModel("models/ctf_sphere/ctf_constructsphere.mdl")
	self.Entity:PhysicsInit(SOLID_NONE)
	self.Entity:SetMoveType(0)
	self.Entity.IsSphere = false -- This is used by the server to remove build spheres when the round starts. While technically a sphere, we set this to false so they aren't removed
	self.Entity.CanMove = 0
	self.Entity:SetModelScale(self.scale, 0)
	self.Entity:SetModelScale(GetConVar("dac_zone_scale"):GetFloat())

end

function ENT:Think()

	-- Search for entities within the sphere radius
	for k,ent in pairs(ents.FindInSphere(self.Entity:GetPos(),1000 * GetConVar("dac_zone_scale"):GetFloat())) do
		if ent:IsValid() then
			if ent:IsPlayer() and ent:Team() == self:GetTeam() and ent:Team() != 3 then
				ent:SetNWBool("IsInBase", true) -- If the player belongs to the same team, we'll set their base status to true
			end
		end
	end

	for k,ent in pairs(ents.GetAll()) do

		if ent:IsPlayer() then
			entTeam = ent:Team()
		end

		if ent:IsValid() and entTeam == self:GetTeam() and ent:GetPos():Distance(self.Entity:GetPos()) > GetConVar("dac_zone_scale"):GetFloat() * 1000 then 
			if ent:IsPlayer() then
				ent:SetNWBool("IsInBase", false) -- If the player leaves their base, set their status to false
				if ent:HasWeapon("weapon_dac_vehiclepreviewer") then -- Additionally remove the vehicle previewer if in possession
					ent:SelectWeapon("weapon_physcannon")
					ent:StripWeapon("weapon_dac_vehiclepreviewer")
					ent:SetNWBool("IsSpawningVehicle", false)
					ent.vehicleName = nil
					ent.vehicleCategory = nil
					ent.vehicleCost = nil
					ent.vehicleIsFlagTransport = nil
					ent.vehicleModel = nil
					ent.vehicleListName = nil
					ent.vehicleClass = nil
					ent.vehicleSpawnOffset = nil
					ent.vehicleSpawnPos = nil
					ent.vehicleSpawnAng = nil
				end
			end
		end
		
	end

	self.Entity:SetModelScale(GetConVar("dac_zone_scale"):GetFloat()) -- Auto-adjust perimeter in tandem with changes to cVars
end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end