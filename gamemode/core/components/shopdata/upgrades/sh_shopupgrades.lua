--- [ Ammo Items Start ] --- 

local V = {
	Name = "Pistol Ammo Pack",
	Model = "models/items/boxsrounds.mdl",
	Icon = "entities/shop_ammo_pistol.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_pistol",
	Cost = 25,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 1, V )

local V = {
	Name = "SMG Ammo Pack",
	Model = "models/items/boxmrounds.mdl",
	Icon = "entities/shop_ammo_smg.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_smg",
	Cost = 50,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 2, V )

local V = {
	Name = "AR2 Ammo Pack",
	Model = "models/items/combine_rifle_cartridge01.mdl",
	Icon = "entities/shop_ammo_ar2.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_ar2",
	Cost = 50,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 3, V )

local V = {
	Name = "Shotgun Ammo Pack",
	Model = "models/items/boxbuckshot.mdl",
	Icon = "entities/shop_ammo_shotgun.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_shotgun",
	Cost = 50,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 4, V )

local V = {
	Name = "Crossbow Ammo Pack",
	Model = "models/items/crossbowrounds.mdl",
	Icon = "entities/shop_ammo_crossbow.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_crossbow",
	Cost = 100,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 5, V )

local V = {
	Name = "RPG Missile",
	Model = "models/weapons/w_missile_closed.mdl",
	Icon = "entities/shop_ammo_rpg.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_rpg",
	Cost = 100,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 6, V )

local V = {
	Name = "SMG Grenade",
	Model = "models/items/ar2_grenade.mdl",
	Icon = "entities/shop_ammo_smg_grenade.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_smg_grenade",
	Cost = 225,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 7, V )

local V = {
	Name = "AR2 Fusion Charge",
	Model = "models/items/combine_rifle_ammo01.mdl",
	Icon = "entities/shop_ammo_ar2_comball.png",
	ListName = "dac_items_ammo",
	Category = "AMMO RESUPPLY",
	Class = "shop_ammo_ar2_comball",
	Cost = 225,
	SpawnOffset = 5,
}
list.Set("dac_items_ammo", 8, V )

--- [ Ammo Items End ] --- 

--- [ Special Ammo Items Start ] --- 

local V = {
	Name = "Healthkit",
	Model = "models/items/healthkit.mdl",
	Icon = "entities/shop_item_healthkit.png",
	ListName = "dac_items_playersupplies",
	Category = "PLAYER SUPPLIES",
	Class = "shop_item_healthkit",
	Cost = 75,
	SpawnOffset = 5,
}
list.Set("dac_items_playersupplies", 1, V )

local V = {
	Name = "Armor Battery",
	Model = "models/items/battery.mdl",
	Icon = "entities/shop_item_battery.png",
	ListName = "dac_items_playersupplies",
	Category = "PLAYER SUPPLIES",
	Class = "shop_item_battery",
	Cost = 15,
	SpawnOffset = 5,
}
list.Set("dac_items_playersupplies", 2, V )

--- [ Special Ammo Items End ] --- 