-- Urban.lua
-- Map definition for the Urban-themed map

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Urban = {}

-- Map configuration
Urban.Config = {
    Name = "Urban",
    Description = "Urban combat environment with multiple levels",
    MaxPlayers = 16,
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
function Urban.Create()
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
        {pos = Vector3.new(0, 3, 0), size = Vector3.new(10, 6, 10)},
        {pos = Vector3.new(20, 3, 20), size = Vector3.new(8, 6, 8)},
        {pos = Vector3.new(-20, 3, -20), size = Vector3.new(8, 6, 8)},
        {pos = Vector3.new(20, 3, -20), size = Vector3.new(8, 6, 8)},
        {pos = Vector3.new(-20, 3, 20), size = Vector3.new(8, 6, 8)}
    }
    
    for i, buildingData in ipairs(buildings) do
        local building = Instance.new("Part")
        building.Name = "Building_" .. i
        building.Size = buildingData.size
        building.Position = buildingData.pos
        building.Anchored = true
        building.Material = Enum.Material.Concrete
        building.Color = CONCRETE_COLOR
        building.Parent = mapFolder
        
        -- Add some detail
        local trim = Instance.new("Part")
        trim.Name = "Trim_" .. i
        trim.Size = Vector3.new(buildingData.size.X + 0.5, 1, buildingData.size.Z + 0.5)
        trim.Position = buildingData.pos + Vector3.new(0, buildingData.size.Y/2, 0)
        trim.Anchored = true
        trim.Material = Enum.Material.Metal
        trim.Color = METAL_COLOR
        trim.Parent = mapFolder
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
    
    -- Create spawn point markers
    for team, positions in pairs(spawnPoints) do
        for i, pos in ipairs(positions) do
            local spawnPoint = Instance.new("Part")
            spawnPoint.Name = team .. "Spawn_" .. i
            spawnPoint.Size = Vector3.new(4, 0.2, 4)
            spawnPoint.Position = pos
            spawnPoint.Anchored = true
            spawnPoint.CanCollide = false
            spawnPoint.Transparency = 0.8
            spawnPoint.Color = team == "TeamA" and TEAM_A_COLOR or TEAM_B_COLOR
            
            -- Add spawn point to config
            table.insert(Urban.Config.SpawnPoints[team], spawnPoint)
            
            spawnPoint.Parent = mapFolder
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
        weaponSpawn.Color = Color3.fromRGB(255, 215, 0) -- Gold color
        
        -- Add to config
        table.insert(Urban.Config.WeaponSpawns, weaponSpawn)
        
        weaponSpawn.Parent = mapFolder
    end
    
    -- Create health/ammo pickup points
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
        pickup.Color = Color3.fromRGB(0, 255, 0) -- Green for health
        
        -- Add to config
        table.insert(Urban.Config.PickupSpawns, pickup)
        
        pickup.Parent = mapFolder
    end
    
    return mapFolder
end

-- Build method for MapManager compatibility
function Urban.Build()
    return Urban.Create()
end

-- Clean up the map
function Urban.Destroy(mapInstance)
    if mapInstance then
        mapInstance:Destroy()
    end
end

-- Map info for the MapManager
Urban.Info = {
    Name = "Urban",
    Description = "Urban combat environment with multiple levels",
    MaxPlayers = 16,
    SpawnPoints = {
        Red = {}, -- Will be filled during map creation
        Blue = {}  -- Will be filled during map creation
    }
}

return Urban 