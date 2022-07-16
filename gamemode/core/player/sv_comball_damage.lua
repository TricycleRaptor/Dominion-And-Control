local timer_Simple = timer.Simple
local IsValid = IsValid

local class = "prop_combine_ball"
local hookName = class .. "_owner_damage"

hook.Add("OnEntityCreated", hookName, function( ent )
    if (ent:GetClass() == class) then
        local owner = nil
        timer_Simple(0, function()
            if IsValid( ent ) then
                owner = ent:GetOwner()
                ent:SetOwner()
            end
        end)

        timer_Simple(0.05, function()
            if IsValid( ent ) and IsValid( owner ) then
                owner:SetVelocity( -ent:GetVelocity() )
            end
        end)
    end
end)