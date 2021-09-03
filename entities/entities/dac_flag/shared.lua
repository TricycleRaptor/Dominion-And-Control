ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Primary gamemode objective"
ENT.Category = "DAC"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Editable = true

function ENT:SetupDataTables()

    local teamList = {}

    for teamIndex, teamData in pairs(GAMEMODE.Teams) do
        teamList[teamData.name] = teamIndex
    end

    -- The second argument is a unique identifier slot in the backend
    -- You can have one of each data type in one slot
    -- Don't lose track of your shit, boss
    self:NetworkVar("Int", 0, "Team", {
        KeyName = "team",
        Edit = { -- Adds entity properties to the context menu for debug purposes
            type = "Combo",
            values = teamList -- Get team data from sh_teams.lua
        }
    })
    self:NetworkVar("Bool", 0, "Held")
    self:NetworkVar("Bool", 1, "OnBase")
    self:NetworkVar("Entity", 0, "Carrier")

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end

function ENT:Think()

    self:AnimateFlag()

end

function ENT:AnimateFlag()

    local numFrames = self.Entity:GetFlexNum()

	if numFrames == 0 then return end

	local totalTime = 2
	local frameTime = totalTime / numFrames

	local animTime = CurTime() % totalTime

	for i=0,(numFrames-1) do
		local progress = animTime / frameTime - i
		if progress <= 0 or progress > 1 then
			progress = 0
		end
		local prev = i - 1
		if prev < 0 then
			prev = numFrames - 1
		end
		self.Entity:SetFlexWeight(i, progress)
		if (progress > 0) then
			self.Entity:SetFlexWeight(prev, 1 - progress)
			return
		end
	end

end