--- [ Armed Vehicles Start ] ---
local V = {
	Name = "Panzer Wespe",
	Model = "models/diggercars/pz2/wespe_updated.mdl",
	ListName = "dac_lvs_tanks",
	Class = "lvs_wheeldrive_wespe",
    Icon = "entities/lvs_wheeldrive_wespe.png",
	Category = "Ground Assault",
    
	IsFlagTransport = false,
	Cost = 500,
	SpawnOffset = 20
}
list.Set("dac_lvs_tanks", "lvs_wheeldrive_wespe", V )

local V = {
	Name = "Panzer II",
	Model = "models/diggercars/pz2/pz2_ausf_c.mdl",
	ListName = "dac_lvs_tanks",
	Class = "lvs_wheeldrive_pz2c",
    Icon = "entities/lvs_wheeldrive_pz2c.png",
	Category = "Ground Assault",
    
	IsFlagTransport = false,
	Cost = 600,
	SpawnOffset = 20
}
list.Set("dac_lvs_tanks", "lvs_wheeldrive_pz2c", V )

local V = {
	Name = "Panzer III",
	Model = "models/diggercars/pz3/pz3_asuf_f.mdl",
	ListName = "dac_lvs_tanks",
	Class = "lvs_wheeldrive_pz3f",
    Icon = "entities/lvs_wheeldrive_pz3f.png",
	Category = "Ground Assault",
    
	IsFlagTransport = false,
	Cost = 700,
	SpawnOffset = 20
}
list.Set("dac_lvs_tanks", "lvs_wheeldrive_pz3f", V )

--- [ Armed Vehicles End ] ---