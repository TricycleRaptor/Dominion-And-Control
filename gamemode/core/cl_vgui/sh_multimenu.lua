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
    local selectedVehicleSpawnOffset = nil

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
                selectedVehicleSpawnOffset == nil or
                selectedVehicleList == nil or
                selectedEntity == nil or
                selectedEntityModel == nil or
                selectedEntityCategory == nil or
                selectedEntityCost == nil or
                selectedEntityClass == nil or
                selectedEntityList == nil or
                selectedEntitySpawnOffset == nil or 
                selectedItem == nil or
                selectedItemModel == nil or
                selectedItemCategory == nil or
                selectedItemCost == nil or
                selectedItemClass == nil or
                selectedItemList == nil or
                selectedItemSpawnOffset == nil
                then

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
                    selectedVehicleSpawnOffset = vehicleValue.SpawnOffset
                    break
                end

                for entityIndex, entityValue in pairs(list.Get("dac_ammocrates")) do
                    selectedEntity = entityValue.Name -- We're just getting the first value and breaking after that
                    selectedEntityModel = entityValue.Model
                    selectedEntityCategory = entityValue.Category
                    selectedEntityCost = entityValue.Cost
                    selectedEntityClass = entityValue.Class
                    selectedEntityList = entityValue.ListName
                    selectedEntitySpawnOffset = entityValue.SpawnOffset
                    break
                end

                for itemIndex, itemValue in pairs(list.Get("dac_items_ammo")) do
                    selectedItem = itemValue.Name -- We're just getting the first value and breaking after that
                    selectedItemModel = itemValue.Model
                    selectedItemCategory = itemValue.Category
                    selectedItemCost = itemValue.Cost
                    selectedItemClass = itemValue.Class
                    selectedItemList = itemValue.ListName
                    selectedItemSpawnOffset = itemValue.SpawnOffset
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
            titleLabel:SetText("DOMINION & CONTROL")
            titleLabel:SetPos(panelX * 0.01,6)
            titleLabel:SizeToContents()

            local creditsLabel = vgui.Create("DLabel", MENU_FRAME)
            creditsLabel:SetFont("DAC.ScoreboardTitle") -- Size 22px
            creditsLabel:SetColor(Color(255,217,0))
            creditsLabel:SetPos(panelX * 0.91, 12)
            creditsLabel.Paint = function(self, w, h)
                creditsLabel:SetText(LocalPlayer():GetNWInt("storeCredits") .. " cR")
                creditsLabel:SetColor(Color(255,217,0))
                creditsLabel:SizeToContents()
            end

            local inBaseLabel = vgui.Create("DLabel", MENU_FRAME)
            inBaseLabel:SetFont("DAC.ScoreboardTitle") -- Size 22px
            inBaseLabel:Dock(BOTTOM)
            inBaseLabel:DockMargin(28, 15, 15, 15)
            inBaseLabel.Paint = function(self, w, h)
                if LocalPlayer():Alive() == true then
                    if LocalPlayer():GetNWBool("IsInBase") == true then
                        inBaseLabel:SetText("HOME")
                        inBaseLabel:SetColor(Color(0,255,0))
                    else
                        inBaseLabel:SetText("AWAY")
                        inBaseLabel:SetColor(Color(255,0,0))
                    end
                else
                    inBaseLabel:SetText("DEAD")
                    inBaseLabel:SetColor(Color(172,172,172))
                end
                inBaseLabel:SizeToContents()
            end

            local mainPanel = vgui.Create("DPanel", MENU_FRAME)
            mainPanel:SetPos(4, 38)
            mainPanel:SetSize(panelX - 8, panelY - 38 - 4)
            mainPanel.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(100,100,100,100))
            end

            local mainColumnSheet = vgui.Create("DColumnSheet", mainPanel)
            mainColumnSheet:Dock(FILL)
            mainColumnSheet:InvalidateParent(true)

            --- ENTITIES TAB ---

            local shopSheet_Items = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Items:Dock(FILL)
            --shopSheet_Items:DockPadding(10,10,10,10)
            shopSheet_Items:InvalidateParent(true)
            shopSheet_Items.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Entities", shopSheet_Items, "icon16/bricks.png")

                -- Divide the vehicles panel into two pieces, dock this child panel to the left
                local shopSheet_Items_Primary = vgui.Create("DPanel", shopSheet_Items)
                shopSheet_Items_Primary:SetWide(shopSheet_Items:GetWide() / 1.5)
                shopSheet_Items_Primary:DockPadding(20,20,20,20)
                shopSheet_Items_Primary:Dock(LEFT)
                shopSheet_Items_Primary:InvalidateParent(true)
                shopSheet_Items_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,0)) -- Red for visualizing positioning
                end

                local shopSheet_Items_Secondary = vgui.Create("DPanel", shopSheet_Items)
                shopSheet_Items_Secondary:SetWide(shopSheet_Items:GetWide() / 3)
                shopSheet_Items_Secondary:DockPadding(20,20,20,20)
                shopSheet_Items_Secondary:Dock(RIGHT)
                shopSheet_Items_Secondary:InvalidateParent(true)
                shopSheet_Items_Secondary.Paint = function(self, w, h)
                        draw.RoundedBox(0,0,0, w, h, Color(0,35,131,0)) -- Blue for visualizing positioning
                end

                local shopSheet_Items_Secondary_TitlePanel = vgui.Create("DPanel", shopSheet_Items_Secondary)
                shopSheet_Items_Secondary_TitlePanel:SetTall(shopSheet_Items:GetTall() / 12)
                shopSheet_Items_Secondary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Items_Secondary_TitlePanel:Dock(TOP)
                shopSheet_Items_Secondary_TitlePanel:InvalidateParent(true)
                shopSheet_Items_Secondary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("PREVIEW", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                local shopSheet_Items_Secondary_PreviewPanel = vgui.Create("DPanel", shopSheet_Items_Secondary)
                shopSheet_Items_Secondary_PreviewPanel:SetTall(shopSheet_Items_Secondary:GetTall() / 2.5)
                shopSheet_Items_Secondary_PreviewPanel:DockPadding(4,4,4,4)
                shopSheet_Items_Secondary_PreviewPanel:Dock(TOP)
                shopSheet_Items_Secondary_PreviewPanel:InvalidateParent(true)
                shopSheet_Items_Secondary_PreviewPanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                end

                    local shopSheet_Items_Secondary_PreviewPanel_Model = vgui.Create("DModelPanel", shopSheet_Items_Secondary_PreviewPanel)
                    shopSheet_Items_Secondary_PreviewPanel_Model:Dock(FILL)
                    shopSheet_Items_Secondary_PreviewPanel_Model:DockPadding(4,4,4,4)
                    shopSheet_Items_Secondary_PreviewPanel_Model:InvalidateParent(true)
                    shopSheet_Items_Secondary_PreviewPanel_Model:SetModel(selectedEntityModel)
                    shopSheet_Items_Secondary_PreviewPanel_Model.LayoutEntity = function(entity)	
                        return
                    end

                    local entityBound_mn, entityBound_mx = shopSheet_Items_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                    local entityBound_size = 0
                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.x) + math.abs(entityBound_mx.x) )
                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.y) + math.abs(entityBound_mx.y) )
                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.z) + math.abs(entityBound_mx.z) )
    
                    shopSheet_Items_Secondary_PreviewPanel_Model:SetFOV( 45 )
                    shopSheet_Items_Secondary_PreviewPanel_Model:SetCamPos( Vector( entityBound_size + 55, entityBound_size + 15, entityBound_size) )
                    shopSheet_Items_Secondary_PreviewPanel_Model:SetLookAt( (entityBound_mn + entityBound_mx) * 0.40)

                    local shopSheet_Items_Secondary_StatsTitle = vgui.Create("DPanel", shopSheet_Items_Secondary)
                    shopSheet_Items_Secondary_StatsTitle:SetTall(shopSheet_Items:GetTall() / 12)
                    shopSheet_Items_Secondary_StatsTitle:DockPadding(20,20,20,20)
                    shopSheet_Items_Secondary_StatsTitle:Dock(TOP)
                    shopSheet_Items_Secondary_StatsTitle:InvalidateParent(true)
                    shopSheet_Items_Secondary_StatsTitle.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                        draw.SimpleText("INFORMATION", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                    end

                    local shopSheet_Items_Secondary_StatsFrame = vgui.Create("DPanel", shopSheet_Items_Secondary)
                    shopSheet_Items_Secondary_StatsFrame:SetTall(shopSheet_Items_Secondary:GetTall() / 5)
                    shopSheet_Items_Secondary_StatsFrame:DockPadding(4,4,4,4)
                    shopSheet_Items_Secondary_StatsFrame:Dock(TOP)
                    shopSheet_Items_Secondary_StatsFrame:InvalidateParent(true)
                    shopSheet_Items_Secondary_StatsFrame.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(71,71,71,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Items_Secondary_StatsPanel_NameLabel = vgui.Create("DLabel", shopSheet_Items_Secondary_StatsFrame)
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:Dock(TOP)
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:DockMargin(6,8,4,4)
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:InvalidateParent(true)
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:SetFont("DAC.ScoreboardTitle")
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:SetText(selectedEntity)
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Items_Secondary_StatsPanel_NameLabel:SetContentAlignment(5) -- https://wiki.facepunch.com/gmod/Panel:SetContentAlignment

                        local shopSheet_Items_Secondary_StatsPanel_CategoryLabel = vgui.Create("DLabel", shopSheet_Items_Secondary_StatsFrame)
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:Dock(TOP)
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:DockMargin(6,0,0,0)
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:InvalidateParent(true)
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetFont("DermaDefaultBold")
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedEntityCategory)
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetContentAlignment(5)

                    local shopSheet_Items_Secondary_BuyButton = vgui.Create("DButton", shopSheet_Items_Secondary)
                    --shopSheet_Items_Secondary_BuyButton:SetTall(shopSheet_Items_Secondary:GetTall() / 5)
                    shopSheet_Items_Secondary_BuyButton:DockMargin(24,24,24,24)
                    shopSheet_Items_Secondary_BuyButton:Dock(FILL)
                    shopSheet_Items_Secondary_BuyButton:SetFont("DAC.PickTeam")
                    shopSheet_Items_Secondary_BuyButton:SetText("PURCHASE (" .. selectedEntityCost .. "cR)")
                    shopSheet_Items_Secondary_BuyButton:InvalidateParent(true)
                    shopSheet_Items_Secondary_BuyButton.Paint = function(self, w, h)
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedEntityCost 
                            and LocalPlayer():Alive() 
                            and LocalPlayer():GetNWBool("IsInBase") == true 
                            and (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetPos()):Length() <= 300 -- Entities need a distance check before they can be purchased
                        then
                                shopSheet_Items_Secondary_BuyButton:SetEnabled(true)
                            draw.RoundedBox(3,0,0, w, h, Color(226,226,226))
                            surface.SetDrawColor(109,255,73)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                        else
                            shopSheet_Items_Secondary_BuyButton:SetEnabled(false)
                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,255))
                            surface.SetDrawColor(255,126,126)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                        end
                    end
                    shopSheet_Items_Secondary_BuyButton.DoClick = function(self, w, h)
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedEntityCost then

                            LocalPlayer():EmitSound(ConfirmNoise)

                            --[[print("\n[DAC DEBUG]: Sending data to server...\n" 
                            .. "Name: " .. selectedEntity .. "\n" 
                            .. "Category: " .. selectedEntityCategory .. "\n"
                            .. "Cost: " .. selectedEntityCost .. "\n"
                            .. "Model: " .. selectedEntityModel .. "\n"
                            .. "List: " .. selectedEntityList .. "\n"
                            .. "Class: " .. selectedEntityClass .. "\n"
                            )]]
                            
                            net.Start("dac_purchase_entity")
                                net.WriteString(selectedEntity)
                                net.WriteString(selectedEntityCategory)
                                net.WriteString(selectedEntityCost)
                                net.WriteString(selectedEntityModel)
                                net.WriteString(selectedEntityList)
                                net.WriteString(selectedEntityClass)
                                net.WriteString(selectedEntitySpawnOffset)
                            net.SendToServer()
                                --print("[DAC DEBUG]: Sent.")

                        else
                            LocalPlayer():EmitSound(DenyNoise)
                        end
                    end

                local shopSheet_Items_Primary_TitlePanel = vgui.Create("DPanel", shopSheet_Items_Primary)
                shopSheet_Items_Primary_TitlePanel:SetTall(shopSheet_Items:GetTall() / 12)
                shopSheet_Items_Primary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Items_Primary_TitlePanel:Dock(TOP)
                shopSheet_Items_Primary_TitlePanel:InvalidateParent(true)
                shopSheet_Items_Primary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("ENTITIES CATALOG", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                    local shopSheet_Items_Primary_PreviewPanel = vgui.Create("DPanel", shopSheet_Items_Primary)
                    --shopSheet_Items_Primary_PreviewPanel:SetTall(shopSheet_Items_Primary:GetTall() / 1.5)
                    shopSheet_Items_Primary_PreviewPanel:DockPadding(5,5,5,5)
                    shopSheet_Items_Primary_PreviewPanel:Dock(FILL)
                    shopSheet_Items_Primary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Items_Primary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Items_Primary_ScrollPanel = vgui.Create("DScrollPanel", shopSheet_Items_Primary_PreviewPanel)
                        shopSheet_Items_Primary_ScrollPanel:Dock(FILL)
                        shopSheet_Items_Primary_ScrollPanel:InvalidateParent(true)
                        shopSheet_Items_Primary_ScrollPanel:GetCanvas():DockPadding(5,5,5,5)
                        shopSheet_Items_Primary_ScrollPanel.Paint = function(self, w, h)
                            draw.RoundedBox(0,0,0, w, h, Color(255,0,179,0))
                        end

                            local shopSheet_Items_AmmoCrates_TitlePanel = vgui.Create("DPanel", shopSheet_Items_Primary_ScrollPanel)
                            shopSheet_Items_AmmoCrates_TitlePanel:SetTall(shopSheet_Items_Primary_PreviewPanel:GetTall() / 12)
                            shopSheet_Items_AmmoCrates_TitlePanel:DockMargin(5,5,5,5)
                            shopSheet_Items_AmmoCrates_TitlePanel:Dock(TOP)
                            shopSheet_Items_AmmoCrates_TitlePanel:InvalidateParent(true)
                            shopSheet_Items_AmmoCrates_TitlePanel.Paint = function(self, w, h)
                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                surface.SetDrawColor(255,255,255)
                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                draw.SimpleText("AMMO CRATES", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                            end

                                local shopSheet_Items_AmmoCrates_IconLayout = vgui.Create( "DIconLayout", shopSheet_Items_Primary_ScrollPanel )
                                shopSheet_Items_AmmoCrates_IconLayout:Dock(TOP)
                                shopSheet_Items_AmmoCrates_IconLayout:SetBorder(10)
                                shopSheet_Items_AmmoCrates_IconLayout:SetSpaceY(5)
                                shopSheet_Items_AmmoCrates_IconLayout:SetSpaceX(5)
                                
                                    for entityIndex, entityValue in pairs (list.Get("dac_ammocrates")) do

                                        local shopSheet_Items_AmmoCrates_IconLayout_PanelFrame = shopSheet_Items_AmmoCrates_IconLayout:Add( "DPanel" )
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame:SetSize( shopSheet_Items_Primary_PreviewPanel:GetWide() / 6, shopSheet_Items_Primary_PreviewPanel:GetWide() / 6 )
                                        
                                        -- Assign contextual values to each panel as it is created for later use
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Name = entityValue.Name
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.ListName = entityValue.ListName
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.VehicleType = entityValue.VehicleType
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Model = entityValue.Model
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Category = entityValue.Category
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Cost = entityValue.Cost
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Class = entityValue.Class
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.SpawnOffset = entityValue.SpawnOffset

                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Paint = function (self, w, h)
                                            if entityValue.Name == selectedEntity then
                                                draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                            else
                                                draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                            end
                                        end

                                        local shopSheet_Items_AmmoCrates_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Items_AmmoCrates_IconLayout_PanelFrame)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot:SetWide(shopSheet_Items_AmmoCrates_IconLayout_PanelFrame:GetTall() * 0.95)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot:Dock(LEFT)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot:InvalidateParent(true)

                                        -- Manually draw the icon slot so it looks nice
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                            surface.SetDrawColor(255,255,255)
                                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                        end

                                        local shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Items_AmmoCrates_IconLayout_IconSlot)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image:Dock(FILL)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image:InvalidateParent(true)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image:SetImage(entityValue.Icon)

                                        local shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Image)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label:SetTall(shopSheet_Items_AmmoCrates_IconLayout_PanelFrame:GetTall() * 0.15)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label:InvalidateParent(true)
                                        shopSheet_Items_AmmoCrates_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                            draw.SimpleText(entityValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                        end

                                        local shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Items_AmmoCrates_IconLayout_PanelFrame)
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button:SetWide(shopSheet_Items_AmmoCrates_IconLayout_PanelFrame:GetWide())
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button:SetTall(shopSheet_Items_AmmoCrates_IconLayout_PanelFrame:GetTall())
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                            -- Return nothing for the ultimate prank, haha ghehgeegr
                                        end
                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button:SetText("")

                                        shopSheet_Items_AmmoCrates_IconLayout_PanelFrame_Button.DoClick = function()

                                            LocalPlayer():EmitSound(ButtonNoise)

                                            selectedEntity = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Name
                                            selectedEntityModel = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Model
                                            selectedEntityType = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.VehicleType
                                            selectedEntityCategory = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Category
                                            selectedEntityCost = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Cost
                                            selectedEntityClass = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.Class
                                            selectedEntityList = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.ListName
                                            selectedEntitySpawnOffset = shopSheet_Items_AmmoCrates_IconLayout_PanelFrame.SpawnOffset

                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetModel(selectedEntityModel)
                                            shopSheet_Items_Secondary_BuyButton:SetText("PURCHASE (" .. selectedEntityCost .. "cR)")
                                            shopSheet_Items_Secondary_StatsPanel_NameLabel:SetText(selectedEntity)
                                            shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedEntityCategory)
                
                                            entityBound_mn, entityBound_mx = shopSheet_Items_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                            entityBound_size = 0
                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.x) + math.abs(entityBound_mx.x) )
                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.y) + math.abs(entityBound_mx.y) )
                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.z) + math.abs(entityBound_mx.z) )
                            
                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetCamPos( Vector( entityBound_size + 55, entityBound_size + 15, entityBound_size) )
                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetLookAt( (entityBound_mn + entityBound_mx) * 0.40)

                                        end

                                    end

                                    local shopSheet_Items_AutoDefense_TitlePanel = vgui.Create("DPanel", shopSheet_Items_Primary_ScrollPanel)
                                    shopSheet_Items_AutoDefense_TitlePanel:SetTall(shopSheet_Items_Primary_PreviewPanel:GetTall() / 12)
                                    shopSheet_Items_AutoDefense_TitlePanel:DockMargin(5,15,5,5)
                                    shopSheet_Items_AutoDefense_TitlePanel:Dock(TOP)
                                    shopSheet_Items_AutoDefense_TitlePanel:InvalidateParent(true)
                                    shopSheet_Items_AutoDefense_TitlePanel.Paint = function(self, w, h)
                                        draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                        surface.SetDrawColor(255,255,255)
                                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                        draw.SimpleText("AUTOMATED DEFENSE", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                    end
        
                                        local shopSheet_Items_AutoDefense_IconLayout = vgui.Create( "DIconLayout", shopSheet_Items_Primary_ScrollPanel )
                                        shopSheet_Items_AutoDefense_IconLayout:Dock(TOP)
                                        shopSheet_Items_AutoDefense_IconLayout:SetBorder(10)
                                        shopSheet_Items_AutoDefense_IconLayout:SetSpaceY(5)
                                        shopSheet_Items_AutoDefense_IconLayout:SetSpaceX(5)
                                        
                                            for entityIndex, entityValue in pairs (list.Get("dac_pointdefense")) do
        
                                                local shopSheet_Items_AutoDefense_IconLayout_PanelFrame = shopSheet_Items_AutoDefense_IconLayout:Add( "DPanel" )
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame:SetSize( shopSheet_Items_Primary_PreviewPanel:GetWide() / 6, shopSheet_Items_Primary_PreviewPanel:GetWide() / 6 )
                                                
                                                -- Assign contextual values to each panel as it is created for later use
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Name = entityValue.Name
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.ListName = entityValue.ListName
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Model = entityValue.Model
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Category = entityValue.Category
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Cost = entityValue.Cost
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Class = entityValue.Class
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.SpawnOffset = entityValue.SpawnOffset
        
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Paint = function (self, w, h)
                                                    if entityValue.Name == selectedEntity then
                                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                                    else
                                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                                    end
                                                end
        
                                                local shopSheet_Items_AutoDefense_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Items_AutoDefense_IconLayout_PanelFrame)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot:SetWide(shopSheet_Items_AutoDefense_IconLayout_PanelFrame:GetTall() * 0.95)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot:Dock(LEFT)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot:InvalidateParent(true)
        
                                                -- Manually draw the icon slot so it looks nice
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot.Paint = function(self, w, h)
                                                    draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                                    surface.SetDrawColor(255,255,255)
                                                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                                end
        
                                                local shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Items_AutoDefense_IconLayout_IconSlot)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image:Dock(FILL)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image:InvalidateParent(true)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image:SetImage(entityValue.Icon)
        
                                                local shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Items_AutoDefense_IconLayout_IconSlot_Image)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label:SetTall(shopSheet_Items_AutoDefense_IconLayout_PanelFrame:GetTall() * 0.15)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label:InvalidateParent(true)
                                                shopSheet_Items_AutoDefense_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                                    draw.SimpleText(entityValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                                end
        
                                                local shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Items_AutoDefense_IconLayout_PanelFrame)
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button:SetWide(shopSheet_Items_AutoDefense_IconLayout_PanelFrame:GetWide())
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button:SetTall(shopSheet_Items_AutoDefense_IconLayout_PanelFrame:GetTall())
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                                    -- Return nothing for the ultimate prank, haha ghehgeegr
                                                end
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button:SetText("")
        
                                                shopSheet_Items_AutoDefense_IconLayout_PanelFrame_Button.DoClick = function()
        
                                                    LocalPlayer():EmitSound(ButtonNoise)
        
                                                    selectedEntity = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Name
                                                    selectedEntityModel = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Model
                                                    selectedEntityCategory = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Category
                                                    selectedEntityCost = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Cost
                                                    selectedEntityClass = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.Class
                                                    selectedEntityList = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.ListName
                                                    selectedEntitySpawnOffset = shopSheet_Items_AutoDefense_IconLayout_PanelFrame.SpawnOffset
        
                                                    shopSheet_Items_Secondary_PreviewPanel_Model:SetModel(selectedEntityModel)
                                                    shopSheet_Items_Secondary_BuyButton:SetText("PURCHASE (" .. selectedEntityCost .. "cR)")
                                                    shopSheet_Items_Secondary_StatsPanel_NameLabel:SetText(selectedEntity)
                                                    shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedEntityCategory)
                        
                                                    entityBound_mn, entityBound_mx = shopSheet_Items_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                                    entityBound_size = 0
                                                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.x) + math.abs(entityBound_mx.x) )
                                                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.y) + math.abs(entityBound_mx.y) )
                                                    entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.z) + math.abs(entityBound_mx.z) )
                                    
                                                    shopSheet_Items_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                                    shopSheet_Items_Secondary_PreviewPanel_Model:SetCamPos( Vector( entityBound_size + 55, entityBound_size + 15, entityBound_size) )
                                                    shopSheet_Items_Secondary_PreviewPanel_Model:SetLookAt( (entityBound_mn + entityBound_mx) * 0.40)
        
                                                end
        
                                            end

                                            local shopSheet_Items_PhysicsProps_TitlePanel = vgui.Create("DPanel", shopSheet_Items_Primary_ScrollPanel)
                                            shopSheet_Items_PhysicsProps_TitlePanel:SetTall(shopSheet_Items_Primary_PreviewPanel:GetTall() / 12)
                                            shopSheet_Items_PhysicsProps_TitlePanel:DockMargin(5,15,5,5)
                                            shopSheet_Items_PhysicsProps_TitlePanel:Dock(TOP)
                                            shopSheet_Items_PhysicsProps_TitlePanel:InvalidateParent(true)
                                            shopSheet_Items_PhysicsProps_TitlePanel.Paint = function(self, w, h)
                                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                                surface.SetDrawColor(255,255,255)
                                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                                draw.SimpleText("PHYSICS OBJECTS", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                            end
                
                                                local shopSheet_Items_PhysicsProps_IconLayout = vgui.Create( "DIconLayout", shopSheet_Items_Primary_ScrollPanel )
                                                shopSheet_Items_PhysicsProps_IconLayout:Dock(TOP)
                                                shopSheet_Items_PhysicsProps_IconLayout:SetBorder(10)
                                                shopSheet_Items_PhysicsProps_IconLayout:SetSpaceY(5)
                                                shopSheet_Items_PhysicsProps_IconLayout:SetSpaceX(5)
                                                
                                                    for entityIndex, entityValue in pairs (list.Get("dac_physicsprops")) do
                
                                                        local shopSheet_Items_PhysicsProps_IconLayout_PanelFrame = shopSheet_Items_PhysicsProps_IconLayout:Add( "DPanel" )
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame:SetSize( shopSheet_Items_Primary_PreviewPanel:GetWide() / 6, shopSheet_Items_Primary_PreviewPanel:GetWide() / 6 )
                                                        
                                                        -- Assign contextual values to each panel as it is created for later use
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Name = entityValue.Name
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.ListName = entityValue.ListName
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Model = entityValue.Model
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Category = entityValue.Category
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Cost = entityValue.Cost
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Class = entityValue.Class
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.SpawnOffset = entityValue.SpawnOffset
                
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Paint = function (self, w, h)
                                                            if entityValue.Name == selectedEntity then
                                                                draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                                            else
                                                                draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                                            end
                                                        end
                
                                                        local shopSheet_Items_PhysicsProps_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Items_PhysicsProps_IconLayout_PanelFrame)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot:SetWide(shopSheet_Items_PhysicsProps_IconLayout_PanelFrame:GetTall() * 0.95)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot:Dock(LEFT)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot:InvalidateParent(true)
                
                                                        -- Manually draw the icon slot so it looks nice
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot.Paint = function(self, w, h)
                                                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                                            surface.SetDrawColor(255,255,255)
                                                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                                        end
                
                                                        local shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Items_PhysicsProps_IconLayout_IconSlot)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image:Dock(FILL)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image:InvalidateParent(true)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image:SetImage(entityValue.Icon)
                
                                                        local shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Image)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label:SetTall(shopSheet_Items_PhysicsProps_IconLayout_PanelFrame:GetTall() * 0.15)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label:InvalidateParent(true)
                                                        shopSheet_Items_PhysicsProps_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                                            draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                                            draw.SimpleText(entityValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                                        end
                
                                                        local shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Items_PhysicsProps_IconLayout_PanelFrame)
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button:SetWide(shopSheet_Items_PhysicsProps_IconLayout_PanelFrame:GetWide())
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button:SetTall(shopSheet_Items_PhysicsProps_IconLayout_PanelFrame:GetTall())
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                                            -- Return nothing for the ultimate prank, haha ghehgeegr
                                                        end
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button:SetText("")
                
                                                        shopSheet_Items_PhysicsProps_IconLayout_PanelFrame_Button.DoClick = function()
                
                                                            LocalPlayer():EmitSound(ButtonNoise)
                
                                                            selectedEntity = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Name
                                                            selectedEntityModel = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Model
                                                            selectedEntityCategory = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Category
                                                            selectedEntityCost = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Cost
                                                            selectedEntityClass = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.Class
                                                            selectedEntityList = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.ListName
                                                            selectedEntitySpawnOffset = shopSheet_Items_PhysicsProps_IconLayout_PanelFrame.SpawnOffset
                
                                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetModel(selectedEntityModel)
                                                            shopSheet_Items_Secondary_BuyButton:SetText("PURCHASE (" .. selectedEntityCost .. "cR)")
                                                            shopSheet_Items_Secondary_StatsPanel_NameLabel:SetText(selectedEntity)
                                                            shopSheet_Items_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedEntityCategory)
                                
                                                            entityBound_mn, entityBound_mx = shopSheet_Items_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                                            entityBound_size = 0
                                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.x) + math.abs(entityBound_mx.x) )
                                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.y) + math.abs(entityBound_mx.y) )
                                                            entityBound_size = math.max( entityBound_size, math.abs(entityBound_mn.z) + math.abs(entityBound_mx.z) )
                                            
                                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetCamPos( Vector( entityBound_size + 55, entityBound_size + 15, entityBound_size) )
                                                            shopSheet_Items_Secondary_PreviewPanel_Model:SetLookAt( (entityBound_mn + entityBound_mx) * 0.40)
                
                                                        end
                
                                                end

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

                    local vehicleBound_mn, vehicleBound_mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                    local vehicleBound_size = 0
                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.x) + math.abs(vehicleBound_mx.x) )
                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.y) + math.abs(vehicleBound_mx.y) )
                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.z) + math.abs(vehicleBound_mx.z) )
    
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( vehicleBound_size, vehicleBound_size + 105, vehicleBound_size) )
                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (vehicleBound_mn + vehicleBound_mx) * 0.3 )

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
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedVehicleCost and LocalPlayer():Alive() and LocalPlayer():GetNWBool("IsInBase") == true then
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
                                    net.WriteString(selectedVehicleSpawnOffset)
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
                                        shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.SpawnOffset = vehicleValue.SpawnOffset

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
                                            selectedVehicleSpawnOffset = shopSheet_Vehicles_ArmedVehicles_IconLayout_PanelFrame.SpawnOffset

                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                            shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                            shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                            shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                            shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
                
                                            vehicleBound_mn, vehicleBound_mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                            vehicleBound_size = 0
                                            vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.x) + math.abs(vehicleBound_mx.x) )
                                            vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.y) + math.abs(vehicleBound_mx.y) )
                                            vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.z) + math.abs(vehicleBound_mx.z) )
                            
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( vehicleBound_size, vehicleBound_size + 105, vehicleBound_size) )
                                            shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (vehicleBound_mn + vehicleBound_mx) * 0.3 )

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
                                shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.SpawnOffset = vehicleValue.SpawnOffset

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
                                    selectedVehicleSpawnOffset = shopSheet_Vehicles_CivilianVehicles_IconLayout_PanelFrame.SpawnOffset

                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                    shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                    shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                    shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                    shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
        
                                    vehicleBound_mn, vehicleBound_mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                    vehicleBound_size = 0
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.x) + math.abs(vehicleBound_mx.x) )
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.y) + math.abs(vehicleBound_mx.y) )
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.z) + math.abs(vehicleBound_mx.z) )
                    
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( vehicleBound_size, vehicleBound_size + 105, vehicleBound_size) )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (vehicleBound_mn + vehicleBound_mx) * 0.3 )

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
                                shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.SpawnOffset = vehicleValue.SpawnOffset

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
                                    selectedVehicleSpawnOffset = shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.SpawnOffset

                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetModel(selectedVehicleModel)
                                    shopSheet_Vehicles_Secondary_BuyButton:SetText("PURCHASE (" .. selectedVehicleCost .. "cR)")
                                    shopSheet_Vehicles_Secondary_StatsPanel_NameLabel:SetText(selectedVehicle)
                                    shopSheet_Vehicles_Secondary_StatsPanel_TransportStatusLabel:SetText("Flag Transport: " .. string.upper(tostring(selectedVehicleTransportStatus)))
                                    shopSheet_Vehicles_Secondary_StatsPanel_CategoryLabel:SetText("Primary Role: " .. selectedVehicleCategory)
        
                                    vehicleBound_mn, vehicleBound_mx = shopSheet_Vehicles_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                    vehicleBound_size = 0
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.x) + math.abs(vehicleBound_mx.x) )
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.y) + math.abs(vehicleBound_mx.y) )
                                    vehicleBound_size = math.max( vehicleBound_size, math.abs(vehicleBound_mn.z) + math.abs(vehicleBound_mx.z) )
                    
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetCamPos( Vector( vehicleBound_size, vehicleBound_size + 105, vehicleBound_size) )
                                    shopSheet_Vehicles_Secondary_PreviewPanel_Model:SetLookAt( (vehicleBound_mn + vehicleBound_mx) * 0.3 )

                                    -- For debugging help
                                    --[[print("\n-- SELECTED VEHICLE --\n" 
                                    .. "Name: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Name .. "\n" 
                                    .. "Type: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.VehicleType .. "\n"
                                    .. "Category: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Category .. "\n"
                                    .. "Cost: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Cost .. "\n"
                                    .. "FlagTransport: " .. tostring(shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.IsFlagTransport) .. "\n"
                                    .. "Model: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Model .. "\n"
                                    .. "List: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.ListName .. "\n"
                                    .. "Class: " .. shopSheet_Vehicles_AirVehicles_IconLayout_PanelFrame.Class.. "\n"
                                    )]]

                                end

                            end

            --- UPGRADE TAB ---

            local shopSheet_Upgrades = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Upgrades:Dock(FILL)
            shopSheet_Upgrades:InvalidateParent(true)
            shopSheet_Upgrades.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Ammo", shopSheet_Upgrades, "icon16/box.png")

                -- Divide the vehicles panel into two pieces, dock this child panel to the left
                local shopSheet_Ammo_Primary = vgui.Create("DPanel", shopSheet_Upgrades)
                shopSheet_Ammo_Primary:SetWide(shopSheet_Upgrades:GetWide() / 1.5)
                shopSheet_Ammo_Primary:DockPadding(20,20,20,20)
                shopSheet_Ammo_Primary:Dock(LEFT)
                shopSheet_Ammo_Primary:InvalidateParent(true)
                shopSheet_Ammo_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,0)) -- Red for visualizing positioning
                end

                local shopSheet_Ammo_Secondary = vgui.Create("DPanel", shopSheet_Upgrades)
                shopSheet_Ammo_Secondary:SetWide(shopSheet_Upgrades:GetWide() / 3)
                shopSheet_Ammo_Secondary:DockPadding(20,20,20,20)
                shopSheet_Ammo_Secondary:Dock(RIGHT)
                shopSheet_Ammo_Secondary:InvalidateParent(true)
                shopSheet_Ammo_Secondary.Paint = function(self, w, h)
                        draw.RoundedBox(0,0,0, w, h, Color(0,35,131,0)) -- Blue for visualizing positioning
                end

                local shopSheet_Ammo_Secondary_TitlePanel = vgui.Create("DPanel", shopSheet_Ammo_Secondary)
                shopSheet_Ammo_Secondary_TitlePanel:SetTall(shopSheet_Upgrades:GetTall() / 12)
                shopSheet_Ammo_Secondary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Ammo_Secondary_TitlePanel:Dock(TOP)
                shopSheet_Ammo_Secondary_TitlePanel:InvalidateParent(true)
                shopSheet_Ammo_Secondary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("PREVIEW", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                local shopSheet_Ammo_Secondary_PreviewPanel = vgui.Create("DPanel", shopSheet_Ammo_Secondary)
                shopSheet_Ammo_Secondary_PreviewPanel:SetTall(shopSheet_Ammo_Secondary:GetTall() / 2.5)
                shopSheet_Ammo_Secondary_PreviewPanel:DockPadding(4,4,4,4)
                shopSheet_Ammo_Secondary_PreviewPanel:Dock(TOP)
                shopSheet_Ammo_Secondary_PreviewPanel:InvalidateParent(true)
                shopSheet_Ammo_Secondary_PreviewPanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                end

                    local shopSheet_Ammo_Secondary_PreviewPanel_Model = vgui.Create("DModelPanel", shopSheet_Ammo_Secondary_PreviewPanel)
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:Dock(FILL)
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:DockPadding(4,4,4,4)
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:InvalidateParent(true)
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetModel(selectedItemModel)
                    shopSheet_Ammo_Secondary_PreviewPanel_Model.LayoutEntity = function(entity)	
                        return
                    end

                    local itemBound_mn, itemBound_mx = shopSheet_Ammo_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                    local itemBound_size = 0
                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.x) + math.abs(itemBound_mx.x) )
                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.y) + math.abs(itemBound_mx.y) )
                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.z) + math.abs(itemBound_mx.z) )
    
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetFOV( 45 )
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetCamPos( Vector( itemBound_size, itemBound_size + 10, itemBound_size) )
                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetLookAt( (itemBound_mn + itemBound_mx) * 0.42 )

                    local shopSheet_Ammo_Secondary_StatsTitle = vgui.Create("DPanel", shopSheet_Ammo_Secondary)
                    shopSheet_Ammo_Secondary_StatsTitle:SetTall(shopSheet_Upgrades:GetTall() / 12)
                    shopSheet_Ammo_Secondary_StatsTitle:DockPadding(20,20,20,20)
                    shopSheet_Ammo_Secondary_StatsTitle:Dock(TOP)
                    shopSheet_Ammo_Secondary_StatsTitle:InvalidateParent(true)
                    shopSheet_Ammo_Secondary_StatsTitle.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                        draw.SimpleText("INFORMATION", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                    end

                    local shopSheet_Ammo_Secondary_StatsFrame = vgui.Create("DPanel", shopSheet_Ammo_Secondary)
                    shopSheet_Ammo_Secondary_StatsFrame:SetTall(shopSheet_Ammo_Secondary:GetTall() / 5)
                    shopSheet_Ammo_Secondary_StatsFrame:DockPadding(4,4,4,4)
                    shopSheet_Ammo_Secondary_StatsFrame:Dock(TOP)
                    shopSheet_Ammo_Secondary_StatsFrame:InvalidateParent(true)
                    shopSheet_Ammo_Secondary_StatsFrame.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(71,71,71,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Ammo_Secondary_StatsPanel_NameLabel = vgui.Create("DLabel", shopSheet_Ammo_Secondary_StatsFrame)
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:Dock(TOP)
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:DockMargin(6,8,4,4)
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:InvalidateParent(true)
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetFont("DAC.ScoreboardTitle")
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetText(selectedItem)
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetContentAlignment(5) -- https://wiki.facepunch.com/gmod/Panel:SetContentAlignment

                        local shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel = vgui.Create("DLabel", shopSheet_Ammo_Secondary_StatsFrame)
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:Dock(TOP)
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:DockMargin(6,0,0,0)
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:InvalidateParent(true)
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetFont("DermaDefaultBold")
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedItemCategory)
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetTextColor(Color(255,255,255))
                        shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetContentAlignment(5)

                    local shopSheet_Ammo_Secondary_BuyButton = vgui.Create("DButton", shopSheet_Ammo_Secondary)
                    --shopSheet_Ammo_Secondary_BuyButton:SetTall(shopSheet_Ammo_Secondary:GetTall() / 5)
                    shopSheet_Ammo_Secondary_BuyButton:DockMargin(24,24,24,24)
                    shopSheet_Ammo_Secondary_BuyButton:Dock(FILL)
                    shopSheet_Ammo_Secondary_BuyButton:SetFont("DAC.PickTeam")
                    shopSheet_Ammo_Secondary_BuyButton:SetText("PURCHASE (" .. selectedItemCost .. "cR)")
                    shopSheet_Ammo_Secondary_BuyButton:InvalidateParent(true)
                    shopSheet_Ammo_Secondary_BuyButton.Paint = function(self, w, h)

                        local gameStage = DAC:GetGameStage()
                        local gameStageData = gameStage:GetData()

                        if LocalPlayer():GetNWInt("storeCredits") >= selectedItemCost 
                            and LocalPlayer():Alive() 
                            and LocalPlayer():GetNWBool("IsInBase") == true 
                            and (LocalPlayer():GetEyeTrace().HitPos - LocalPlayer():GetPos()):Length() <= 300 -- Entities need a distance check before they can be purchased
                            and gameStageData.name == "MATCH" -- Not allowed to buy ammo or health during pre-setup
                        then
                            shopSheet_Ammo_Secondary_BuyButton:SetEnabled(true)
                            draw.RoundedBox(3,0,0, w, h, Color(226,226,226))
                            surface.SetDrawColor(109,255,73)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                            shopSheet_Ammo_Secondary_BuyButton:SetText("PURCHASE (" .. selectedItemCost .. "cR)")
                        else
                            shopSheet_Ammo_Secondary_BuyButton:SetEnabled(false)
                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,255))
                            surface.SetDrawColor(255,126,126)
                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 4)
                            shopSheet_Ammo_Secondary_BuyButton:SetText("MATCH NOT STARTED")
                        end
                    end
                    shopSheet_Ammo_Secondary_BuyButton.DoClick = function(self, w, h)
                        if LocalPlayer():GetNWInt("storeCredits") >= selectedItemCost then

                            LocalPlayer():EmitSound(ConfirmNoise)

                            --[[print("\n[DAC DEBUG]: Sending data to server...\n" 
                            .. "Name: " .. selectedItem .. "\n" 
                            .. "Category: " .. selectedItemCategory .. "\n"
                            .. "Cost: " .. selectedItemCost .. "\n"
                            .. "Model: " .. selectedItemModel .. "\n"
                            .. "List: " .. selectedItemList .. "\n"
                            .. "Class: " .. selectedItemClass .. "\n"
                            )]]
                            
                            net.Start("dac_purchase_entity")
                                net.WriteString(selectedItem)
                                net.WriteString(selectedItemCategory)
                                net.WriteString(selectedItemCost)
                                net.WriteString(selectedItemModel)
                                net.WriteString(selectedItemList)
                                net.WriteString(selectedItemClass)
                                net.WriteString(selectedItemSpawnOffset)
                            net.SendToServer()
                                --print("[DAC DEBUG]: Sent.")

                        else
                            LocalPlayer():EmitSound(DenyNoise)
                        end
                    end

                local shopSheet_Ammo_Primary_TitlePanel = vgui.Create("DPanel", shopSheet_Ammo_Primary)
                shopSheet_Ammo_Primary_TitlePanel:SetTall(shopSheet_Upgrades:GetTall() / 12)
                shopSheet_Ammo_Primary_TitlePanel:DockPadding(20,20,20,20)
                shopSheet_Ammo_Primary_TitlePanel:Dock(TOP)
                shopSheet_Ammo_Primary_TitlePanel:InvalidateParent(true)
                shopSheet_Ammo_Primary_TitlePanel.Paint = function(self, w, h)
                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255)
                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    draw.SimpleText("UPGRADES CATALOG", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                    local shopSheet_Ammo_Primary_PreviewPanel = vgui.Create("DPanel", shopSheet_Ammo_Primary)
                    --shopSheet_Ammo_Primary_PreviewPanel:SetTall(shopSheet_Ammo_Primary:GetTall() / 1.5)
                    shopSheet_Ammo_Primary_PreviewPanel:DockPadding(5,5,5,5)
                    shopSheet_Ammo_Primary_PreviewPanel:Dock(FILL)
                    shopSheet_Ammo_Primary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Ammo_Primary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(97,97,97,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                        local shopSheet_Ammo_Primary_ScrollPanel = vgui.Create("DScrollPanel", shopSheet_Ammo_Primary_PreviewPanel)
                        shopSheet_Ammo_Primary_ScrollPanel:Dock(FILL)
                        shopSheet_Ammo_Primary_ScrollPanel:InvalidateParent(true)
                        shopSheet_Ammo_Primary_ScrollPanel:GetCanvas():DockPadding(5,5,5,5)
                        shopSheet_Ammo_Primary_ScrollPanel.Paint = function(self, w, h)
                            draw.RoundedBox(0,0,0, w, h, Color(255,0,179,0))
                        end

                            local shopSheet_Ammo_AmmoCrates_TitlePanel = vgui.Create("DPanel", shopSheet_Ammo_Primary_ScrollPanel)
                            shopSheet_Ammo_AmmoCrates_TitlePanel:SetTall(shopSheet_Ammo_Primary_PreviewPanel:GetTall() / 12)
                            shopSheet_Ammo_AmmoCrates_TitlePanel:DockMargin(5,5,5,5)
                            shopSheet_Ammo_AmmoCrates_TitlePanel:Dock(TOP)
                            shopSheet_Ammo_AmmoCrates_TitlePanel:InvalidateParent(true)
                            shopSheet_Ammo_AmmoCrates_TitlePanel.Paint = function(self, w, h)
                                draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                surface.SetDrawColor(255,255,255)
                                surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                draw.SimpleText("INDIVIDUAL AMMO", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                            end

                                local shopSheet_Ammo_AmmoCrates_IconLayout = vgui.Create( "DIconLayout", shopSheet_Ammo_Primary_ScrollPanel )
                                shopSheet_Ammo_AmmoCrates_IconLayout:Dock(TOP)
                                shopSheet_Ammo_AmmoCrates_IconLayout:SetBorder(10)
                                shopSheet_Ammo_AmmoCrates_IconLayout:SetSpaceY(5)
                                shopSheet_Ammo_AmmoCrates_IconLayout:SetSpaceX(5)
                                
                                    for itemIndex, itemValue in pairs (list.Get("dac_items_ammo")) do

                                        local shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame = shopSheet_Ammo_AmmoCrates_IconLayout:Add( "DPanel" )
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame:SetSize( shopSheet_Ammo_Primary_PreviewPanel:GetWide() / 6, shopSheet_Ammo_Primary_PreviewPanel:GetWide() / 6 )
                                        
                                        -- Assign contextual values to each panel as it is created for later use
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Name = itemValue.Name
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.ListName = itemValue.ListName
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Model = itemValue.Model
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Category = itemValue.Category
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Cost = itemValue.Cost
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Class = itemValue.Class
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.SpawnOffset = itemValue.SpawnOffset

                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Paint = function (self, w, h)
                                            if itemValue.Name == selectedItem then
                                                draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                            else
                                                draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                            end
                                        end

                                        local shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot:SetWide(shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame:GetTall() * 0.95)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot:Dock(LEFT)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot:InvalidateParent(true)

                                        -- Manually draw the icon slot so it looks nice
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                            surface.SetDrawColor(255,255,255)
                                            surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                        end

                                        local shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image:Dock(FILL)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image:InvalidateParent(true)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image:SetImage(itemValue.Icon)

                                        local shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Image)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label:SetTall(shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame:GetTall() * 0.15)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label:InvalidateParent(true)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                            draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                            draw.SimpleText(itemValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                        end

                                        local shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame)
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button:SetWide(shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame:GetWide())
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button:SetTall(shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame:GetTall())
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                            -- Return nothing for the ultimate prank, haha ghehgeegr
                                        end
                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button:SetText("")

                                        shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame_Button.DoClick = function()

                                            LocalPlayer():EmitSound(ButtonNoise)

                                            selectedItem = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Name
                                            selectedItemModel = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Model
                                            selectedItemCategory = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Category
                                            selectedItemCost = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Cost
                                            selectedItemClass = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.Class
                                            selectedItemList = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.ListName
                                            selectedItemSpawnOffset = shopSheet_Ammo_AmmoCrates_IconLayout_PanelFrame.SpawnOffset

                                            shopSheet_Ammo_Secondary_PreviewPanel_Model:SetModel(selectedItemModel)
                                            shopSheet_Ammo_Secondary_BuyButton:SetText("PURCHASE (" .. selectedItemCost .. "cR)")
                                            shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetText(selectedItem)
                                            shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedItemCategory)
                
                                            itemBound_mn, itemBound_mx = shopSheet_Ammo_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                            itemBound_size = 0
                                            itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.x) + math.abs(itemBound_mx.x) )
                                            itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.y) + math.abs(itemBound_mx.y) )
                                            itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.z) + math.abs(itemBound_mx.z) )
                            
                                            shopSheet_Ammo_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                            shopSheet_Ammo_Secondary_PreviewPanel_Model:SetCamPos( Vector( itemBound_size, itemBound_size + 10 , itemBound_size) )
                                            shopSheet_Ammo_Secondary_PreviewPanel_Model:SetLookAt( (itemBound_mn + itemBound_mx) * 0.42 )

                                        end

                                    end

                                    local shopSheet_Ammo_AutoDefense_TitlePanel = vgui.Create("DPanel", shopSheet_Ammo_Primary_ScrollPanel)
                                    shopSheet_Ammo_AutoDefense_TitlePanel:SetTall(shopSheet_Ammo_Primary_PreviewPanel:GetTall() / 12)
                                    shopSheet_Ammo_AutoDefense_TitlePanel:DockMargin(5,15,5,5)
                                    shopSheet_Ammo_AutoDefense_TitlePanel:Dock(TOP)
                                    shopSheet_Ammo_AutoDefense_TitlePanel:InvalidateParent(true)
                                    shopSheet_Ammo_AutoDefense_TitlePanel.Paint = function(self, w, h)
                                        draw.RoundedBox(3,0,0, w, h, Color(0,0,0,200))
                                        surface.SetDrawColor(255,255,255)
                                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                        draw.SimpleText("HEALTH & ARMOR", "DAC.PickTeam", w * 0.5, 12, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                    end
        
                                        local shopSheet_Ammo_AutoDefense_IconLayout = vgui.Create( "DIconLayout", shopSheet_Ammo_Primary_ScrollPanel )
                                        shopSheet_Ammo_AutoDefense_IconLayout:Dock(TOP)
                                        shopSheet_Ammo_AutoDefense_IconLayout:SetBorder(10)
                                        shopSheet_Ammo_AutoDefense_IconLayout:SetSpaceY(5)
                                        shopSheet_Ammo_AutoDefense_IconLayout:SetSpaceX(5)
                                        
                                            for entityIndex, itemValue in pairs (list.Get("dac_items_playersupplies")) do
        
                                                local shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame = shopSheet_Ammo_AutoDefense_IconLayout:Add( "DPanel" )
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame:SetSize( shopSheet_Ammo_Primary_PreviewPanel:GetWide() / 6, shopSheet_Ammo_Primary_PreviewPanel:GetWide() / 6 )
                                                
                                                -- Assign contextual values to each panel as it is created for later use
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Name = itemValue.Name
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.ListName = itemValue.ListName
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Model = itemValue.Model
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Category = itemValue.Category
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Cost = itemValue.Cost
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Class = itemValue.Class
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.SpawnOffset = itemValue.SpawnOffset
        
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Paint = function (self, w, h)
                                                    if itemValue.Name == selectedItem then
                                                        draw.RoundedBox(3,0,0, w, h, Color(71,144,255))
                                                    else
                                                        draw.RoundedBox(3,0,0, w, h, Color(218,218,218))
                                                    end
                                                end
        
                                                local shopSheet_Ammo_AutoDefense_IconLayout_IconSlot = vgui.Create("DPanel", shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot:SetWide(shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame:GetTall() * 0.95)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot:DockMargin(4,4,4,4)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot:Dock(LEFT)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot:InvalidateParent(true)
        
                                                -- Manually draw the icon slot so it looks nice
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot.Paint = function(self, w, h)
                                                    draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                                                    surface.SetDrawColor(255,255,255)
                                                    surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                                                end
        
                                                local shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image = vgui.Create("DImage", shopSheet_Ammo_AutoDefense_IconLayout_IconSlot)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image:DockMargin(4,4,4,4)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image:Dock(FILL)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image:InvalidateParent(true)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image:SetImage(itemValue.Icon)
        
                                                local shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label = vgui.Create("DPanel", shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Image)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label:SetTall(shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame:GetTall() * 0.15)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label:DockMargin(4,4,4,4)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label:Dock(BOTTOM)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label:InvalidateParent(true)
                                                shopSheet_Ammo_AutoDefense_IconLayout_IconSlot_Label.Paint = function(self, w, h)
                                                    draw.RoundedBox(3,0,0, w, h, Color(0,0,0,192))
                                                    draw.SimpleText(itemValue.Name, "DermaDefault", w * 0.5, 3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                                                end
        
                                                local shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button = vgui.Create("DButton", shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame)
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button:SetWide(shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame:GetWide())
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button:SetTall(shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame:GetTall())
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button.Paint = function(self, w, h)
                                                    -- Return nothing for the ultimate prank, haha ghehgeegr
                                                end
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button:SetText("")
        
                                                shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame_Button.DoClick = function()
        
                                                    LocalPlayer():EmitSound(ButtonNoise)
        
                                                    selectedItem = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Name
                                                    selectedItemModel = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Model
                                                    selectedItemType = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.VehicleType
                                                    selectedItemCategory = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Category
                                                    selectedItemCost = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Cost
                                                    selectedItemClass = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.Class
                                                    selectedItemList = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.ListName
                                                    selectedItemSpawnOffset = shopSheet_Ammo_AutoDefense_IconLayout_PanelFrame.SpawnOffset
        
                                                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetModel(selectedItemModel)
                                                    shopSheet_Ammo_Secondary_BuyButton:SetText("PURCHASE (" .. selectedItemCost .. "cR)")
                                                    shopSheet_Ammo_Secondary_StatsPanel_NameLabel:SetText(selectedItem)
                                                    shopSheet_Ammo_Secondary_StatsPanel_CategoryLabel:SetText("Category: " .. selectedItemCategory)
                        
                                                    itemBound_mn, itemBound_mx = shopSheet_Ammo_Secondary_PreviewPanel_Model.Entity:GetRenderBounds()
                                                    itemBound_size = 0
                                                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.x) + math.abs(itemBound_mx.x) )
                                                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.y) + math.abs(itemBound_mx.y) )
                                                    itemBound_size = math.max( itemBound_size, math.abs(itemBound_mn.z) + math.abs(itemBound_mx.z) )
                                    
                                                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetFOV( 45 )
                                                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetCamPos( Vector( itemBound_size, itemBound_size + 10 , itemBound_size) )
                                                    shopSheet_Ammo_Secondary_PreviewPanel_Model:SetLookAt( (itemBound_mn + itemBound_mx) * 0.42 )
        
                                                end
        
                                            end

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

            --- PLAYERMODEL TAB ---

            local shopSheet_Player = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Player:Dock(FILL)
            shopSheet_Player:InvalidateParent(true)
            shopSheet_Player.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Player", shopSheet_Player, "icon16/user.png")

                local shopSheet_Player_Primary = vgui.Create("DPanel", shopSheet_Player)
                shopSheet_Player_Primary:SetWide(shopSheet_Player:GetWide() / 2)
                shopSheet_Player_Primary:DockPadding(20,20,20,20)
                shopSheet_Player_Primary:Dock(LEFT)
                shopSheet_Player_Primary:InvalidateParent(true)
                shopSheet_Player_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,100)) -- Red for visualizing positioning
                end

                local shopSheet_Player_Secondary = vgui.Create("DPanel", shopSheet_Player)
                shopSheet_Player_Secondary:SetWide(shopSheet_Player:GetWide() / 2)
                shopSheet_Player_Secondary:DockPadding(20,20,20,20)
                shopSheet_Player_Secondary:Dock(RIGHT)
                shopSheet_Player_Secondary:InvalidateParent(true)
                shopSheet_Player_Secondary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(0,35,100)) -- Blue for visualizing positioning
                end

            --- KOFI TIP TAB ---

            local shopSheet_Tip = vgui.Create("DHTML", mainColumnSheet)
            shopSheet_Tip:Dock(FILL)
            shopSheet_Tip:InvalidateParent(true)
            mainColumnSheet:AddSheet("Ko-fi Tip", shopSheet_Tip, "icon16/cup.png")

                local shopSheet_Tip_Panel = vgui.Create("DPanel", shopSheet_Tip)
                shopSheet_Tip_Panel:SetWide(shopSheet_Tip:GetWide() / 2)
                shopSheet_Tip_Panel:DockPadding(20,20,20,20)
                shopSheet_Tip_Panel:Dock(FILL)
                shopSheet_Tip_Panel:InvalidateParent(true)
                shopSheet_Tip_Panel.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(100,100,100,100))
                    draw.SimpleText("Loading...", "DAC.PickTeam", w * 0.5, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2)
                end

                local shopSheet_Tip_Window = vgui.Create( "DHTML", shopSheet_Tip_Panel )
                shopSheet_Tip_Window:Dock(FILL)
                shopSheet_Tip_Window:OpenURL("ko-fi.com/dragonbyte1546")

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