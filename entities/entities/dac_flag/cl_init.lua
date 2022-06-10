include("shared.lua")

function ENT:Draw()

    local ang = self:GetAngles()
--[[     flagMat = Material("dominion/ui/flag.png")
    flagPosVector = self:GetPos()+ Vector(0,0,150)-- xyz vector
    renderContext = flagPosVector:ToScreen()

    if self.Entity:GetOnBase() == false then
        floatZ = math.sin(CurTime() * 2) * 10
    else
        floatZ = 0
    end ]]

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

--[[     if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 150 ^ 2 then
        cam.IgnoreZ()
        cam.Start2D()
            surface.SetDrawColor(team.GetColor(self:GetTeam()))
            surface.SetMaterial(flagMat)
            surface.DrawTexturedRect(renderContext.x, renderContext.y - floatZ, 40, 40)
        cam.End2D()
    end ]]

    if self.Entity:GetHeld() == false and self.Entity:GetOnBase() == false and CurTime() - self.Entity:GetDropTime() < 20 then -- The flag is dropped, we can render objects on client here 
        if !IsValid(self.ringModel) then
            self.ringModel = ClientsideModel("models/hunter/tubes/tube4x4x025.mdl")
            self.ringModel:SetPos(self.Entity:GetPos())
            self.ringModel:SetMaterial("models/wireframe")
            self.ringModel:SetColor(team.GetColor(self.Entity:GetTeam()))
            self.ringModel:SetParent(self.Entity)
            self.ringModel:DrawShadow(false)
            self.ringModel:Spawn()
        else
            self.ringModelAngles = self.ringModel:GetAngles()
            self.ringModelAngles:Add(Angle(0,0.02,0))
            self.ringModel:SetAngles(self.ringModelAngles)
        end
    else
        if IsValid(self.ringModel) then
            self.ringModel:Remove()
            self.ringModel = nil
        end
    end

end

function ENT:AnimateFlag()

    local numFrames = self.Entity:GetFlexNum()

	if numFrames == 0 then return end

	local totalTime = 2
	local frameTime = totalTime / numFrames

	local animTime = CurTime() % totalTime

	for i=0,(numFrames-1) do

		local progress = animTime / frameTime - i
		if progress <= 0 or progress > 1 then
			progress = 0
		end

		local prev = i - 1
		if prev < 0 then
			prev = numFrames - 1
		end

		self.Entity:SetFlexWeight(i, progress)

		if (progress > 0) then
			self.Entity:SetFlexWeight(prev, 1 - progress)
			return
		end
	end

end

function ENT:Think()
    self:AnimateFlag() -- Call animation function
end