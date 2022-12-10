--Credit to DoopieWop for original code: https://github.com/DoopieWop/lua_combine_mine
--Minor gamemode-specific edits by TricycleRaptor

language.Add("shop_combine_mine", "Lua Combine Mine")

local mat = Material("sprites/glow04_noz")

hook.Add("PostDrawOpaqueRenderables", "DAC.LuaCombineMineSprite", function()
    for k, v in ipairs(ents.FindByClass("shop_combine_mine")) do
        if !v:GetNWBool("light") then continue end

        local ang = v:GetAngles()
        local pos = v:GetPos() + ang:Up() * 10

        local color = v:GetNWVector("lightcolor", Vector(255, 0, 0)):ToColor()
        color.a = v:GetNWInt("lightalpha", 255)

        render.SetMaterial(mat)
        render.DrawSprite(pos, 18, 18, color)
    end
end)