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