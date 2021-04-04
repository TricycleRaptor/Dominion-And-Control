DAC = DAC or {}
DAC.__index = DAC
DAC.GameStages = {}


--  ██████╗ ██████╗ ███╗   ██╗██╗   ██╗ █████╗ ██████╗ ███████╗
-- ██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔══██╗██╔══██╗██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║██║   ██║███████║██████╔╝███████╗
-- ██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══██║██╔══██╗╚════██║
-- ╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ██║  ██║██║  ██║███████║
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝

DAC.ConVars = {}
DAC.ConVars.deathSound = CreateConVar("dac_death_sounds", 0, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED), "Play funny Death sounds")

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
		if data.nextAutoStage and CurTime() >= curGameStage:GetEndTime() then
			local newStage = DAC.GameStage.New(data.nextAutoStage)
			DAC:SetGameStage(newStage)
		end
	end
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