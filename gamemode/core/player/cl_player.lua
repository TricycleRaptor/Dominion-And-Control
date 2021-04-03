hook.Add( "CreateClientsideRagdoll", "RemoveClientRagdoll", function( entity, ragdoll )
	if entity:IsPlayer() then
        ragdoll:Remove()
    end
end )