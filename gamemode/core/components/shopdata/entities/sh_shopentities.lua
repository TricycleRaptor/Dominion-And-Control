--- [ Ammo Crates Start ] ---

local V = {
	Name = "Pistol Supply Crate",
	Model = "models/items/ammocrate_pistol.mdl",
	Icon = "entities/shop_ammocrate_pistol.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_pistol",
	Cost = 500,
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
	Cost = 2000,
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
	Cost = 2000,
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
	Cost = 2000,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 4, V )

--[[local V = {
	Name = "Grenade Supply  Crate",
	Model = "models/items/ammocrate_grenade.mdl",
	Icon = "entities/shop_ammocrate_grenade.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_grenade",
	Cost = 1500,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 5, V )]]

local V = {
	Name = "RPG Supply Crate",
	Model = "models/items/ammocrate_rockets.mdl",
	Icon = "entities/shop_ammocrate_rpg.png",
	ListName = "dac_ammocrates",
	Category = "AMMO RESTOCK",
	Class = "shop_ammocrate_rpg",
	Cost = 2500,
	SpawnOffset = 9,
}
list.Set("dac_ammocrates", 5, V )

--- [ Ammo Crates End ] ---

--- [ Point Defense Start ] ---

local V = {
	Name = "Combine Turret",
	Model = "models/combine_turrets/floor_turret.mdl",
	Icon = "entities/shop_combine_turret.png",
	ListName = "dac_pointdefense",
	Category = "POINT DEFENSE",
	Class = "shop_combine_turret",
	Cost = 350,
	SpawnOffset = 10,
}
list.Set("dac_pointdefense", 1, V )

--- [ Point Defense End ] --- 