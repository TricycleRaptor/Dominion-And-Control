hook.Add( "CreateClientsideRagdoll", "fade_out_corpses", function( entity, ragdoll )
	if entity:IsPlayer() then
        entity.remove()
    end
end )