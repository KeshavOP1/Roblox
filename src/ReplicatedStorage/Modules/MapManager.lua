-- MapManager.lua
-- Handles loading and management of maps

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local MapManager = {}

-- Store all available maps
MapManager.Maps = {}

-- Currently active map
MapManager.CurrentMap = nil
MapManager.CurrentMapName = nil

-- Initialize the map manager
function MapManager.Initialize()
    -- Load all map modules
    local success, result = pcall(function()
        -- Define Urban map directly
        local Urban = {
            Config = {
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
            },
            
            Build = function(self)
                local mapFolder = Instance.new("Folder")
                mapFolder.Name = "Urban"
                
                -- Create ground
                local ground = Instance.new("Part")
                ground.Name = "Ground"
                ground.Size = Vector3.new(200, 1, 200)
                ground.Position = Vector3.new(0, 0, 0)
                ground.Anchored = true
                ground.Material = Enum.Material.Concrete
                ground.Parent = mapFolder
                
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
                        
                        table.insert(self.Config.SpawnPoints[team], spawnPoint)
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
                    
                    table.insert(self.Config.WeaponSpawns, weaponSpawn)
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
                    
                    table.insert(self.Config.PickupSpawns, pickup)
                end
                
                return mapFolder
            end,
            
            Cleanup = function(mapInstance)
                if mapInstance then
                    mapInstance:Destroy()
                end
            end
        }
        
        -- Register the map
        MapManager.Maps["Urban"] = Urban
        
        -- Create map info
        Urban.Info = {
            Name = Urban.Config.Name,
            Description = Urban.Config.Description,
            MaxPlayers = Urban.Config.MaxPlayers,
            Thumbnail = Urban.Config.Thumbnail or "rbxassetid://0" -- Use default if not provided
        }
    end)
    
    if not success then
        warn("Error initializing MapManager: " .. tostring(result))
        return false
    end
    
    -- Count maps
    local mapCount = 0
    for _ in pairs(MapManager.Maps) do
        mapCount = mapCount + 1
    end
    
    print("MapManager initialized with " .. mapCount .. " maps")
    
    return true
end

-- Get a list of all available maps
function MapManager.GetMapList()
    local mapList = {}
    
    for mapName, _ in pairs(MapManager.Maps) do
        table.insert(mapList, mapName)
    end
    
    return mapList
end

-- Get map information
function MapManager.GetMapInfo(mapName)
    if not MapManager.Maps[mapName] then
        return nil
    end
    
    return MapManager.Maps[mapName].Info
end

-- Load a map
function MapManager.LoadMap(mapName)
    -- Check if the map exists
    if not MapManager.Maps[mapName] then
        warn("Map not found: " .. mapName)
        return false
    end
    
    -- Unload current map if one is loaded
    if MapManager.CurrentMap then
        MapManager.UnloadMap()
    end
    
    -- Build the map
    local success, result = pcall(function()
        local mapInstance = MapManager.Maps[mapName].Build(MapManager.Maps[mapName])
        
        -- Place in workspace
        if mapInstance then
            mapInstance.Parent = workspace
            
            -- Store reference to current map
            MapManager.CurrentMap = mapInstance
            MapManager.CurrentMapName = mapName
            
            return true
        end
        
        return false
    end)
    
    if not success then
        warn("Error loading map: " .. tostring(result))
        return false
    end
    
    print("Map loaded: " .. mapName)
    return result
end

-- Unload the current map
function MapManager.UnloadMap()
    if not MapManager.CurrentMap then
        return false
    end
    
    local mapName = MapManager.CurrentMapName
    
    -- Call cleanup method if available
    if MapManager.Maps[mapName] and MapManager.Maps[mapName].Cleanup then
        MapManager.Maps[mapName].Cleanup(MapManager.CurrentMap)
    else
        -- Otherwise just destroy the map
        MapManager.CurrentMap:Destroy()
    end
    
    -- Clear references
    MapManager.CurrentMap = nil
    MapManager.CurrentMapName = nil
    
    print("Map unloaded: " .. mapName)
    return true
end

-- Get spawn points for the current map
function MapManager.GetSpawnPoints(team)
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return {}
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map or not map.Config or not map.Config.SpawnPoints then
        return {}
    end
    
    -- Map team names to the map's team names
    local teamMapping = {
        Red = "TeamA",
        Blue = "TeamB"
    }
    
    local mappedTeam = teamMapping[team] or team
    
    if mappedTeam then
        -- Return spawn points for specific team
        return map.Config.SpawnPoints[mappedTeam] or {}
    else
        -- Return all spawn points
        local allSpawnPoints = {}
        
        for _, spawnPoints in pairs(map.Config.SpawnPoints) do
            for _, spawnPoint in ipairs(spawnPoints) do
                table.insert(allSpawnPoints, spawnPoint)
            end
        end
        
        return allSpawnPoints
    end
end

-- Get a random spawn point for a team
function MapManager.GetRandomSpawnPoint(team)
    local spawnPoints = MapManager.GetSpawnPoints(team)
    
    if #spawnPoints == 0 then
        return nil
    end
    
    return spawnPoints[math.random(1, #spawnPoints)]
end

-- Get capture points for the current map
function MapManager.GetCapturePoints()
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return {}
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map or not map.CapturePoints then
        return {}
    end
    
    return map.CapturePoints
end

-- Get flag positions for the current map
function MapManager.GetFlagPositions()
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return {}
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map or not map.FlagPositions then
        return {}
    end
    
    return map.FlagPositions
end

-- Set up weapon spawners for the current map
function MapManager.SetupWeaponSpawners()
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return false
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map or not map.Config or not map.Config.WeaponSpawns then
        return false
    end
    
    -- This would set up weapon spawners based on the map's configuration
    print("Setting up weapon spawners for " .. MapManager.CurrentMapName)
    
    -- Create weapon spawners at each spawn point
    for _, weaponSpawn in ipairs(map.Config.WeaponSpawns) do
        -- Create a visual indicator for the weapon spawn
        local indicator = Instance.new("Part")
        indicator.Name = "WeaponSpawnIndicator"
        indicator.Anchored = true
        indicator.CanCollide = false
        indicator.Size = Vector3.new(2, 0.5, 2)
        indicator.Position = weaponSpawn.Position
        indicator.BrickColor = BrickColor.new("Bright yellow")
        indicator.Material = Enum.Material.Neon
        indicator.Transparency = 0.5
        indicator.Parent = MapManager.CurrentMap
    end
    
    return true
end

-- Set up health/ammo pickups for the current map
function MapManager.SetupPickups()
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return false
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map or not map.Config or not map.Config.PickupSpawns then
        return false
    end
    
    -- This would set up pickups based on the map's configuration
    print("Setting up pickups for " .. MapManager.CurrentMapName)
    
    -- Create pickups at each spawn point
    for _, pickupSpawn in ipairs(map.Config.PickupSpawns) do
        -- Create a visual indicator for the pickup
        local indicator = Instance.new("Part")
        indicator.Name = "PickupIndicator"
        indicator.Anchored = true
        indicator.CanCollide = false
        indicator.Size = Vector3.new(1, 1, 1)
        indicator.Position = pickupSpawn.Position
        indicator.BrickColor = BrickColor.new("Bright green")
        indicator.Material = Enum.Material.Neon
        indicator.Shape = Enum.PartType.Ball
        indicator.Transparency = 0.5
        indicator.Parent = MapManager.CurrentMap
    end
    
    return true
end

-- Get spawn location for a particular environmental feature
function MapManager.GetEnvironmentalLocation(featureType, index)
    if not MapManager.CurrentMap or not MapManager.CurrentMapName then
        return nil
    end
    
    local map = MapManager.Maps[MapManager.CurrentMapName]
    
    if not map then
        return nil
    end
    
    -- Return appropriate location based on feature type
    if featureType == "Hazard" and map.Hazards then
        return map.Hazards[index or 1]
    elseif featureType == "Killstreak" and map.KillstreakLocations then
        local locations = {}
        for name, pos in pairs(map.KillstreakLocations) do
            table.insert(locations, {Name = name, Position = pos})
        end
        return locations[index or 1]
    elseif featureType == "Cover" and map.CoverPoints then
        return map.CoverPoints[index or 1]
    end
    
    return nil
end

return MapManager 