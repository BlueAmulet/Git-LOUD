local TAirUnit = import('/lua/defaultunits.lua').AirUnit

local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

SEA0211 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {},
        LinkedRailGun = Class(TAirToAirLinkedRailgun) {},
    },
}

TypeClass = SEA0211
