local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the main UI container
local function createUIContainer()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameUI"
    screenGui.ResetOnSpawn = false
    
    -- Create main container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, 0, 1, 0)
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = screenGui
    
    -- Create HUD container
    local hudContainer = Instance.new("Frame")
    hudContainer.Name = "HUDContainer"
    hudContainer.Size = UDim2.new(1, 0, 1, 0)
    hudContainer.BackgroundTransparency = 1
    hudContainer.Parent = mainContainer
    
    -- Create Ammo Counter
    local ammoCounter = Instance.new("Frame")
    ammoCounter.Name = "AmmoCounter"
    ammoCounter.Size = UDim2.new(0, 200, 0, 50)
    ammoCounter.Position = UDim2.new(1, -220, 1, -70)
    ammoCounter.BackgroundTransparency = 0.5
    ammoCounter.BackgroundColor3 = Color3.new(0, 0, 0)
    ammoCounter.Parent = hudContainer
    
    -- Create Kill Feed
    local killFeed = Instance.new("Frame")
    killFeed.Name = "KillFeed"
    killFeed.Size = UDim2.new(0, 300, 0, 200)
    killFeed.Position = UDim2.new(0, 20, 0, 20)
    killFeed.BackgroundTransparency = 0.5
    killFeed.BackgroundColor3 = Color3.new(0, 0, 0)
    killFeed.Parent = hudContainer
    
    -- Create Score Display
    local scoreDisplay = Instance.new("Frame")
    scoreDisplay.Name = "ScoreDisplay"
    scoreDisplay.Size = UDim2.new(0, 200, 0, 50)
    scoreDisplay.Position = UDim2.new(0.5, -100, 0, 20)
    scoreDisplay.BackgroundTransparency = 0.5
    scoreDisplay.BackgroundColor3 = Color3.new(0, 0, 0)
    scoreDisplay.Parent = hudContainer
    
    -- Create Health Display
    local healthDisplay = Instance.new("Frame")
    healthDisplay.Name = "HealthDisplay"
    healthDisplay.Size = UDim2.new(0, 200, 0, 20)
    healthDisplay.Position = UDim2.new(0.5, -100, 1, -40)
    healthDisplay.BackgroundTransparency = 0.5
    healthDisplay.BackgroundColor3 = Color3.new(0, 0, 0)
    healthDisplay.Parent = hudContainer
    
    -- Create Mini Map
    local miniMap = Instance.new("Frame")
    miniMap.Name = "MiniMap"
    miniMap.Size = UDim2.new(0, 150, 0, 150)
    miniMap.Position = UDim2.new(1, -170, 0, 20)
    miniMap.BackgroundTransparency = 0.5
    miniMap.BackgroundColor3 = Color3.new(0, 0, 0)
    miniMap.Parent = hudContainer
    
    return screenGui
end

-- Initialize UI for a player
local function initializeUI(player)
    local ui = createUIContainer()
    ui.Parent = player:WaitForChild("PlayerGui")
end

-- Connect to player joining
Players.PlayerAdded:Connect(initializeUI)

-- Initialize UI for existing players
for _, player in ipairs(Players:GetPlayers()) do
    initializeUI(player)
end 