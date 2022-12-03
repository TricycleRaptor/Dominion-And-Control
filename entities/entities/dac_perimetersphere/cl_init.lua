include("shared.lua")

function ENT:DrawTranslucent()
	-- We're not going to draw these since they don't need to be visible. Good for debugging though
	--self.Entity:DrawModel()
	
	local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

    if data.name == "MATCH" then -- We should only draw these rings during the match
		local playerDistanceDelta = LocalPlayer():GetPos():Distance(self.Entity:GetPos()) - GetConVar("dac_zone_scale"):GetFloat() * 1000
		local colorR, colorG, colorB, colorA = team.GetColor(self.Entity:GetTeam()):Unpack()
		local adjustedColor = Color(colorR, colorG, colorB, colorA - Lerp((playerDistanceDelta  - 700) / 150, 90, 255))
		--local adjustedColor = Color(colorR, colorG, colorB, 255, 120, 255)
		if playerDistanceDelta < 1150 then -- Don't render at all if you're past the minimum vector fade, for optimization purposes
			render.StartWorldRings()
			-- Args: pos = where, radius = how big, [thicc = how thick, detail = how laggy]
			render.AddWorldRing(self.Entity:GetPos(), GetConVar("dac_zone_scale"):GetFloat() * 1000 + 20, 10, 60, adjustedColor)
			render.FinishWorldRings()
		end
	end

end