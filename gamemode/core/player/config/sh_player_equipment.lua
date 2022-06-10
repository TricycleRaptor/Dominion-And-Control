-- Primary weapons

local V = {

	Name = "Pulse Rifle",
	Model = "models/weapons/w_irifle.mdl",
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
list.Set( "weapons_primary", "weapon_ar2", V )

local V = {

	Name = "SMG-1",
	Model = "models/weapons/w_smg1.mdl",
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
list.Set( "weapons_primary", "weapon_smg1", V )

local V = {

	Name = "Shotgun",
	Model = "models/weapons/w_shotgun.mdl",
	Class = "weapon_shotgun",
	Category = "Primary",
	Damage = 56,
	RPM = 68,
	Capacity = 6,
	AmmoType = "Buckshot",
	Accuracy = "Low",
	Projectile = "Hitscan",
	Description = "Chambered in 12-gauge, 7-pellet buckshot, the SPAS-12 is a pump-action shotgun manufactured by Luigi Franchi S.p.A.",

}
list.Set( "weapons_primary", "weapon_shotgun", V )

local V = {

	Name = "Crossbow",
	Model = "models/weapons/w_crossbow.mdl",
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
list.Set( "weapons_primary", "weapon_crossbow", V )

-- Tools

local V = {

	Name = "M83 Frag Grenade",
	Model = "models/weapons/w_grenade.mdl",
	Class = "weapon_frag",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "Grenade",
	Description = "A standard fragmentation grenade with a laser diode countdown timer.",

}
list.Set( "weapons_equipment", "weapon_frag", V )

local V = {

	Name = "AT4 Missile Launcher",
	Model = "models/weapons/w_rocket_launcher.mdl",
	Class = "weapon_lfsmissilelauncher",
	Category = "Equipment",
	Capacity = 6,
	AmmoType = "RPG_Round",
	Description = "A powerful missile launcher with onboard radar for detecting and locking onto aircraft.",

}
list.Set( "weapons_equipment", "weapon_lfsmissilelauncher", V )

local V = {

	Name = "Medkit",
	Model = "models/Items/HealthKit.mdl",
	Class = "weapon_medkit",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "None",
	Description = "A handheld medkit used for healing other players as well as the user.",

}
list.Set( "weapons_equipment", "weapon_medkit", V )

-- TODO: Add spotter tool and vehicle repair tool