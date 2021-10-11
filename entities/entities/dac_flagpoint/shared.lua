ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flag Point"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Base for flag objective"
ENT.Category = "DAC"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Editable = true

function ENT:GetFlagPos()
    return self:GetPos() + self:GetUp() * 10
end

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
        Edit = {
            type = "Combo",
            values = teamList
        }
    })
    self:NetworkVar("Bool", 0, "HasFlag")
    self:NetworkVar("Int", 1, "FlagScore", {
        KeyName = "flagscore",
        Edit = {
            type = "Int",
            min = 0,
            max = 3 -- We should change this to a CVAR value but for now we're hardcoding it to be three.
        }
    })

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)
        self:NetworkVarNotify("FlagScore", self.OnScoreChanged)

    end

end

function ENT:PhysicsUpdate( phys )

	local angles = phys:GetAngles()
	phys:GetEntity():SetAngles(Angle(0,angles.y,0))
	phys:SetAngles(Angle(0,angles.y,0))

end