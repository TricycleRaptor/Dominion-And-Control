DEFINE_BASECLASS("player_default")
 
local PLAYER = {} 
 
PLAYER.SlowWalkSpeed = 80 -- Reduced speed for silent slow walk
PLAYER.WalkSpeed = 200 -- Default Half-Life 2 walk speed
PLAYER.RunSpeed = 350 -- Nerfed sprint speed by 12.5%

function PLAYER:Loadout()

    userTeam = self.Player:Team()
    -- Give the team captain their team setup, if their team isn't prepped
    if self.Player.IsCaptain and GAMEMODE.Teams[userTeam].baseSet == false then
        self.Player:Give("weapon_dac_baseselector")
    end

    -- Give players their gear
    self.Player:Give("weapon_physcannon")
    self.Player:Give("weapon_crowbar")
    self.Player:Give("weapon_pistol")
    self.Player:Give(self.Player.primaryWeapon)
    self.Player:Give(self.Player.specialWeapon)

    -- Giving ammo doesn't account the current mag in the weapon by default, so this is purely reserve
    self.Player:RemoveAllAmmo()
    self.Player:GiveAmmo(72, "Pistol", true)  -- 72/18 = 4! 4 mags! Ah-ah-ah! https://www.youtube.com/watch?v=B-Wd-Q3F8KM
    self.Player:GiveAmmo(180, "SMG1", true)
    self.Player:GiveAmmo(120, "AR2", true)
    self.Player:GiveAmmo(24, "Buckshot", true)
    self.Player:GiveAmmo(4, "XBowBolt", true)
    self.Player:GiveAmmo(1, "Grenade", true)
    -- This will change later, hard coded for now

    self.Player:StripWeapon("gmod_camera")

end

function PLAYER:GiveBuildTools()
    self.Player:Give("gmod_tool")
    self.Player:Give("weapon_physgun")
end

function PLAYER:RemoveBuildTools()
    self.Player:StripWeapon("gmod_tool")
    self.Player:StripWeapon("weapon_physgun")
end
 
player_manager.RegisterClass("DAC_playerclass", PLAYER, "player_default")