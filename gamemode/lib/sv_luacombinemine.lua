--Credit to DoopieWop for original code: https://github.com/DoopieWop/lua_combine_mine
--Minor gamemode-specific edits by TricycleRaptor

hook.Add("GetPreferredCarryAngles", "DAC.LuaCombineMineCarryAngles", function(ent, ply)
    if ent:GetClass() != "shop_combine_mine" then return end

    return Angle(0, 0, 0)
end)

hook.Add("GravGunPunt", "DAC.LuaCombineMineGravityPunted", function(ply, ent)
    if ent:GetClass() != "shop_combine_mine" then return end

    if ent:GetStatus() == MINE_STATE_TRIGGERED or ent:GetStatus() == MINE_STATE_ARMED then
        return
    end

    if ent.bHeldByPhysgun then
        ent.hPlayerGrabber = nil
        ent.bHeldByPhysgun = false
        ent:SetStatus(MINE_STATE_LAUNCHED)
        return
    end

    ent.bDisarmed = false
    ent.bPlacedByPlayer = true

    ent.PhysicsCollide = nil
    ent:SetThink(ent.SettleThink)
    ent:SetNextThink(0.1)
end)

hook.Add("GravGunOnDropped", "DAC.LuaCombineMineGravityDropped", function(ply, ent)
    if ent:GetClass() != "shop_combine_mine" then return end

    ent.flTimeGrabbed = 9999999999999999999
    ent.bHeldByPhysgun = false
    ent.hPlayerGrabber = nil

    if ent:GetStatus() == MINE_STATE_TRIGGERED or ent:GetStatus() == MINE_STATE_LAUNCHED then return end


    if ent:GetStatus() == MINE_STATE_ARMED then
        ent:Wake(false)
        return
    end

    ent.bPlacedByPlayer = true
    ent:OpenHooks(true)
    ent:SetStatus(MINE_STATE_DEPLOY)
end)

hook.Add("GravGunOnPickedUp", "DAC.LuaCombineMineGravityPickUp", function(ply, ent)
    if ent:GetClass() != "shop_combine_mine" then return end

    ent.iFlipAttempts = 0

    if ent:GetStatus() == MINE_STATE_ARMED then
        ent:UpdateLight(true, Color(255, 255, 0, 190))
        ent.flTimeGrabbed = CurTime()
        ent.bHeldByPhysgun = true
        ent.hPlayerGrabber = ply

        sound.EmitHint(SOUND_MOVE_AWAY, ent:GetPos() + Vector(0, 0, 60), 32, 0.2, ent)
        return
    else
        ent.bHeldByPhysgun = true
        ent.hPlayerGrabber = ply

        if ent:GetStatus() == MINE_STATE_TRIGGERED then
            return
        else
            ent.bDisarmed = false
            ent:SetStatus(MINE_STATE_DEPLOY)
        end
    end
end)

local EMETA = FindMetaTable("Entity")

function EMETA:IsValidWorld()
    if self == game.GetWorld() then return true end

    return IsValid(self)
end