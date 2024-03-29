ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SMG Ammo Crate"
ENT.Author = "Tricycle Raptor"
ENT.Purpose = "SMG ammo crate for the buy menu"
ENT.Category = "DAC Shop"

ENT.Cost = 2000
ENT.Model = "models/items/ammocrate_ar2.mdl"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Editable = true

function ENT:SetupDataTables()

    local teamList = {}

    for teamIndex, teamData in pairs(GAMEMODE.Teams) do
        teamList[teamData.name] = teamIndex --WIP
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