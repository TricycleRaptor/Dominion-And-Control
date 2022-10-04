local vehicleMeta = FindMetaTable( "Vehicle" ) -- Call the lookup table for vehicle data

function vehicleMeta:SetVehicleShopPrice(int)
    self.shopPrice = int
end

function vehicleMeta:GetVehicleShopPrice()
    return self.shopPrice
end

function vehicleMeta:SetTeam(int)
    self.Team = int
end

function vehicleMeta:GetTeam()
    return self.Team
end