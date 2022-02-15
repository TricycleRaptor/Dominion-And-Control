include( "shared.lua" )
function GM:HUDDrawTargetID()
-- Because this returns nothing, we won't get any information about other players like their name or health when looking at them
end

function GM:SpawnMenuOpen()
    local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not LocalPlayer():IsAdmin() then 
			return false
		else 
			return true 
		end
	else
		return true 
	end
end
hook.Add("SpawnMenuOpen", "DAC.SpawnMenu", SpawnMenuOpen)

function GM:ContextMenuOpen()
    local stage = DAC:GetGameStage()
	local data = stage and stage:GetData()
	if not data.allowBuilding then
		if not LocalPlayer():IsAdmin() then 
			return false
		else 
			return true 
		end
	else
		return true 
	end
end
hook.Add("ContextMenuOpen", "DAC.ContextMenu", ContextMenuOpen)

function GM:Think()
end