-- ClientMain.lua
-- Main client script that initializes all components

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local uiContainer = player:WaitForChild("PlayerGui")

-- Components
local components = {
    Camera = nil,
    AmmoCounter = nil,
    KillFeed = nil,
    ScoreDisplay = nil,
    HealthDisplay = nil,
    MiniMap = nil
}

-- Load modules with error handling
local function loadModule(path)
    local success, result = pcall(function()
        return require(path)
    end)
    
    if success then
        return result
    else
        warn("Failed to load module:", path.Name, "-", result)
        return nil
    end
end

-- Create UI container
local function createUIContainer()
    -- Check if HUD exists
    local hud = uiContainer:FindFirstChild("HUD")
    if not hud then
        -- Create HUD container
        hud = Instance.new("ScreenGui")
        hud.Name = "HUD"
        hud.ResetOnSpawn = false
        hud.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        hud.Parent = uiContainer
        
        -- Create background frame
        local background = Instance.new("Frame")
        background.Name = "Background"
        background.Size = UDim2.new(1, 0, 1, 0)
        background.BackgroundTransparency = 1
        background.Parent = hud
    end
    
    return hud
end

-- Initialize UI components
local function initializeUIComponents()
    local hud = createUIContainer()
    
    -- AmmoCounter
    local ammoCounter = StarterGui:FindFirstChild("HUD") and StarterGui.HUD:FindFirstChild("AmmoCounter")
    if ammoCounter then
        components.AmmoCounter = loadModule(ammoCounter)
        if components.AmmoCounter then
            print("Initializing AmmoCounter...")
            components.AmmoCounter.Initialize()
        end
    else
        -- Create AmmoCounter module in memory if it doesn't exist in StarterGui
        local AmmoCounter = loadModule(ReplicatedStorage:FindFirstChild("UIModules") and ReplicatedStorage.UIModules:FindFirstChild("AmmoCounter"))
        if AmmoCounter then
            components.AmmoCounter = AmmoCounter
            print("Initializing AmmoCounter from ReplicatedStorage...")
            AmmoCounter.Initialize()
        else
            warn("AmmoCounter module not found")
        end
    end
    
    -- KillFeed
    local killFeed = StarterGui:FindFirstChild("HUD") and StarterGui.HUD:FindFirstChild("KillFeed")
    if killFeed then
        components.KillFeed = loadModule(killFeed)
        if components.KillFeed then
            print("Initializing KillFeed...")
            components.KillFeed.Initialize()
        end
    else
        -- Create KillFeed module in memory if it doesn't exist in StarterGui
        local KillFeed = loadModule(ReplicatedStorage:FindFirstChild("UIModules") and ReplicatedStorage.UIModules:FindFirstChild("KillFeed"))
        if KillFeed then
            components.KillFeed = KillFeed
            print("Initializing KillFeed from ReplicatedStorage...")
            KillFeed.Initialize()
        else
            warn("KillFeed module not found")
        end
    end
    
    -- ScoreDisplay
    local scoreDisplay = StarterGui:FindFirstChild("HUD") and StarterGui.HUD:FindFirstChild("ScoreDisplay")
    if scoreDisplay then
        components.ScoreDisplay = loadModule(scoreDisplay)
        if components.ScoreDisplay then
            print("Initializing ScoreDisplay...")
            components.ScoreDisplay.Initialize()
        end
    else
        -- Create ScoreDisplay module in memory if it doesn't exist in StarterGui
        local ScoreDisplay = loadModule(ReplicatedStorage:FindFirstChild("UIModules") and ReplicatedStorage.UIModules:FindFirstChild("ScoreDisplay"))
        if ScoreDisplay then
            components.ScoreDisplay = ScoreDisplay
            print("Initializing ScoreDisplay from ReplicatedStorage...")
            ScoreDisplay.Initialize()
        else
            warn("ScoreDisplay module not found")
        end
    end
    
    -- HealthDisplay
    if StarterGui:FindFirstChild("HUD") and StarterGui.HUD:FindFirstChild("HealthDisplay") then
        components.HealthDisplay = loadModule(StarterGui.HUD.HealthDisplay)
        if components.HealthDisplay then
            components.HealthDisplay.Initialize()
        end
    end
    
    -- MiniMap
    if StarterGui:FindFirstChild("HUD") and StarterGui.HUD:FindFirstChild("MiniMap") then
        components.MiniMap = loadModule(StarterGui.HUD.MiniMap)
        if components.MiniMap then
            components.MiniMap.Initialize()
        end
    end
end

-- Initialize character
local function initializeCharacter(character)
    print("Initializing character...")
    
    -- Load the camera module
    local CameraController = loadModule("Modules/CameraController")
    if CameraController then
        components.Camera = CameraController.new()
        components.Camera:Initialize(character)
        print("Camera controller initialized")
    else
        warn("Failed to load camera controller")
    end
    
    -- Load player controller
    local PlayerController = loadModule("Modules/PlayerController")
    if PlayerController then
        components.PlayerController = PlayerController.new(character)
        components.PlayerController:Initialize()
        print("Player controller initialized")
    else
        warn("Failed to load player controller")
    end
    
    -- No need to explicitly load WeaponController as it's a separate script
    -- that runs automatically in StarterPlayerScripts
    
    -- Fire player ready event after a delay
    task.wait(1)
    local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")
    playerEvents.PlayerReady:FireServer()
    
    print("Character initialization complete")
end

-- Connect to player events
player.CharacterAdded:Connect(initializeCharacter)

-- Handle game events
local function connectGameEvents()
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    
    -- Game status event
    if gameEvents:FindFirstChild("GameStatusChanged") then
        gameEvents.GameStatusChanged.OnClientEvent:Connect(function(data)
            if components.ScoreDisplay then
                components.ScoreDisplay.UpdateGameStatus(data)
            end
        end)
    end
    
    -- Kill feed event
    if gameEvents:FindFirstChild("KillFeedUpdated") then
        gameEvents.KillFeedUpdated.OnClientEvent:Connect(function(data)
            if components.KillFeed then
                components.KillFeed.AddKill(data)
            end
        end)
    end
end

-- Handle when a weapon is reloaded
local function onWeaponReloaded(weaponData)
    if components.AmmoCounter then
        components.AmmoCounter.UpdateAmmo(weaponData.Ammo, weaponData.ReserveAmmo)
    end
end

-- Handle weapon events
local function connectWeaponEvents()
    local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
    
    -- Weapon reloaded event
    if weaponEvents:FindFirstChild("WeaponReloaded") then
        weaponEvents.WeaponReloaded.OnClientEvent:Connect(function(weaponData)
            onWeaponReloaded(weaponData)
        end)
    end
end

-- Initialize UI
local function initialize()
    print("Initializing client...")
    
    -- Create UI container
    local hud = createUIContainer()
    
    -- Initialize UI components
    initializeUIComponents()
    
    -- Connect to game events
    connectGameEvents()
    
    -- Connect to weapon events
    connectWeaponEvents()
    
    -- Initialize character if already spawned
    if player.Character then
        initializeCharacter(player.Character)
    end
    
    print("Client initialization complete")
end

-- Handle game status changes
local function handleGameStatusChange(status, data)
    -- Update UI based on game status
    if status == "MatchStart" then
        -- Show game UI
        if components.ScoreDisplay then
            components.ScoreDisplay.Show()
        end
    elseif status == "MatchEnd" then
        -- Show end game UI
    elseif status == "Lobby" then
        -- Show lobby UI
        if components.ScoreDisplay then
            components.ScoreDisplay.Hide()
        end
    end
end

-- Handle player respawn
local function handleRespawn()
    -- Clean up resources before respawn
    if components.Camera then
        components.Camera:Cleanup()
        components.Camera = nil
    end
    
    -- Hide UI components
    if components.AmmoCounter then
        components.AmmoCounter.Hide()
    end
end

-- Clean up when the script is destroyed
local function cleanup()
    -- Destroy all components
    for name, component in pairs(components) do
        if component and typeof(component) == "table" and component.Cleanup then
            component:Cleanup()
        end
    end
    
    -- Clear components table
    components = {}
    
    print("Client cleaned up")
end

-- Start initialization
initialize() 