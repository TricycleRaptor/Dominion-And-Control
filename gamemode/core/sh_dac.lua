DAC = DAC or {}
DAC.__index = DAC
DAC.GameStages = {}


--  ██████╗ ██████╗ ███╗   ██╗██╗   ██╗ █████╗ ██████╗ ███████╗
-- ██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔══██╗██╔══██╗██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║██║   ██║███████║██████╔╝███████╗
-- ██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
-- ╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ██║  ██║██║  ██║███████║
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

--DAC.ConVars = {}
--DAC.ConVars.buildTime = CreateConVar("dac_build_time", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED), "Time allocated for build stage.", 1, 60)

--  ██████╗  █████╗ ███╗   ███╗███████╗███████╗████████╗ █████╗  ██████╗ ███████╗
-- ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔════╝╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝
-- ██║  ███╗███████║██╔████╔██║█████╗  ███████╗   ██║   ███████║██║  ███╗█████╗
-- ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ╚════██║   ██║   ██╔══██║██║   ██║██╔══╝
-- ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗███████║   ██║   ██║  ██║╚██████╔╝███████╗
--  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝

hook.Add("Think", "DAC.GameStage.Think", function()
	local curGameStage = DAC:GetGameStage()
	if curGameStage then
		curGameStage:Think()

		local data = curGameStage:GetData()
		if SERVER then

			if data.nextStage and CurTime() >= curGameStage:GetEndTime() then
				local newStage = DAC.GameStage.New(data.nextStage)
				DAC:SetGameStage(newStage)
	
				if data.nextStage == GAMESTAGE_PLAY then
					BeginMatch() -- Run match preparations on players and the map, function is found in sv_dac.lua
				end
			end

			-- Handle overtime
			if data.name == "OVERTIME" then -- If we hit the overtime gamestage

				local teamScoreCard = {}

				for k, v in pairs (team.GetAllTeams()) do
					if k ~= 0 and k ~= 1001 and k ~= 1002 then -- Exclude connecting, unassigned, and spectator teams
						table.insert(teamScoreCard, k, team.GetScore(k))
					end
				end

				if GetConVar("dac_overtime"):GetBool() then -- Overtime enabled

					local tied = true
				  
					for _, score in pairs(teamScoreCard) do
					  if score ~= teamScoreCard[next(teamScoreCard)] then
						tied = false
						break
					  end
					end
				  
					if not tied then
					
					  -- Find team with highest score
					  local highestScore = 0
					  local winningTeam
				  
					  for teamId, score in pairs(teamScoreCard) do
						if score > highestScore then
						  highestScore = score
						  winningTeam = teamId
						end
					  end
				  
					  --print("[DAC DEBUG]: Winning team is " .. team.GetName(winningTeam))

					  local endStage = DAC.GameStage.New(GAMESTAGE_END)
					  DAC:SetGameStage(endStage)
					  DAC:SyncGameStage()
					  EndMatch(winningTeam)

					end

				else -- Overtime disabled

					local tied = true
				  
					for _, score in pairs(teamScoreCard) do
					  if score ~= teamScoreCard[next(teamScoreCard)] then
						tied = false
						break
					  end
					end
				  
					if tied then

					  -- Tied, announce draw, end match
					  --print("[DAC DEBUG]: Winning team is " .. team.GetName(1001) .. ", due to a tie.")

					  local endStage = DAC.GameStage.New(GAMESTAGE_END)
					  DAC:SetGameStage(endStage)
					  DAC:SyncGameStage()
					  EndMatch(1001)  -- Technically passing in the unassigned team, since it's a draw

					else

					  -- Find team with highest score
					  local highestScore = 0
					  local winningTeam
				  
					  for teamId, score in pairs(teamScoreCard) do
						if score > highestScore then
						  highestScore = score
						  winningTeam = teamId
						end
					  end
				  
					  --print("[DAC DEBUG]: Winning team is " .. team.GetName(winningTeam) "!")

					  local endStage = DAC.GameStage.New(GAMESTAGE_END)
					  DAC:SetGameStage(endStage)
					  DAC:SyncGameStage()
					  EndMatch(winningTeam)

					end

				end

			end	

		end
	end
end)

--[[hook.Add("Think", "DAC.TableChecking", function()
	if SERVER then

		teamScoreCard = {}
		for k, v in pairs (team.GetAllTeams()) do
			if k ~= 0 and k~= 1001 and k ~= 1002 then -- Exclude connecting, unassigned, and spectator teams
				table.insert(teamScoreCard, k, team.GetScore(k))
			end
		end

	end
end)]]

hook.Add("Initialize", "DAC.GamemodeInitialLoad", function()
	local defaultStage = DAC.GameStage.New(DAC.DefaultGameStage)
	DAC:SetGameStage(defaultStage)
end)

function DAC:RegisterGameStage(key, data)
	self.GameStages[key] = data
end

function DAC:GetGameStage()
	return self.CurrentGameStage
end

function DAC:SetGameStage(gameStage)
	self.CurrentGameStage = gameStage
	if SERVER then
		self:SyncGameStage()
	end
end