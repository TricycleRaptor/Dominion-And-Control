hook.Add("HUDPaint", "DAC.HudGameStage", function()
	local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

	local w, h = ScrW(), ScrH()
	local hudX = w * 0.5
	local hudY = 10
	local stageNameDrawn = false

	if data.showOnHud then
		stageNameDrawn = true
		draw.SimpleTextOutlined(data.name, "DAC.GameStage", hudX, hudY, data.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
	end

	if data.duration then

		local timeRemaining = math.Round(gameStage:GetTimeRemaining())
		local minutes = math.floor(timeRemaining / 60)
		local seconds = timeRemaining - (minutes * 60)
		local timerYOffset = 0

		if stageNameDrawn == true then
			timerYOffset = 0.04
		else
			timerYOffset = 0
		end

		if seconds < 10 then
			seconds = "0"..seconds
		end

		draw.SimpleTextOutlined(minutes..":"..seconds, "DAC.GameStage", hudX, hudY + h * timerYOffset, data.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
	end

end)