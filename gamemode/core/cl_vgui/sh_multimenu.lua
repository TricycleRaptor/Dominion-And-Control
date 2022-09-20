if CLIENT then

    ButtonNoise = Sound("buttons/lightswitch2.wav")
    OpenNoise = Sound("npc/scanner/scanner_scan4.wav")
    CloseNoise = Sound("npc/scanner/scanner_scan2.wav")
    ConfirmNoise = Sound("buttons/button14.wav")
    DenyNoise = Sound("buttons/button8.wav")

    local SH = ScrH()
    local SW = ScrW()

    MENU_FRAME = MENU_FRAME or nil
    function multiMenu()     

        -- Menu button was pushed and the frame isn't valid, so we'll create it
        if !IsValid(MENU_FRAME) then

            LocalPlayer():EmitSound(OpenNoise)
            gui.EnableScreenClicker(true)

            -- MAIN FRAME SETUP --
            
            MENU_FRAME = vgui.Create( "DFrame" )
            MENU_FRAME:SetSize(SW * 0.70, SH * 0.70)
            MENU_FRAME:Center()
            MENU_FRAME:ShowCloseButton(false)
            MENU_FRAME:SetDraggable(false)
            MENU_FRAME:SetTitle("")
            MENU_FRAME.Paint = function( self, w, h )
                draw.RoundedBox(3, 0, 0, MENU_FRAME:GetWide(), MENU_FRAME:GetTall(), Color(0, 0, 0, 240))
                surface.SetDrawColor(255,255,255)
                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
            end

            local panelX, panelY = MENU_FRAME:GetSize()

            --- MAIN PANELS SETUP ---

            local titleLabel = vgui.Create("DLabel", MENU_FRAME)
            titleLabel:SetFont("DAC.PickTeam") -- Size 32px
            titleLabel:SetText("GAMEMODE MENU PROTOTYPE")
            titleLabel:SetPos(panelX * 0.01,6)
            titleLabel:SizeToContents()

            local creditsLabel = vgui.Create("DLabel", MENU_FRAME)
            creditsLabel:SetFont("DAC.ScoreboardTitle") -- Size 22px
            creditsLabel:SetText( LocalPlayer():GetNWInt("storeCredits") .. " cR")
            creditsLabel:SetPos(panelX * 0.935, 12)
            creditsLabel:SizeToContents()

            local mainPanel = vgui.Create("DPanel", MENU_FRAME)
            mainPanel:SetPos(4, 38)
            mainPanel:SetSize(panelX - 8, panelY - 38 - 4)
            mainPanel.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(100,100,100,100))
            end

            local mainColumnSheet = vgui.Create("DColumnSheet", mainPanel)
            mainColumnSheet:Dock(FILL)
            mainColumnSheet:InvalidateParent(true)

            --- ITEMS TAB ---

            local shopSheet_Items = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Items:Dock(FILL)
            --shopSheet_Items:DockPadding(10,10,10,10)
            shopSheet_Items:InvalidateParent(true)
            shopSheet_Items.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Entities", shopSheet_Items, "icon16/bricks.png")

                local shopSheet_Primary = vgui.Create("DPanel", shopSheet_Items)
                shopSheet_Primary:SetWide(shopSheet_Items:GetWide() / 2)
                --shopSheet_Primary:DockMargin(10,10,10,10)
                shopSheet_Primary:Dock(LEFT)
                shopSheet_Primary:InvalidateParent(true)
                shopSheet_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,0)) -- Red for visualizing positioning
                end

                local shopSheet_Secondary = vgui.Create("DPanel", shopSheet_Items)
                shopSheet_Secondary:SetWide(shopSheet_Items:GetWide() / 2)
                --shopSheet_Secondary:DockMargin(10,10,10,10)
                shopSheet_Secondary:Dock(RIGHT)
                shopSheet_Secondary:InvalidateParent(true)
                shopSheet_Secondary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(0,35,131,0)) -- Blue for visualizing positioning
                end

            --- VEHICLE TAB ---

            local shopSheet_Vehicles = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Vehicles:Dock(FILL)
            shopSheet_Vehicles.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Vehicles", shopSheet_Vehicles, "icon16/car.png")

            --- UPGRADE TAB ---

            local shopSheet_Upgrades = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Upgrades:Dock(FILL)
            shopSheet_Upgrades.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Upgrades", shopSheet_Upgrades, "icon16/user_add.png")

            --- LOADOUT TAB ---

            local shopSheet_Loadout = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Loadout:Dock(FILL)
            shopSheet_Loadout.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Loadout", shopSheet_Loadout, "icon16/briefcase.png")

        else

            -- Menu button was pushed, and the frame is already open, so now we'll close it
            LocalPlayer():EmitSound(CloseNoise)
            gui.EnableScreenClicker(false)
            MENU_FRAME:Remove()
            MENU_FRAME = nil

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