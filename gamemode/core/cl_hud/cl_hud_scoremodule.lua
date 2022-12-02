local SH = ScrH()
local SW = ScrW()

local BLUE_PANE_POS = {x = SW * 0.45, y = (10)}
local BLUE_PANE_LENGTH = SW * 0.055 -- % of screen width
local BLUE_PANE_HEIGHT = 50

local RED_PANE_POS = {x = SW * 0.55, y = (10)}
local RED_PANE_LENGTH = SW * 0.055 -- % of screen width
local RED_PANE_HEIGHT = 50

local FLAG_PANE_POS = {x = 30, y = (SH - 100)}

local PANE_COLOR = Color(0, 0, 0, 235)
local GROUP_INDICATOR_WIDTH = 10
local ANGLE = 0.75

local animated_values = {
	blue_pane_height = 30,
    red_pane_height = 30
}

-- Drawing Team Indicators
local red_group_indicator_coordinates = {
	{x = RED_PANE_POS.x + RED_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = RED_PANE_POS.y},
	{x = RED_PANE_POS.x + RED_PANE_LENGTH, y = RED_PANE_POS.y},
	{x = RED_PANE_POS.x + RED_PANE_LENGTH - RED_PANE_HEIGHT * ANGLE, y = RED_PANE_POS.y + RED_PANE_HEIGHT},
	{x = RED_PANE_POS.x + RED_PANE_LENGTH - RED_PANE_HEIGHT * ANGLE - GROUP_INDICATOR_WIDTH, y = RED_PANE_POS.y + RED_PANE_HEIGHT}
}

local blue_group_indicator_coordinates = {
    {x = BLUE_PANE_POS.x - BLUE_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = BLUE_PANE_POS.y},
    {x = BLUE_PANE_POS.x - BLUE_PANE_LENGTH, y = BLUE_PANE_POS.y},
    {x = BLUE_PANE_POS.x - BLUE_PANE_LENGTH + BLUE_PANE_HEIGHT * ANGLE, y = BLUE_PANE_POS.y + BLUE_PANE_HEIGHT},
    {x = BLUE_PANE_POS.x - BLUE_PANE_LENGTH + BLUE_PANE_HEIGHT * ANGLE - GROUP_INDICATOR_WIDTH, y = BLUE_PANE_POS.y + BLUE_PANE_HEIGHT}
}

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

hook.Add("HUDPaint", "DAC.HudScoreModules", function()
    local gameStage = DAC:GetGameStage()
	local data = gameStage:GetData()

    if data.name == "MATCH" then

        -- We're just hard referencing team indexes for now. In the future, if we make this support multiple teams, we'll have to change this up a bit.
        drawTrapeziumReversed(BLUE_PANE_POS, BLUE_PANE_HEIGHT, BLUE_PANE_LENGTH, PANE_COLOR)
        surface.SetDrawColor(team.GetColor(1)) -- Blue team is index 1
        surface.DrawPoly(blue_group_indicator_coordinates)
        drawText({x = BLUE_PANE_POS.x - 35 , y = BLUE_PANE_POS.y + 0}, Color(255, 255, 255), "HUD.AmmoFont48", team.GetScore(1))

        drawTrapezium(RED_PANE_POS, RED_PANE_HEIGHT, RED_PANE_LENGTH, PANE_COLOR)
        surface.SetDrawColor(team.GetColor(2)) -- Red team is index 2
        surface.DrawPoly(red_group_indicator_coordinates)
        drawText({x = RED_PANE_POS.x + 10, y = RED_PANE_POS.y + 0}, Color(255, 255, 255), "HUD.AmmoFont48", team.GetScore(2))

    end

end)