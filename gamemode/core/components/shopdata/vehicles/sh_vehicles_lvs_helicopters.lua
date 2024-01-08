--- [ LFS Military Start ] ---

local V = {
	Name = "Attack Chopper",
	Model = "models/Combine_Helicopter.mdl",
	ListName = "dac_lvs_helicopters",
	Class = "lvs_helicopter_combine",
    Icon = "entities/lvs_helicopter_combine.png",
	Category = "Air Assault",

    IsFlagTransport = false,
	Cost = 1500,
	SpawnOffset = 120
}
list.Set("dac_lvs_helicopters", 1, V )

local V = {
	Name = "Transport Heli",
	Model = "models/blu/helicopter.mdl",
	ListName = "dac_lvs_helicopters",
	Class = "lvs_helicopter_rebel",
    Icon = "entities/lvs_helicopter_rebel.png",
	Category = "Transportation",

    IsFlagTransport = true,
	Cost = 500,
	SpawnOffset = 120
}
list.Set("dac_lvs_helicopters", 2, V )

--- [ LFS Military End ] ---