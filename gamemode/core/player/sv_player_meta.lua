local meta = FindMetaTable( "Player" ) -- Call the lookup table for player data

function meta:SetPlayerCarrierStatus(boolean)
    self.isFlagCarrier = boolean
end    

function meta:GetPlayerCarrierStatus()
    return self.isFlagCarrier
end

function meta:SetPlayerWeapon(string)
    self.primaryWeapon = string
end    

function meta:GetPlayerWeapon()
    return self.primaryWeapon
end

function meta:SetPlayerSpecial(string)
    self.specialWeapon = string
end    

function meta:GetPlayerSpecial()
    return self.specialWeapon
end

function meta:SetDefaultWeapons()

    local firstPrimaryWeapon = nil
    for weaponIndex, weaponValue in pairs(list.Get("weapons_primary")) do
        firstPrimaryWeapon = weaponValue.Class
        break
    end

    local firstSpecialWeapon = nil
    for weaponIndex, weaponValue in pairs(list.Get("weapons_equipment")) do
        firstSpecialWeapon = weaponValue.Class
        break
    end

    self.primaryWeapon = firstPrimaryWeapon
    self.specialWeapon = firstSpecialWeapon

end

function meta:ChatMessage_Basic(messageString)
    net.Start("ChatMessage_Basic")
    net.WriteString(messageString)
    net.Send(self)
end

function meta:ChatMessage_TeamChangeNotice(ply, oldteam, newteam)
    net.Start("ChatMessage_TeamChangeNotice")
    net.WriteEntity(ply)
    net.WriteFloat(oldteam)
    net.WriteFloat(newteam)
    net.Send(self)
end

function meta:ChatMessage_PlayerKill(victim, inflictor, attacker, reward)
    net.Start("ChatMessage_PlayerKill")
    net.WriteEntity(victim)
    net.WriteEntity(inflictor)
    net.WriteEntity(attacker)
    net.WriteFloat(reward)
    net.Send(self)
end

function meta:ChatMessage_PassiveIncome()
    net.Start("ChatMessage_PassiveIncome")
    net.Send(self)
end


function meta:ChatMessage_FlagCapture()
    net.Start("ChatMessage_FlagCapture")
    net.Send(self)
end