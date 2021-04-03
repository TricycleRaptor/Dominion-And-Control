local WorkShopDls = {}

local WorkshopMaps = {
	["1449731878"] = "gm_vyten"
}

if SERVER then
	for k, _ in pairs(WorkShopDls) do
		resource.AddWorkshop(k)
	end

	for k, v in pairs(WorkshopMaps) do
		if string.find(game.GetMap(), v) then
			resource.AddWorkshop(k)
		end
	end
end