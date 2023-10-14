local PLAYER = {} 
DEFINE_BASECLASS("player_default")
player_manager.RegisterClass("DAC_playerclass", PLAYER, "player_default")

PLAYER.TauntCam = TauntCamera()
        
PLAYER.SlowWalkSpeed = 80 -- Reduced speed for silent slow walk
PLAYER.WalkSpeed = 200 -- Default Half-Life 2 walk speed
PLAYER.RunSpeed = 335 -- Nerfed sprint speed by 12.5%

if SERVER then
    util.AddNetworkString("UpdatePlayerPrimaryWeapon")
    util.AddNetworkString("UpdatePlayerSecondaryWeapon")
end

function PLAYER:Loadout()

    self.Player:StripWeapons() -- Remove everything as a precaution

    userTeam = self.Player:Team()
    -- Give the team captain their team setup, if their team isn't prepped
    if self.Player.IsCaptain and GAMEMODE.Teams[userTeam].baseSet == false then
        self.Player:Give("weapon_dac_baseselector")
    end

    -- Give players their gear if the match is enabled
    self.Player:Give("weapon_physcannon")
    self.Player:Give("weapon_crowbar")
    self.Player:Give("weapon_pistol")
    self.Player:Give(self.Player.primaryWeapon)
    self.Player:Give(self.Player.specialWeapon)

    -- Giving ammo doesn't account the current mag in the weapon by default, so this is purely reserve
    self.Player:RemoveAllAmmo()
    self.Player:GiveAmmo(72, "Pistol", true)  -- 72/18 = 4! 4 mags! Ah-ah-ah! https://www.youtube.com/watch?v=B-Wd-Q3F8KM
    self.Player:GiveAmmo(180, "SMG1", true)
    self.Player:GiveAmmo(120, "AR2", true)
    self.Player:GiveAmmo(24, "Buckshot", true)
    self.Player:GiveAmmo(9, "XBowBolt", true)
    --self.Player:GiveAmmo(2, "RPG_Round", true)
    self.Player:GiveAmmo(1, "Grenade", true)
    -- This will change later, hard coded for now

end

function PLAYER:GiveBuildTools()
    self.Player:Give("gmod_tool")
    self.Player:Give("weapon_physgun")
end

function PLAYER:RemoveBuildTools()
    self.Player:StripWeapon("gmod_tool")
    self.Player:StripWeapon("weapon_physgun")
end

function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function TauntCamera()

	local CAM = {}

	local WasOn					= false

	local CustomAngles			= angle_zero
	local PlayerLockAngles		= nil

	local InLerp				= 0
	local OutLerp				= 1

	--
	-- Draw the local player if we're active in any way
	--
	CAM.ShouldDrawLocalPlayer = function( self, ply, on )

		return on || OutLerp < 1

	end

	--
	-- Implements the third person, rotation view (with lerping in/out)
	--
	CAM.CalcView = function( self, view, ply, on )

		if ( !ply:Alive() || !IsValid( ply:GetViewEntity() ) || ply:GetViewEntity() != ply ) then on = false end

		if ( WasOn != on ) then

			if ( on ) then InLerp = 0 end
			if ( !on ) then OutLerp = 0 end

			WasOn = on

		end

		if ( !on && OutLerp >= 1 ) then

			CustomAngles = view.angles * 1
			PlayerLockAngles = nil
			InLerp = 0
			return

		end

		if ( PlayerLockAngles == nil ) then return end

		--
		-- Simple 3rd person camera
		--
		local TargetOrigin = view.origin - CustomAngles:Forward() * 300
		local tr = util.TraceHull( { start = view.origin, endpos = TargetOrigin, mask = MASK_SHOT, filter = player.GetAll(), mins = Vector( -8, -8, -8 ), maxs = Vector( 8, 8, 8 ) } )
		TargetOrigin = tr.HitPos + tr.HitNormal

		if ( InLerp < 1 ) then

			InLerp = InLerp + FrameTime() * 5.0
			view.origin = LerpVector( InLerp, view.origin, TargetOrigin )
			view.angles = LerpAngle( InLerp, PlayerLockAngles, CustomAngles )
			return true

		end

		if ( OutLerp < 1 ) then

			OutLerp = OutLerp + FrameTime() * 3.0
			view.origin = LerpVector( 1-OutLerp, view.origin, TargetOrigin )
			view.angles = LerpAngle( 1-OutLerp, PlayerLockAngles, CustomAngles )
			return true

		end

		view.angles = CustomAngles * 1
		view.origin = TargetOrigin
		return true

	end

	--
	-- Freezes the player in position and uses the input from the user command to
	-- rotate the custom third person camera
	--
	CAM.CreateMove = function( self, cmd, ply, on )

		if ( !ply:Alive() ) then on = false end
		if ( !on ) then return end

		if ( PlayerLockAngles == nil ) then
			PlayerLockAngles = CustomAngles * 1
		end

		--
		-- Rotate our view
		--
		CustomAngles.pitch	= CustomAngles.pitch	+ cmd:GetMouseY() * 0.01
		CustomAngles.yaw	= CustomAngles.yaw		- cmd:GetMouseX() * 0.01

		--
		-- Lock the player's controls and angles
		--
		cmd:SetViewAngles( PlayerLockAngles )
		cmd:ClearButtons()
		cmd:ClearMovement()

		return true

	end

	return CAM

end
    
-- Receive Primary weapon for loadout
net.Receive("UpdatePlayerPrimaryWeapon", function( len, ply )

    local receivedWeapon = net.ReadString()

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        for weaponIndex, weaponValue in pairs (list.Get("weapons_primary")) do
            if weaponValue.Class == receivedWeapon then
                --print(ply:GetPlayerWeapon())
                ply:SetPlayerWeapon(receivedWeapon)
                return
            end
        end
    end

end )

-- Receive Secondary/Special weapon for loadout
net.Receive("UpdatePlayerSecondaryWeapon", function( len, ply )

    local receivedWeapon = net.ReadString()

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        for weaponIndex, weaponValue in pairs (list.Get("weapons_equipment")) do
            if weaponValue.Class == receivedWeapon then
                --print(ply:GetPlayerSpecial())
                ply:SetPlayerSpecial(receivedWeapon)
                return
            end
        end
    end

end )