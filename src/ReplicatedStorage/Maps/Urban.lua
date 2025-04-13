-- Urban.lua
-- Map definition for the Urban-themed map

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Urban = {}

-- Map configuration
Urban.Config = {
    Name = "Urban",
    Description = "Urban combat environment with multiple levels",
    MaxPlayers = 16,
    Thumbnail = "rbxassetid://0", -- Placeholder thumbnail
    SpawnPoints = {
        TeamA = {}, -- Will be filled during map creation
        TeamB = {}  -- Will be filled during map creation
    },
    WeaponSpawns = {}, -- Will be filled during map creation
    PickupSpawns = {}  -- Will be filled during map creation
}

-- Colors
local TEAM_A_COLOR = Color3.fromRGB(13, 105, 172) -- Blue
local TEAM_B_COLOR = Color3.fromRGB(196, 40, 28)  -- Red
local CONCRETE_COLOR = Color3.fromRGB(163, 162, 165)
local METAL_COLOR = Color3.fromRGB(96, 96, 96)

-- Create the map
function Urban.Build()
    local mapFolder = Instance.new("Folder")
    mapFolder.Name = "Urban"
    
    -- Create ground
    local ground = Instance.new("Part")
    ground.Name = "Ground"
    ground.Size = Vector3.new(200, 1, 200)
    ground.Position = Vector3.new(0, 0, 0)
    ground.Anchored = true
    ground.Material = Enum.Material.Concrete
    ground.Color = CONCRETE_COLOR
    ground.Parent = mapFolder
    
    -- Create buildings and cover
    local buildings = {
        -- Main buildings
        {pos = Vector3.new(-40, 15, -40), size = Vector3.new(30, 30, 30)},
        {pos = Vector3.new(40, 15, 40), size = Vector3.new(30, 30, 30)},
        {pos = Vector3.new(-40, 15, 40), size = Vector3.new(30, 30, 30)},
        {pos = Vector3.new(40, 15, -40), size = Vector3.new(30, 30, 30)},
        
        -- Cover blocks
        {pos = Vector3.new(0, 2, 0), size = Vector3.new(10, 4, 10)},
        {pos = Vector3.new(20, 2, 20), size = Vector3.new(8, 4, 8)},
        {pos = Vector3.new(-20, 2, -20), size = Vector3.new(8, 4, 8)},
        {pos = Vector3.new(20, 2, -20), size = Vector3.new(8, 4, 8)},
        {pos = Vector3.new(-20, 2, 20), size = Vector3.new(8, 4, 8)}
    }
    
    for i, building in ipairs(buildings) do
        local part = Instance.new("Part")
        part.Name = "Building_" .. i
        part.Size = building.size
        part.Position = building.pos
        part.Anchored = true
        part.Material = Enum.Material.Concrete
        part.Color = CONCRETE_COLOR
        part.Parent = mapFolder
    end
    
    -- Create spawn points
    local spawnPoints = {
        TeamA = {
            Vector3.new(-80, 5, -80),
            Vector3.new(-80, 5, -60),
            Vector3.new(-60, 5, -80),
            Vector3.new(-70, 5, -70)
        },
        TeamB = {
            Vector3.new(80, 5, 80),
            Vector3.new(80, 5, 60),
            Vector3.new(60, 5, 80),
            Vector3.new(70, 5, 70)
        }
    }
    
    for team, positions in pairs(spawnPoints) do
        for i, pos in ipairs(positions) do
            local spawnPoint = Instance.new("Part")
            spawnPoint.Name = team .. "Spawn_" .. i
            spawnPoint.Size = Vector3.new(4, 0.2, 4)
            spawnPoint.Position = pos
            spawnPoint.Anchored = true
            spawnPoint.CanCollide = false
            spawnPoint.Transparency = 0.8
            spawnPoint.Parent = mapFolder
            
            table.insert(Urban.Config.SpawnPoints[team], spawnPoint)
        end
    end
    
    -- Create weapon spawn points
    local weaponSpawnPositions = {
        Vector3.new(0, 1, 30),
        Vector3.new(0, 1, -30),
        Vector3.new(30, 1, 0),
        Vector3.new(-30, 1, 0)
    }
    
    for i, pos in ipairs(weaponSpawnPositions) do
        local weaponSpawn = Instance.new("Part")
        weaponSpawn.Name = "WeaponSpawn_" .. i
        weaponSpawn.Size = Vector3.new(2, 0.2, 2)
        weaponSpawn.Position = pos
        weaponSpawn.Anchored = true
        weaponSpawn.CanCollide = false
        weaponSpawn.Transparency = 0.5
        weaponSpawn.Parent = mapFolder
        
        table.insert(Urban.Config.WeaponSpawns, weaponSpawn)
    end
    
    -- Create pickup points
    local pickupPositions = {
        Vector3.new(15, 1, 15),
        Vector3.new(-15, 1, -15),
        Vector3.new(15, 1, -15),
        Vector3.new(-15, 1, 15)
    }
    
    for i, pos in ipairs(pickupPositions) do
        local pickup = Instance.new("Part")
        pickup.Name = "Pickup_" .. i
        pickup.Size = Vector3.new(1, 0.2, 1)
        pickup.Position = pos
        pickup.Anchored = true
        pickup.CanCollide = false
        pickup.Transparency = 0.5
        pickup.Parent = mapFolder
        
        table.insert(Urban.Config.PickupSpawns, pickup)
    end
    
    return mapFolder
end

-- Cleanup method
function Urban.Cleanup(mapInstance)
    if mapInstance then
        mapInstance:Destroy()
    end
end

return Urban 