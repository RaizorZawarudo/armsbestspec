local Unlocker, awful, bishoparms = ...
local arms = bishoparms.warrior.arms

-- stuff out here only runs once, when the file is first loaded.
print("Example warrior locked and loaded!")

-- this is the routine actor function.
arms:Init(function()
    if target.enemy then
        -- auto attack to generate rage
        StartAttack()
        -- spells we created in the spell book are magically available in our actor!
        hamstring()
        --coolies
        odynsFury()

        -- heal
        impendingVictory("halfHpNotCCd")
        bloodthirst("heal")

        --attacks
        execute("proc")
        whirlwind("cleave")
        rampage()
        execute()
        onslaught()
        bloodthirst()
        slam()
    end
end)