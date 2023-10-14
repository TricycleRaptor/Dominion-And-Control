local cleanUpEntities = {
	"item_*",  -- Parse any item entities spawned by the map like healthkits or ammo for removal
	"weapon_*"  -- Parse any weapon entities spawned by the map for remvoval
}

function CleanupMapEntities()
	-- This function will remove items we don't want from the map such as healthkits, ammo, and weapons. This is important for loadout integrity and also ensures
	-- that we can use any maps that may come with items on the map by default, such as the Half-Life 2: Deathmatch maps or something like gm_boreas.
	if SERVER then
		for _, class in pairs(cleanUpEntities) do
			for _, ent in pairs(ents.FindByClass(class)) do -- Find each weapon
				ent:Remove() -- Remove it
			end
		end
	end
end

function GM:InitPostEntity() -- This is called after the server has initialized the map and all entities within it
	CleanupMapEntities() -- Remove the entities we don't want in the map using the function defined in shared.lua
end

-- https://wiki.facepunch.com/gmod/GM:PostCleanupMap
hook.Add("PostCleanupMap", "DAC.MapCleaned", function(ply, cmd)

	CleanupMapEntities() -- Remove weapons and items from the map again after cleanup
	
	timer.Simple(0.1, function() -- I had to use an extra timer to ensure loadouts worked properly, Garry! Son of a cock!
		for _, ply in pairs(player.GetAll()) do

			ply:SetPlayerCarrierStatus(false) -- Set each player's flag carrier status to false if the map is cleaned up.
			ply:SetNWInt("storeCredits", GetConVar("dac_income_balance"):GetInt())
			ply:SetNWBool("IsSpawningVehicle", false)
			ply:SetNWBool("IsInBase", false)
			ply:SetFrags(0)
			ply:SetDeaths(0)
			player_manager.RunClass(ply, "Loadout") -- Get the player loadout

			if ply.IsCaptain then
				ply:Give("weapon_dac_baseselector")
				ply:SelectWeapon("weapon_dac_baseselector")
			else
				ply:SelectWeapon("weapon_physcannon")
			end

			for teamKey, teamData in pairs(GAMEMODE.Teams) do
				GAMEMODE.Teams[teamKey].basePos = nil
				GAMEMODE.Teams[teamKey].baseSet = false
				team.SetScore(teamKey, 0)
			end

			-- Remove passive timers for income
			if timer.Exists("DAC.timerSalary") then
				timer.Pause("DAC.timerSalary")
				timer.Remove("DAC.timerSalary")
			end

		end
	end)

	--PrintTable(GAMEMODE.Teams)
	local setupStage = DAC.GameStage.New(1) -- 1 is the ENUM for the setup phase
	DAC:SetGameStage(setupStage)
	DAC:SyncGameStage()
end)