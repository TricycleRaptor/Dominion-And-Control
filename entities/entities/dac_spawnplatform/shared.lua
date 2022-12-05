ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Team Spawn"
ENT.Author = "Arrin Bevers"
ENT.Purpose = "Gamemode team spawn"
ENT.Category = "DAC"

ENT.Spawnable = false
ENT.AdminSpawnable = true
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

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end

function ENT:PhysicsUpdate( phys )

	local angles = phys:GetAngles()
	phys:GetEntity():SetAngles(Angle(0,angles.y,0))
	phys:SetAngles(Angle(0,angles.y,0))

end