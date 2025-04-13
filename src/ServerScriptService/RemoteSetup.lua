local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Remote Events folder
local function createRemoteEvents()
    -- Create GameEvents folder
    local gameEvents = Instance.new("Folder")
    gameEvents.Name = "GameEvents"
    gameEvents.Parent = ReplicatedStorage
    
    -- Create WeaponEvents folder
    local weaponEvents = Instance.new("Folder")
    weaponEvents.Name = "WeaponEvents"
    weaponEvents.Parent = ReplicatedStorage
    
    -- Create MapEvents folder
    local mapEvents = Instance.new("Folder")
    mapEvents.Name = "MapEvents"
    mapEvents.Parent = ReplicatedStorage
    
    -- Create PlayerEvents folder
    local playerEvents = Instance.new("Folder")
    playerEvents.Name = "PlayerEvents"
    playerEvents.Parent = ReplicatedStorage
    
    -- Game Events
    local function createGameEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = gameEvents
        return event
    end
    
    -- Weapon Events
    local function createWeaponEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = weaponEvents
        return event
    end
    
    -- Map Events
    local function createMapEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = mapEvents
        return event
    end
    
    -- Player Events
    local function createPlayerEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = playerEvents
        return event
    end
    
    -- Create all Game Events
    createGameEvent("GameStatus")
    createGameEvent("MatchStart")
    createGameEvent("MatchEnd")
    createGameEvent("RoundStart")
    createGameEvent("RoundEnd")
    createGameEvent("PlayerKilled")
    createGameEvent("PlayerRespawned")
    createGameEvent("ScoreUpdate")
    createGameEvent("TeamScoreUpdate")
    
    -- Create all Weapon Events
    createWeaponEvent("WeaponFired")
    createWeaponEvent("WeaponReloaded")
    createWeaponEvent("WeaponSwitched")
    createWeaponEvent("AmmoUpdate")
    createWeaponEvent("DamageDealt")
    createWeaponEvent("HitMarker")
    
    -- Create all Map Events
    createMapEvent("MapVote")
    createMapEvent("MapChange")
    createMapEvent("SpawnPointUpdate")
    createMapEvent("PickupSpawned")
    createMapEvent("PickupCollected")
    
    -- Create all Player Events
    createPlayerEvent("PlayerJoined")
    createPlayerEvent("PlayerLeft")
    createPlayerEvent("PlayerDied")
    createPlayerEvent("PlayerSpawned")
    createPlayerEvent("HealthUpdate")
    createPlayerEvent("KillstreakUpdate")
end

-- Create Remote Functions
local function createRemoteFunctions()
    -- Create GameFunctions folder
    local gameFunctions = Instance.new("Folder")
    gameFunctions.Name = "GameFunctions"
    gameFunctions.Parent = ReplicatedStorage
    
    -- Create WeaponFunctions folder
    local weaponFunctions = Instance.new("Folder")
    weaponFunctions.Name = "WeaponFunctions"
    weaponFunctions.Parent = ReplicatedStorage
    
    -- Create MapFunctions folder
    local mapFunctions = Instance.new("Folder")
    mapFunctions.Name = "MapFunctions"
    mapFunctions.Parent = ReplicatedStorage
    
    -- Create PlayerFunctions folder
    local playerFunctions = Instance.new("Folder")
    playerFunctions.Name = "PlayerFunctions"
    playerFunctions.Parent = ReplicatedStorage
    
    -- Game Functions
    local function createGameFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = gameFunctions
        return func
    end
    
    -- Weapon Functions
    local function createWeaponFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = weaponFunctions
        return func
    end
    
    -- Map Functions
    local function createMapFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = mapFunctions
        return func
    end
    
    -- Player Functions
    local function createPlayerFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = playerFunctions
        return func
    end
    
    -- Create all Game Functions
    createGameFunction("GetGameState")
    createGameFunction("GetMatchInfo")
    createGameFunction("GetTeamInfo")
    
    -- Create all Weapon Functions
    createWeaponFunction("GetWeaponData")
    createWeaponFunction("GetPlayerLoadout")
    createWeaponFunction("CanSwitchWeapon")
    
    -- Create all Map Functions
    createMapFunction("GetCurrentMap")
    createMapFunction("GetSpawnPoints")
    createMapFunction("GetMapVotes")
    
    -- Create all Player Functions
    createPlayerFunction("GetPlayerStats")
    createPlayerFunction("GetPlayerKillstreak")
    createPlayerFunction("GetPlayerHealth")
end

-- Initialize all remotes
local function initializeRemotes()
    createRemoteEvents()
    createRemoteFunctions()
end

-- Run initialization
initializeRemotes() 

-- Create Remote Events folder
local function createRemoteEvents()
    -- Create GameEvents folder
    local gameEvents = Instance.new("Folder")
    gameEvents.Name = "GameEvents"
    gameEvents.Parent = ReplicatedStorage
    
    -- Create WeaponEvents folder
    local weaponEvents = Instance.new("Folder")
    weaponEvents.Name = "WeaponEvents"
    weaponEvents.Parent = ReplicatedStorage
    
    -- Create MapEvents folder
    local mapEvents = Instance.new("Folder")
    mapEvents.Name = "MapEvents"
    mapEvents.Parent = ReplicatedStorage
    
    -- Create PlayerEvents folder
    local playerEvents = Instance.new("Folder")
    playerEvents.Name = "PlayerEvents"
    playerEvents.Parent = ReplicatedStorage
    
    -- Game Events
    local function createGameEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = gameEvents
        return event
    end
    
    -- Weapon Events
    local function createWeaponEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = weaponEvents
        return event
    end
    
    -- Map Events
    local function createMapEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = mapEvents
        return event
    end
    
    -- Player Events
    local function createPlayerEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = playerEvents
        return event
    end
    
    -- Create all Game Events
    createGameEvent("GameStatus")
    createGameEvent("MatchStart")
    createGameEvent("MatchEnd")
    createGameEvent("RoundStart")
    createGameEvent("RoundEnd")
    createGameEvent("PlayerKilled")
    createGameEvent("PlayerRespawned")
    createGameEvent("ScoreUpdate")
    createGameEvent("TeamScoreUpdate")
    
    -- Create all Weapon Events
    createWeaponEvent("WeaponFired")
    createWeaponEvent("WeaponReloaded")
    createWeaponEvent("WeaponSwitched")
    createWeaponEvent("AmmoUpdate")
    createWeaponEvent("DamageDealt")
    createWeaponEvent("HitMarker")
    
    -- Create all Map Events
    createMapEvent("MapVote")
    createMapEvent("MapChange")
    createMapEvent("SpawnPointUpdate")
    createMapEvent("PickupSpawned")
    createMapEvent("PickupCollected")
    
    -- Create all Player Events
    createPlayerEvent("PlayerJoined")
    createPlayerEvent("PlayerLeft")
    createPlayerEvent("PlayerDied")
    createPlayerEvent("PlayerSpawned")
    createPlayerEvent("HealthUpdate")
    createPlayerEvent("KillstreakUpdate")
end

-- Create Remote Functions
local function createRemoteFunctions()
    -- Create GameFunctions folder
    local gameFunctions = Instance.new("Folder")
    gameFunctions.Name = "GameFunctions"
    gameFunctions.Parent = ReplicatedStorage
    
    -- Create WeaponFunctions folder
    local weaponFunctions = Instance.new("Folder")
    weaponFunctions.Name = "WeaponFunctions"
    weaponFunctions.Parent = ReplicatedStorage
    
    -- Create MapFunctions folder
    local mapFunctions = Instance.new("Folder")
    mapFunctions.Name = "MapFunctions"
    mapFunctions.Parent = ReplicatedStorage
    
    -- Create PlayerFunctions folder
    local playerFunctions = Instance.new("Folder")
    playerFunctions.Name = "PlayerFunctions"
    playerFunctions.Parent = ReplicatedStorage
    
    -- Game Functions
    local function createGameFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = gameFunctions
        return func
    end
    
    -- Weapon Functions
    local function createWeaponFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = weaponFunctions
        return func
    end
    
    -- Map Functions
    local function createMapFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = mapFunctions
        return func
    end
    
    -- Player Functions
    local function createPlayerFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = playerFunctions
        return func
    end
    
    -- Create all Game Functions
    createGameFunction("GetGameState")
    createGameFunction("GetMatchInfo")
    createGameFunction("GetTeamInfo")
    
    -- Create all Weapon Functions
    createWeaponFunction("GetWeaponData")
    createWeaponFunction("GetPlayerLoadout")
    createWeaponFunction("CanSwitchWeapon")
    
    -- Create all Map Functions
    createMapFunction("GetCurrentMap")
    createMapFunction("GetSpawnPoints")
    createMapFunction("GetMapVotes")
    
    -- Create all Player Functions
    createPlayerFunction("GetPlayerStats")
    createPlayerFunction("GetPlayerKillstreak")
    createPlayerFunction("GetPlayerHealth")
end

-- Initialize all remotes
local function initializeRemotes()
    createRemoteEvents()
    createRemoteFunctions()
end

-- Run initialization
initializeRemotes() 

-- Create Remote Events folder
local function createRemoteEvents()
    -- Create GameEvents folder
    local gameEvents = Instance.new("Folder")
    gameEvents.Name = "GameEvents"
    gameEvents.Parent = ReplicatedStorage
    
    -- Create WeaponEvents folder
    local weaponEvents = Instance.new("Folder")
    weaponEvents.Name = "WeaponEvents"
    weaponEvents.Parent = ReplicatedStorage
    
    -- Create MapEvents folder
    local mapEvents = Instance.new("Folder")
    mapEvents.Name = "MapEvents"
    mapEvents.Parent = ReplicatedStorage
    
    -- Create PlayerEvents folder
    local playerEvents = Instance.new("Folder")
    playerEvents.Name = "PlayerEvents"
    playerEvents.Parent = ReplicatedStorage
    
    -- Game Events
    local function createGameEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = gameEvents
        return event
    end
    
    -- Weapon Events
    local function createWeaponEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = weaponEvents
        return event
    end
    
    -- Map Events
    local function createMapEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = mapEvents
        return event
    end
    
    -- Player Events
    local function createPlayerEvent(name)
        local event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = playerEvents
        return event
    end
    
    -- Create all Game Events
    createGameEvent("GameStatus")
    createGameEvent("MatchStart")
    createGameEvent("MatchEnd")
    createGameEvent("RoundStart")
    createGameEvent("RoundEnd")
    createGameEvent("PlayerKilled")
    createGameEvent("PlayerRespawned")
    createGameEvent("ScoreUpdate")
    createGameEvent("TeamScoreUpdate")
    
    -- Create all Weapon Events
    createWeaponEvent("WeaponFired")
    createWeaponEvent("WeaponReloaded")
    createWeaponEvent("WeaponSwitched")
    createWeaponEvent("AmmoUpdate")
    createWeaponEvent("DamageDealt")
    createWeaponEvent("HitMarker")
    
    -- Create all Map Events
    createMapEvent("MapVote")
    createMapEvent("MapChange")
    createMapEvent("SpawnPointUpdate")
    createMapEvent("PickupSpawned")
    createMapEvent("PickupCollected")
    
    -- Create all Player Events
    createPlayerEvent("PlayerJoined")
    createPlayerEvent("PlayerLeft")
    createPlayerEvent("PlayerDied")
    createPlayerEvent("PlayerSpawned")
    createPlayerEvent("HealthUpdate")
    createPlayerEvent("KillstreakUpdate")
end

-- Create Remote Functions
local function createRemoteFunctions()
    -- Create GameFunctions folder
    local gameFunctions = Instance.new("Folder")
    gameFunctions.Name = "GameFunctions"
    gameFunctions.Parent = ReplicatedStorage
    
    -- Create WeaponFunctions folder
    local weaponFunctions = Instance.new("Folder")
    weaponFunctions.Name = "WeaponFunctions"
    weaponFunctions.Parent = ReplicatedStorage
    
    -- Create MapFunctions folder
    local mapFunctions = Instance.new("Folder")
    mapFunctions.Name = "MapFunctions"
    mapFunctions.Parent = ReplicatedStorage
    
    -- Create PlayerFunctions folder
    local playerFunctions = Instance.new("Folder")
    playerFunctions.Name = "PlayerFunctions"
    playerFunctions.Parent = ReplicatedStorage
    
    -- Game Functions
    local function createGameFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = gameFunctions
        return func
    end
    
    -- Weapon Functions
    local function createWeaponFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = weaponFunctions
        return func
    end
    
    -- Map Functions
    local function createMapFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = mapFunctions
        return func
    end
    
    -- Player Functions
    local function createPlayerFunction(name)
        local func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = playerFunctions
        return func
    end
    
    -- Create all Game Functions
    createGameFunction("GetGameState")
    createGameFunction("GetMatchInfo")
    createGameFunction("GetTeamInfo")
    
    -- Create all Weapon Functions
    createWeaponFunction("GetWeaponData")
    createWeaponFunction("GetPlayerLoadout")
    createWeaponFunction("CanSwitchWeapon")
    
    -- Create all Map Functions
    createMapFunction("GetCurrentMap")
    createMapFunction("GetSpawnPoints")
    createMapFunction("GetMapVotes")
    
    -- Create all Player Functions
    createPlayerFunction("GetPlayerStats")
    createPlayerFunction("GetPlayerKillstreak")
    createPlayerFunction("GetPlayerHealth")
end

-- Initialize all remotes
local function initializeRemotes()
    createRemoteEvents()
    createRemoteFunctions()
end

-- Run initialization
initializeRemotes() 