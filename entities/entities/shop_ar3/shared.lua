ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "AR3 Emplacement Gun"
ENT.Author			= "Zaubermuffin, Tricycle Raptor for edits"
ENT.Information		= "A mounted gun that is usually found on clamps."
ENT.Purpose 		= "Mounted turret for base defense"
ENT.Category 		= "DAC Shop"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()

    local teamList = {}

    for teamIndex, teamData in pairs(GAMEMODE.Teams) do
        teamList[teamData.name] = teamIndex --WIP
    end

    -- The second argument is a unique identifier slot in the backend
    -- You can have one of each data type in one slot
    -- Don't lose track of your shit, boss
    self:NetworkVar("Int", 0, "Team", {
        KeyName = "team",
        Edit = { -- Adds entity properties to the context menu for debug purposes
            type = "Combo",
            values = teamList -- Get team data from sh_teams.lua
        }
    })

    if SERVER then

        self:NetworkVarNotify("Team", self.OnTeamChanged)

    end

end

-- Local function defined later.
local FindAR3At

-- Disable all tools but a few.
function ENT:CanTool(ply, tr, mode)
	return mode == 'remover' or mode == 'colour' or mode == 'material' or mode == 'nocollide'
end

-- If you want to move us, use the clamp we're attached to instead.
ENT.PhysgunDisabled = true

-- Almost no properties.
local function CanProperty(ply, act, ent)
	if not IsValid(ent) or (ent:GetClass() ~= 'sent_zar3' and ent:GetModel() ~= 'models/props_combine/combine_barricade_short01a.mdl') or (act ~= 'bonemanipulate' and act ~= 'drive' and act ~= 'persist' and act ~= 'nocollide_on' and act ~= 'collision') then
		return
	end
	
	-- We forbid interaction with the SENT itself
	if ent:GetClass() == 'sent_zar3' then
		return false
	end
	
	-- If this is a "special clamp", forbid interaction.
	if FindAR3At(ent) then
		return false
	end
end
hook.Add('CanProperty', '_ZAR3CanProperty', CanProperty)

-- Returns the position the AR3 is spawned at on a clamp,
local function AR3Position(clamp)
	return clamp:GetPos() + clamp:GetUp()*10 - clamp:GetForward()*4
end

-- Searches the clamp for an AR3, returns if there is one.
function FindAR3At(clamp)
		-- Found by playing around - looks pretty neat.
	local pos = AR3Position(clamp)
	
	-- Search for other AR3s within a small box around this position. There can only be one.
	for k, v in pairs(ents.FindInBox(pos - Vector(1, 1, 1), pos + Vector(1, 1, 1))) do
		if v:GetClass() == 'sent_zar3' then
			return v
		end
	end
	
	return false
end

-- Export, client/server will import it and remove it afterwards.
ZAR3_FindAR3At, ZAR3_AR3Position = FindAR3At, AR3Position

-- Add a property thingy.
properties.Add( "zar3_collision_off", 
{
	MenuLabel	=	"Turn world collision off",
	Order		=	1501,
	MenuIcon	=	"icon16/collision_off.png",
	
	Filter = 
		function(self, ent, ply)
			if not IsValid(ent) or (ent:GetClass() ~= 'sent_zar3' and not FindAR3At(ent)) then 
				return false 
			end
			
			
			local clamp = ent:GetClass() == 'sent_zar3' and ent:GetParent() or ent
			if not IsValid(clamp) then
				return false
			end
			
			-- Eugh, this conflicts with the normal tool but I don't want to unnecessary set flags and all that.
			if clamp:GetCollisionGroup() ~= COLLISION_GROUP_NONE then
				return false
			end
	
			if not gamemode.Call("CanProperty", ply, "zar3_nocollide", FindAR3At(clamp)) then 
				return false 
			end
			
			return true 
		end,
					
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	
	Receive	=	function( self, length, player )
		local ent = net.ReadEntity()
		if not self:Filter(ent, player) then 
			return 
		end
		
		local clamp = ent:GetClass() == 'sent_zar3' and ent:GetParent() or ent
		local phys = clamp:GetPhysicsObject()
		if not IsValid(phys) then
			return
		end
		
		phys:EnableCollisions(false)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:EnableMotion(false)
		clamp:SetCollisionGroup(COLLISION_GROUP_WORLD)
		clamp.ZAR3NoCollided = true
	end
});


properties.Add( "zar3_collision_on", 
{
	MenuLabel	=	"Turn world collision on",
	Order		=	-99,
	MenuIcon	=	"icon16/collision_on.png",
	
	Filter = 
		function(self, ent, ply) 
			if not IsValid(ent) or (ent:GetClass() ~= 'sent_zar3' and not FindAR3At(ent)) then 
				return false 
			end
			
			
			local clamp = ent:GetClass() == 'sent_zar3' and ent:GetParent() or ent
			if not IsValid(clamp) then
				return false
			end
			
			-- Eugh, this conflicts with the normal tool but I don't want to unnecessary set flags and all that.
			if clamp:GetCollisionGroup() ~= COLLISION_GROUP_WORLD then
				return false
			end
			
			if not gamemode.Call("CanProperty", ply, "zar3_nocollide", FindAR3At(clamp)) then 
				return false 
			end
			
			return true
		end,
					
	Action =
		function(self, ent)
			self:MsgStart()
				net.WriteEntity(ent)
			self:MsgEnd()
		end,
					
	Receive = 
		function(self, length, player)
			local ent = net.ReadEntity()
			if not self:Filter(ent, player) then 
				return 
			end
			
			local clamp = ent:GetClass() == 'sent_zar3' and ent:GetParent() or ent
			local phys = clamp:GetPhysicsObject()
			if not IsValid(phys) then
				return
			end
			
			phys:EnableCollisions(true)
			phys:EnableDrag(true)
			phys:EnableGravity(true)
			phys:EnableMotion(true)
			clamp:SetCollisionGroup(COLLISION_GROUP_NONE)
			clamp.ZAR3NoCollided = nil
		end	
});