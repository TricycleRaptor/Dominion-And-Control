function DrawVehicleConfirmationBox()

    if CLIENT then

        local Trace = LocalPlayer():GetEyeTrace()
        local Dist = (Trace.HitPos - LocalPlayer():GetPos()):Length()
    
            LocalPlayer():EmitSound("buttons/blip1.wav")

            local Frame = vgui.Create( "DFrame" )
            Frame:SetTitle("Confirm vehicle purchase?")
            --Frame:SetSize( 180, 130 )
            Frame:SetSize( ScrW() * 0.15, ScrH() * 0.12 )
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
            YesButton:SetPos(Frame:GetWide() * 0.10, Frame:GetTall() * 0.5)
            YesButton:SetSize(Frame:GetWide() * 0.3, Frame:GetTall() * 0.2)

            --print("Button width is: " .. YesButton:GetWide())
            --print("Button height is: " .. YesButton:GetTall())

            YesButton.DoClick = function()
                --print("[DAC DEBUG]: Client accepted selection.")
                net.Start( "dac_vehicle_confirmation" )
                    net.WriteBool(true)
                net.SendToServer()
                Frame:Close()
                LocalPlayer():EmitSound("buttons/button14.wav")
            end

            local NoButton = vgui.Create("DButton", Frame)
            NoButton:SetText("No")
            NoButton:SetTextColor( Color(0,0,0) )
            NoButton:SetPos(Frame:GetWide() * 0.60, Frame:GetTall() * 0.5)
            NoButton:SetSize(Frame:GetWide() * 0.3, Frame:GetTall() * 0.2)

            NoButton.DoClick = function()
                --print( "[DAC DEBUG]: Client rejected selection." )
                net.Start( "dac_vehicle_confirmation" )
                    net.WriteBool(false)
                net.SendToServer()
                Frame:Close()
                LocalPlayer():EmitSound("buttons/button19.wav")
            end

            Frame.Think = function()
                if LocalPlayer():GetNWBool("IsInBase") == false then
                    Frame:Close()
                    LocalPlayer():EmitSound("buttons/combine_button2.wav")
                end
            end

    end

end