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
    mortalStrike = NS(12294, { damage = "physical" }),
    overpower = NS(7384, { damage = "physical" }),
    rend = NS(772, { damage = "physical", bleed = true }),
    slam = NS(1464, { damage = "physical" }),
    execute = NS(5308, { damage = "physical" }),
    impendingVictory = NS(202168, { damage = "physical" }),

    --DAMAGE COOLIES
    colossussSmash = NS(262161, { damage = "physical"}),
    avatar = NS(107574),
    sweepingStrikes = NS(260708),
    sharpenBlade = NS(198817),

    --DEFENSIVES 
    dieByTheSword = NS(118039),
}, arms, getfenv(1))
-- ^^^ make sure you replace "arms" here with your specialization's routine actor!

hamstring:Callback(function (spell) 
    if not target.player then return end
    if target.debuffRemains(1715) < 2 then
        return spell:Cast(target)
    end
    
end)

mortalStrike:Callback(function (spell)
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        return spell:Cast(target, {face = true})
    end  
end)

mortalStrike:Callback("proc Battlelord", function(spell)
    if not player.buff("Battlelord") then return end
    if target.meleeRangeOf(player) then
        return spell:Cast(target, {face = true})
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

slam:Callback(function (spell)
    if not spell:Castable() then return end
    if target.meleeRangeOf(player) then
        return spell:Cast()
    end    
end)