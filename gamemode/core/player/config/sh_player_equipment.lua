-- Primary weapons

local V = {

	Name = "SMG-1",
	Model = "models/weapons/w_smg1.mdl",
	Icon = "entities/weapon_smg1.png",
	Class = "weapon_smg1",
	Category = "Primary",
	Damage = 4,
	RPM = 800,
	Capacity = 45,
	AmmoType = "SMG1",
	Accuracy = "Low",
	Projectile = "Hitscan",
	Description = "The MP7, better known as the SMG-1, is a fully automatic compact submachine gun manufactured by Heckler & Koch.",

}
list.Set( "weapons_primary", 1, V )

local V = {

	Name = "Pulse Rifle",
	Model = "models/weapons/w_irifle.mdl",
	Icon = "entities/weapon_ar2.png",
	Class = "weapon_ar2",
	Category = "Primary",
	Damage = 8,
	RPM = 600,
	Capacity = 30,
	AmmoType = "AR2",
	Accuracy = "Medium",
	Projectile = "Hitscan",
	Description = "The Overwatch Standard Issue Pulse Rifle (OSIPR), is an automatic Dark Fusion assault rifle manufactured by the Combine.",

}
list.Set( "weapons_primary", 2, V )

local V = {

	Name = "Shotgun",
	Model = "models/weapons/w_shotgun.mdl",
	Icon = "entities/weapon_shotgun.png",
	Class = "weapon_shotgun",
	Category = "Primary",
	Damage = 8,
	RPM = 68,
	Capacity = 6,
	AmmoType = "Buckshot",
	Accuracy = "Spread",
	Projectile = "Hitscan",
	Description = "Chambered in 12-gauge, 7-pellet buckshot, the SPAS-12 is a pump-action shotgun manufactured by Luigi Franchi S.p.A.",

}
list.Set( "weapons_primary", 3, V )

local V = {

	Name = "Crossbow",
	Model = "models/weapons/w_crossbow.mdl",
	Icon = "entities/weapon_crossbow.png",
	Class = "weapon_crossbow",
	Category = "Primary",
	Damage = 100,
	RPM = 31,
	Capacity = 1,
	AmmoType = "XBowBolt",
	Accuracy = "High",
	Projectile = "Projectile",
	Description = "A scoped, long-range crossbow built by the Human Resistance. Fires low-velocity, superheated rebar bolts in single action.",

}
list.Set( "weapons_primary", 4, V )

--[[local V = {

	Name = ".357 Magnum",
	Model = "models/weapons/c_357.mdl",
	Icon = "entities/weapon_357.png",
	Class = "weapon_357",
	Category = "Primary",
	Damage = 40,
	RPM = 80,
	Capacity = 6,
	AmmoType = "357",
	Accuracy = "High",
	Projectile = "Hitscan",
	Description = "A pre-war Python revolver with a six-inch barrel, loaded in .357 caliber ammunition. Manufactured by Colt.",

}
list.Set( "weapons_primary", 5, V )]]

-- Tools

local V = {

	Name = "M83 Frag Grenade",
	Model = "models/weapons/w_grenade.mdl",
	Icon = "entities/weapon_frag.png",
	Class = "weapon_frag",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "Grenade",
	Description = "A standard fragmentation grenade with a laser diode countdown timer.",

}
list.Set( "weapons_equipment", 1, V )

local V = {

	Name = "AT4 Missile Launcher",
	--Model = "models/weapons/w_rocket_launcher.mdl",
	Model = "models/weapons/w_rpg.mdl",
	Icon = "entities/weapon_rpg.png",
	Class = "weapon_lfsmissilelauncher",
	Category = "Equipment",
	Capacity = 6,
	AmmoType = "RPG_Round",
	Description = "A powerful missile launcher with onboard radar for detecting and locking onto aircraft.",

}
list.Set( "weapons_equipment", 2, V )

local V = {

	Name = "Handheld Medkit",
	Model = "models/Items/HealthKit.mdl",
	Icon = "entities/weapon_medkit.png",
	Class = "weapon_medkit",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "None",
	Description = "A handheld medkit used for healing other players as well as the user.",

}
list.Set( "weapons_equipment", 3, V )

local V = {

	Name = "Vehicle Repair Tool",
	Model = "models/weapons/w_physics.mdl",
	Icon = "entities/weapon_simrepair.png",
	Class = "weapon_dac_vehiclerepair",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "None",
	Description = "A handheld tool for repairing and restocking purchasable vehicles.",

}
list.Set( "weapons_equipment", 4, V )

-- TODO: Add spotter tool