local WorkShopDls = {
	["771487490"] = "[simfphys] LUA Vehicles - Base",
	["831680603"] = "[simfphys] armed vehicles",
	["1571918906"] = "[LFS] - Planes"
}

local WorkshopMaps = {
	["1449731878"] = "gm_vyten",
	["1289646999"] = "gm_rhine",
	["1864156937"] = "rp_deadcity"
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