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
    self.primaryWeapon = "weapon_smg1"
    self.specialWeapon = "weapon_frag"
end