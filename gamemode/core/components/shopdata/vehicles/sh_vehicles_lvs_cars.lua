local V = {
	Name = "Willys Jeep",
	Model = "models/diggercars/willys/willys_mg.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_wheeldrive_dodwillyjeep_mg",
    Icon = "entities/lvs_wheeldrive_dodwillyjeep.png",
	Category = "Ground Assault",
    
	IsFlagTransport = true,
	Cost = 100,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_wheeldrive_dodwillyjeep_mg", V )

local V = {
	Name = "M5M16 Half-Track",
	Model = "models/diggercars/m5m16/m5m16.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_wheeldrive_dodhalftrack_us",
    Icon = "entities/lvs_wheeldrive_dodhalftrack_us.png",
	Category = "Anti-Air",
    
	IsFlagTransport = true,
	Cost = 500,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_wheeldrive_dodhalftrack_us", V )