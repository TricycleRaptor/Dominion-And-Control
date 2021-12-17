function DrawConfirmationBox()
    
    if CLIENT then
        
        LocalPlayer():EmitSound("buttons/blip1.wav")

        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle("Confirm base selection?")
        Frame:SetSize( 180, 130 )
        --Frame:SetSize( ScrW() * 0.209, ScrH() * 0.139 )
        Frame:Center()			
        Frame:MakePopup()
        Frame:SetVisible(true) 
        Frame:SetDraggable(false) 
        Frame:ShowCloseButton(false)
        Frame:SetBackgroundBlur(true)

        --print("Panel width is: " .. Frame:GetWide())
        --print("Panel height is: " .. Frame:GetTall())
                
        local YesButton = vgui.Create("DButton", Frame)
        YesButton:SetText("Yes")
        YesButton:SetTextColor( Color(0,0,0) )
        YesButton:SetPos( 25, 60 )
        YesButton:SetSize( Frame:GetWide() * 0.3, Frame:GetTall() * 0.2 )

        --print("Button width is: " .. YesButton:GetWide())
        --print("Button height is: " .. YesButton:GetTall())

        YesButton.DoClick = function()
            --print("[DAC DEBUG]: Selection accepted.")
            net.Start( "dac_sendbase_confirmation" )
                net.WriteBool(true)
            net.SendToServer()
            Frame:Close()
            LocalPlayer():EmitSound("buttons/button14.wav")
        end

        local NoButton = vgui.Create("DButton", Frame)
        NoButton:SetText("No")
        NoButton:SetTextColor( Color(0,0,0) )
        NoButton:SetPos( 100, 60 )
        NoButton:SetSize( Frame:GetWide() * 0.3, Frame:GetTall() * 0.2 )

        NoButton.DoClick = function()
            --print( "[DAC DEBUG]: Selection rejected." )
            net.Start( "dac_sendbase_confirmation" )
                net.WriteBool(false)
            net.SendToServer()
            Frame:Close()
            LocalPlayer():EmitSound("buttons/button19.wav")
        end

    end

end