local V = {
	Name = "222 Scout Car",
	Model = "models/diggercars/222/222.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_wheeldrive_dodspaehwagen",
    Icon = "entities/lvs_wheeldrive_dodspaehwagen.png",
	Category = "Ground Assault",
    
	IsFlagTransport = true,
	Cost = 350,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_wheeldrive_dodspaehwagen", V )

local V = {
	Name = "Kuebel Wagon",
	Model = "models/diggercars/kubel/kubelwagen.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_wheeldrive_dodkuebelwagen",
    Icon = "entities/lvs_wheeldrive_dodkuebelwagen.png",
	Category = "Transportation",
    
	IsFlagTransport = true,
	Cost = 100,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_wheeldrive_dodkuebelwagen", V )

local V = {
	Name = "Schuet Half-Track",
	Model = "models/diggercars/sdkfz250/2501.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_wheeldrive_sdkfz250",
    Icon = "entities/lvs_wheeldrive_sdkfz250.png",
	Category = "Transportation",
    
	IsFlagTransport = true,
	Cost = 200,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_wheeldrive_sdkfz250", V )

local V = {
	Name = "Flak 38 Gun",
	Model = "models/blu/flak38.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_trailer_flak",
    Icon = "entities/lvs_trailer_flak.png",
	Category = "Transportation",
    
	IsFlagTransport = true,
	Cost = 250,
	SpawnOffset = 20
}
list.Set("dac_lvs_cars", "lvs_trailer_flak", V )

local V = {
	Name = "Flak 38 Trailer",
	Model = "models/blu/flakcarriage.mdl",
	ListName = "dac_lvs_cars",
	Class = "lvs_trailer_flaktrailer",
    Icon = "entities/lvs_trailer_flaktrailer.png",
	Category = "Transportation",

    IsFlagTransport = false,
	Cost = 50,

	SpawnOffset = 20,
	SpawnAngleOffset = 20
}
list.Set("dac_lvs_cars", "lvs_trailer_flaktrailer", V )