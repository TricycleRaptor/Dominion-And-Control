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

    self:NetworkVar("Int", 0, "Team", {
        KeyName = "team",
        Edit = {
            type = "Combo",
            values = teamList
        }
    })

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end