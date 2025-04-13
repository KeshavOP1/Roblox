-- GameInitializer.lua
-- Initializes all components of the game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")

-- List of components to load
local components = {
    CleanupControllers = true,
    ServerMain = true,
    WeaponHandler = true,
    RemoteHandlers = true,
    SetupTeams = true,
    GameModeController = true,
    -- WeaponController should NOT be here, it's a client script
    -- Add other components here
}

-- Load order for initialization
local loadOrder = {
    "CleanupControllers",
    "RemoteEventsInit",
    "SetupTeams",
    "ServerMain",
    "WeaponHandler", 
    "RemoteHandlers",
    "GameModeController"
}

-- Create a boundary for the game
local function createBoundary()
    local boundary = workspace:FindFirstChild("Boundary")
    if boundary then
        boundary:Destroy()
    end
    
    boundary = Instance.new("Folder")
    boundary.Name = "Boundary"
    boundary.Parent = workspace
    
    -- Create a large flat ground
    local ground = Instance.new("Part")
    ground.Name = "Ground"
    ground.Size = Vector3.new(500, 1, 500)
    ground.Position = Vector3.new(0, 0, 0)
    ground.Anchored = true
    ground.CanCollide = true
    ground.Material = Enum.Material.Grass
    ground.BrickColor = BrickColor.new("Bright green")
    ground.Parent = boundary
    
    -- Create boundary walls
    local wallSize = Vector3.new(500, 50, 5)
    local wallPositions = {
        Vector3.new(0, 25, 250), -- North
        Vector3.new(0, 25, -250), -- South
        Vector3.new(250, 25, 0), -- East
        Vector3.new(-250, 25, 0) -- West
    }
    local wallOrientations = {
        Vector3.new(0, 0, 0), -- North
        Vector3.new(0, 0, 0), -- South
        Vector3.new(0, 90, 0), -- East
        Vector3.new(0, 90, 0) -- West
    }
    
    for i, position in ipairs(wallPositions) do
        local wall = Instance.new("Part")
        wall.Name = "Wall" .. i
        wall.Size = wallSize
        wall.Position = position
        wall.Orientation = wallOrientations[i]
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.SmoothPlastic
        wall.BrickColor = BrickColor.new("Dark stone grey")
        wall.Transparency = 0.5
        wall.Parent = boundary
    end
    
    -- Create some obstacles for cover
    local obstacles = {
        {
            Name = "Building1",
            Size = Vector3.new(20, 30, 20),
            Position = Vector3.new(50, 15, 50),
            Color = "Brick yellow"
        },
        {
            Name = "Building2",
            Size = Vector3.new(25, 20, 15),
            Position = Vector3.new(-40, 10, -60),
            Color = "Medium stone grey"
        },
        {
            Name = "Wall1",
            Size = Vector3.new(30, 8, 2),
            Position = Vector3.new(10, 4, -20),
            Color = "Dark stone grey"
        },
        {
            Name = "Wall2",
            Size = Vector3.new(2, 8, 40),
            Position = Vector3.new(-30, 4, 0),
            Color = "Dark stone grey"
        }
    }
    
    for _, obstacleData in ipairs(obstacles) do
        local obstacle = Instance.new("Part")
        obstacle.Name = obstacleData.Name
        obstacle.Size = obstacleData.Size
        obstacle.Position = obstacleData.Position
        obstacle.Anchored = true
        obstacle.CanCollide = true
        obstacle.Material = Enum.Material.SmoothPlastic
        obstacle.BrickColor = BrickColor.new(obstacleData.Color)
        obstacle.Parent = boundary
    end
    
    print("Boundary created")
end

-- Initialize the game
local function initialize()
    print("Initializing FPS Game...")
    
    -- Create a boundary for the game
    createBoundary()
    
    -- Load HUD components
    local hudFolder = StarterGui:FindFirstChild("HUD")
    if not hudFolder then
        hudFolder = Instance.new("Folder")
        hudFolder.Name = "HUD"
        hudFolder.Parent = StarterGui
    end
    
    -- Load components in order
    for _, componentName in ipairs(loadOrder) do
        if components[componentName] then
            print("Loading component:", componentName)
            
            -- If the component is a module, require it
            local component = ReplicatedStorage:FindFirstChild(componentName)
            if component and component:IsA("ModuleScript") then
                require(component)
            end
            
            -- If the component is a server script, run it
            local script = ServerScriptService:FindFirstChild(componentName)
            if script and script:IsA("Script") then
                -- Scripts in ServerScriptService automatically run, no need to do anything
                print("Component loaded:", componentName)
            else
                print("Component not found in ServerScriptService:", componentName)
            end
        end
    end
    
    print("Game initialization complete")
end

-- Start initialization
initialize() 