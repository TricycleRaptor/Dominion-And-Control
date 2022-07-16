local function CalcRoll(angles, velocity, rollAngle, rollSpeed)
    local right = angles:Right()

    -- Get amount of lateral movement
    local side = velocity:Dot(right)

    local sign = side < 0 and -1 or 1
    side = math.abs(side)

    local value = rollAngle

    if side < rollSpeed then
        side = side * value / rollSpeed
    else
        side = value
    end

    return side * sign
end

hook.Add("CalcView", "DAC.LuaClViewRoll", function (ply, pos, angles, ...)

    if ply:GetMoveType() == MOVETYPE_NOCLIP then return end

    local t = {
        angles = angles
    }
    
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and isfunction(wep.CalcView) then
        local view = wep:CalcView(ply, pos, angles, ...)
        if istable(view) then
            table.CopyFromTo(view, t)
        elseif isvector(view) then
            t.origin = view
        elseif isangle(view) then
            t.angles = view
        end
    end

    -- calculate view roll
    local roll = CalcRoll(t.angles, ply:GetAbsVelocity(), 0.8, 200)
    t.angles.r = t.angles.r + roll

    return t
	
end)
