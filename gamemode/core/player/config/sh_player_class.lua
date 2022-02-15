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

    -- Give players their guaranteed weapons
    self.Player:Give("weapon_physcannon")
    self.Player:Give("weapon_crowbar")
    self.Player:Give("weapon_pistol")
    self.Player:StripWeapon("gmod_camera")

    -- We remove all ammo from the player and give them the pistol and ammo reserves with it because it is the guaranteed sidearm
    -- Giving ammo doesn't account the current mag in the weapon by default, so this is purely reserve
    -- This will change later
    self.Player:RemoveAllAmmo()
    self.Player:GiveAmmo(72, "Pistol", true)  -- 72/18 = 4! 4 mags! Ah-ah-ah! https://www.youtube.com/watch?v=B-Wd-Q3F8KM

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