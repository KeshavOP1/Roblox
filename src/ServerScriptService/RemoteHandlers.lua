-- RemoteHandlers.lua
-- Handles all remote events and functions for the FPS game

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for RemoteEventsInit to complete
local RemoteEvents = require(ReplicatedStorage:WaitForChild("RemoteEventsInit"))

-- Wait for event folders to be created before proceeding
local function waitForRemoteEvents()
    -- Wait until all remote event instances are created
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents:WaitForChild("GameStatus")
    gameEvents:WaitForChild("MatchStart")
    gameEvents:WaitForChild("MatchEnd")
    gameEvents:WaitForChild("RoundStart")
    gameEvents:WaitForChild("RoundEnd")
    gameEvents:WaitForChild("ScoreUpdate")
    gameEvents:WaitForChild("TeamScoreUpdate")
    
    local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
    weaponEvents:WaitForChild("WeaponFired")
    weaponEvents:WaitForChild("WeaponReloaded")
    weaponEvents:WaitForChild("WeaponSwitched")
    weaponEvents:WaitForChild("AmmoUpdate")
    weaponEvents:WaitForChild("DamageDealt")
    weaponEvents:WaitForChild("HitMarker")
    
    local mapEvents = ReplicatedStorage:WaitForChild("MapEvents")
    mapEvents:WaitForChild("MapVote")
    mapEvents:WaitForChild("MapChange")
    mapEvents:WaitForChild("SpawnPointUpdate")
    mapEvents:WaitForChild("PickupSpawned")
    mapEvents:WaitForChild("PickupCollected")
    
    local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")
    playerEvents:WaitForChild("PlayerJoined")
    playerEvents:WaitForChild("PlayerLeft")
    playerEvents:WaitForChild("PlayerDied")
    playerEvents:WaitForChild("PlayerSpawned")
    playerEvents:WaitForChild("HealthUpdate")
    playerEvents:WaitForChild("KillstreakUpdate")
    
    -- Wait for function folders too
    local gameFunctions = ReplicatedStorage:WaitForChild("GameFunctions")
    local weaponFunctions = ReplicatedStorage:WaitForChild("WeaponFunctions")
    local mapFunctions = ReplicatedStorage:WaitForChild("MapFunctions")
    local playerFunctions = ReplicatedStorage:WaitForChild("PlayerFunctions")
    
    print("All remote events and functions are ready")
    return {
        gameEvents = gameEvents,
        weaponEvents = weaponEvents,
        mapEvents = mapEvents,
        playerEvents = playerEvents,
        gameFunctions = gameFunctions,
        weaponFunctions = weaponFunctions,
        mapFunctions = mapFunctions,
        playerFunctions = playerFunctions
    }
end

-- Handle Game Events
local function handleGameEvents(gameEvents)
    -- Game Status
    gameEvents.GameStatus.OnServerEvent:Connect(function(player, status, data)
        -- Handle game status changes
        print("Game Status:", status, data)
    end)
    
    -- Match Events
    gameEvents.MatchStart.OnServerEvent:Connect(function(player, matchData)
        -- Handle match start
        print("Match Started:", matchData)
    end)
    
    gameEvents.MatchEnd.OnServerEvent:Connect(function(player, matchData)
        -- Handle match end
        print("Match Ended:", matchData)
    end)
    
    -- Round Events
    gameEvents.RoundStart.OnServerEvent:Connect(function(player, roundData)
        -- Handle round start
        print("Round Started:", roundData)
    end)
    
    gameEvents.RoundEnd.OnServerEvent:Connect(function(player, roundData)
        -- Handle round end
        print("Round Ended:", roundData)
    end)
    
    -- Score Events
    gameEvents.ScoreUpdate.OnServerEvent:Connect(function(player, scoreData)
        -- Handle score update
        print("Score Updated:", scoreData)
    end)
    
    gameEvents.TeamScoreUpdate.OnServerEvent:Connect(function(player, teamScoreData)
        -- Handle team score update
        print("Team Score Updated:", teamScoreData)
    end)
end

-- Handle Weapon Events
local function handleWeaponEvents(weaponEvents)
    -- Weapon Fired
    weaponEvents.WeaponFired.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon fired
        print("Weapon Fired:", weaponData)
    end)
    
    -- Weapon Reloaded
    weaponEvents.WeaponReloaded.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon reloaded
        print("Weapon Reloaded:", weaponData)
    end)
    
    -- Weapon Switched
    weaponEvents.WeaponSwitched.OnServerEvent:Connect(function(player, weaponData)
        -- Handle weapon switched
        print("Weapon Switched:", weaponData)
    end)
    
    -- Ammo Update
    weaponEvents.AmmoUpdate.OnServerEvent:Connect(function(player, ammoData)
        -- Handle ammo update
        print("Ammo Updated:", ammoData)
    end)
    
    -- Damage Dealt
    weaponEvents.DamageDealt.OnServerEvent:Connect(function(player, damageData)
        -- Handle damage dealt
        print("Damage Dealt:", damageData)
    end)
    
    -- Hit Marker
    weaponEvents.HitMarker.OnServerEvent:Connect(function(player, hitData)
        -- Handle hit marker
        print("Hit Marker:", hitData)
    end)
end

-- Handle Map Events
local function handleMapEvents(mapEvents)
    -- Map Vote
    mapEvents.MapVote.OnServerEvent:Connect(function(player, voteData)
        -- Handle map vote
        print("Map Vote:", voteData)
    end)
    
    -- Map Change
    mapEvents.MapChange.OnServerEvent:Connect(function(player, mapData)
        -- Handle map change
        print("Map Changed:", mapData)
    end)
    
    -- Spawn Point Update
    mapEvents.SpawnPointUpdate.OnServerEvent:Connect(function(player, spawnData)
        -- Handle spawn point update
        print("Spawn Points Updated:", spawnData)
    end)
    
    -- Pickup Events
    mapEvents.PickupSpawned.OnServerEvent:Connect(function(player, pickupData)
        -- Handle pickup spawned
        print("Pickup Spawned:", pickupData)
    end)
    
    mapEvents.PickupCollected.OnServerEvent:Connect(function(player, pickupData)
        -- Handle pickup collected
        print("Pickup Collected:", pickupData)
    end)
end

-- Handle Player Events
local function handlePlayerEvents(playerEvents)
    -- Player Joined
    playerEvents.PlayerJoined.OnServerEvent:Connect(function(player, playerData)
        -- Handle player joined
        print("Player Joined:", playerData)
    end)
    
    -- Player Left
    playerEvents.PlayerLeft.OnServerEvent:Connect(function(player, playerData)
        -- Handle player left
        print("Player Left:", playerData)
    end)
    
    -- Player Died
    playerEvents.PlayerDied.OnServerEvent:Connect(function(player, deathData)
        -- Handle player died
        print("Player Died:", deathData)
    end)
    
    -- Player Spawned
    playerEvents.PlayerSpawned.OnServerEvent:Connect(function(player, spawnData)
        -- Handle player spawned
        print("Player Spawned:", spawnData)
    end)
    
    -- Health Update
    playerEvents.HealthUpdate.OnServerEvent:Connect(function(player, healthData)
        -- Handle health update
        print("Health Updated:", healthData)
    end)
    
    -- Killstreak Update
    playerEvents.KillstreakUpdate.OnServerEvent:Connect(function(player, killstreakData)
        -- Handle killstreak update
        print("Killstreak Updated:", killstreakData)
    end)
end

-- Handle Remote Functions
local function handleRemoteFunctions(gameFunctions, weaponFunctions, mapFunctions, playerFunctions)
    -- Game Functions
    gameFunctions.GetGameState.OnServerInvoke = function(player)
        -- Return game state
        return {
            Status = "Playing",
            Mode = "Team Deathmatch",
            TimeRemaining = 600
        }
    end
    
    gameFunctions.GetMatchInfo.OnServerInvoke = function(player)
        -- Return match info
        return {
            Map = "Urban",
            Mode = "Team Deathmatch",
            TimeRemaining = 600
        }
    end
    
    gameFunctions.GetTeamInfo.OnServerInvoke = function(player)
        -- Return team info
        return {
            RedTeam = {
                Score = 0,
                Players = {}
            },
            BlueTeam = {
                Score = 0,
                Players = {}
            }
        }
    end
    
    -- Weapon Functions
    weaponFunctions.GetWeaponData.OnServerInvoke = function(player, weaponName)
        -- Return weapon data
        return {
            Name = weaponName,
            Damage = 25,
            FireRate = 600,
            ReloadTime = 2,
            ClipSize = 30,
            ReserveAmmo = 90
        }
    end
    
    weaponFunctions.GetPlayerLoadout.OnServerInvoke = function(player)
        -- Return player loadout
        return {
            Primary = "AK47",
            Secondary = "Glock",
            Melee = "Knife"
        }
    end
    
    weaponFunctions.CanSwitchWeapon.OnServerInvoke = function(player, weaponName)
        -- Return if player can switch to weapon
        return true
    end
    
    -- Map Functions
    mapFunctions.GetCurrentMap.OnServerInvoke = function(player)
        -- Return current map
        return {
            Name = "Urban",
            Mode = "Team Deathmatch",
            TimeRemaining = 600
        }
    end
    
    mapFunctions.GetSpawnPoints.OnServerInvoke = function(player)
        -- Return spawn points
        return {
            RedTeam = {
                Vector3.new(0, 5, 0),
                Vector3.new(50, 5, 50),
                Vector3.new(-50, 5, -50)
            },
            BlueTeam = {
                Vector3.new(0, 5, 0),
                Vector3.new(50, 5, -50),
                Vector3.new(-50, 5, 50)
            }
        }
    end
    
    mapFunctions.GetMapVotes.OnServerInvoke = function(player)
        -- Return map votes
        return {
            Urban = 5,
            Desert = 3,
            Snow = 2
        }
    end
    
    -- Player Functions
    playerFunctions.GetPlayerStats.OnServerInvoke = function(player)
        -- Return player stats
        return {
            Kills = 0,
            Deaths = 0,
            Assists = 0,
            Score = 0
        }
    end
    
    playerFunctions.GetPlayerKillstreak.OnServerInvoke = function(player)
        -- Return player killstreak
        return {
            Current = 0,
            Highest = 0
        }
    end
    
    playerFunctions.GetPlayerHealth.OnServerInvoke = function(player)
        -- Return player health
        return {
            Current = 100,
            Max = 100
        }
    end
end

-- Initialize all handlers
local function initializeHandlers()
    print("Initializing RemoteHandlers...")
    
    -- Wait for all remote events to be ready
    local remotes = waitForRemoteEvents()
    
    -- Set up handlers once events are ready
    handleGameEvents(remotes.gameEvents)
    handleWeaponEvents(remotes.weaponEvents)
    handleMapEvents(remotes.mapEvents)
    handlePlayerEvents(remotes.playerEvents)
    handleRemoteFunctions(remotes.gameFunctions, remotes.weaponFunctions, remotes.mapFunctions, remotes.playerFunctions)
    
    print("RemoteHandlers initialization complete")
end

-- Start initialization
initializeHandlers() 