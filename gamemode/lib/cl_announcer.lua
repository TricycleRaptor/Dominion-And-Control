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

-- We'll need to update the HUD as well, but we can do it elsewhere. For now this is just audio.

local function BroadcastBeginAudio(len, ply)
    local team = net.ReadBool()
    LocalPlayer():EmitSound(BeginNoise)
    LocalPlayer():EmitSound(DeployNoise)
end
net.Receive("SendBeginAudio", BroadcastBeginAudio)

local function BroadcastGameOverAudio(len, ply)
    local team = net.ReadBool()
    LocalPlayer():EmitSound(OverNoise)
end
net.Receive("SendGameOverAudio", BroadcastGameOverAudio)

local function BroadcastTakenAudio(len, ply)

    local team = net.ReadFloat() -- The capturing player's team is passed in here
    LocalPlayer():EmitSound(PickupNoise)
    LocalPlayer():EmitSound(PickupNoise2)

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