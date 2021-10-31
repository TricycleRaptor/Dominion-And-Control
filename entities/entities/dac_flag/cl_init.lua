include("shared.lua")

function ENT:Draw()

    if LocalPlayer() == self:GetCarrier() and LocalPlayer():GetViewEntity() == LocalPlayer() then --Show up on cameras, bitch
        self.Entity:DrawShadow(false)
    else
        self.Entity:DrawModel()
    end

    if self.Entity:GetHeld() == true and self:GetCarrier():IsPlayer() and self.Entity:GetCarrier():Alive() then -- Normalize draw angles when held
        local carrier = self.Entity:GetCarrier()
        local angles = carrier:GetAngles()
        angles.p = 0
        angles.r = 0
        self.Entity:SetAngles(angles)
        self.Entity:SetPos(carrier:GetPos() + angles:Up() * 10 - angles:Forward() * 5)
    end

end