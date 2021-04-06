AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/ctf_flagbase/ctf_flagbase.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self.IsBase = true
	self.HasFlag = true

	local flagEnt = ents.Create("dac_flag")
	flagEnt:SetPos(self:GetFlagPos())
	flagEnt:Spawn()
	flagEnt:SetParent(self)

	self.ChildFlag = flagEnt

end

function ENT:Think()


end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)
	self.ChildFlag:SetTeam(newValue)

end