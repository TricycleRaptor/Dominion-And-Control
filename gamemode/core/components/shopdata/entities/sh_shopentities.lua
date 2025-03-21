--- [ Ammo Crates Start ] ---

local V = {
	Name = "Pistol Supply Crate",
	Model = "models/items/ammocrate_pistol.mdl",
	Icon = "entities/shop_ammocrate_pistol.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_pistol",
	Cost = 300,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 1, V )

local V = {
	Name = "SMG Supply Crate",
	Model = "models/items/ammocrate_smg1.mdl",
	Icon = "entities/shop_ammocrate_smg.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_smg",
	Cost = 500,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 2, V )

local V = {
	Name = "AR2 Supply Crate",
	Model = "models/items/ammocrate_ar2.mdl",
	Icon = "entities/shop_ammocrate_ar2.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_ar2",
	Cost = 500,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 3, V )

local V = {
	Name = "Shotgun Supply Crate",
	Model = "models/items/ammocrate_buckshot.mdl",
	Icon = "entities/shop_ammocrate_shotgun.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_shotgun",
	Cost = 500,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 4, V )

local V = {
	Name = "RPG Supply Crate",
	Model = "models/items/ammocrate_rockets.mdl",
	Icon = "entities/shop_ammocrate_rpg.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_rpg",
	Cost = 1000,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 5, V )

local V = {
	Name = "Grenade Supply Crate",
	Model = "models/items/ammocrate_grenade.mdl",
	Icon = "entities/shop_ammocrate_grenade.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_grenade",
	Cost = 1000,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 6, V )

--- [ Ammo Crates End ] ---

--- [ Point Defense Start ] ---

local V = {
	Name = "Combine Turret",
	Model = "models/combine_turrets/floor_turret.mdl",
	Icon = "entities/shop_combine_turret.png",
	ListName = "dac_defense",
	Category = "POINT DEFENSE",
	Class = "shop_combine_turret",
	Cost = 350,
	SpawnOffset = 10,
}
list.Set("dac_defense", 1, V )

local V = {
	Name = "Combine Mine",
	Model = "models/props_combine/combine_mine01.mdl",
	Icon = "entities/shop_combine_mine.png",
	ListName = "dac_defense",
	Category = "POINT DEFENSE",
	Class = "shop_combine_mine",
	Cost = 200,
	SpawnOffset = 5,
}
list.Set("dac_defense", 2, V )

local V = {
	Name = "AR3 Emplacement Gun",
	Model = "models/props_combine/bunker_gun01.mdl",
	Icon = "entities/shop_ar3.png",
	ListName = "dac_defense",
	Category = "POINT DEFENSE",
	Class = "shop_ar3",
	Cost = 350,
	SpawnOffset = 5,
}
list.Set("dac_defense", 3, V )

local V = {
	Name = "Vehicle Repair Station",
	Model = "models/props_vehicles/generatortrailer01.mdl",
	Icon = "entities/lvs_vehicle_repair.png",
	ListName = "dac_defense",
	Category = "UTILITY",
	Class = "lvs_vehicle_repair",
	Cost = 300,
	SpawnOffset = 5,
}
list.Set("dac_defense", 4, V )

local V = {
	Name = "Vehicle Gas Station",
	Model = "models/props_wasteland/gaspump001a.mdl",
	Icon = "entities/lvs_item_refuel.png",
	ListName = "dac_defense",
	Category = "UTILITY",
	Class = "lvs_item_refuel",
	Cost = 100,
	SpawnOffset = 5,
}
list.Set("dac_defense", 5, V )

local V = {
	Name = "Heli Ammo Station",
	Model = "models/balloons/hot_airballoon.mdl",
	Icon = "entities/lvs_vehicle_air_refil.png",
	ListName = "dac_defense",
	Category = "UTILITY",
	Class = "lvs_vehicle_air_refil",
	Cost = 300,
	SpawnOffset = 5,
}
list.Set("dac_defense", 6, V )

--- [ Point Defense End ] --- 

--- [ Physics Props Start ] ---

local V = {
	Name = "Concrete Barrier",
	Model = "models/props_c17/concrete_barrier001a.mdl",
	Icon = "entities/shop_physicsprop_concretebarrier.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_concretebarrier",
	Cost = 50,
	SpawnOffset = 5,
}
list.Set("dac_physicsprops", 1, V )

local V = {
	Name = "Barrel",
	Model = "models/props_c17/oildrum001.mdl",
	Icon = "entities/shop_physicsprop_barrel.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_barrel",
	Cost = 25,
	SpawnOffset = 5,
}
list.Set("dac_physicsprops", 2, V )

local V = {
	Name = "Explosive Barrel",
	Model = "models/props_c17/oildrum001_explosive.mdl",
	Icon = "entities/shop_physicsprop_explosivebarrel.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_explosivebarrel",
	Cost = 125,
	SpawnOffset = 5,
}
list.Set("dac_physicsprops", 3, V )

local V = {
	Name = "Wooden Crate",
	Model = "models/props_junk/wood_crate001a.mdl",
	Icon = "entities/shop_physicsprop_woodencrate.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_woodencrate",
	Cost = 25,
	SpawnOffset = 25,
}
list.Set("dac_physicsprops", 4, V )

local V = {
	Name = "Large Wooden Crate",
	Model = "models/props_junk/wood_crate002a.mdl",
	Icon = "entities/shop_physicsprop_largewoodencrate.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_largewoodencrate",
	Cost = 35,
	SpawnOffset = 25,
}
list.Set("dac_physicsprops", 5, V )

local V = {
	Name = "Sawblade (Single)",
	Model = "models/props_junk/sawblade001a.mdl",
	Icon = "entities/shop_physicsprop_sawbladesingle.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_sawbladesingle",
	Cost = 50,
	SpawnOffset = 5,
}
list.Set("dac_physicsprops", 6, V )

local V = {
	Name = "Sawblade (3 Pack)",
	Model = "models/props_junk/sawblade001a.mdl",
	Icon = "entities/shop_physicsprop_sawbladepack.png",
	ListName = "dac_physicsprops",
	Category = "PHYSICS OBJECTS",
	Class = "shop_physicsprop_sawbladepack",
	Cost = 125,
	SpawnOffset = 5,
}
list.Set("dac_physicsprops", 7, V )

--- [ Physics Props End ] --- 