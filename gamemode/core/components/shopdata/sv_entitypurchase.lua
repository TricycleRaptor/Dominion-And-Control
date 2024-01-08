net.Receive("dac_purchase_entity", function(len, ply)

    local entityName = net.ReadString() -- Name
    local entityCategory = net.ReadString() -- Category
    local entityCost = net.ReadString() -- Cost
    local entityModel = net.ReadString() -- Model
    local entityListName = net.ReadString() -- Listname
    local entityClass = net.ReadString() -- Class
    local entitySpawnOffset = net.ReadString() -- Class

    --[[print("\n[DAC DEBUG]: Server received:\n"
    .. "Sending Player: " ..tostring(ply:Nick()) .. "\n" 
    .. "Name: " .. tostring(entityName) .. "\n" 
    .. "Category: " .. tostring(entityCategory) .. "\n"
    .. "Cost: " .. tostring(entityCost) .. "\n"
    .. "Model: " .. tostring(entityModel) .. "\n"
    .. "List: " .. tostring(entityListName) .. "\n"
    .. "Class: " .. tostring(entityClass) .. "\n"
    )]]

    local Trace = ply:GetEyeTrace()
    local SpawnPos = Trace.HitPos + Trace.HitNormal

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        for entityIndex, entityValue in pairs (list.Get(entityListName)) do
            if entityValue.Class == entityClass then
                local newEnt = ents.Create(entityClass)
                newEnt:SetPos(SpawnPos + Vector(0,0, entitySpawnOffset))
                newEnt:SetAngles(Angle(0, ply:EyeAngles().Y - 180, _)) -- Set the prop angles to face the player, but maintain the Z axis

                if !string.find( newEnt:GetClass():lower(), "lvs" ) then
                    newEnt:SetTeam(ply:Team()) -- LVS non-vehicle entities can't assign a team
                end

                newEnt:Spawn()
                newEnt:Activate()
                newEnt:SetNWInt('OwningTeam', ply:Team())
            
                ply:SetNWInt("storeCredits", ply:GetNWInt("storeCredits") - entityCost)
                ply:EmitSound("ambient/levels/labs/coinslot1.wav") -- We want this serverside so other players can hear if the player buys something
            end
        end
    end

end)