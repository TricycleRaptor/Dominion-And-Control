local SH = ScrH()
local SW = ScrW()

local HEALTH_PANE_POS = {x = 30, y = (SH - 100)}
local HEALTH_PANE_LENGTH = SW * 0.20 -- % of screen width
local HEALTH_PANE_HEIGHT = 60

local AMMO_PANE_POS = {x = SW - 30, y = (SH - 100)}
local AMMO_PANE_LENGTH = SW * 0.115 -- % of screen width
local AMMO_PANE_HEIGHT = 60

local PANE_COLOR = Color(0, 0, 0, 235)
local GROUP_INDICATOR_WIDTH = 10
local ANGLE = 0.75

local animated_values = {
	current_health = 0,
	armor = 0,
	health_pane_height = 30,
	secondary_ammo_pane_length = 0,
	fps = 0
}

local fps = 0

-- HUD Elements
local function drawTrapezium(position, height, length, color)
	local trapezium_coordinates = {
		{x = math.max(position.x, position.x), y = position.y},
		{x = math.max(position.x + length, position.x), y = position.y},
		{x = math.max(position.x + length - height * ANGLE, position.x), y = position.y + height},
		{x = math.max(position.x, position.x), y = position.y + height}
	}
	surface.SetDrawColor(color)
	surface.DrawPoly(trapezium_coordinates)
end

local function drawTrapeziumReversed(position, height, length, color)
	local trapezium_coordinates = {
		{x = math.min(position.x - length, position.x), y = position.y},
		{x = math.min(position.x, position.x), y = position.y},
		{x = math.min(position.x, position.x), y = position.y + height},
		{x = math.min(position.x - length + height * ANGLE, position.x), y = position.y + height}
	}
	surface.SetDrawColor(color)
	surface.DrawPoly(trapezium_coordinates)
end

local function drawText(position, color, font, text)
	surface.SetFont(font)
	surface.SetTextColor(color)
	surface.SetTextPos(position.x, position.y)
	surface.DrawText(text)
end

-- Disable Default HUD
hook.Add("HUDShouldDraw", "DAC.DisableDefaultHud", function(part_name)
	if part_name == "CHudBattery" or part_name == "CHudHealth" or part_name == "CHudAmmo" or part_name == "CHudSecondaryAmmo" or part_name == "CHudSuitPower" then
		return false
	end
end)

hook.Add("HUDPaint", "DAC.MainFrameHud", function()

	local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

	if not LocalPlayer():Alive() or data.name == "END" then -- Hide if dead
		return
	end

	local current_health = LocalPlayer():Health()
	local max_health = LocalPlayer():GetMaxHealth()
	local current_armor = LocalPlayer():Armor()
	local active_weapon = LocalPlayer():GetActiveWeapon()
	local clip1 = active_weapon:IsValid() and {active_weapon:Clip1(), active_weapon:GetMaxClip1()} or nil
	local clip2 = active_weapon:IsValid() and {active_weapon:Clip2(), active_weapon:GetMaxClip2()} or nil
	local primary_ammo_id = active_weapon:IsValid() and active_weapon:GetPrimaryAmmoType() or -1
	local secondary_ammo_id = active_weapon:IsValid() and active_weapon:GetSecondaryAmmoType() or -1
	local primary_ammo_amount = LocalPlayer():GetAmmoCount(primary_ammo_id)
	local secondary_ammo_amount = LocalPlayer():GetAmmoCount(secondary_ammo_id)
	local ping = LocalPlayer():Ping()

	local local_health_pane_height = (current_armor > 0) and HEALTH_PANE_HEIGHT or HEALTH_PANE_HEIGHT / 2 + 5
	local local_secondary_ammo_pane_length = secondary_ammo_id ~= -1 and (80 + (#tostring(secondary_ammo_amount) - 1) * 10) or 0

	animated_values.current_health = Lerp(0.05, animated_values.current_health, current_health)
	animated_values.armor = math.Round(animated_values.health_pane_height) == local_health_pane_height and Lerp(0.05, animated_values.armor, current_armor) or animated_values.armor
	animated_values.health_pane_height = Lerp(0.1, animated_values.health_pane_height, local_health_pane_height)
	animated_values.secondary_ammo_pane_length = Lerp(0.1, animated_values.secondary_ammo_pane_length, local_secondary_ammo_pane_length)
	animated_values.fps = Lerp(0.1, animated_values.fps, Lerp(0.05, animated_values.fps, 1 / FrameTime()))

	draw.NoTexture()

	-- Health Panel
	drawTrapezium(HEALTH_PANE_POS, animated_values.health_pane_height, HEALTH_PANE_LENGTH, PANE_COLOR)
	drawTrapezium({x = HEALTH_PANE_POS.x + 5, y = HEALTH_PANE_POS.y + 5}, HEALTH_PANE_HEIGHT / 2 - 5, HEALTH_PANE_LENGTH - 15 - GROUP_INDICATOR_WIDTH, Color(56, 0, 0, 240)) -- Max HP
	drawTrapezium({x = HEALTH_PANE_POS.x + 5, y = HEALTH_PANE_POS.y + 5}, HEALTH_PANE_HEIGHT / 2 - 5, (HEALTH_PANE_LENGTH - 15 - GROUP_INDICATOR_WIDTH) * math.min(animated_values.current_health / max_health, 1), (current_health <= max_health) and Color(255, 0, 0, 240) or Color(200, 100, 20, 240)) -- Current HP

	drawText({x = HEALTH_PANE_POS.x + 10, y = HEALTH_PANE_POS.y + 5}, Color(255, 255, 255), "Trebuchet24", math.max(current_health, 0))
	drawText({x = HEALTH_PANE_POS.x + 10 + math.max(#tostring(max_health), #tostring(current_health)) * 12, y = HEALTH_PANE_POS.y + 13}, Color(255, 255, 255), "TargetIDSmall", "/ " .. max_health)

	if current_armor > 0 and math.Round(animated_values.health_pane_height) == local_health_pane_height then
		drawTrapezium({x = HEALTH_PANE_POS.x + 5, y = HEALTH_PANE_POS.y + 5 + HEALTH_PANE_HEIGHT / 2}, HEALTH_PANE_HEIGHT / 2 - 10, HEALTH_PANE_LENGTH - 15 - GROUP_INDICATOR_WIDTH - HEALTH_PANE_HEIGHT * 0.4, Color(20, 40, 80, 240)) -- Max Armor
		drawTrapezium({x = HEALTH_PANE_POS.x + 5, y = HEALTH_PANE_POS.y + 5 + HEALTH_PANE_HEIGHT / 2}, HEALTH_PANE_HEIGHT / 2 - 10, (HEALTH_PANE_LENGTH - 15 - GROUP_INDICATOR_WIDTH - HEALTH_PANE_HEIGHT * 0.4) * (math.min(animated_values.armor, 100) / 100), Color(20, 60, 200, 240)) -- Current Armor
		drawText({x = HEALTH_PANE_POS.x + 10, y = HEALTH_PANE_POS.y + 2 + HEALTH_PANE_HEIGHT / 2}, Color(255, 255, 255), "Trebuchet24", math.max(current_armor, 0))
	end

	-- Ammo Panel
	if active_weapon then --Is a weapon active?
		if primary_ammo_id ~= -1 then --If it has an ammo pool, we'll proceed
			drawTrapeziumReversed(AMMO_PANE_POS, AMMO_PANE_HEIGHT, AMMO_PANE_LENGTH, PANE_COLOR) --Build the basic shape

            if LocalPlayer():GetActiveWeapon():GetPrintName() != nil then
                drawText({x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH + 45, y = HEALTH_PANE_POS.y + 5}, Color(255, 255, 255), "HUD.AmmoFont13", LocalPlayer():GetActiveWeapon():GetPrintName())
            end
			if clip1[1] >= 0 and clip1[2] >= 0 then
				drawText({x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH + 45, y = HEALTH_PANE_POS.y + 25}, Color(255, 255, 255), "DermaLarge", clip1[1])
				drawText({x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH + 45 + math.max(#tostring(clip1[1]), #tostring(clip1[2])) * 17, y = HEALTH_PANE_POS.y + 35}, Color(255, 255, 255), "HUD.AmmoFont20", "\\" .. clip1[2])
			end
			drawText({x = AMMO_PANE_POS.x - 45 - #tostring(primary_ammo_amount) * 12, y = HEALTH_PANE_POS.y + 14}, Color(255, 255, 255), "HUD.AmmoFont48", primary_ammo_amount)
			local group_indicator_coordinates = {
				{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - GROUP_INDICATOR_WIDTH - animated_values.secondary_ammo_pane_length, y = AMMO_PANE_POS.y},
				{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = AMMO_PANE_POS.y},
				{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - GROUP_INDICATOR_WIDTH + AMMO_PANE_HEIGHT * ANGLE, y = AMMO_PANE_POS.y + AMMO_PANE_HEIGHT},
				{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - GROUP_INDICATOR_WIDTH + AMMO_PANE_HEIGHT * ANGLE - animated_values.secondary_ammo_pane_length, y = AMMO_PANE_POS.y + AMMO_PANE_HEIGHT}
			}
			surface.SetDrawColor(PANE_COLOR)
			surface.DrawPoly(group_indicator_coordinates)

			if math.Round(animated_values.secondary_ammo_pane_length) == local_secondary_ammo_pane_length and secondary_ammo_id ~= -1 then
				drawText({x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - 45 - #tostring(secondary_ammo_amount) * 17, y = HEALTH_PANE_POS.y + 5}, Color(255, 255, 255), "HUD.AmmoFont13", "ALT")
				drawText({x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - 15 - #tostring(secondary_ammo_amount) * 17, y = HEALTH_PANE_POS.y + 12}, Color(255, 255, 255), "HUD.AmmoFont48", secondary_ammo_amount)
			end
		end
	end

	-- Drawing Group Indicators
	local health_group_indicator_coordinates = {
		{x = HEALTH_PANE_POS.x + HEALTH_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = HEALTH_PANE_POS.y},
		{x = HEALTH_PANE_POS.x + HEALTH_PANE_LENGTH, y = HEALTH_PANE_POS.y},
		{x = HEALTH_PANE_POS.x + HEALTH_PANE_LENGTH - animated_values.health_pane_height * ANGLE, y = HEALTH_PANE_POS.y + animated_values.health_pane_height},
		{x = HEALTH_PANE_POS.x + HEALTH_PANE_LENGTH - animated_values.health_pane_height * ANGLE - GROUP_INDICATOR_WIDTH, y = HEALTH_PANE_POS.y + animated_values.health_pane_height}
	}
	surface.SetDrawColor(team.GetColor(LocalPlayer():Team())) -- Change this shape's color based on the player's team
	--surface.SetDrawColor(Color(100, 100, 100, 235))
	surface.DrawPoly(health_group_indicator_coordinates)

	if primary_ammo_id ~= -1 then
		local ammo_group_indicator_coordinates = {
			{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = AMMO_PANE_POS.y},
			{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH, y = AMMO_PANE_POS.y},
			{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH + AMMO_PANE_HEIGHT * ANGLE, y = AMMO_PANE_POS.y + AMMO_PANE_HEIGHT},
			{x = AMMO_PANE_POS.x - AMMO_PANE_LENGTH + AMMO_PANE_HEIGHT * ANGLE - GROUP_INDICATOR_WIDTH, y = AMMO_PANE_POS.y + AMMO_PANE_HEIGHT}
		}
		surface.SetDrawColor(team.GetColor(LocalPlayer():Team())) -- Change this shape's color based on the player's team
		--surface.SetDrawColor(Color(100, 100, 100, 235))
		surface.DrawPoly(ammo_group_indicator_coordinates)
	end

	-- Ping & FPS
	--drawText({x = SW - 80, y = SH - 20}, Color(255, 255, 255), "Trebuchet18", ping .. "ms; " .. math.Round(animated_values.fps) .. "fps;")
end)