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
    local selectedPrimary = nil
    local selectedSpecial = nil

    MENU_FRAME = MENU_FRAME or nil

    function multiMenu()

        -- Menu button was pushed and the frame isn't valid, so we'll create it
        if !IsValid(MENU_FRAME) then

            LocalPlayer():EmitSound(OpenNoise)
            gui.EnableScreenClicker(true)

            -- Before we do anything else, we should get the first index of the weapon lists. This allows us to retrieve the first class value regardless of what the list contains
            -- This should only be done once as not to override weapon selections once they've been picked, so we check for nil and then assign internally
            -- That way it'll never trip again beyond first opening the menu
            if selectedPrimary == nil or selectedSpecial == nil then

                -- We assign the first class value to a variable that is used to drive the paint function on the selection buttons later
                -- Because those lists are populated by the same table in ascending order, the first value in the table should be highlighted on the UI
                for weaponIndex, weaponValue in pairs(list.Get("weapons_primary")) do
                    selectedPrimary = weaponValue.Class -- We're just getting the first value and breaking after that
                    print("Assigned selectedPrimary as: " .. selectedPrimary)
                    break
                end
                    
                for weaponIndex, weaponValue in pairs(list.Get("weapons_equipment")) do
                    selectedSpecial = weaponValue.Class -- We're just getting the first value and breaking after that
                    print("Assigned selectedSpecial as: " .. selectedSpecial)
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
            creditsLabel:SetText( LocalPlayer():GetNWInt("storeCredits") .. " cR") -- This will probably need to be moved to a think or paint function, just a placeholder for now
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

            --- VEHICLE TAB ---

            local shopSheet_Vehicles = vgui.Create("DPanel", mainColumnSheet)
            shopSheet_Vehicles:Dock(FILL)
            shopSheet_Vehicles:InvalidateParent(true)
            shopSheet_Vehicles.Paint = function(self, w, h)
                draw.RoundedBox(0,0,0, w, h, Color(10,10,10,100))
            end
            mainColumnSheet:AddSheet("Vehicles", shopSheet_Vehicles, "icon16/car.png")

                -- [LEFT VEHICLES PANEL] --
                -- Divide the vehicles panel into two pieces, dock this child panel to the left
                local shopSheet_Vehicles_Primary = vgui.Create("DPanel", shopSheet_Vehicles)
                shopSheet_Vehicles_Primary:SetWide(shopSheet_Vehicles:GetWide() / 2)
                shopSheet_Vehicles_Primary:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Primary:Dock(LEFT)
                shopSheet_Vehicles_Primary:InvalidateParent(true)
                shopSheet_Vehicles_Primary.Paint = function(self, w, h)
                    draw.RoundedBox(0,0,0, w, h, Color(107,0,0,100)) -- Red for visualizing positioning
                end

                    local shopSheet_Vehicles_Primary_PreviewPanel = vgui.Create("DPanel", shopSheet_Vehicles_Primary)
                    shopSheet_Vehicles_Primary_PreviewPanel:SetTall(shopSheet_Vehicles_Primary:GetTall() / 1.5)
                    shopSheet_Vehicles_Primary_PreviewPanel:DockPadding(4,4,4,4)
                    shopSheet_Vehicles_Primary_PreviewPanel:Dock(TOP)
                    shopSheet_Vehicles_Primary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Vehicles_Primary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
                        surface.SetDrawColor(255,255,255)
                        surface.DrawOutlinedRect(2, 2, w - 4, h - 4, 2)
                    end

                    -- Local arrays for indexing list rows
                    -- I know they're technically tables because Lua doesn't have arrays, fuck you
                    local primaryWeaponClasses = {}
                    local primaryWeaponIcons = {}

                    local shopSheet_Vehicles_Primary_List = vgui.Create("DListView", shopSheet_Vehicles_Primary)
                    shopSheet_Vehicles_Primary_List:SetTall(shopSheet_Vehicles_Primary:GetTall() / 4)
                    shopSheet_Vehicles_Primary_List:Dock(BOTTOM)
                    shopSheet_Vehicles_Primary_List:InvalidateParent(true)
                        
                    shopSheet_Vehicles_Primary_List:SetMultiSelect(false)
                    shopSheet_Vehicles_Primary_List:SetSortable(false)
                    shopSheet_Vehicles_Primary_List:AddColumn("Weapon")
                    shopSheet_Vehicles_Primary_List:AddColumn("Type")
                    shopSheet_Vehicles_Primary_List:AddColumn("Accuracy")
                    shopSheet_Vehicles_Primary_List:AddColumn("Damage")
                    shopSheet_Vehicles_Primary_List:AddColumn("Capacity")

                    -- Populate available primary weapons from the "Weapons_primary" list 
                    -- PATH: (player/config/sh_player_equipment.lua)
                    for weaponIndex, weaponValue in pairs (list.Get("weapons_primary")) do
                        shopSheet_Vehicles_Primary_List:AddLine(weaponValue.Name, weaponValue.Projectile, weaponValue.Accuracy, weaponValue.Damage, weaponValue.Capacity)
                        shopSheet_Vehicles_Primary_List:GetLine()
                        primaryWeaponClasses[weaponIndex] = weaponValue.Class
                        primaryWeaponIcons[weaponIndex] = weaponValue.Icon
                    end

                    -- Assign each line in the list a class and model for external references. Used to change the player's weapon internally and set the preview model
                    for lineIndex, rowValue in pairs (shopSheet_Vehicles_Primary_List:GetLines()) do
                        rowValue.Class = primaryWeaponClasses[lineIndex]
                        rowValue.Icon = primaryWeaponIcons[lineIndex]
                    end

                    shopSheet_Vehicles_Primary_List:SortByColumn(5, true)
                    shopSheet_Vehicles_Primary_List:SelectFirstItem() -- Because the SMG1 is the first index in the "weapons_primary" list, we set the model to the SMG earlier for this reason

                    local shopSheet_Vehicles_Primary_PreviewPanel_Icon = vgui.Create("DImage", shopSheet_Vehicles_Primary_PreviewPanel)	-- Add image to Frame
                    shopSheet_Vehicles_Primary_PreviewPanel_Icon:SetImage("entities/weapon_smg1.png")
                    shopSheet_Vehicles_Primary_PreviewPanel_Icon:Dock(FILL)
                    --shopSheet_Vehicles_Primary_PreviewPanel_Icon:SetSize(150, 150)	-- Size it to 150x150

                    shopSheet_Vehicles_Primary_List.OnRowSelected = function( panel, index, row )
                        LocalPlayer():EmitSound(SelectLoadoutOption)
                        shopSheet_Vehicles_Primary_PreviewPanel_Icon:SetImage(row.Icon) -- Calling the row model set earlier
                    end

                -- [RIGHT VEHICLES PANEL] --
                -- Divide the loadout panel into two pieces, dock this child panel to the right
                local shopSheet_Vehicles_Secondary = vgui.Create("DPanel", shopSheet_Vehicles)
                shopSheet_Vehicles_Secondary:SetWide(shopSheet_Vehicles:GetWide() / 2)
                shopSheet_Vehicles_Secondary:DockPadding(20,20,20,20)
                shopSheet_Vehicles_Secondary:Dock(RIGHT)
                shopSheet_Vehicles_Secondary:InvalidateParent(true)
                    shopSheet_Vehicles_Secondary.Paint = function(self, w, h)
                        draw.RoundedBox(0,0,0, w, h, Color(0,35,131,100)) -- Blue for visualizing positioning
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

                    -- Build a panel within the second portion of the layout screen to build a list
                    local shopSheet_Loadout_Secondary_PreviewPanel = vgui.Create("DPanel", shopSheet_Loadout_Secondary)
                    --shopSheet_Loadout_Secondary_PreviewPanel:SetTall(shopSheet_Loadout_Secondary:GetTall() / 1.5)
                    shopSheet_Loadout_Secondary_PreviewPanel:DockPadding(4,4,4,4)
                    shopSheet_Loadout_Secondary_PreviewPanel:Dock(FILL)
                    shopSheet_Loadout_Secondary_PreviewPanel:InvalidateParent(true)
                    shopSheet_Loadout_Secondary_PreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(3,0,0, w, h, Color(179,179,179,100))
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
                            for weaponIndex, weaponValue in pairs (list.Get("weapons_primary")) do

                                -- Make a panel first, this will be used for actual design
                                local shopSheet_Loadout_Secondary_ListItem_Panel = shopSheet_Loadout_Secondary_List:Add("DPanel")
                                shopSheet_Loadout_Secondary_ListItem_Panel:SetTall(shopSheet_Loadout_Secondary_PreviewPanel:GetTall() / 5)
                                shopSheet_Loadout_Secondary_ListItem_Panel:DockMargin(4,4,4,4)
                                shopSheet_Loadout_Secondary_ListItem_Panel:Dock(TOP)
                                shopSheet_Loadout_Secondary_ListItem_Panel:InvalidateParent(true)

                                -- If the panel's weapon class is equivalent to the selected weapon, we should highlight it
                                -- Otherwise we'll paint it with a regular gray color
                                shopSheet_Loadout_Secondary_ListItem_Panel.Paint = function (self, w, h)
                                    if weaponValue.Class == selectedPrimary then
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
                                    selectedPrimary = shopSheet_Loadout_Secondary_ListItem_Panel.Class

                                    if selectedPrimary ~= LocalPlayer().primaryWeapon then
                                        net.Start("UpdatePlayerPrimaryWeapon")
                                            net.WriteString(selectedPrimary)
                                        net.SendToServer()
                                    end

                                end

                            end

                            -- When we first build the buttons for the list, we ran a loop on an external array(s) that let us retrieve values from each weapon in the loadout table
                            -- That value is then assigned to each panel in the same index order, so we can call that value externally when the panel's reference button is clicked
                            for panelIndex, rowValue in pairs (shopSheet_Loadout_Secondary_List:GetChildren()) do -- We're getting the list's children since that's where the weapon panels reside
                                rowValue.Class = secondaryWeaponClasses[panelIndex]
                            end

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