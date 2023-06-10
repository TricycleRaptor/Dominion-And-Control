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
	-- The flag starts attached to the flagbase, so adjust these values accordingly
	self:SetHasFlag(true)

end

function ENT:Think()

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
	self:SetSkin(newValue)
	self.ChildFlag:SetTeam(newValue)
end

function ENT:OnScoreChanged(_, oldValue, newValue) -- _ makes these unimportant
	for k, v in pairs(team.GetAllTeams()) do
		if (k == self:GetTeam()) then
			team.SetScore(k, newValue)
			-- Maybe consider adding a win condition here as well, though it's not really necessary since this was more for testing purposes with the edit variables
		end
		if team.GetScore(k) >= GetConVar("dac_capture_target"):GetFloat() then
			local endStage = DAC.GameStage.New(GAMESTAGE_END)
			DAC:SetGameStage(endStage)
			DAC:SyncGameStage() -- Force gamestage into "end" stage so the game can time out, don't want an edge case of moving into overtime after the game is won
			EndMatch(k)
		end
	end
end