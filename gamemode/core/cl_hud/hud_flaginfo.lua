local flagMat = Material("dominion/ui/flag.png")

local function DrawHUDFlagNotice(len, ply)

	local flag = net.ReadEntity()
	local heldBool = net.ReadBool()
	local flagTeam = flag:GetTeam()

	hook.Add("HUDPaint", "DAC.PlayerHoldingFlag", function()

		if heldBool == true then
			surface.SetDrawColor(team.GetColor(flagTeam))
			surface.SetMaterial(flagMat)
			surface.DrawTexturedRect(0, 0, 80, 80)
		end

	end)

end
net.Receive("SendFlagHUDNotify", DrawHUDFlagNotice)

hook.Add("HUDPaint", "DAC.RenderFlagIcon", function()

	for k, ent in pairs(ents.FindByClass("dac_flag")) do

		if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > 50 ^ 2 then

			local flagPosIconVector = ent:GetPos() + Vector(0,0,150)
			local renderContext = flagPosIconVector:ToScreen()
	
			surface.SetDrawColor(team.GetColor(ent:GetTeam()))
			surface.SetMaterial(flagMat)
			surface.DrawTexturedRect(renderContext.x, renderContext.y, 40, 40)
			-- TODO: Rotate around origin to be center-oriented
			
		end

	end

end)

hook.Add("HUDPaint", "DAC.RenderFlagClaim", function()

	local w, h = ScrW(), ScrH()
	local hudX = w * 0.465
	local hudY = h * 0.85

	for _, ent in pairs(ents.FindByClass("dac_flag")) do

		-- These conditions are not mutually exclusive, but cannot both be true simultaneously... Otherwise we have a problem, chief
		if ent:GetHeld() == false and ent:GetOnBase() == false then
			count = 200 - (CurTime() - ent:GetDropTime()) * 10
		else
			count = 200
		end

		-- Only draw countdown visuals for players that are on the team that the flag belongs to (Halo 3 Style)
		if LocalPlayer():GetPos():Distance(ent:GetPos()) <= 1200 and ent:GetHeld() == false and ent:GetOnBase() == false and ent:GetTeam() == LocalPlayer():Team() then 
			
			surface.SetDrawColor(0,0,0,235)
			surface.DrawRect( hudX, hudY, 200, 30)
			surface.SetDrawColor(team.GetColor(ent:GetTeam()))
			surface.DrawRect( hudX, hudY, count, 30)

		end

	end

end)