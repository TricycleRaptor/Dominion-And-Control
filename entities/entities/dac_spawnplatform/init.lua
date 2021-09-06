AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.Entity:SetModel("models/ctf_spawnarea/ctf_spawnarea.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)

	self.Entity.IsSpawnRegion = true
	self.Entity.SpawnIndex = 0

end

function ENT:GetSpawnPos()

	local pos = self.Entity:GetPos() + Vector(0,0,10)
	local dir = Vector(0,0,0)
	if self.Entity.SpawnIndex > 0 then
		local angle = (self.Entity.SpawnIndex - 1) / (team.NumPlayers(self.Entity:GetTeam()) - 1) * math.pi * 2
		dir = self.Entity:GetForward() * math.sin(angle) + self.Entity:GetRight() * math.cos(angle)
	end
	self.Entity.SpawnIndex = (self.Entity.SpawnIndex + 1) % team.NumPlayers(self.Entity:GetTeam())

	return (pos + dir * 55)

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end