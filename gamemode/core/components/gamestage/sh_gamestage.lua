DAC.GameStage = DAC.GameStage or {}

local GameStage = DAC.GameStage
GameStage.stage = 1
GameStage.startTime = 0
GameStage.active = false

GameStage.__index = GameStage
DAC.GameStage = GameStage

function net.WriteGameStage(gameStage)
	net.WriteInt(gameStage.stage, 32)
	net.WriteInt(gameStage.startTime, 32)
	net.WriteBool(gameStage.active)
end

function net.ReadGameStage()
	local gameStage = GameStage.New()
	gameStage.stage = net.ReadInt(32)
	gameStage.startTime = net.ReadInt(32)
	gameStage.active = net.ReadBool()

	return gameStage
end

function GameStage.New(stageId)
	local newGameStage = {}
	setmetatable(newGameStage, GameStage)

	if stageId then
		newGameStage:SetStage(stageId)
		newGameStage:Start()
	end

	return newGameStage
end

function GameStage:SetStage(stage)
	self.stage = stage
end

function GameStage:GetDuration()
	return self:GetData().duration or 0
end

function GameStage:Start()
	self.startTime = CurTime()
	self.active = true
end

function GameStage:GetEndTime()
	return self.startTime + (self:GetDuration() * 60)
end

function GameStage:GetTimeRemaining()
	return math.max(self:GetEndTime() - CurTime(), 0)
end

function GameStage:GetData()
	return DAC.GameStages[self.stage] or {}
end

function GameStage:Think()
	if self:GetData().name == "BUILD" then
		self:GetData().duration = GetConVar("dac_build_time"):GetInt() -- Dynamic cVar adjustment for build time
	end
end