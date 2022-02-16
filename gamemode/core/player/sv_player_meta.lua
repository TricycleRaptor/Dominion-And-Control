local meta = FindMetaTable( "Player" ) -- Call the lookup table for player data

function meta:SetPlayerCarrierStatus(boolean)
    self.isFlagCarrier = boolean
end    

function meta:GetPlayerCarrierStatus()
    return self.isFlagCarrier
end

function meta:SetPlayerWeapon(weaponString)
    self.primaryWeapon = weaponString
end    

function meta:GetPlayerWeapon()
    return self.primaryWeapon
end

function meta:SetPlayerSpecial(specialString)
    self.specialWeapon = specialString
end    

function meta:GetPlayerSpecial()
    return self.specialWeapon
end