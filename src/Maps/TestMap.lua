-- TestMap.lua
-- A simple test map for the FPS game

local TestMap = {
    Name = "Test Map",
    Description = "A simple test map for development",
    Size = Vector3.new(100, 20, 100),
    SpawnPoints = {
        Team1 = {
            Vector3.new(-20, 5, 0),
            Vector3.new(-15, 5, 5),
            Vector3.new(-10, 5, -5)
        },
        Team2 = {
            Vector3.new(20, 5, 0),
            Vector3.new(15, 5, 5),
            Vector3.new(10, 5, -5)
        }
    },
    CapturePoints = {
        {
            Position = Vector3.new(0, 5, 0),
            Radius = 10,
            Name = "Center Point"
        }
    },
    WeaponSpawns = {
        {
            Position = Vector3.new(-30, 5, 0),
            WeaponType = "AK47",
            RespawnTime = 30
        },
        {
            Position = Vector3.new(30, 5, 0),
            WeaponType = "M4A1",
            RespawnTime = 30
        }
    },
    HealthPacks = {
        {
            Position = Vector3.new(-25, 5, 10),
            HealthAmount = 50,
            RespawnTime = 15
        },
        {
            Position = Vector3.new(25, 5, 10),
            HealthAmount = 50,
            RespawnTime = 15
        }
    },
    AmmoPacks = {
        {
            Position = Vector3.new(-25, 5, -10),
            AmmoType = "AssaultRifle",
            AmmoAmount = 60,
            RespawnTime = 20
        },
        {
            Position = Vector3.new(25, 5, -10),
            AmmoType = "AssaultRifle",
            AmmoAmount = 60,
            RespawnTime = 20
        }
    }
}

return TestMap 