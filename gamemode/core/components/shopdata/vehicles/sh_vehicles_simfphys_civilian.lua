--- [ Civilian Vehicles Start ] ---

local V = {
	Name = "Dune Buggy",
	Model = "models/buggy.mdl",
	ListName = "dac_simfphys_civilian",
	BaseClass = "gmod_sent_vehicle_fphysics_base",
	Class = "sim_fphys_jeep",
    Icon = "entities/sim_fphys_jeep.png",
	Category = "TRANSPORTATION",
    VehicleType = "simfphys",
    IsFlagTransport = true,
	Cost = 100,

	SpawnOffset = 20,
	
	Members = {
		Mass = 1700,
		
		--OnTick = function(ent) print("hi") end,
		--OnSpawn = function(ent) print("i spawned") end,
		--OnDelete = function(ent) print("im removed :(") end,
		--OnDestroyed = function(ent) print("im destroyed :((((") end,
		
		LightsTable = "jeep",
		
		FrontWheelRadius = 18,
		RearWheelRadius = 20,
		
		CustomMassCenter = Vector(0,0,0),
		
		SeatOffset = Vector(0,0,-2),
		SeatPitch = 0,
		
		SpeedoMax = 120,

		StrengthenSuspension = false,
		
		FrontHeight = 13.5,
		FrontConstant = 27000,
		FrontDamping = 2800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 13.5,
		RearConstant = 32000,
		RearDamping = 2900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 44,
		Efficiency = 1.337,
		GripOffset = 0,
		BrakePower = 40,
		
		IdleRPM = 750,
		LimitRPM = 6500,

		PeakTorque = 100,
		PowerbandStart = 2200,
		PowerbandEnd = 6300,
		
		FuelFillPos = Vector(17.64,-14.55,30.06),
		
		PowerBias = 0.5,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/jeep/jeep_idle.wav",
		
		snd_low = "simulated_vehicles/jeep/jeep_low.wav",
		snd_low_revdown = "simulated_vehicles/jeep/jeep_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jeep/jeep_second.wav",

		snd_mid_pitch = 1,

		Sound_Idle = "simulated_vehicles/misc/nanjing_loop.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/misc/m50.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 58,
		Sound_MidFadeOutRate = 0.476,
		
		Sound_High = "simulated_vehicles/misc/v8high2.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.75,
		Sound_HighFadeInRPMpercent = 58,
		Sound_HighFadeInRate = 0.19,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "simulated_vehicles/horn_1.wav", 
		
		DifferentialGear = 0.3,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45}
	}
}
list.Set("dac_simfphys_civilian", "sim_fphys_jeep", V )

local V = {
	Name = "Transport Van",
	Model = "models/blu/van/pw_van.mdl",
	ListName = "dac_simfphys_civilian",
	BaseClass = "gmod_sent_vehicle_fphysics_base",
	Class = "sim_fphys_van",
    Icon = "entities/sim_fphys_pwvan.png",
	Category = "TRANSPORTATION",
    VehicleType = "simfphys",
    IsFlagTransport = true,
	Cost = 150,

	SpawnOffset = 20,
	
	Members = {
		Mass = 2500,
		
		EnginePos = Vector(89.98,0,51.3),
		
		LightsTable = "van",
		
		CustomWheels = true,
		CustomSuspensionTravel = 10,
		
		CustomWheelModel = "models/salza/van/van_wheel.mdl",
		CustomWheelPosFL = Vector(45,44,20),
		CustomWheelPosFR = Vector(45,-44,20),
		CustomWheelPosRL = Vector(-72,44,20),
		CustomWheelPosRR = Vector(-72,-44,20),
		CustomWheelAngleOffset = Angle(0,-90,0),
		
		CustomMassCenter = Vector(0,0,15),
		
		CustomSteerAngle = 35,
		
		SeatOffset = Vector(36,-23,72),
		SeatPitch = 8,
		SeatYaw = 90,
		
		PassengerSeats = {
			{
				pos = Vector(45,-27,33),
				ang = Angle(0,-90,9)
			},
			{
				pos = Vector(45,0,33),
				ang = Angle(0,-90,9)
			},
			{
				pos = Vector(-38,-29,28),
				ang = Angle(0,0,0)
			}
		},
		
		FrontHeight = 12,
		FrontConstant = 45000,
		FrontDamping = 3500,
		FrontRelativeDamping = 3500,
		
		RearHeight = 12,
		RearConstant = 45000,
		RearDamping = 3500,
		RearRelativeDamping = 3500,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 350,
		
		TurnSpeed = 8,
		
		MaxGrip = 45,
		Efficiency = 1.8,
		GripOffset = -2,
		BrakePower = 55,
		
		IdleRPM = 750,
		LimitRPM = 6000,
		PeakTorque = 95,
		PowerbandStart = 1000,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(-93.45,46.02,42.24),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/generic3/generic3_idle.wav",
		
		snd_low = "simulated_vehicles/generic3/generic3_low.wav",
		snd_low_revdown = "simulated_vehicles/generic3/generic3_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/generic3/generic3_mid.wav",
		snd_mid_gearup = "simulated_vehicles/generic3/generic3_second.wav",
		snd_mid_pitch = 1,
		
		DifferentialGear = 0.52,
		Gears = {-0.1,0,0.1,0.2,0.3,0.4}
	}
}
list.Set("dac_simfphys_civilian", "sim_fphys_van", V )

local V = {
	Name = "Pickup Truck",
	Model = "models/blu/avia/avia.mdl",
	ListName = "dac_simfphys_civilian",
	BaseClass = "gmod_sent_vehicle_fphysics_base",
	Class = "sim_fphys_pwavia",
    Icon = "entities/sim_fphys_pwavia.png",
	Category = "TRANSPORTATION",
    VehicleType = "simfphys",
    IsFlagTransport = true,
	Cost = 200,

	SpawnOffset = 20,
	SpawnAngleOffset = 90,

	Members = {
		Mass = 2500,
		
		EnginePos = Vector(49.37,-2.41,44.13),
		
		LightsTable = "avia",
		
		CustomWheels = true,
		CustomSuspensionTravel = 10,
		
		CustomWheelModel = "models/salza/avia/avia_wheel.mdl",
		CustomWheelPosFL = Vector(78,37,17),
		CustomWheelPosFR = Vector(78,-40,17),
		CustomWheelPosRL = Vector(-55,38.5,17),
		CustomWheelPosRR = Vector(-55,-37,17),
		CustomWheelAngleOffset = Angle(0,180,0),
		
		CustomMassCenter = Vector(0,0,5),
		
		CustomSteerAngle = 35,
		
		SeatOffset = Vector(55,-20,95),
		SeatPitch = 15,
		SeatYaw = 90,
		
		PassengerSeats = {
			{
				pos = Vector(79,-21,45),
				ang = Angle(0,-90,0)
			}
		},
		
		FrontHeight = 8,
		FrontConstant = 40000,
		FrontDamping = 3500,
		FrontRelativeDamping = 3500,
		
		RearHeight = 8,
		RearConstant = 40000,
		RearDamping = 3500,
		RearRelativeDamping = 3500,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 49,
		Efficiency = 1.1,
		GripOffset = -2,
		BrakePower = 45,	
		
		IdleRPM = 750,
		LimitRPM = 4200,
		PeakTorque = 160,
		PowerbandStart = 1500,
		PowerbandEnd = 3800,
		Turbocharged = false,
		Supercharged = false,
		
		FuelFillPos = Vector(9.79,35.14,30.77),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 100,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,
		
		snd_pitch = 1,
		snd_idle = "simulated_vehicles/jeep/jeep_idle.wav",
		
		snd_low = "simulated_vehicles/jeep/jeep_low.wav",
		snd_low_revdown = "simulated_vehicles/jeep/jeep_revdown.wav",
		snd_low_pitch = 0.9,
		
		snd_mid = "simulated_vehicles/jeep/jeep_mid.wav",
		snd_mid_gearup = "simulated_vehicles/jeep/jeep_second.wav", 
		snd_mid_pitch = 1,
		
		DifferentialGear = 0.45,
		Gears = {-0.15,0,0.15,0.25,0.35,0.45,0.52}
	}
}
list.Set("dac_simfphys_civilian", "sim_fphys_pwavia", V )

--- [ Civilian Vehicles End ] ---