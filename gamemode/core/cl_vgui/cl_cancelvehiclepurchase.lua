function DrawVehicleCancellationBox()

    if CLIENT then
    
        LocalPlayer():EmitSound("buttons/blip1.wav")

        local Frame = vgui.Create( "DFrame" )
        Frame:SetTitle("Cancel vehicle purchase?")
        Frame:SetSize( ScrW() * 0.15, ScrH() * 0.12 )
        Frame:Center()			
        Frame:MakePopup()
        Frame:SetVisible(true) 
        Frame:SetDraggable(false) 
        Frame:ShowCloseButton(false)
        Frame:SetBackgroundBlur(true)
                    
        local YesButton = vgui.Create("DButton", Frame)
        YesButton:SetText("Yes")
        YesButton:SetTextColor( Color(0,0,0) )
        YesButton:SetPos(Frame:GetWide() * 0.10, Frame:GetTall() * 0.5)
        YesButton:SetSize(Frame:GetWide() * 0.3, Frame:GetTall() * 0.2)

        YesButton.DoClick = function()

            net.Start("dac_vehicle_cancellation")
                net.WriteBool(true)
            net.SendToServer()

            Frame:Close()
            LocalPlayer():EmitSound("buttons/combine_button2.wav")

        end

        local NoButton = vgui.Create("DButton", Frame)
        NoButton:SetText("No")
        NoButton:SetTextColor( Color(0,0,0) )
        NoButton:SetPos(Frame:GetWide() * 0.60, Frame:GetTall() * 0.5)
        NoButton:SetSize(Frame:GetWide() * 0.3, Frame:GetTall() * 0.2)

        NoButton.DoClick = function()

            net.Start("dac_vehicle_cancellation")
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