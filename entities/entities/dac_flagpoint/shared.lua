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

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end