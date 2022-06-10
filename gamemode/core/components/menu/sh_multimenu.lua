if CLIENT then

    ButtonNoise = Sound("buttons/lightswitch2.wav")
    OpenNoise = Sound("npc/scanner/scanner_scan4.wav")
    CloseNoise = Sound("npc/scanner/scanner_scan2.wav")
    ConfirmNoise = Sound("buttons/button14.wav")
    DenyNoise = Sound("buttons/button8.wav")

    local MenuDerma = nil
    local SH = ScrH()
    local SW = ScrW()

    local PANE_COLOR = Color(15, 15, 15, 250)
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

    function multiMenu()

        if !IsValid(MenuDerma) then -- This is a basic check, create a derma panel if there isn't one
            MenuDerma = vgui.Create("DFrame")
            MenuDerma:SetSize(SW * 0.55, SH * 0.75)
            MenuDerma:Center()
            MenuDerma:SetTitle("")
            MenuDerma:SetDraggable(false)
            MenuDerma:ShowCloseButton(false)
            MenuDerma:SetDeleteOnClose(false)

            MenuDerma:SetMouseInputEnabled(true) -- Needs to be set on a panel made in the context of the dframe
            MenuDerma:SetKeyboardInputEnabled(true)

            MenuDerma:IsVisible()
            LocalPlayer():EmitSound(OpenNoise)
    
            MenuDerma.Paint = function() -- Paint is a 2D rendering context where custom elements are added, the DFrame VGUI sets everything in place
    
                draw.RoundedBox(0, 0, 0, MenuDerma:GetWide(), MenuDerma:GetTall(), Color(56,56,56,253))

                local TITLE_PANE_POS = {x = 0 , y = 0}
                local TITLE_PANE_LENGTH = MenuDerma:GetWide()
                local TITLE_PANE_HEIGHT = MenuDerma:GetTall() / 10
    
                local title_group_indicator_coordinates = {
                    {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - GROUP_INDICATOR_WIDTH, y = TITLE_PANE_POS.y},
                    {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH , y = TITLE_PANE_POS.y},
                    {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - TITLE_PANE_HEIGHT * ANGLE, y = TITLE_PANE_POS.y + TITLE_PANE_HEIGHT},
                    {x = TITLE_PANE_POS.x + TITLE_PANE_LENGTH - TITLE_PANE_HEIGHT * ANGLE - GROUP_INDICATOR_WIDTH, y = TITLE_PANE_POS.y + TITLE_PANE_HEIGHT}
                }
    
                drawTrapezium(TITLE_PANE_POS, TITLE_PANE_HEIGHT, TITLE_PANE_LENGTH, PANE_COLOR)
                drawText({x = TITLE_PANE_POS.x + 30, y = TITLE_PANE_POS.y + 5}, Color(255, 255, 255), "DAC.ScoreboardName", "DOMINION & CONTROL")
                drawText({x = TITLE_PANE_POS.x + 30, y = TITLE_PANE_POS.y + 50}, Color(255, 255, 255), "DAC.ScoreboardTitle", "Gamemode Menu")
                
                surface.SetDrawColor(Color(100, 100, 100, 159))
                surface.DrawPoly(title_group_indicator_coordinates)
                
            end
    
        else

            if MenuDerma:IsVisible() then
                MenuDerma:SetVisible(false)
                MenuDerma:SetMouseInputEnabled(false)
                MenuDerma:SetKeyboardInputEnabled(false)
                LocalPlayer():EmitSound(CloseNoise)
            else
                MenuDerma:SetVisible(true)
                MenuDerma:SetMouseInputEnabled(true)
                MenuDerma:SetKeyboardInputEnabled(true)
                LocalPlayer():EmitSound(OpenNoise)
            end
            
        end
    
    end
    concommand.Add("dac_multimenu", multiMenu)

end

if SERVER then

    local weaponList = list.Get("weapons_primary")
    local toolList = list.Get("weapons_equipment")
    local selectedWeapon = nil
    local selectedTool= nil

end