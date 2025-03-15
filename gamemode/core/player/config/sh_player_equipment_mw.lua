-- Primary weapons

local V = {

	Name = "MP5 SMG",
	Model = "models/weapons/w_smg1.mdl",
	Icon = "vgui/entities/mg_mpapa5.png",
	Class = "mg_mpapa5",
	Category = "Primary",
	Damage = 4,
	RPM = 800,
	Capacity = 45,
	AmmoType = "SMG1",
	Accuracy = "Low",
	Projectile = "Hitscan",
	Description = "The MP7, better known as the SMG-1, is a fully automatic compact submachine gun manufactured by Heckler & Koch.",

}
list.Set( "weapons_primary_mw", 1, V )

local V = {

	Name = "M4A1 Assault Rifle",
	Model = "models/weapons/w_irifle.mdl",
	Icon = "vgui/entities/mg_mike4.png",
	Class = "mg_mike4",
	Category = "Primary",
	Damage = 8,
	RPM = 600,
	Capacity = 30,
	AmmoType = "AR2",
	Accuracy = "Medium",
	Projectile = "Hitscan",
	Description = "The Overwatch Standard Issue Pulse Rifle (OSIPR), is an automatic Dark Fusion assault rifle manufactured by the Combine.",

}
list.Set( "weapons_primary_mw", 2, V )

local V = {

	Name = "870 Pump Shotgun",
	Model = "models/weapons/w_shotgun.mdl",
	Icon = "vgui/entities/mg_romeo870.png",
	Class = "mg_romeo870",
	Category = "Primary",
	Damage = 8,
	RPM = 68,
	Capacity = 6,
	AmmoType = "Buckshot",
	Accuracy = "Spread",
	Projectile = "Hitscan",
	Description = "Chambered in 12-gauge, 7-pellet buckshot, the SPAS-12 is a pump-action shotgun manufactured by Luigi Franchi S.p.A.",

}
list.Set( "weapons_primary_mw", 3, V )

local V = {

	Name = "EBR-14 Marksman Rifle",
	Model = "models/weapons/w_crossbow.mdl",
	Icon = "vgui/entities/mg_mike14.png",
	Class = "mg_mike14",
	Category = "Primary",
	Damage = 100,
	RPM = 31,
	Capacity = 1,
	AmmoType = "XBowBolt",
	Accuracy = "High",
	Projectile = "Hitscan",
	Description = "A scoped, long-range crossbow built by the Human Resistance. Fires low-velocity, superheated rebar bolts in single action.",

}
list.Set( "weapons_primary_mw", 4, V )

local V = {

	Name = "SPR Bolt Rifle",
	Model = "models/weapons/w_crossbow.mdl",
	Icon = "vgui/entities/mg_romeo700.png",
	Class = "mg_romeo700",
	Category = "Primary",
	Damage = 100,
	RPM = 31,
	Capacity = 1,
	AmmoType = "XBowBolt",
	Accuracy = "High",
	Projectile = "Hitscan",
	Description = "A scoped, long-range crossbow built by the Human Resistance. Fires low-velocity, superheated rebar bolts in single action.",

}
list.Set( "weapons_primary_mw", 5, V )

-- Tools

local V = {

	Name = "Frag Grenade",
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

	Name = "RPG Launcher",
	--Model = "models/weapons/w_rocket_launcher.mdl",
	Model = "models/weapons/w_rpg.mdl",
	Icon = "entities/weapon_rpg.png",
	Class = "weapon_rpg",
	Category = "Equipment",
	Capacity = 3,
	AmmoType = "RPG_Round",
	Description = "A powerful lasaer-guided rocket launcher for vehicles, tanks and light armor.",

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
	Icon = "entities/weapon_lvsrepair.png",
	Class = "weapon_lvsrepair",
	Category = "Equipment",
	Capacity = 1,
	AmmoType = "None",
	Description = "A handheld tool for repairing ground and air vehicles.",

}
list.Set( "weapons_equipment", 4, V )

-- TODO: Add spotter tool