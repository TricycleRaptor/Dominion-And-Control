ammolimit = {}
ammolimit.convars = {}
-- Console variables
CreateConVar("maxammo_enabled", 			1, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)

-- Half-Life 2
CreateConVar("maxammo_pistol", 				108, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_357", 				36, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_smg1", 				270, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_smg1_grenade", 		3, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_ar2", 				180, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_ar2_ball", 			3, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_buckshot", 			36, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_crossbowbolt", 		10, 	{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_grenade", 			6, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_slam", 				5, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
CreateConVar("maxammo_rpg_round", 			3, 		{FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_ARCHIVE}, true)
 
function ammolimit.updateconvars ()
	-- Half-Life 2
	maxammo_enabled = 		GetConVarNumber("maxammo_enabled")
	maxammo_Pistol = 		GetConVarNumber("maxammo_pistol")
	maxammo_357 = 			GetConVarNumber("maxammo_357")
	maxammo_SMG1 = 			GetConVarNumber("maxammo_smg1")
	maxammo_SMG1_Grenade = 	GetConVarNumber("maxammo_smg1_grenade")
	maxammo_AR2 = 			GetConVarNumber("maxammo_ar2")
	maxammo_AR2AltFire = 	GetConVarNumber("maxammo_ar2_ball")
	maxammo_Buckshot = 		GetConVarNumber("maxammo_buckshot")
	maxammo_XBowBolt = 		GetConVarNumber("maxammo_crossbowbolt")
	maxammo_Grenade = 		GetConVarNumber("maxammo_grenade")
	maxammo_slam = 			GetConVarNumber("maxammo_slam")
	maxammo_RPG_Round = 	GetConVarNumber("maxammo_rpg_round")
end


hook.Add( "Think", "ammolimit", function (Player)
	ammolimit.updateconvars ()
	
	if maxammo_enabled == 1 then
		for pn,pl in pairs(player.GetAll()) do
			
			--//////////////////////////////////////// Half-Life 2 ////////////////////////////////////////
			if pl:GetAmmoCount("357")> maxammo_357 then		
				pl:RemoveAmmo( pl:GetAmmoCount("357")-maxammo_357, "357" )
			end
			
			if pl:GetAmmoCount("AR2")>maxammo_AR2 then		
				pl:RemoveAmmo( pl:GetAmmoCount("AR2")-maxammo_AR2, "AR2" )
			end
			
			if pl:GetAmmoCount("AR2AltFire")>maxammo_AR2AltFire then		
				pl:RemoveAmmo( pl:GetAmmoCount("AR2AltFire")-maxammo_AR2AltFire, "AR2AltFire" )
			end
			
			if pl:GetAmmoCount("Buckshot")>maxammo_Buckshot then		
				pl:RemoveAmmo( pl:GetAmmoCount("Buckshot")-maxammo_Buckshot, "Buckshot" )
			end
			
			if pl:GetAmmoCount("XBowBolt")>maxammo_XBowBolt then		
				pl:RemoveAmmo( pl:GetAmmoCount("XBowBolt")-maxammo_XBowBolt, "XBowBolt" )
			end
		
			if pl:GetAmmoCount("Grenade")>maxammo_Grenade then		
				pl:RemoveAmmo( pl:GetAmmoCount("Grenade")-maxammo_Grenade, "Grenade" )
			end
		
			if pl:GetAmmoCount("slam")>maxammo_slam then		
				pl:RemoveAmmo( pl:GetAmmoCount("slam")-maxammo_slam, "slam" )
			end
			
			if pl:GetAmmoCount("Pistol")>maxammo_Pistol then		
				pl:RemoveAmmo( pl:GetAmmoCount("Pistol")-maxammo_Pistol, "Pistol" )
			end
			
			if pl:GetAmmoCount("RPG_Round")>maxammo_RPG_Round then		
				pl:RemoveAmmo( pl:GetAmmoCount("RPG_Round")-maxammo_RPG_Round, "RPG_Round" )
			end
			
			if pl:GetAmmoCount("SMG1")>maxammo_SMG1 then		
				pl:RemoveAmmo( pl:GetAmmoCount("SMG1")-maxammo_SMG1, "SMG1" )
			end
			
			if pl:GetAmmoCount("SMG1_Grenade")>maxammo_SMG1_Grenade then		
				pl:RemoveAmmo( pl:GetAmmoCount("SMG1_Grenade")-maxammo_SMG1_Grenade, "SMG1_Grenade" )
			end

		end
	end
end)