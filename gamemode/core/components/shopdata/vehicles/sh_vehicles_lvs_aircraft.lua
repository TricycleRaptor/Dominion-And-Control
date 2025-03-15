local V = {
	Name = "P47 Thunderbolt",
	Model = "models/blu/p47.mdl",
	ListName = "dac_lvs_aircraft",
	Class = "lvs_plane_p47",
    Icon = "entities/lvs_plane_p47.png",
	Category = "Air Assault",

    IsFlagTransport = false,
	Cost = 1000,
	SpawnOffset = 120
}
list.Set("dac_lvs_aircraft", 1, V )

local V = {
	Name = "Combine Helicopter",
	Model = "models/Combine_Helicopter.mdl",
	ListName = "dac_lvs_aircraft",
	Class = "lvs_helicopter_combine",
    Icon = "entities/lvs_helicopter_combine.png",
	Category = "Air Assault",

    IsFlagTransport = false,
	Cost = 1500,
	SpawnOffset = 120
}
list.Set("dac_lvs_aircraft", 2, V )

local V = {
	Name = "Resistance Helicopter",
	Model = "models/blu/helicopter.mdl",
	ListName = "dac_lvs_aircraft",
	Class = "lvs_helicopter_rebel",
    Icon = "entities/lvs_helicopter_rebel.png",
	Category = "Transportation",

    IsFlagTransport = true,
	Cost = 500,
	SpawnOffset = 120
}
list.Set("dac_lvs_aircraft", 3, V )