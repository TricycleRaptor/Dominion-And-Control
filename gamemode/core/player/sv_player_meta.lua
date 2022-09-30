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