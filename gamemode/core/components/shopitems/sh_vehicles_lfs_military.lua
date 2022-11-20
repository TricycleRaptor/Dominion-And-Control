--- [ LFS Military Start ] ---

local V = {
	Name = "Resistance Helicopter",
	Model = "models/blu/helicopter.mdl",
	ListName = "dac_lfs_military",
    BaseClass = "lunasflightschool_basescript_heli",
	Class = "lunasflightschool_rebelheli",
    Icon = "entities/lunasflightschool_rebelheli.png",
	Category = "TRANSPORTATION",
    VehicleType = "lfs",
    IsFlagTransport = true,
	Cost = 750,
	SpawnOffset = 120,
}
list.Set("dac_lfs_military", 1, V )

local V = {
	Name = "Combine Helicopter",
	Model = "models/Combine_Helicopter.mdl",
	ListName = "dac_lfs_military",
    BaseClass = "lunasflightschool_basescript_heli",
	Class = "lunasflightschool_combineheli",
    Icon = "entities/lunasflightschool_combineheli.png",
	Category = "AERIAL ASSAULT",
    VehicleType = "lfs",
    IsFlagTransport = false,
	Cost = 1000,
	SpawnOffset = 120,
}
list.Set("dac_lfs_military", 2, V )

--- [ LFS Military End ] ---