-- ServerMain.lua
-- Main server script for the FPS game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- Load modules
local GameManager = require(ReplicatedStorage.Modules.GameManager)
local MapManager = require(ReplicatedStorage.Modules.MapManager)
local WeaponSystem = require(ReplicatedStorage.Modules.WeaponSystem)

-- Initialize remote events
local RemoteEvents = require(ReplicatedStorage.RemoteEventsInit)

-- Components
local components = {
    GameManager = nil,
    MapManager = nil
}

-- Set up weapon handling
local function setupWeaponHandling()
    -- Use the remote events from our initialization
    local weaponEvents = RemoteEvents.WeaponEvents
    
    -- Fire weapon event
    weaponEvents.WeaponFired.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon fired
        print("Weapon fired by", player.Name, "with data:", weaponData)
    end)
    
    -- Reload weapon event
    weaponEvents.WeaponReloaded.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon reloaded
        print("Weapon reloaded by", player.Name, "with data:", weaponData)
    end)
    
    -- Switch weapon event
    weaponEvents.WeaponSwitched.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon switched
        print("Weapon switched by", player.Name, "with data:", weaponData)
    end)
    
    -- Ammo changed event
    weaponEvents.WeaponAmmoChanged.OnServerEvent:Connect(function(player, weaponData)
        -- Handle ammo changed
        print("Ammo changed for", player.Name, "with data:", weaponData)
    end)
end

-- Set up damage handling
local function setupDamageHandling()
    -- Use the remote events from our initialization
    local playerEvents = RemoteEvents.PlayerEvents
    
    -- Player damage event
    playerEvents.PlayerDamage.OnServerEvent:Connect(function(player, targetPlayer, damage, weaponType)
        -- Handle player damage
        print("Player", player.Name, "damaged", targetPlayer.Name, "with", weaponType, "for", damage, "damage")
        
        -- Apply damage to the target player
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = targetPlayer.Character.Humanoid
            humanoid.Health = humanoid.Health - damage
            
            -- Check if player died
            if humanoid.Health <= 0 then
                print("Player", targetPlayer.Name, "was killed by", player.Name)
                -- Handle player death
            end
        end
    end)
end

-- Set up map voting
local function setupMapVotingEvents()
    -- Use the remote events from our initialization
    local mapEvents = RemoteEvents.MapEvents
    
    -- Map vote event
    mapEvents.MapVote.OnServerEvent:Connect(function(player, mapName)
        -- Handle map vote
        print("Player", player.Name, "voted for map:", mapName)
        
        -- Add vote to the map voting system
        -- This would be implemented in the GameManager
    end)
end

-- Set up game events
local function setupGameEvents()
    -- Use the remote events from our initialization
    local gameEvents = RemoteEvents.GameEvents
    
    -- Game status event
    gameEvents.GameStatus.OnServerEvent:Connect(function(player, status, data)
        -- Handle game status changes
        print("Game status changed to:", status, "with data:", data)
    end)
    
    -- Match start event
    gameEvents.MatchStart.OnServerEvent:Connect(function(player, matchData)
        -- Handle match start
        print("Match started with data:", matchData)
    end)
    
    -- Match end event
    gameEvents.MatchEnd.OnServerEvent:Connect(function(player, matchData)
        -- Handle match end
        print("Match ended with data:", matchData)
    end)
    
    -- Team score update event
    gameEvents.TeamScoreUpdate.OnServerEvent:Connect(function(player, teamScoreData)
        -- Handle team score update
        print("Team score updated:", teamScoreData)
    end)
end

-- Set up map pickups
local function setupMapPickups()
    -- Set up weapon spawners
    if not MapManager.SetupWeaponSpawners() then
        warn("Failed to set up weapon spawners")
    end
    
    -- Set up pickups
    if not MapManager.SetupPickups() then
        warn("Failed to set up pickups")
    end
    
    print("Map pickups set up")
end

-- Initialize the server
local function initializeServer()
    print("Initializing server...")
    
    -- Initialize components
    components.GameManager = GameManager.new()
    components.MapManager = MapManager.Initialize()
    
    -- Set up event handlers
    setupWeaponHandling()
    setupDamageHandling()
    setupMapVotingEvents()
    setupGameEvents()
    
    -- Load a test map
    print("Loading test map...")
    if not MapManager.LoadMap("Urban") then
        warn("Failed to load map. Pickups will not be set up.")
    else
        -- Set up map pickups
        setupMapPickups()
    end
    
    print("Server initialization complete")
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    print(player.Name .. " joined the game")
    
    -- Give player default weapon
    print("Giving " .. player.Name .. " default weapon")
    -- This would be implemented in the WeaponSystem
end)

-- Initialize the server
initializeServer() 