local WorkShopAddons = {
	["2912816023"] = "[LVS] - Framework",
	["2922255746"] = "[LVS] - Helicopters",
	["3027255911"] = "[LVS] - Cars",
	["3047221988"] = "[LVS] - Tanks"
}

if SERVER then
	for k, _ in pairs(WorkShopAddons) do
		resource.AddWorkshop(k)
	end
end