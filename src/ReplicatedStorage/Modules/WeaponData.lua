-- WeaponData.lua
-- Contains configuration data for all weapons in the game

local WeaponData = {}

-- Assault Rifles
WeaponData.AK47 = {
    Name = "AK47",
    Type = "AssaultRifle",
    Damage = 35,
    HeadshotMultiplier = 2.5,
    FireRate = 600, -- RPM
    ClipSize = 30,
    ReserveAmmo = 120,
    ReloadTime = 2.2,
    Range = 1000,
    Spread = {
        Hip = 5.0,
        Aim = 1.5
    },
    Recoil = {
        X = 2.0, -- Horizontal recoil
        Y = 3.5, -- Vertical recoil
        Recovery = 0.9 -- Recovery speed
    },
    BulletDrop = 0.5,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "AK47_Fire",
        Reload = "AK47_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "AssaultRifle",
    UnlockLevel = 0
}

WeaponData.M4A1 = {
    Name = "M4A1",
    Type = "AssaultRifle",
    Damage = 28,
    HeadshotMultiplier = 2.3,
    FireRate = 800,
    ClipSize = 30,
    ReserveAmmo = 120,
    ReloadTime = 1.8,
    Range = 900,
    Spread = {
        Hip = 4.0,
        Aim = 1.0
    },
    Recoil = {
        X = 1.5,
        Y = 2.8,
        Recovery = 1.0
    },
    BulletDrop = 0.4,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "M4A1_Fire",
        Reload = "M4A1_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "AssaultRifle",
    UnlockLevel = 5
}

WeaponData.SCAR = {
    Name = "SCAR",
    Type = "AssaultRifle",
    Damage = 32,
    HeadshotMultiplier = 2.4,
    FireRate = 620,
    ClipSize = 25,
    ReserveAmmo = 100,
    ReloadTime = 2.0,
    Range = 950,
    Spread = {
        Hip = 4.5,
        Aim = 1.2
    },
    Recoil = {
        X = 1.8,
        Y = 3.0,
        Recovery = 0.95
    },
    BulletDrop = 0.45,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "SCAR_Fire",
        Reload = "SCAR_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "AssaultRifle",
    UnlockLevel = 10
}

-- SMGs
WeaponData.MP5 = {
    Name = "MP5",
    Type = "SMG",
    Damage = 22,
    HeadshotMultiplier = 2.0,
    FireRate = 900,
    ClipSize = 30,
    ReserveAmmo = 150,
    ReloadTime = 1.5,
    Range = 600,
    Spread = {
        Hip = 3.5,
        Aim = 1.8
    },
    Recoil = {
        X = 1.2,
        Y = 2.0,
        Recovery = 1.2
    },
    BulletDrop = 0.6,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "MP5_Fire",
        Reload = "MP5_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SMG",
    UnlockLevel = 3
}

WeaponData.UZI = {
    Name = "UZI",
    Type = "SMG",
    Damage = 20,
    HeadshotMultiplier = 1.8,
    FireRate = 950,
    ClipSize = 32,
    ReserveAmmo = 160,
    ReloadTime = 1.4,
    Range = 500,
    Spread = {
        Hip = 4.0,
        Aim = 2.0
    },
    Recoil = {
        X = 1.5,
        Y = 1.8,
        Recovery = 1.3
    },
    BulletDrop = 0.65,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = false,
        Magazine = true
    },
    Sounds = {
        Fire = "UZI_Fire",
        Reload = "UZI_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SMG",
    UnlockLevel = 8
}

WeaponData.VECTOR = {
    Name = "VECTOR",
    Type = "SMG",
    Damage = 18,
    HeadshotMultiplier = 1.9,
    FireRate = 1200,
    ClipSize = 25,
    ReserveAmmo = 125,
    ReloadTime = 1.6,
    Range = 550,
    Spread = {
        Hip = 3.2,
        Aim = 1.5
    },
    Recoil = {
        X = 1.0,
        Y = 1.5,
        Recovery = 1.5
    },
    BulletDrop = 0.6,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "VECTOR_Fire",
        Reload = "VECTOR_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SMG",
    UnlockLevel = 15
}

-- Sniper Rifles
WeaponData.AWP = {
    Name = "AWP",
    Type = "SniperRifle",
    Damage = 120,
    HeadshotMultiplier = 3.0,
    FireRate = 50,
    ClipSize = 5,
    ReserveAmmo = 30,
    ReloadTime = 3.5,
    Range = 2000,
    Spread = {
        Hip = 10.0,
        Aim = 0.1
    },
    Recoil = {
        X = 3.0,
        Y = 8.0,
        Recovery = 0.6
    },
    BulletDrop = 0.2,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = false,
        Magazine = false
    },
    Sounds = {
        Fire = "AWP_Fire",
        Reload = "AWP_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SniperRifle",
    UnlockLevel = 20
}

WeaponData.BARRETT = {
    Name = "BARRETT",
    Type = "SniperRifle",
    Damage = 150,
    HeadshotMultiplier = 2.5,
    FireRate = 40,
    ClipSize = 5,
    ReserveAmmo = 25,
    ReloadTime = 4.0,
    Range = 2500,
    Spread = {
        Hip = 15.0,
        Aim = 0.2
    },
    Recoil = {
        X = 4.0,
        Y = 10.0,
        Recovery = 0.5
    },
    BulletDrop = 0.15,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = false,
        Magazine = false
    },
    Sounds = {
        Fire = "BARRETT_Fire",
        Reload = "BARRETT_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SniperRifle",
    UnlockLevel = 30
}

WeaponData.DRAGUNOV = {
    Name = "DRAGUNOV",
    Type = "SniperRifle",
    Damage = 90,
    HeadshotMultiplier = 2.8,
    FireRate = 120,
    ClipSize = 10,
    ReserveAmmo = 40,
    ReloadTime = 3.0,
    Range = 1800,
    Spread = {
        Hip = 8.0,
        Aim = 0.3
    },
    Recoil = {
        X = 2.5,
        Y = 6.0,
        Recovery = 0.7
    },
    BulletDrop = 0.25,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = true,
        Magazine = false
    },
    Sounds = {
        Fire = "DRAGUNOV_Fire",
        Reload = "DRAGUNOV_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "SniperRifle",
    UnlockLevel = 25
}

-- Shotguns
WeaponData.SPAS12 = {
    Name = "SPAS12",
    Type = "Shotgun",
    Damage = 25, -- Per pellet, shoots 8 pellets
    HeadshotMultiplier = 1.5,
    FireRate = 80,
    ClipSize = 8,
    ReserveAmmo = 32,
    ReloadTime = 0.6, -- Per shell
    Range = 400,
    Spread = {
        Hip = 7.0,
        Aim = 5.0
    },
    Recoil = {
        X = 3.0,
        Y = 5.0,
        Recovery = 0.8
    },
    BulletDrop = 0.8,
    PelletCount = 8,
    AttachmentSlots = {
        Optic = true,
        Barrel = false,
        Underbarrel = true,
        Magazine = false
    },
    Sounds = {
        Fire = "SPAS12_Fire",
        Reload = "SPAS12_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "Shotgun",
    UnlockLevel = 12
}

WeaponData.AA12 = {
    Name = "AA12",
    Type = "Shotgun",
    Damage = 18, -- Per pellet, shoots 8 pellets
    HeadshotMultiplier = 1.3,
    FireRate = 300,
    ClipSize = 20,
    ReserveAmmo = 60,
    ReloadTime = 3.0,
    Range = 350,
    Spread = {
        Hip = 8.0,
        Aim = 6.0
    },
    Recoil = {
        X = 3.5,
        Y = 4.5,
        Recovery = 0.9
    },
    BulletDrop = 0.9,
    PelletCount = 8,
    AttachmentSlots = {
        Optic = true,
        Barrel = false,
        Underbarrel = true,
        Magazine = true
    },
    Sounds = {
        Fire = "AA12_Fire",
        Reload = "AA12_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "Shotgun",
    UnlockLevel = 18
}

-- Pistols
WeaponData.GLOCK = {
    Name = "GLOCK",
    Type = "Pistol",
    Damage = 25,
    HeadshotMultiplier = 2.0,
    FireRate = 400,
    ClipSize = 15,
    ReserveAmmo = 60,
    ReloadTime = 1.5,
    Range = 500,
    Spread = {
        Hip = 3.0,
        Aim = 1.0
    },
    Recoil = {
        X = 1.0,
        Y = 2.0,
        Recovery = 1.2
    },
    BulletDrop = 0.7,
    AttachmentSlots = {
        Optic = false,
        Barrel = true,
        Underbarrel = false,
        Magazine = true
    },
    Sounds = {
        Fire = "GLOCK_Fire",
        Reload = "GLOCK_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "Pistol",
    UnlockLevel = 0
}

WeaponData.DEAGLE = {
    Name = "DEAGLE",
    Type = "Pistol",
    Damage = 70,
    HeadshotMultiplier = 2.2,
    FireRate = 150,
    ClipSize = 7,
    ReserveAmmo = 35,
    ReloadTime = 1.8,
    Range = 700,
    Spread = {
        Hip = 4.0,
        Aim = 1.5
    },
    Recoil = {
        X = 3.0,
        Y = 5.0,
        Recovery = 0.8
    },
    BulletDrop = 0.6,
    AttachmentSlots = {
        Optic = true,
        Barrel = true,
        Underbarrel = false,
        Magazine = false
    },
    Sounds = {
        Fire = "DEAGLE_Fire",
        Reload = "DEAGLE_Reload",
        Empty = "Gun_Empty"
    },
    AnimationSet = "Pistol",
    UnlockLevel = 10
}

-- Melee Weapons
WeaponData.KNIFE = {
    Name = "KNIFE",
    Type = "Melee",
    Damage = 50,
    BackstabMultiplier = 2.0,
    AttackRate = 120,
    Range = 3,
    Sounds = {
        Swing = "Knife_Swing",
        Hit = "Knife_Hit"
    },
    AnimationSet = "Melee",
    UnlockLevel = 0
}

WeaponData.KATANA = {
    Name = "KATANA",
    Type = "Melee",
    Damage = 85,
    BackstabMultiplier = 1.5,
    AttackRate = 80,
    Range = 4,
    Sounds = {
        Swing = "Katana_Swing",
        Hit = "Katana_Hit"
    },
    AnimationSet = "Melee",
    UnlockLevel = 22
}

-- Explosives
WeaponData.FRAG_GRENADE = {
    Name = "FRAG_GRENADE",
    Type = "Throwable",
    Damage = 100,
    BlastRadius = 10,
    FuseTime = 3.5,
    ThrowForce = 50,
    MaxCount = 2,
    Sounds = {
        Throw = "Grenade_Throw",
        Explode = "Grenade_Explode"
    },
    AnimationSet = "Throwable",
    UnlockLevel = 5
}

WeaponData.FLASHBANG = {
    Name = "FLASHBANG",
    Type = "Throwable",
    BlastRadius = 15,
    FuseTime = 1.5,
    ThrowForce = 60,
    FlashDuration = 5.0,
    MaxCount = 2,
    Sounds = {
        Throw = "Flash_Throw",
        Explode = "Flash_Explode"
    },
    AnimationSet = "Throwable",
    UnlockLevel = 8
}

WeaponData.C4 = {
    Name = "C4",
    Type = "Placeable",
    Damage = 150,
    BlastRadius = 12,
    ArmTime = 3.0,
    DetonationType = "Remote",
    MaxCount = 1,
    Sounds = {
        Place = "C4_Place",
        Arm = "C4_Arm",
        Explode = "C4_Explode"
    },
    AnimationSet = "Placeable",
    UnlockLevel = 15
}

-- Attachment Data
WeaponData.Attachments = {
    -- Optics
    RedDot = {
        Type = "Optic",
        Name = "Red Dot Sight",
        StatModifiers = {
            Spread = {
                Aim = 0.8 -- 20% better aim spread
            }
        },
        ZoomLevel = 1.2,
        UnlockLevel = 5
    },
    Holographic = {
        Type = "Optic",
        Name = "Holographic Sight",
        StatModifiers = {
            Spread = {
                Aim = 0.75 -- 25% better aim spread
            }
        },
        ZoomLevel = 1.3,
        UnlockLevel = 10
    },
    ACOG = {
        Type = "Optic",
        Name = "ACOG Scope",
        StatModifiers = {
            Spread = {
                Aim = 0.6 -- 40% better aim spread
            },
            Recoil = {
                Y = 1.1 -- 10% more vertical recoil
            }
        },
        ZoomLevel = 2.0,
        UnlockLevel = 15
    },
    SniperScope = {
        Type = "Optic",
        Name = "Sniper Scope",
        StatModifiers = {
            Spread = {
                Aim = 0.3 -- 70% better aim spread
            },
            Recoil = {
                Y = 1.2 -- 20% more vertical recoil
            }
        },
        ZoomLevel = 4.0,
        UnlockLevel = 20
    },
    
    -- Barrels
    Suppressor = {
        Type = "Barrel",
        Name = "Suppressor",
        StatModifiers = {
            Damage = 0.85, -- 15% less damage
            Range = 0.9 -- 10% less range
        },
        MuzzleFlash = false,
        SoundReduction = true,
        UnlockLevel = 8
    },
    CompensatorV = {
        Type = "Barrel",
        Name = "Vertical Compensator",
        StatModifiers = {
            Recoil = {
                Y = 0.7 -- 30% less vertical recoil
            }
        },
        UnlockLevel = 12
    },
    CompensatorH = {
        Type = "Barrel",
        Name = "Horizontal Compensator",
        StatModifiers = {
            Recoil = {
                X = 0.7 -- 30% less horizontal recoil
            }
        },
        UnlockLevel = 12
    },
    ExtendedBarrel = {
        Type = "Barrel",
        Name = "Extended Barrel",
        StatModifiers = {
            Damage = 1.1, -- 10% more damage
            Range = 1.15, -- 15% more range
            Recoil = {
                Y = 1.1 -- 10% more vertical recoil
            }
        },
        UnlockLevel = 18
    },
    
    -- Underbarrel
    ForwardGrip = {
        Type = "Underbarrel",
        Name = "Forward Grip",
        StatModifiers = {
            Recoil = {
                X = 0.8, -- 20% less horizontal recoil
                Y = 0.9 -- 10% less vertical recoil
            }
        },
        UnlockLevel = 7
    },
    AngledGrip = {
        Type = "Underbarrel",
        Name = "Angled Grip",
        StatModifiers = {
            Recoil = {
                Recovery = 1.3 -- 30% faster recoil recovery
            }
        },
        UnlockLevel = 14
    },
    Laser = {
        Type = "Underbarrel",
        Name = "Laser Sight",
        StatModifiers = {
            Spread = {
                Hip = 0.7 -- 30% better hip fire spread
            }
        },
        UnlockLevel = 10
    },
    
    -- Magazine
    ExtendedMag = {
        Type = "Magazine",
        Name = "Extended Magazine",
        StatModifiers = {
            ClipSize = 1.5, -- 50% more ammo
            ReloadTime = 1.1 -- 10% longer reload time
        },
        UnlockLevel = 6
    },
    FastMag = {
        Type = "Magazine",
        Name = "Fast Magazine",
        StatModifiers = {
            ReloadTime = 0.7 -- 30% faster reload time
        },
        UnlockLevel = 13
    },
    APRounds = {
        Type = "Magazine",
        Name = "Armor Piercing Rounds",
        StatModifiers = {
            Damage = 1.15, -- 15% more damage
            ClipSize = 0.8 -- 20% less ammo
        },
        UnlockLevel = 20
    }
}

return WeaponData 