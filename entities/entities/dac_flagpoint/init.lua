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
	self.Entity.IsFlagBase = true

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

function ENT:OnScoreChanged(_, oldValue, newValue) -- _ makes these unimportant

	--print("[DAC DEBUG]: Score network notify passed.")

	for k, v in pairs(team.GetAllTeams()) do
		if (k == self:GetTeam()) then
			
			-- print("[DAC DEBUG]: Team network comparison passed.")
			
			--team.SetScore(k, team.GetScore(k) + 1)
			team.SetScore(k, newValue)
		
			--print("[DAC DEBUG]: Blue team's score is " .. team.GetScore(1))
			--print("[DAC DEBUG]: Red team's score is " .. team.GetScore(2))

		end
	end

end