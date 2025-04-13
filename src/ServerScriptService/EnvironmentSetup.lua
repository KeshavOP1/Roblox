local Workspace = game:GetService("Workspace")

-- Create spawn points
local function createSpawnPoints()
    -- Remove existing spawn points
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("SpawnLocation") then
            child:Destroy()
        end
    end
    
    -- Create new spawn points
    local spawnPositions = {
        Vector3.new(0, 5, 0),
        Vector3.new(50, 5, 50),
        Vector3.new(-50, 5, -50),
        Vector3.new(50, 5, -50),
        Vector3.new(-50, 5, 50)
    }
    
    for _, position in ipairs(spawnPositions) do
        local spawn = Instance.new("SpawnLocation")
        spawn.Position = position
        spawn.Anchored = true
        spawn.CanCollide = false
        spawn.Transparency = 0.5
        spawn.Parent = Workspace
    end
end

-- Create basic terrain
local function createTerrain()
    -- Clear existing terrain
    local terrain = Workspace.Terrain
    terrain:Clear()
    
    -- Create base terrain
    local size = Vector3.new(100, 1, 100)
    local position = CFrame.new(0, 0, 0)
    terrain:FillBlock(position, size, Enum.Material.Grass)
    
    -- Create some hills and obstacles
    local function createHill(position, size)
        terrain:FillBlock(CFrame.new(position), size, Enum.Material.Grass)
    end
    
    -- Create several hills
    createHill(Vector3.new(20, 1, 20), Vector3.new(10, 5, 10))
    createHill(Vector3.new(-20, 1, -20), Vector3.new(10, 5, 10))
    createHill(Vector3.new(20, 1, -20), Vector3.new(10, 5, 10))
    createHill(Vector3.new(-20, 1, 20), Vector3.new(10, 5, 10))
    
    -- Create some cover objects
    local function createCover(position, size)
        local part = Instance.new("Part")
        part.Size = size
        part.Position = position
        part.Anchored = true
        part.Material = Enum.Material.Concrete
        part.Parent = Workspace
    end
    
    -- Create several cover objects
    createCover(Vector3.new(30, 2.5, 0), Vector3.new(2, 5, 10))
    createCover(Vector3.new(-30, 2.5, 0), Vector3.new(2, 5, 10))
    createCover(Vector3.new(0, 2.5, 30), Vector3.new(10, 5, 2))
    createCover(Vector3.new(0, 2.5, -30), Vector3.new(10, 5, 2))
end

-- Initialize environment
local function initializeEnvironment()
    createSpawnPoints()
    createTerrain()
end

-- Run initialization
initializeEnvironment() 