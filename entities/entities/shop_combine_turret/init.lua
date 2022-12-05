AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:DrawShadow(false)

	self.combine_turret = ents.Create("npc_turret_floor")
	self.combine_turret:SetPos(self:GetPos() + Vector(0,0,-7))
	self.combine_turret:SetAngles(self:GetAngles() + Angle(0, 180, 0))
	self.combine_turret.tipCount = 0
	--self:SetTeam(1)
	self.combine_turret:Spawn()
	self.combine_turret:Activate()

	--print("[DAC DEBUG]: " .. tostring(self.combine_turret) .. " has a team index of "  .. tostring(self:GetTeam() .. "."))

	-- Get all the players in the match and update their relationship status for an initial spawn
	for _, ply in pairs (player.GetAll()) do

		if IsValid(self.combine_turret) and IsValid(ply) then
			if ply:Team() == self:GetTeam() then
				self.combine_turret:AddEntityRelationship(ply, D_LI, 99) -- Don't attack players that belong to the turret's team
				--print("[DAC DEBUG]: " .. tostring(self.combine_turret) .. " likes "  .. ply:Nick() .. "~")
			else
				self.combine_turret:AddEntityRelationship(ply, D_HT, 99) -- Shoot those fuckers
				--print("[DAC DEBUG]: " .. tostring(self.combine_turret) .. " hates "  .. ply:Nick() .. "!")
			end
		end

	end

	-- Afterwards, we'll create a timer that does the same thing, so if new players join the game or switch teams, this is still updated
	-- Currently has a cadence of five seconds, might want to be a bit higher in a real game setting, but five is suitable for testing
	timer.Create("DAC.TurretRelationshipUpdate_" .. tostring(self.combine_turret), 5, 0, function() -- Assign a unique identifer to the relationship timer
		for _, ply in pairs (player.GetAll()) do
			if IsValid(self.combine_turret) and IsValid(ply) then
				if ply:Team() == self:GetTeam() then
					self.combine_turret:AddEntityRelationship(ply, D_LI, 99) -- Don't attack players that belong to the turret's team
					--print("[DAC DEBUG]: " .. tostring(self.combine_turret) .. " likes "  .. ply:Nick() .. "~")
				else
					self.combine_turret:AddEntityRelationship(ply, D_HT, 99) -- Shoot those fuckers
					--print("[DAC DEBUG]: " .. tostring(self.combine_turret) .. " hates "  .. ply:Nick() .. "!")
				end
			end
		end
	end)

end

function ENT:Think()

	if !IsValid (self.combine_turret) then
		timer.Remove("DAC.TurretRelationshipUpdate_" .. tostring(self.combine_turret)) -- Remove the timer if invalid
		self:Remove()
	end

end

function ENT:OnRemove()

	if IsValid (self.combine_turret) then
		self.combine_turret:Remove()
		timer.Remove("DAC.TurretRelationshipUpdate_" .. tostring(self.combine_turret)) -- Remove the timer upon removal
	end

end

function ENT:OnTeamChanged(_, _, newValue) -- _ makes these unimportant
end

hook.Add( "OnNPCKilled", "DAC.CombineTurretExplosion", function( npc, attacker, inflictor )

	if npc:GetClass() == "npc_turret_floor" then

		if npc.tipCount ~= nil then

			npc.tipCount = npc.tipCount + 1

			if npc.tipCount < 3 then
				npc:EmitSound("npc/turret_floor/click1.wav")
			end
			
			if npc.tipCount >= 3 then -- Explode after the turret tips over (and dies) three times
				
				timer.Remove("DAC.TurretRelationshipUpdate_" .. tostring(npc.combine_turret)) -- Remove the timer and prepared to self-destruct
				
				npc:EmitSound("buttons/button8.wav")
				npc:Fire("SelfDestruct")
	
				timer.Simple( 4.1, function() 

					local blastRadius = 300
					local effectData = EffectData()
					effectData:SetOrigin(npc:GetPos())
					util.Effect("Explosion", effectData) -- Make the explosion effect
					util.BlastDamage(npc, npc, npc:GetPos(), blastRadius, 100) -- Apply explosion damage
					util.Decal("Scorch", npc:GetPos(), npc:GetPos() - Vector(0,0,25), nil) -- Draw a scorch mark on the ground
					npc:Remove() -- Yeet

				end )

			end

		end

	end

end)