local ScoreboardDerma = nil
local SH = ScrH()
local SW = ScrW()

local PANE_COLOR = Color(0, 0, 0, 235)
local GROUP_INDICATOR_WIDTH = 10
local ANGLE = 0.75

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

function GM:ScoreboardShow()

    if !IsValid(ScoreboardDerma) then -- This is a basic check, create a derma panel if there isn't one
        ScoreboardDerma = vgui.Create("DFrame")
        ScoreboardDerma:SetSize(SW / 3, SH * 0.75)
        ScoreboardDerma:SetPos(SW / 3, SH / 10)
        ScoreboardDerma:SetTitle("")
        ScoreboardDerma:SetDraggable(false)
        ScoreboardDerma:ShowCloseButton(false)

        ScoreboardDerma.Paint = function() -- Paint is a 2D rendering context where custom elements are added, the DFrame VGUI sets everything in place

            --draw.RoundedBox(0, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(60,60,60,75)) -- Bounding box reference, comment/uncomment as needed
            local TITLE_PANE_POS = {x = 0 , y = 0} -- Needs to be {0, 0} to reference the derma panel top left corner, pretty fucking annoying. Thank you, Garry.
            local TITLE_PANE_LENGTH = ScoreboardDerma:GetWide()
            local TITLE_PANE_HEIGHT = ScoreboardDerma:GetTall() / 10

            local title_group_indicator_coordinates = {
                {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = TITLE_PANE_POS.y},
                {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH , y = TITLE_PANE_POS.y},
                {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - TITLE_PANE_HEIGHT * ANGLE, y = TITLE_PANE_POS.y + TITLE_PANE_HEIGHT},
                {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - TITLE_PANE_HEIGHT * ANGLE - GROUP_INDICATOR_WIDTH, y = TITLE_PANE_POS.y + TITLE_PANE_HEIGHT}
            }

            drawTrapezium(TITLE_PANE_POS, TITLE_PANE_HEIGHT, TITLE_PANE_LENGTH, PANE_COLOR)
            drawText({x = TITLE_PANE_POS.x + 30, y = TITLE_PANE_POS.y + 5}, Color(255, 255, 255), "DAC.ScoreboardName", "DOMINION & CONTROL")
            drawText({x = TITLE_PANE_POS.x + 30, y = TITLE_PANE_POS.y + 50}, Color(255, 255, 255), "DAC.ScoreboardTitle", GetHostName())
            
            surface.SetDrawColor(Color(100, 100, 100, 235))
            surface.DrawPoly(title_group_indicator_coordinates)
            
        end

    end

    if IsValid(ScoreboardDerma) then
        ScoreboardDerma:Show()
        ScoreboardDerma:MakePopup()
        ScoreboardDerma:SetKeyBoardInputEnabled(false)
    end
end

function GM:ScoreboardHide()
    if IsValid(ScoreboardDerma) then
        ScoreboardDerma:Hide()
    end
end