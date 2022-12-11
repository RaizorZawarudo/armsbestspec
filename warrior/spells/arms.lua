local Unlocker, awful, example = ...
local arms = example.warrior.arms

local NS = awful.Spell
local player = awful.player
local enemy = awful.enemy
local target = awful.target

awful.Populate({
    --UTILS
    hamstring = NS(1715, {damage = "physical"} ),
    
    -- ATTACKS
    bloodthirst = NS(23881, { damage = "physical" }),
    rampage = NS(184367, { damage = "physical" }),
    whirlwind = NS(190411, { damage = "physical" }),
    slam = NS(1464, { damage = "physical" }),
    execute = NS(5308, { damage = "physical" }),
    impendingVictory = NS(202168, { damage = "physical" }),
    onslaught = NS(315720, {damage = "physical" }),

    --DAMAGE COOLIES
    odynsFury = NS(385059),
    avatar = NS(107574),
    recklessness = NS(1719),
}, arms, getfenv(1))
-- ^^^ make sure you replace "arms" here with your specialization's routine actor!

hamstring:Callback(function (spell) 
    if not target.player then return end
    if target.debuffRemains(1715) < 2 then
        return spell:Cast(target)
    end
    
end)

bloodthirst:Callback(function (spell)
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        return spell:Cast(target, {face = true})
    end  
end)

bloodthirst:Callback("heal", function(spell)
    if not spell:Castable() then return end
    if player.hp > 35 then return end
    if target.meleeRangeOf(player) then
        return spell:Cast(target, {face = true})
    end 
end)

rampage:Callback(function(spell)
    if player.Rage > 80 and target.meleeRangeOf(player) then
        if spell:Cast(target, {face = true}) then
            awful.alert("Rampage", spell.id)
        end
    end
end)

whirlwind:Callback("cleave", function(spell)
    if not player.hasTalent("Improved Whirlwind") then return end
    if not spell:Castable() then return end
    if player.buff("Whirlwind") then return end
    if player.distanceliteral > 4 then return end
    local bcc, hittable = enemies.around(player, 6.5, function(o) return o.bcc end)
    if bcc > 0 or hittable < 2 then return end
    return spell:Cast()

end)

execute:Callback(function (spell)
    if not player.hasTalent("Improved Exectue") then return end
    if not spell:Castable() then return end
    if target.hp > 20 then return end
    if target.meleeRangeOf(player) then
        return spell:Cast()
    end 
end)

execute:Callback("proc", function (spell)
    if player.buff("Sudden Death") then
        if target.meleeRangeOf(player) then
            return spell:Cast()
        end
    end    
end)

impendingVictory:Callback("halfHpNotCCd", function (spell)
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        if player.hp < 50 then
            return spell:Cast()
        end
    end    
end)

onslaught:Callback(function (spell)
    if not player.hasTalent("Onslaught") then return end
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        return spell:Cast()
    end    
end)

slam:Callback(function (spell)
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        return spell:Cast()
    end    
end)

odynsFury:Callback(function (spell)
    if not player.hasTalent("Odyn's Fury") or not spell:Castable() then return end
    if player.hasTalent("Avatar") and not player.hasTalent(390135) and player.buffRemains("Avatar") > 15 then
        if spell:Cast() then
            awful.alert("Odyn's Fury", spell.id)
        end
    end
    if player.buffRemains("Recklessness") > 8 then
        if spell:Cast() then
            awful.alert("Odyn's Fury", spell.id)
        end
    end    
end)