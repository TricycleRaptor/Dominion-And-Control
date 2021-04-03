DAC = DAC or {}
DAC.__index = DAC
DAC.GameStages = {}

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