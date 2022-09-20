if CLIENT then

    ButtonNoise = Sound("buttons/lightswitch2.wav")
    OpenNoise = Sound("npc/scanner/scanner_scan4.wav")
    CloseNoise = Sound("npc/scanner/scanner_scan2.wav")
    ConfirmNoise = Sound("buttons/button14.wav")
    DenyNoise = Sound("buttons/button8.wav")

    local SH = ScrH()
    local SW = ScrW()

    local PANEL = {
        Init = function(self)

            self:SetSize(SW * 0.75, SH * 0.70)
            self:Center()
            self:SetVisible(true)
            local panelX, panelY = self:GetSize()

            --- MAIN PANEL SETUP ---

            local titleLabel = vgui.Create("DLabel", self)
            titleLabel:SetFont("DAC.PickTeam") -- Size 32px
            titleLabel:SetText("GAMEMODE MENU PROTOTYPE")
            titleLabel:SetPos(panelX * 0.01,6)
            titleLabel:SizeToContents()

            local creditsLabel = vgui.Create("DLabel", self)
            creditsLabel:SetFont("DAC.ScoreboardTitle") -- Size 22px
            creditsLabel:SetText( LocalPlayer():GetNWInt("storeCredits") .. " cR")
            creditsLabel:SetPos(panelX * 0.935, 12)
            creditsLabel:SizeToContents()

            local mainPanel = vgui.Create("DPanel", self)
            mainPanel:SetPos(4, 38)
            mainPanel:SetSize(panelX - 8, panelY - 38 - 4)
            mainPanel.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(100,100,100,100))
            end

            local mainColumnSheet = vgui.Create("DColumnSheet", mainPanel)
            mainColumnSheet:Dock(FILL)

            --- ITEMS TAB ---

            local shopSheet_Items = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Items:Dock(FILL)
            shopSheet_Items.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Entities", shopSheet_Items, "icon16/bricks.png")

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

                local loadoutSheet_Primary = vgui.Create("DPanel", shopSheet_Loadout)
                loadoutSheet_Primary:SetWide(shopSheet_Loadout:GetWide())
                loadoutSheet_Primary:Dock(LEFT)
                loadoutSheet_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(255,255,255))
                end
        
        end,

        Paint = function( self, w, h )
            draw.RoundedBox(3, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 240) )
            surface.SetDrawColor(255,255,255)
            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
        end

    }
    vgui.Register("dac_multimenu", PANEL)

    -- [PANEL ELEMENTS END] --

    function multiMenu()

        if !IsValid(MainMenu) then
            MainMenu = vgui.Create("dac_multimenu")
            MainMenu:SetVisible(false)
        end

        if MainMenu:IsVisible() then
            MainMenu:SetVisible(false)
            LocalPlayer():EmitSound(CloseNoise)
            gui.EnableScreenClicker(false)
        else
            MainMenu:SetVisible(true)
            LocalPlayer():EmitSound(OpenNoise)
            gui.EnableScreenClicker(true)
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