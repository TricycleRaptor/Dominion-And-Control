local meta = FindMetaTable( "Entity" ) -- Call the lookup table of the game's entire entity list

function meta:SetPlayerCarrierStatus(boolean)
    if(self:IsValid() and self:IsPlayer()) then -- Only add this to the player entity
        self.isFlagCarrier = boolean
    end
end    

function meta:GetPlayerCarrierStatus()
    if(self:IsValid() and self:IsPlayer()) then
        return self.isFlagCarrier
    end
end