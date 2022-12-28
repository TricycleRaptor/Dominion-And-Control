AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SendFlagHUDNotify")

function ENT:Initialize()

	local ScoreCount = nil
	self:SetName("dac_flag")
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT ) -- Force check of transmission state

	self:SetModel("models/ctf_flag/ctf_flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetTrigger(true) -- Make this triggerable for a touchpoint condition

	-- Set a base condition for the networked vars
	-- The flag starts attached to the base, so adjust these values accordingly
	self:SetOnBase(true)
	self:SetHeld(false)
	self:SetCarrier(nil)
	self:SetDropTime(0)
	self:SetAngles(Angle(0,90,0))
	self.Entity.IsFlag = true

end

function ENT:StartTouch(entity)

	if entity:IsValid() 
	and entity:IsPlayer() 
	and entity:Alive() 
	and entity:Team() != self:GetTeam() 
	and entity:GetPlayerCarrierStatus() == false
	and not entity:InVehicle() 
	and not self:GetHeld() 
	then -- Consider adding a condition to check against spectators, come back to this later
		
		-- Can't set this in the entity initialization hook for some reason, so I have to fucking do it here
		if(self:GetOnBase() == true and self:GetHeld() == false) then
			self.ParentBase = self:GetParent()
		end

		net.Start("SendTakenAudio")
		net.WriteFloat(entity:Team()) -- Pass in the flag carrier's team for networking behavior
		net.Broadcast() -- This sends to all players, not just the flag carrier
		-- We could have this also play "Action is coming" to the player who picked up the flag on a low chance modifier... Good easter egg suggestion made by Steiner.
		-- https://www.youtube.com/watch?v=-yhgV5_8mMA

		net.Start("SendFlagHUDNotify")
		net.WriteEntity(self.Entity) -- Pass in the flag for parsing on client
		net.WriteBool(true)
		net.Send(entity)
		
		-- Broadcast flag pickup
		self:SetOnBase(false)
		self:SetHeld(true)
		self:SetCarrier(entity)
		self.ParentBase:SetHasFlag(false)
		entity:SetPlayerCarrierStatus(true) -- Send carrier boolean status to player entity
		--print("[DAC DEBUG]: Set " .. entity:Nick() .. "'s flag carrier status to " .. tostring(entity:GetPlayerCarrierStatus()) .. ".")

		-- Setup collision
		self.Entity:SetParent(entity)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	----- BEGIN INSTANT FLAG RECOVERY CONDITION -----
	--elseif entity:IsValid() and entity:IsPlayer() and entity:Alive() and entity:Team() == self:GetTeam() and self:GetHeld() == false and self:GetOnBase() == false then -- Team member touched the flag
		
		-- Network that the flag has been returned
		--print("[DAC]: " .. entity:Nick() .. " returned the flag.")
		--self.Entity:ReturnFlag()
		--net.Start("SendReturnedAudio")
		--net.WriteFloat(self.Entity:GetTeam()) -- Pass in the flag carrier's team for networking behavior
		--net.Broadcast() -- This sends to all players, not just the flag carrier

	----- END INSTANT FLAG RECOVERY CONDITION -----
		
	elseif entity:IsValid() 
		and entity:IsPlayer() 
		and entity:Alive() 
		and entity:Team() == self:GetTeam() 
		and entity:GetPlayerCarrierStatus() == true
		and self:GetHeld() == false 
		and self:GetOnBase() == true then -- Flag is on base and the player is on the same team
			
		--print("[DAC DEBUG]: Score condition tripped.")
		entity:SetPlayerCarrierStatus(false)
		self:ScoreFlag(self.Entity:GetTeam())
			
		for _, child in pairs(entity:GetChildren()) do -- Find the flag held by the flag carrier. There's probably a better way to do this but I'm out of ideas.
			if (child:GetClass() == "dac_flag") then
				--print("[DAC DEBUG]: Child flag identified. Returning.")
				child:ReturnFlag()
				break -- Stop iterations after flag is identified
			end
		end

		local curMoney = entity:GetNWInt("storeCredits")
		local newMoney = curMoney + GetConVar("dac_income_amount"):GetInt() * 2
		entity:SetNWInt("storeCredits", newMoney)
		entity:ChatPrint( "[DAC]: You earned " .. GetConVar("dac_income_amount"):GetInt() * 2 .. "cR for capturing a flag!")

		net.Start("SendScoreAudio")
		net.WriteFloat(entity:Team()) -- Pass in the flag carrier's team for networking behavior
		net.Broadcast() -- This sends to all players, not just the flag carrier

		net.Start("SendFlagHUDNotify") -- Notify the carrying player's HUD
		net.WriteEntity(self.Entity)
		net.WriteBool(false)
		net.Send(entity)

	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant

	self:SetSkin(newValue)

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS -- Always network the flag entity, to ensure the position is always known to the player (this also allows flag icons always update their position)
end