-- Overriding the HUD notices from Sandbox for weapon and ammo pickups
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/base/gamemode/cl_hudpickup.lua

function GM:HUDWeaponPickedUp( wep )
end

function GM:HUDItemPickedUp( itemname )
end

function GM:HUDAmmoPickedUp( itemname, amount )
end

function GM:HUDDrawPickupHistory()
end