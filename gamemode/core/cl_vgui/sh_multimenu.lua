if CLIENT then

    -- UI Sounds --
    ButtonNoise = Sound("buttons/lightswitch2.wav")
    OpenNoise = Sound("npc/scanner/scanner_scan4.wav")
    CloseNoise = Sound("npc/scanner/scanner_scan2.wav")
    ConfirmNoise = Sound("buttons/button14.wav")
    DenyNoise = Sound("buttons/button8.wav")

    -- Tab Specific --
    OpenLoadoutTab = Sound("items/ammocrate_open.wav")
    SelectLoadoutOption = Sound("items/ammo_pickup.wav")

    local SH = ScrH()
    local SW = ScrW()

    -- Dynamic weapon vars
    local selectedPrimary = nil
    local selectedSpecial = nil

    -- Dynamic vehicle vars
    local selectedVehicle = nil
    local selectedVehicleModel = nil
    local selectedVehicleType = nil
    local selectedVehicleCategory = nil 
    local selectedVehicleTransportStatus = nil
    local selectedVehicleCost = nil
    local selectedVehicleClass = nil
    local selectedVehicleList = nil

    MENU_FRAME = MENU_FRAME or nil

    function multiMenu()

        -- Menu button was pushed and the frame isn't valid, so we'll create it
        if !IsValid(MENU_FRAME) then

            LocalPlayer():EmitSound(OpenNoise)
            gui.EnableScreenClicker(true)

            -- Before we do anything else, we should get the first index of the weapon lists. This allows us to retrieve the first class value regardless of what the list contains
            -- This should only be done once as not to override weapon selections once they've been picked, so we check for nil and then assign internally
            -- That way it'll never trip again beyond first opening the menu
            if selectedPrimary == nil or 
                selectedSpecial == nil or 
                selectedVehicle == nil or 
                selectedVehicleModel == nil or
                selectedVehicleType == nil or
                selectedVehicleCategory == nil or
                selectedVehicleTransportStatus == nil or
                selectedVehicleClass == nil or
                selectedVehicleList == nil then

                -- We assign the first class value to a variable that is used to drive the paint function on the selection buttons later
                -- Because those lists are populated by the same table in ascending order, the first value in the table should be highlighted on the UI
                for weaponIndex, weaponValue in pairs(list.Get("weapons_primary")) do
                    selectedPrimary = weaponValue.Class -- We're just getting the first value and breaking after that
                    --print("Assigned selectedPrimary as: " .. selectedPrimary)
                    break
                end
                    
                for weaponIndex, weaponValue in pairs(list.Get("weapons_equipment")) do
                    selectedSpecial = weaponValue.Class -- We're just getting the first value and breaking after that
                    --print("Assigned selectedSpecial as: " .. selectedSpecial)
                    break
                end

                for vehicleIndex, vehicleValue in pairs(list.Get("dac_simfphys_armed")) do
                    selectedVehicle = vehicleValue.Name -- We're just getting the first value and breaking after that
                    selectedVehicleModel = vehicleValue.Model
                    selectedVehicleType = vehicleValue.VehicleType
                    selectedVehicleCategory = vehicleValue.Category
                    selectedVehicleTransportStatus = vehicleValue.IsFlagTransport
                    selectedVehicleCost = vehicleValue.Cost
                    selectedVehicleClass = vehicleValue.Class
                    selectedVehicleList = vehicleValue.ListName
                    break
                end

            end

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
            creditsLabel:SetColor(Color(255,217,0))
            creditsLabel:SetText( LocalPlayer():GetNWInt("storeCredits") .. " cR") -- This will probably need to be moved to a think or paint function, just a placeholder for now
            creditsLabel:SetPos(panelX * 0.91, 12)
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

            --- VEHICLE TAB ---

            local shopSheet_Vehicles = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Vehicles:Dock(FILL)
            shopSheet_Vehicles:InvalidateParent(true)
            shopSheet_Vehicles.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Vehicles", shopSheet_Vehicles, "icon16/car.png")

                -- Divide the vehicles panel into two pieces, dock this child panel to the left
                local shopSheet_Vehicles_Primary = vgui.Create("DPanel", shopSheet_Vehicles)
                shopSheet_Vehicles_Primary:SetWide(shopSheet_Vehicles:GetWide() / 1.5)
                shopSheet_Vehicles_Primary:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Primary:Dock(LEFT)
                shopSheet_Vehicles_Primary:InvalidateParent(true)
                shopSheet_Vehicles_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,0)) -- Red for visualizing positioning
                end

                local shopSheet_Vehicles_Secondary = vgui.Create("DPanel", shopSheet_Vehicles)
                shopSheet_Vehicles_Secondary:SetWide(shopSheet_Vehicles:GetWide() / 3)
                shopSheet_Vehicles_Secondary:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Secondary:Dock(RIGHT)
                shopSheet_Vehicles_Secondary:InvalidateParent(true)
                shopSheet_Vehicles_Secondary.Paint = function(self, w, h)
                        draw.RoundedBox(0,0,0, w, h, Color(0,35,131,0)) -- Blue for visualizing positioning
                end

                local shopSheet_Vehicles_Secondary_TitlePanel = vgui.Create("DPanel", shopSheet_Vehicles_Secondary)
                shopSheet_Vehicles_Secondary_TitlePanel:SetTall(shopSheet_Vehicles:GetTall() / 12)
                shopSheet_Vehicles_Secondary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Secondary_TitlePanel:Dock(TOP)
                shopSheet_Vehicles_Secondary_TitlePanel:InvalidateParent(true)
                shopSheet_Vehicles_Secondary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("PREVIEW", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                local shopSheet_Vehicles_Secondary_PreviewPanel = vgui.Create("DPanel", shopSheet_Vehicles_Secondary)
                shopSheet_Vehicles_Secondary_PreviewPanel:SetTall(shopSheet_Vehicles_Secondary:GetTall() / 2.5)
                shopSheet_Vehicles_Secondary_PreviewPanel:DockPadding(4,4,4,4)
                shopSheet_Vehicles_Secondary_PreviewPanel:Dock(TOP)
                shopSheet_Vehicles_Secondary_PreviewPanel:InvalidateParent(true)
                shopSheet_Vehicles_Secondary_PreviewPanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                end

                    local shopSheet_Vehicles_Secondary_PreviewPanel_Model = vgui.Create("DModelPanel", shopSheet_Vehicles_Secondary_PreviewPanel)
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:Dock(FILL)
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:DockPadding(4,4,4,4)
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:InvalidateParent(true)
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model.LayoutEntity = function(entity)	
                        return
                    end

                    local mn, mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                    local size = 0
                    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
    
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( size, size + 105, size) )
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (mn + mx) * 0.3 )

                    local shopSheet_Vehicles_Secondary_StatsTitle = vgui.Create("DPanel", shopSheet_Vehicles_Secondary)
                    shopSheet_Vehicles_Secondary_StatsTitle:SetTall(shopSheet_Vehicles:GetTall() / 12)
                    shopSheet_Vehicles_Secondary_StatsTitle:DockPadding(20,20,20,20)
                    shopSheet_Vehicles_Secondary_StatsTitle:Dock(TOP)
                    shopSheet_Vehicles_Secondary_StatsTitle:InvalidateParent(true)
                    shopSheet_Vehicles_Secondary_StatsTitle.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                        draw.SimpleText("STATISTICS", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                    end

                    local shopSheet_Vehicles_Secondary_StatsFrame = vgui.Create("DPanel", shopSheet_Vehicles_Secondary)
                    shopSheet_Vehicles_Secondary_StatsFrame:SetTall(shopSheet_Vehicles_Secondary:GetTall() / 5)
                    shopSheet_Vehicles_Secondary_StatsFrame:DockPadding(4,4,4,4)
                    shopSheet_Vehicles_Secondary_StatsFrame:Dock(TOP)
                    shopSheet_Vehicles_Secondary_StatsFrame:InvalidateParent(true)
                    shopSheet_Vehicles_Secondary_StatsFrame.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(71,71,71,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Vehicles_Secondary_StatsPanel_NameLabel = vgui.Create("DLabel", shopSheet_Vehicles_Secondary_StatsFrame)
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:Dock(TOP)
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:DockMargin(6,8,4,4)
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:InvalidateParent(true)
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetFont("DAC.ScoreboardTitle")
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetContentAlignment(5) -- https://wiki.facepunch.com/gmod/Panel:SetContentAlignment

                        local shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel = vgui.Create("DLabel", shopSheet_Vehicles_Secondary_StatsFrame)
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:Dock(TOP)
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:DockMargin(6,0,0,0)
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:InvalidateParent(true)
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetFont("DermaDefaultBold")
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetContentAlignment(5)

                        local shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel = vgui.Create("DLabel", shopSheet_Vehicles_Secondary_StatsFrame)
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:Dock(TOP)
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:DockMargin(6,0,0,0)
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:InvalidateParent(true)
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetFont("DermaDefaultBold")
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetContentAlignment(5)

                    local shopSheet_Vehicles_Secondary_BuyButton = vgui.Create("DButton", shopSheet_Vehicles_Secondary)
                    --shopSheet_Vehicles_Secondary_BuyButton:SetTall(shopSheet_Vehicles_Secondary:GetTall() / 5)
                    shopSheet_Vehicles_Secondary_BuyButton:DockMargin(24,24,24,24)
                    shopSheet_Vehicles_Secondary_BuyButton:Dock(FILL)
                    shopSheet_Vehicles_Secondary_BuyButton:SetFont("DAC.PickTeam")
                    shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                    shopSheet_Vehicles_Secondary_BuyButton:InvalidateParent(true)
                    shopSheet_Vehicles_Secondary_BuyButton.Paint = function(self, w, h)
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedVehicleCost and LocalPlayer():Alive() then
                            shopSheet_Vehicles_Secondary_BuyButton:SetEnabled(true)
                            draw.RoundedBox(3,0,0, w, h, Color(226,226,226))
                            surface.SetDrawColor(109,255,73)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                        else
                            shopSheet_Vehicles_Secondary_BuyButton:SetEnabled(false)
                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,255))
                            surface.SetDrawColor(255,126,126)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                        end
                    end
                    shopSheet_Vehicles_Secondary_BuyButton.DoClick = function(self, w, h)
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedVehicleCost then

                            LocalPlayer():EmitSound(ConfirmNoise)

                            net.Start("dac_givevehicle_preview")
                                net.WriteString("weapon_dac_vehiclepreviewer")
                            net.SendToServer()

                            --[[print("\n[DAC DEBUG]: Sending vehicle data to server...\n" 
                            .. "Name: " .. selectedVehicle .. "\n" 
                            .. "Type: " .. selectedVehicleType .. "\n" 
                            .. "Category: " .. selectedVehicleCategory .. "\n"
                            .. "Cost: " .. selectedVehicleCost .. "\n"
                            .. "FlagTransport: " .. tostring(selectedVehicleTransportStatus) .. "\n"
                            .. "Model: " .. selectedVehicleModel .. "\n"
                            .. "List: " .. selectedVehicleList .. "\n"
                            .. "Class: " .. selectedVehicleClass .. "\n"
                            )]]
                            
                            -- Stagger the vehicle data being sent to the client by the next tick. This allows the client to obtain and intiailize the selector tool
                            timer.Simple(0.5, function() 
                                net.Start("dac_sendvehicledata")
                                    net.WriteString(selectedVehicle)
                                    net.WriteString(selectedVehicleType)
                                    net.WriteString(selectedVehicleCategory)
                                    net.WriteString(selectedVehicleCost)
                                    net.WriteBool(selectedVehicleTransportStatus)
                                    net.WriteString(selectedVehicleModel)
                                    net.WriteString(selectedVehicleList)
                                    net.WriteString(selectedVehicleClass)
                                net.SendToServer()
                                --print("[DAC DEBUG]: Sent.")
                            end)

                        else
                            LocalPlayer():EmitSound(DenyNoise)
                        end
                    end

                local shopSheet_Vehicles_Primary_TitlePanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary)
                shopSheet_Vehicles_Primary_TitlePanel:SetTall(shopSheet_Vehicles:GetTall() / 12)
                shopSheet_Vehicles_Primary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Primary_TitlePanel:Dock(TOP)
                shopSheet_Vehicles_Primary_TitlePanel:InvalidateParent(true)
                shopSheet_Vehicles_Primary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("VEHICLE CATALOG", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                    local shopSheet_Vehicles_Primary_PreviewPanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary)
                    --shopSheet_Vehicles_Primary_PreviewPanel:SetTall(shopSheet_Vehicles_Primary:GetTall() / 1.5)
                    shopSheet_Vehicles_Primary_PreviewPanel:DockPadding(5,5,5,5)
                    shopSheet_Vehicles_Primary_PreviewPanel:Dock(FILL)
                    shopSheet_Vehicles_Primary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Vehicles_Primary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Vehicles_Primary_ScrollPanel = vgui.Create("DScrollPanel", shopSheet_Vehicles_Primary_PreviewPanel)
                        shopSheet_Vehicles_Primary_ScrollPanel:Dock(FILL)
                        shopSheet_Vehicles_Primary_ScrollPanel:InvalidateParent(true)
                        shopSheet_Vehicles_Primary_ScrollPanel:GetCanvas():DockPadding(5,5,5,5)
                        shopSheet_Vehicles_Primary_ScrollPanel.Paint = function(self, w, h)
                            draw.RoundedBox(0,0,0, w, h, Color(255,0,179,0))
                        end

                            local shopSheet_Vehicles_ArmedVehicles_TitlePanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary_ScrollPanel)
                            shopSheet_Vehicles_ArmedVehicles_TitlePanel:SetTall(shopSheet_Vehicles_Primary_PreviewPanel:GetTall() / 12)
                            shopSheet_Vehicles_ArmedVehicles_TitlePanel:DockMargin(5,5,5,5)
                            shopSheet_Vehicles_ArmedVehicles_TitlePanel:Dock(TOP)
                            shopSheet_Vehicles_ArmedVehicles_TitlePanel:InvalidateParent(true)
                            shopSheet_Vehicles_ArmedVehicles_TitlePanel.Paint = function(self, w, h)
                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                surface.SetDrawColor(255,255,255)
                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                draw.SimpleText("MILITARY", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                            end

                                local shopSheet_Vehicles_ArmedVehicles_IconLayout = vgui.Create( "DIconLayout", shopSheet_Vehicles_Primary_ScrollPanel )
                                shopSheet_Vehicles_ArmedVehicles_IconLayout:Dock(TOP)
                                shopSheet_Vehicles_ArmedVehicles_IconLayout:SetBorder(10)
                                shopSheet_Vehicles_ArmedVehicles_IconLayout:SetSpaceY(5)
                                shopSheet_Vehicles_ArmedVehicles_IconLayout:SetSpaceX(5)
                                
                                    for vehicleIndex, vehicleValue in pairs (list.Get("dac_simfphys_armed")) do

                                        local shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame = shopSheet_Vehicles_ArmedVehicles_IconLayout:Add( "DPanel" )
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame:SetSize( shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6, shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6 )
                                        
                                        -- Assign contextual values to each panel as it is created for later use
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Name = vehicleValue.Name
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.ListName = vehicleValue.ListName
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.VehicleType = vehicleValue.VehicleType
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Model = vehicleValue.Model
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Category = vehicleValue.Category
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.IsFlagTransport = vehicleValue.IsFlagTransport
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Cost = vehicleValue.Cost
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Class = vehicleValue.Class

                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Paint = function (self, w, h)
                                            if vehicleValue.Name == selectedVehicle then
                                                draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                            else
                                                draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                            end
                                        end

                                        local shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot:SetWide(shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame:GetTall() * 0.95)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot:Dock(LEFT)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot:InvalidateParent(true)

                                        -- Manually draw the icon slot so it looks nice
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                            surface.SetDrawColor(255,255,255)
                                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                        end

                                        local shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image:Dock(FILL)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image:InvalidateParent(true)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image:SetImage(vehicleValue.Icon)

                                        local shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Image)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label:SetTall(shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame:GetTall() * 0.15)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label:InvalidateParent(true)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                            draw.SimpleText(vehicleValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                        end

                                        local shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame)
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button:SetWide(shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame:GetWide())
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button:SetTall(shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame:GetTall())
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                            -- Return nothing for the ultimate prank, haha ghehgeegr
                                        end
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button:SetText("")

                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame_Button.DoClick = function()

                                            LocalPlayer():EmitSound(ButtonNoise)

                                            selectedVehicle = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Name
                                            selectedVehicleModel = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Model
                                            selectedVehicleType = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.VehicleType
                                            selectedVehicleCategory = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Category
                                            selectedVehicleTransportStatus = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.IsFlagTransport
                                            selectedVehicleCost = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Cost
                                            selectedVehicleClass = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Class
                                            selectedVehicleList = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.ListName

                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                            shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                            shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                            shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                            shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
                
                                            mn, mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                            size = 0
                                            size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                                            size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                                            size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
                            
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( size, size + 105, size) )
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (mn + mx) * 0.3 )

                                            -- For debugging help
                                            --[[print("\n-- SELECTED VEHICLE --\n" 
                                            .. "Name: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Name .. "\n" 
                                            .. "Type: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.VehicleType .. "\n"
                                            .. "Category: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Category .. "\n"
                                            .. "Cost: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Cost .. "\n"
                                            .. "FlagTransport: " .. tostring(shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.IsFlagTransport) .. "\n"
                                            .. "Model: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Model .. "\n"
                                            .. "List: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.ListName .. "\n"
                                            .. "Class: " .. shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.Class .. "\n"
                                            )]]

                                        end

                                    end

                            local shopSheet_Vehicles_CivilianVehicles_TitlePanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary_ScrollPanel)
                            shopSheet_Vehicles_CivilianVehicles_TitlePanel:SetTall(shopSheet_Vehicles_Primary_PreviewPanel:GetTall() / 12)
                            shopSheet_Vehicles_CivilianVehicles_TitlePanel:DockMargin(5,15,5,5) -- Any subsequent title panels should have a top margin parameter of 15 for following iconlayouts
                            shopSheet_Vehicles_CivilianVehicles_TitlePanel:Dock(TOP)
                            shopSheet_Vehicles_CivilianVehicles_TitlePanel:InvalidateParent(true)
                            shopSheet_Vehicles_CivilianVehicles_TitlePanel.Paint = function(self, w, h)
                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                surface.SetDrawColor(255,255,255)
                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                draw.SimpleText("CIVILIAN", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                            end

                            local shopSheet_Vehicles_CivilianVehicles_IconLayout = vgui.Create( "DIconLayout", shopSheet_Vehicles_Primary_ScrollPanel )
                            shopSheet_Vehicles_CivilianVehicles_IconLayout:Dock(TOP)
                            shopSheet_Vehicles_CivilianVehicles_IconLayout:SetBorder(10)
                            shopSheet_Vehicles_CivilianVehicles_IconLayout:SetSpaceY(5)
                            shopSheet_Vehicles_CivilianVehicles_IconLayout:SetSpaceX(5)

                            for vehicleIndex, vehicleValue in pairs (list.Get("dac_simfphys_civilian")) do

                                local shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame = shopSheet_Vehicles_CivilianVehicles_IconLayout:Add( "DPanel" )
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame:SetSize( shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6, shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6 )
                                
                                -- Assign contextual values to each panel as it is created for later use
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Name = vehicleValue.Name
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.ListName = vehicleValue.ListName
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.VehicleType = vehicleValue.VehicleType
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Model = vehicleValue.Model
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Category = vehicleValue.Category
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.IsFlagTransport = vehicleValue.IsFlagTransport
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Cost = vehicleValue.Cost
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Class = vehicleValue.Class

                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Paint = function (self, w, h)
                                    if vehicleValue.Name == selectedVehicle then
                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                    else
                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                    end
                                end

                                local shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot:SetWide(shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame:GetTall() * 0.95)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot:Dock(LEFT)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot:InvalidateParent(true)

                                -- Manually draw the icon slot so it looks nice
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot.Paint = function(self, w, h)
                                    draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                    surface.SetDrawColor(255,255,255)
                                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                end

                                local shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image:Dock(FILL)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image:InvalidateParent(true)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image:SetImage(vehicleValue.Icon)

                                local shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Image)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label:SetTall(shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame:GetTall() * 0.15)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label:InvalidateParent(true)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                    draw.SimpleText(vehicleValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                end

                                local shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame)
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button:SetWide(shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame:GetWide())
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button:SetTall(shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame:GetTall())
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                    -- Return nothing for the ultimate prank, haha ghehgeegr
                                end
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button:SetText("")

                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame_Button.DoClick = function()

                                    LocalPlayer():EmitSound(ButtonNoise)

                                    selectedVehicle = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Name
                                    selectedVehicleModel = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Model
                                    selectedVehicleType = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.VehicleType
                                    selectedVehicleCategory = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Category
                                    selectedVehicleTransportStatus = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.IsFlagTransport
                                    selectedVehicleCost = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Cost
                                    selectedVehicleClass = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Class
                                    selectedVehicleList = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.ListName

                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                    shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                    shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                    shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                    shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
        
                                    mn, mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                    size = 0
                                    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                                    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                                    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
                    
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( size, size + 105, size) )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (mn + mx) * 0.3 )

                                    -- For debugging help
                                    --[[print("\n-- SELECTED VEHICLE --\n" 
                                    .. "Name: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Name .. "\n" 
                                    .. "Type: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.VehicleType .. "\n"
                                    .. "Category: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Category .. "\n"
                                    .. "Cost: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Cost .. "\n"
                                    .. "FlagTransport: " .. tostring(shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.IsFlagTransport) .. "\n"
                                    .. "Model: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Model .. "\n"
                                    .. "List: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.ListName .. "\n"
                                    .. "Class: " .. shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.Class .. "\n"
                                    )]]

                                end

                            end

                            local shopSheet_Vehicles_AirVehicles_TitlePanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary_ScrollPanel)
                            shopSheet_Vehicles_AirVehicles_TitlePanel:SetTall(shopSheet_Vehicles_Primary_PreviewPanel:GetTall() / 12)
                            shopSheet_Vehicles_AirVehicles_TitlePanel:DockMargin(5,15,5,5) -- Any subsequent title panels should have a top margin parameter of 15 for following iconlayouts
                            shopSheet_Vehicles_AirVehicles_TitlePanel:Dock(TOP)
                            shopSheet_Vehicles_AirVehicles_TitlePanel:InvalidateParent(true)
                            shopSheet_Vehicles_AirVehicles_TitlePanel.Paint = function(self, w, h)
                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                surface.SetDrawColor(255,255,255)
                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                draw.SimpleText("AIRCRAFT", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                            end

                            local shopSheet_Vehicles_AirVehicles_IconLayout = vgui.Create( "DIconLayout", shopSheet_Vehicles_Primary_ScrollPanel )
                            shopSheet_Vehicles_AirVehicles_IconLayout:Dock(TOP)
                            shopSheet_Vehicles_AirVehicles_IconLayout:SetBorder(10)
                            shopSheet_Vehicles_AirVehicles_IconLayout:SetSpaceY(5)
                            shopSheet_Vehicles_AirVehicles_IconLayout:SetSpaceX(5)

                            for vehicleIndex, vehicleValue in pairs (list.Get("dac_lfs_military")) do

                                local shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame = shopSheet_Vehicles_AirVehicles_IconLayout:Add( "DPanel" )
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame:SetSize( shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6, shopSheet_Vehicles_Primary_PreviewPanel:GetWide() / 6 )
                                
                                -- Assign contextual values to each panel as it is created for later use
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Name = vehicleValue.Name
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.ListName = vehicleValue.ListName
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.VehicleType = vehicleValue.VehicleType
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Model = vehicleValue.Model
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Category = vehicleValue.Category
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.IsFlagTransport = vehicleValue.IsFlagTransport
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Cost = vehicleValue.Cost
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Class = vehicleValue.Class

                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Paint = function (self, w, h)
                                    if vehicleValue.Name == selectedVehicle then
                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                    else
                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                    end
                                end

                                local shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot:SetWide(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame:GetTall() * 0.95)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot:Dock(LEFT)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot:InvalidateParent(true)

                                -- Manually draw the icon slot so it looks nice
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot.Paint = function(self, w, h)
                                    draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                    surface.SetDrawColor(255,255,255)
                                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                end

                                local shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image:Dock(FILL)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image:InvalidateParent(true)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image:SetImage(vehicleValue.Icon)

                                local shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Image)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label:SetTall(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame:GetTall() * 0.15)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label:InvalidateParent(true)
                                shopSheet_Vehicles_AirVehicles_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                    draw.SimpleText(vehicleValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                end

                                local shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame)
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button:SetWide(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame:GetWide())
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button:SetTall(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame:GetTall())
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                    -- Return nothing for the ultimate prank, haha ghehgeegr
                                end
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button:SetText("")

                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame_Button.DoClick = function()

                                    LocalPlayer():EmitSound(ButtonNoise)

                                    selectedVehicle = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Name
                                    selectedVehicleModel = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Model
                                    selectedVehicleType = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.VehicleType
                                    selectedVehicleCategory = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Category
                                    selectedVehicleTransportStatus = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.IsFlagTransport
                                    selectedVehicleCost = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Cost
                                    selectedVehicleClass = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Class
                                    selectedVehicleList = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.ListName

                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                    shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                    shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                    shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                    shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
        
                                    mn, mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                    size = 0
                                    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                                    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                                    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
                    
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( size, size + 105, size) )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (mn + mx) * 0.3 )

                                    -- For debugging help
                                    print("\n-- SELECTED VEHICLE --\n" 
                                    .. "Name: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Name .. "\n" 
                                    .. "Type: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.VehicleType .. "\n"
                                    .. "Category: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Category .. "\n"
                                    .. "Cost: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Cost .. "\n"
                                    .. "FlagTransport: " .. tostring(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.IsFlagTransport) .. "\n"
                                    .. "Model: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Model .. "\n"
                                    .. "List: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.ListName .. "\n"
                                    .. "Class: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Class.. "\n"
                                    )

                                end

                            end

            --- UPGRADE TAB ---

            local shopSheet_Upgrades = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Upgrades:Dock(FILL)
            shopSheet_Upgrades:InvalidateParent(true)
            shopSheet_Upgrades.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Upgrades", shopSheet_Upgrades, "icon16/user_add.png")

            --- LOADOUT TAB ---

            local shopSheet_Loadout = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Loadout:Dock(FILL)
            shopSheet_Loadout:InvalidateParent(true)
            shopSheet_Loadout.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Loadout", shopSheet_Loadout, "icon16/briefcase.png")

            -- [LEFT LOADOUT PANEL] --
            -- Divide the loadout panel into two pieces, dock this child panel to the left

                local shopSheet_Loadout_Primary = vgui.Create("DPanel", shopSheet_Loadout)
                shopSheet_Loadout_Primary:SetWide(shopSheet_Loadout:GetWide() / 2)
                shopSheet_Loadout_Primary:DockPadding(20,20,20,20)
                shopSheet_Loadout_Primary:Dock(LEFT)
                shopSheet_Loadout_Primary:InvalidateParent(true)
                shopSheet_Loadout_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,0)) -- Red for visualizing positioning
                end

                local shopSheet_Loadout_Primary_TitlePanel = vgui.Create("DPanel", shopSheet_Loadout_Primary)
                shopSheet_Loadout_Primary_TitlePanel:SetTall(shopSheet_Loadout:GetTall() / 12)
                shopSheet_Loadout_Primary_TitlePanel:Dock(TOP)
                shopSheet_Loadout_Primary_TitlePanel:InvalidateParent(true)
                shopSheet_Loadout_Primary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("PRIMARY WEAPON", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                    -- Build a panel within the second portion of the layout screen to build a list
                    local shopSheet_Loadout_Primary_PreviewPanel = vgui.Create("DPanel", shopSheet_Loadout_Primary)
                    --shopSheet_Loadout_Primary_PreviewPanel:SetTall(shopSheet_Loadout_Primary:GetTall() / 1.5)
                    shopSheet_Loadout_Primary_PreviewPanel:DockPadding(4,4,4,4)
                    shopSheet_Loadout_Primary_PreviewPanel:Dock(FILL)
                    shopSheet_Loadout_Primary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Loadout_Primary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        -- Assign a scroll panel in the event that the weapon list exceeds the total height of the parent panel
                        local shopSheet_Loadout_Primary_ScrollPanel = vgui.Create("DScrollPanel", shopSheet_Loadout_Primary_PreviewPanel)
                        shopSheet_Loadout_Primary_ScrollPanel:Dock(FILL)
                        shopSheet_Loadout_Primary_ScrollPanel:InvalidateParent(true)

                            -- Create a list within the scroll panel
                            local shopSheet_Loadout_Primary_List = vgui.Create("DListLayout", shopSheet_Loadout_Primary_ScrollPanel)
                            shopSheet_Loadout_Primary_List:SetPaintBackground(true)
                            shopSheet_Loadout_Primary_List:SetBackgroundColor(Color(0, 0, 0, 0))
                            shopSheet_Loadout_Primary_List:DockPadding(4,4,4,4)
                            shopSheet_Loadout_Primary_List:Dock(FILL)
                            shopSheet_Loadout_Primary_List:InvalidateParent(true)

                            -- Local arrays for indexing panel rows with list data outside of the loop scope
                            -- I know they're technically tables because Lua doesn't have arrays, fuck you
                            local primaryWeaponClasses = {}

                            -- The main loop for building the weapon panels in the list
                            for weaponIndex, weaponValue in pairs (list.Get("weapons_primary")) do

                                -- Make a panel first, this will be used for actual design
                                local shopSheet_Loadout_Primary_ListItem_Panel = shopSheet_Loadout_Primary_List:Add("DPanel")
                                shopSheet_Loadout_Primary_ListItem_Panel:SetTall(shopSheet_Loadout_Primary_PreviewPanel:GetTall() / 5)
                                shopSheet_Loadout_Primary_ListItem_Panel:DockMargin(4,4,4,4)
                                shopSheet_Loadout_Primary_ListItem_Panel:Dock(TOP)
                                shopSheet_Loadout_Primary_ListItem_Panel:InvalidateParent(true)

                                -- If the panel's weapon class is equivalent to the selected weapon, we should highlight it
                                -- Otherwise we'll paint it with a regular gray color
                                shopSheet_Loadout_Primary_ListItem_Panel.Paint = function (self, w, h)
                                    if weaponValue.Class == selectedPrimary then
                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                    else
                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                    end
                                end

                                    -- Make a slot on the left side of the panel second, to hold the weapon's icon
                                    local shopSheet_Loadout_Primary_ListItem_Panel_IconSlot = vgui.Create("DPanel", shopSheet_Loadout_Primary_ListItem_Panel)
                                    shopSheet_Loadout_Primary_ListItem_Panel_IconSlot:SetWide(shopSheet_Loadout_Primary_ListItem_Panel:GetTall())
                                    shopSheet_Loadout_Primary_ListItem_Panel_IconSlot:DockMargin(4,4,4,4)
                                    shopSheet_Loadout_Primary_ListItem_Panel_IconSlot:Dock(LEFT)
                                    shopSheet_Loadout_Primary_ListItem_Panel_IconSlot:InvalidateParent(true)

                                    -- Here, we are going to parse the weapon class to each panel as the weapon list is iterated
                                    -- We can then use this later to call the panel's class in the click function
                                    primaryWeaponClasses[weaponIndex] = weaponValue.Class

                                    -- Manually draw the icon slot so it looks nice
                                    shopSheet_Loadout_Primary_ListItem_Panel_IconSlot.Paint = function(self, w, h)
                                        draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                        surface.SetDrawColor(255,255,255)
                                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                    end

                                    -- Make the actual icon for the weapon itself and parent it to the slot we built previously
                                    local shopSheet_Loadout_Primary_ListItem_Panel_Icon = vgui.Create("DImage", shopSheet_Loadout_Primary_ListItem_Panel_IconSlot)
                                    shopSheet_Loadout_Primary_ListItem_Panel_Icon:DockMargin(4,4,4,4)
                                    shopSheet_Loadout_Primary_ListItem_Panel_Icon:Dock(FILL)
                                    shopSheet_Loadout_Primary_ListItem_Panel_Icon:InvalidateParent(true)
                                    shopSheet_Loadout_Primary_ListItem_Panel_Icon:SetImage(weaponValue.Icon)

                                -- Make a button to go over each panel, which will serve as the click functionality and also drive the appearance of the parent panel
                                local shopSheet_Loadout_Primary_ListItem_Button = vgui.Create("DButton", shopSheet_Loadout_Primary_ListItem_Panel)
                                shopSheet_Loadout_Primary_ListItem_Button:SetFont("DAC.PickTeam")
                                shopSheet_Loadout_Primary_ListItem_Button:SetText(weaponValue.Name) -- For visual purposes only during the WIP stage
                                shopSheet_Loadout_Primary_ListItem_Button:Dock(FILL)
                                shopSheet_Loadout_Primary_ListItem_Button:InvalidateParent(true)

                                -- Override the paint function of the actual button. This will return nothing when the menu is complete, to keep it invisible.
                                shopSheet_Loadout_Primary_ListItem_Button.Paint = function (self, w, h)
                                    --draw.RoundedBox(0,0,0, w, h, Color(172,98,98,100)) -- For visual purposes only during the WIP stage
                                end

                                -- We return the class (I.E. "weapon_smg1") assigned from the loop below, into a local variable to drive loadout functionality.
                                -- If this variable is not equivalent to the local player's current weapon, we'll send a net message to the server so that it can be updated.
                                -- In that net message, we want to send the weapon class, derived here, and the player it came from, so their weapon can be updated serverside.
                                -- When that message is received, it is important to loop through the table that the weapons are being pulled from. The weapon should not be changed if the (cont.)
                                -- weapon class doesn't match any values in the table, as that means the player is attempting to send weapon data that should not be available to them.
                                shopSheet_Loadout_Primary_ListItem_Button.DoClick = function (self)

                                    LocalPlayer():EmitSound(SelectLoadoutOption)
                                    selectedPrimary = shopSheet_Loadout_Primary_ListItem_Panel.Class

                                    if selectedPrimary ~= LocalPlayer().primaryWeapon then
                                        net.Start("UpdatePlayerPrimaryWeapon")
                                            net.WriteString(selectedPrimary)
                                        net.SendToServer()
                                    end

                                end

                            end

                            -- When we first build the buttons for the list, we ran a loop on an external array(s) that let us retrieve values from each weapon in the loadout table
                            -- That value is then assigned to each panel in the same index order, so we can call that value externally when the panel's reference button is clicked
                            for panelIndex, rowValue in pairs (shopSheet_Loadout_Primary_List:GetChildren()) do -- We're getting the list's children since that's where the weapon panels reside
                                rowValue.Class = primaryWeaponClasses[panelIndex]
                            end
            
            -- [RIGHT LOADOUT PANEL] --
            -- Divide the loadout panel into two pieces, dock this child panel to the right

                local shopSheet_Loadout_Secondary = vgui.Create("DPanel", shopSheet_Loadout)
                shopSheet_Loadout_Secondary:SetWide(shopSheet_Loadout:GetWide() / 2)
                shopSheet_Loadout_Secondary:DockPadding(20,20,20,20)
                shopSheet_Loadout_Secondary:Dock(RIGHT)
                shopSheet_Loadout_Secondary:InvalidateParent(true)
                shopSheet_Loadout_Secondary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(0,35,131,0)) -- Blue for visualizing positioning
                end

                local shopSheet_Loadout_Secondary_TitlePanel = vgui.Create("DPanel", shopSheet_Loadout_Secondary)
                shopSheet_Loadout_Secondary_TitlePanel:SetTall(shopSheet_Loadout:GetTall() / 12)
                shopSheet_Loadout_Secondary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Loadout_Secondary_TitlePanel:Dock(TOP)
                shopSheet_Loadout_Secondary_TitlePanel:InvalidateParent(true)
                shopSheet_Loadout_Secondary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("SECONDARY WEAPON", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                    -- Build a panel within the second portion of the layout screen to build a list
                    local shopSheet_Loadout_Secondary_PreviewPanel = vgui.Create("DPanel", shopSheet_Loadout_Secondary)
                    --shopSheet_Loadout_Secondary_PreviewPanel:SetTall(shopSheet_Loadout_Secondary:GetTall() / 1.5)
                    shopSheet_Loadout_Secondary_PreviewPanel:DockPadding(4,4,4,4)
                    shopSheet_Loadout_Secondary_PreviewPanel:Dock(FILL)
                    shopSheet_Loadout_Secondary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Loadout_Secondary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        -- Assign a scroll panel in the event that the weapon list exceeds the total height of the parent panel
                        local shopSheet_Loadout_Secondary_ScrollPanel = vgui.Create("DScrollPanel", shopSheet_Loadout_Secondary_PreviewPanel)
                        shopSheet_Loadout_Secondary_ScrollPanel:Dock(FILL)
                        shopSheet_Loadout_Secondary_ScrollPanel:InvalidateParent(true)

                            -- Create a list within the scroll panel
                            local shopSheet_Loadout_Secondary_List = vgui.Create("DListLayout", shopSheet_Loadout_Secondary_ScrollPanel)
                            shopSheet_Loadout_Secondary_List:SetPaintBackground(true)
                            shopSheet_Loadout_Secondary_List:SetBackgroundColor(Color(0, 0, 0, 0))
                            shopSheet_Loadout_Secondary_List:DockPadding(4,4,4,4)
                            shopSheet_Loadout_Secondary_List:Dock(FILL)
                            shopSheet_Loadout_Secondary_List:InvalidateParent(true)

                            -- Local arrays for indexing panel rows with list data outside of the loop scope
                            -- I know they're technically tables because Lua doesn't have arrays, fuck you
                            local secondaryWeaponClasses = {}

                            -- The main loop for building the weapon panels in the list
                            for weaponIndex, weaponValue in pairs (list.Get("weapons_equipment")) do

                                -- Make a panel first, this will be used for actual design
                                local shopSheet_Loadout_Secondary_ListItem_Panel = shopSheet_Loadout_Secondary_List:Add("DPanel")
                                shopSheet_Loadout_Secondary_ListItem_Panel:SetTall(shopSheet_Loadout_Secondary_PreviewPanel:GetTall() / 5)
                                shopSheet_Loadout_Secondary_ListItem_Panel:DockMargin(4,4,4,4)
                                shopSheet_Loadout_Secondary_ListItem_Panel:Dock(TOP)
                                shopSheet_Loadout_Secondary_ListItem_Panel:InvalidateParent(true)

                                -- If the panel's weapon class is equivalent to the selected weapon, we should highlight it
                                -- Otherwise we'll paint it with a regular gray color
                                shopSheet_Loadout_Secondary_ListItem_Panel.Paint = function (self, w, h)
                                    if weaponValue.Class == selectedSpecial then
                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                    else
                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                    end
                                end

                                    -- Make a slot on the left side of the panel second, to hold the weapon's icon
                                    local shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot = vgui.Create("DPanel", shopSheet_Loadout_Secondary_ListItem_Panel)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot:SetWide(shopSheet_Loadout_Secondary_ListItem_Panel:GetTall())
                                    shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot:DockMargin(4,4,4,4)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot:Dock(LEFT)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot:InvalidateParent(true)

                                    -- Here, we are going to parse the weapon class to each panel as the weapon list is iterated
                                    -- We can then use this later to call the panel's class in the click function
                                    secondaryWeaponClasses[weaponIndex] = weaponValue.Class

                                    -- Manually draw the icon slot so it looks nice
                                    shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot.Paint = function(self, w, h)
                                        draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                        surface.SetDrawColor(255,255,255)
                                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                    end

                                    -- Make the actual icon for the weapon itself and parent it to the slot we built previously
                                    local shopSheet_Loadout_Secondary_ListItem_Panel_Icon = vgui.Create("DImage", shopSheet_Loadout_Secondary_ListItem_Panel_IconSlot)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_Icon:DockMargin(4,4,4,4)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_Icon:Dock(FILL)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_Icon:InvalidateParent(true)
                                    shopSheet_Loadout_Secondary_ListItem_Panel_Icon:SetImage(weaponValue.Icon)

                                -- Make a button to go over each panel, which will serve as the click functionality and also drive the appearance of the parent panel
                                local shopSheet_Loadout_Secondary_ListItem_Button = vgui.Create("DButton", shopSheet_Loadout_Secondary_ListItem_Panel)
                                shopSheet_Loadout_Secondary_ListItem_Button:SetText(weaponValue.Name) -- For visual purposes only during the WIP stage
                                shopSheet_Loadout_Secondary_ListItem_Button:SetFont("DAC.PickTeam")
                                shopSheet_Loadout_Secondary_ListItem_Button:Dock(FILL)
                                shopSheet_Loadout_Secondary_ListItem_Button:InvalidateParent(true)

                                -- Override the paint function of the actual button. This will return nothing when the menu is complete, to keep it invisible.
                                shopSheet_Loadout_Secondary_ListItem_Button.Paint = function (self, w, h)
                                    --draw.RoundedBox(0,0,0, w, h, Color(172,98,98,100)) -- For visual purposes only during the WIP stage
                                end

                                -- We return the class (I.E. "weapon_smg1") assigned from the loop below, into a local variable to drive loadout functionality.
                                -- If this variable is not equivalent to the local player's current weapon, we'll send a net message to the server so that it can be updated.
                                -- In that net message, we want to send the weapon class, derived here, and the player it came from, so their weapon can be updated serverside.
                                -- When that message is received, it is important to loop through the table that the weapons are being pulled from. The weapon should not be changed if the (cont.)
                                -- weapon class doesn't match any values in the table, as that means the player is attempting to send weapon data that should not be available to them.
                                shopSheet_Loadout_Secondary_ListItem_Button.DoClick = function (self)

                                    LocalPlayer():EmitSound(SelectLoadoutOption)
                                    selectedSpecial = shopSheet_Loadout_Secondary_ListItem_Panel.Class

                                    if selectedSpecial ~= LocalPlayer().specialWeapon then
                                        net.Start("UpdatePlayerSecondaryWeapon")
                                            net.WriteString(selectedSpecial)
                                        net.SendToServer()
                                    end

                                end

                            end

                            -- When we first build the buttons for the list, we ran a loop on an external array(s) that let us retrieve values from each weapon in the loadout table
                            -- That value is then assigned to each panel in the same index order, so we can call that value externally when the panel's reference button is clicked
                            for panelIndex, rowValue in pairs (shopSheet_Loadout_Secondary_List:GetChildren()) do -- We're getting the list's children since that's where the weapon panels reside
                                rowValue.Class = secondaryWeaponClasses[panelIndex]
                            end

            --[[local shopSheet_Tip = vgui.Create("DHTML", mainColumnSheet)
            shopSheet_Tip:Dock(FILL)
            shopSheet_Tip:InvalidateParent(true)
            mainColumnSheet:AddSheet("Tip Me?", shopSheet_Tip, "icon16/star.png")

                local shopSheet_Tip_Panel = vgui.Create("DPanel", shopSheet_Tip)
                --shopSheet_Tip_Panel:SetWide(shopSheet_Loadout:GetWide() / 2)
                --shopSheet_Tip_Panel:DockPadding(20,20,20,20)
                shopSheet_Tip_Panel:Dock(FILL)
                shopSheet_Tip_Panel:InvalidateParent(true)
                shopSheet_Tip_Panel.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(100,100,100,100))
                    draw.SimpleText("Loading...", "DAC.PickTeam", w * 0.5, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                local shopSheet_Tip_Window = vgui.Create( "DHTML", shopSheet_Tip_Panel )
                shopSheet_Tip_Window:Dock(FILL)
                shopSheet_Tip_Window:OpenURL("ko-fi.com/dragonbyte1546")]]

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