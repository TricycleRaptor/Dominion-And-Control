
hook.Add("HUDPaint", "DAC.HudGameStage", function()
	local w, h = ScrW(), ScrH()
	local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

	if data.showOnHud then
		local hudX = w *0.5
		local hudY = 10
		draw.SimpleTextOutlined(data.name, "DAC.GameStage", hudX, hudY, data.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
			if data.timed then
			local timeRemaining = math.Round(gameStage:GetTimeRemaining())
			local minutes = math.floor(timeRemaining / 60)
			local seconds = timeRemaining - (minutes * 60)
			if seconds < 10 then
				seconds = "0"..seconds
			end

			draw.SimpleTextOutlined(minutes..":"..seconds, "DAC.GameStage", hudX, hudY + h*0.04, data.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0,255))
		end
	end
end)