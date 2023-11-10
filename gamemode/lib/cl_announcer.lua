-- These are hardcoded sound paths for now. Later, we can make these dynamic and call through string variables for announcer packs.
-- We'll probably want to put these on serverside so the client can read those in globally. Not sure yet.
BeginNoise = Sound("announcer/intro.wav")
DeployNoise = Sound("ambient/levels/streetwar/city_battle13.wav")
BaseAppear = Sound("npc/scanner/scanner_nearmiss1.wav")
ScoreNoise = Sound("announcer/captured.wav")
ScoreNoise2 = Sound("ambient/levels/citadel/weapon_disintegrate2.wav")
PickupNoise = Sound("announcer/taken.wav")
PickupNoise2 = Sound("ambient/levels/canals/windchime2.wav")
DropNoise = Sound("announcer/dropped.wav")
DropNoise2 = Sound("ambient/alarms/warningbell1.wav")
ReturnNoise = Sound("announcer/recovered.wav")
OverNoise = Sound("announcer/over.wav")
DrawNoise = Sound("announcer/over.wav")
ActionComing = Sound("memes/actioncoming.wav")

-- We'll need to update the HUD as well, but we can do it elsewhere. For now this is just audio.

local function BroadcastBeginAudio(len, ply)
    local team = net.ReadBool()
    LocalPlayer():EmitSound(BeginNoise)
    LocalPlayer():EmitSound(DeployNoise)
end
net.Receive("SendBeginAudio", BroadcastBeginAudio)

local function BroadcastGameOverAudio(len, ply)

    local teamInt = net.ReadInt(32)
    LocalPlayer():EmitSound(OverNoise)

    if teamInt ~= 1001 then -- 1001 is the unassigned team ENUM in Garry's Mod. If this number is received, this means the match is a draw.

        local startTime = CurTime()
        local fadeInDuration = 1 -- in seconds
        local holdDuration = 4 -- in seconds
        local fadeOutDuration = 1 -- in seconds

        hook.Add("HUDPaint", "WinningTeamLogo", function()

            local currentTime = CurTime()
            local deltaTime = currentTime - startTime
            local alpha = 255
    
            if deltaTime < fadeInDuration then
                -- Fade in
                alpha = 255 * (deltaTime / fadeInDuration)
            elseif deltaTime < fadeInDuration + holdDuration then
                -- Hold
                alpha = 255
            elseif deltaTime < fadeInDuration + holdDuration + fadeOutDuration then
                -- Fade out
                alpha = 255 * (1 - (deltaTime - fadeInDuration - holdDuration) / fadeOutDuration)
            else
                -- Reset startTime
                startTime = currentTime
            end
    
            local screenWidth = ScrW()
            local screenHeight = ScrH()
            local imageWidth = screenWidth / 3
            local imageHeight = screenHeight / 2
            local xPos = (screenWidth - imageWidth) / 2
            local yPos = (screenHeight - imageHeight) / 2
    
            surface.SetMaterial(Material("dominion/announcer/winLogo_team" .. teamInt .. ".png"))
            surface.SetDrawColor(255, 255, 255, alpha)
            surface.DrawTexturedRect(xPos, yPos, imageWidth, imageHeight)
    
        end)
    
        timer.Simple(6, function()
            hook.Remove("HUDPaint", "WinningTeamLogo")
        end)

    else
        LocalPlayer():EmitSound(DrawNoise)
    end

end
net.Receive("SendGameOverAudio", BroadcastGameOverAudio)

local function BroadcastTakenAudio(len, ply)

    local team = net.ReadFloat() -- The capturing player's team is passed in here
    LocalPlayer():EmitSound(PickupNoise)
    LocalPlayer():EmitSound(PickupNoise2)

    if GetConVar("dac_eastereggs"):GetBool() == true then -- 1% chance

        if GetConVar("dac_eastereggs"):GetBool() == true then
            local randomInt = math.random(0, 100)
            if (randomInt > 99) then -- 1% chance
                timer.Simple( 3, function() 
                    LocalPlayer():EmitSound(ActionComing)
                end )
            end
        end

    end

end
net.Receive("SendTakenAudio", BroadcastTakenAudio)

local function BroadcastScoreAudio(len, ply)

    local team = net.ReadFloat() -- The capturing player's team is passed in here
    LocalPlayer():EmitSound(ScoreNoise)
    LocalPlayer():EmitSound(ScoreNoise2)

end
net.Receive("SendScoreAudio", BroadcastScoreAudio)

local function BroadcastDroppedAudio(len, ply)

    local team = net.ReadFloat() -- The capturing player's team is passed in here
    LocalPlayer():EmitSound(DropNoise)
    LocalPlayer():EmitSound(DropNoise2)

end
net.Receive("SendDroppedAudio", BroadcastDroppedAudio)

local function BroadcastReturnedAudio(len, ply)

    local flagTeam = net.ReadFloat() -- The returned flag's team is passed in here
    LocalPlayer():EmitSound(ReturnNoise)

end
net.Receive("SendReturnedAudio", BroadcastReturnedAudio)