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
	self.Entity.IsSphere = true
	self.Entity.CanMove = 0
	self.Entity:SetModelScale(self.scale, 0)

end

function ENT:WarpToValidSpot(ply)
	local targetDir = ((ply:GetPos() - self.Entity:GetPos()) * Vector(1,1,0) + Vector(0,0,5)):GetNormalized()
	local target = nil
	local totalYaw = 0

	local tr = nil
	repeat
		target = targetDir * 1000 * GetConVar("dac_zone_scale"):GetFloat() + targetDir * 100 + self.Entity:GetPos()
		tr = util.TraceHull( {
			start = target,
			endpos = target + Vector(0,0,1),
			mins, maxs = ply:WorldSpaceAABB()
		} )
		targetDir:Rotate(Angle(0,10,0))
		totalYaw = totalYaw + 10
		if (totalYaw >= 360) then
			totalYaw = 0
			targetDir:Rotate(Angle(-10,0,0))
			if math.abs(targetDir.z) == 1 then
				targetDir.z = targetDir.z * -1
			end
		end
	until not tr.Hit

	ply:SetPos(target)
end

function ENT:Think()
	local sphericalents = {}

	for k,ent in pairs(ents.FindInSphere(self.Entity:GetPos(),1000 * GetConVar("dac_zone_scale"):GetFloat())) do
		if ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == self:GetTeam() then
			--RestoreTools(ent)
		elseif ent:IsValid() and ent:IsPlayer() and ent:Team() != self:GetTeam() and ent:Team() != 3 then
			self.Entity:WarpToValidSpot(ent)
		end
		table.insert(sphericalents, ent)
	end

	for k,ent in pairs(ents.GetAll()) do

		if ent:IsPlayer() then
			entTeam = ent:Team()
		end

		if ent:IsValid() and entTeam == self:GetTeam() and table.HasValue(sphericalents,ent) == false then
			if ent:IsPlayer() then
				ent:ExitVehicle()
				ent:Spawn()
			elseif ent.IsFlagBase then
				if (ent:GetTeam() == self:GetTeam()) then
					ent:SetPos(self.Entity:GetPos() + Vector(-100,0,10))
					ent:SetAngles(Angle(0,0,0))
				end
			elseif ent.IsSpawnRegion then
				if (ent:GetTeam() == self:GetTeam()) then
					ent:SetPos(self.Entity:GetPos() + Vector(100,0,5))
					ent:SetAngles(Angle(0,0,0))
				end
			end
		end
		
		self.Entity:SetModelScale(GetConVar("dac_zone_scale"):GetFloat())
	end
end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end