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
		if SERVER and data.nextStage and CurTime() >= curGameStage:GetEndTime() then
			local newStage = DAC.GameStage.New(data.nextStage)
			DAC:SetGameStage(newStage)
		end
	end
end)

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