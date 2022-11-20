hook.Add("HUDPaint", "DAC.RenderBaseIcon", function()

    local baseIcon = Material("dominion/ui/base_indicator.png")

	for k, ent in pairs(ents.FindByClass("dac_flag")) do

		--if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > 100 ^ 2 then

			local baseIconVector = ent:GetPos() + Vector(0,0,1500)
			local renderContext = baseIconVector:ToScreen()
	
			surface.SetDrawColor(team.GetColor(ent:GetTeam()))
			surface.SetMaterial(baseIcon)
			surface.DrawTexturedRect(renderContext.x, renderContext.y, 40, 40)
			-- TODO: Rotate around origin to be center-oriented
			
		--end

	end

end)