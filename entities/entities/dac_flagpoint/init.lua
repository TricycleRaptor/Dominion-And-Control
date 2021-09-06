AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/ctf_flagbase/ctf_flagbase.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	local flagEnt = ents.Create("dac_flag")
	flagEnt:SetPos(self:GetFlagPos())
	flagEnt:Spawn()
	flagEnt:SetParent(self)

	self.ChildFlag = flagEnt

	-- Set a base condition for the networked vars
	-- The flag starts attached to the flag, so adjust these values accordingly
	self:SetHasFlag(true)

end

function ENT:Think()


end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)
	self.ChildFlag:SetTeam(newValue)

end