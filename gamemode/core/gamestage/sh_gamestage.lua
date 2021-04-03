DAC.GameStage = DAC.GameStage or {}

local GameStage = DAC.GameStage
GameStage.stage = GAMESTAGE_BUILD
GameStage.duration = 10 -- minutes
GameStage.startTime = 0
GameStage.active = false

GameStage.__index = GameStage
DAC.GameStage = GameStage

function net.WriteGameStage(gameStage)
	net.WriteInt(gameStage.stage, 32)
	net.WriteInt(gameStage.duration, 32)
	net.WriteInt(gameStage.startTime, 32)
	net.WriteBool(gameStage.active)
end

function net.ReadGameStage()
	local gameStage = GameStage.New()
	gameStage.stage = net.ReadInt(32)
	gameStage.duragion = net.ReadInt(32)
	gameStage.startTime = net.ReadInt(32)
	gameStage.active = net.ReadBool()

	return gameStage
end

function GameStage.New()
	local newGameStage = {}
	setmetatable(newGameStage, GameStage)
	return newGameStage
end

function GameStage:SetStage(stage)
	self.stage = stage
end

function GameStage:SetDuration(minutes)
	self.duration = minutes
end

function GameStage:GetDuration()
	return self.duration
end

function GameStage:Start()
	self.startTime = CurTime()
	self.active = true
end

function GameStage:GetEndTime()
	return self.startTime + (self:GetDuration() * 60)
end

function GameStage:GetTimeRemaining()
	return self:GetEndTime() - CurTime()
end

function GameStage:GetData()
	return DAC.GameStages[self.stage] or {}
end