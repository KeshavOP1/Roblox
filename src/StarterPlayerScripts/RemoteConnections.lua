local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Get Remote Events folders
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
local mapEvents = ReplicatedStorage:WaitForChild("MapEvents")
local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")

-- Get Remote Functions folders
local gameFunctions = ReplicatedStorage:WaitForChild("GameFunctions")
local weaponFunctions = ReplicatedStorage:WaitForChild("WeaponFunctions")
local mapFunctions = ReplicatedStorage:WaitForChild("MapFunctions")
local playerFunctions = ReplicatedStorage:WaitForChild("PlayerFunctions")

-- Connect to Game Events
local function connectGameEvents()
    -- Game Status
    gameEvents.GameStatus.OnClientEvent:Connect(function(status, data)
        -- Handle game status changes
        print("Game Status:", status, data)
    end)
    
    -- Match Events
    gameEvents.MatchStart.OnClientEvent:Connect(function(matchData)
        -- Handle match start
        print("Match Started:", matchData)
    end)
    
    gameEvents.MatchEnd.OnClientEvent:Connect(function(matchData)
        -- Handle match end
        print("Match Ended:", matchData)
    end)
    
    -- Round Events
    gameEvents.RoundStart.OnClientEvent:Connect(function(roundData)
        -- Handle round start
        print("Round Started:", roundData)
    end)
    
    gameEvents.RoundEnd.OnClientEvent:Connect(function(roundData)
        -- Handle round end
        print("Round Ended:", roundData)
    end)
    
    -- Score Events
    gameEvents.ScoreUpdate.OnClientEvent:Connect(function(scoreData)
        -- Handle score update
        print("Score Updated:", scoreData)
    end)
    
    gameEvents.TeamScoreUpdate.OnClientEvent:Connect(function(teamScoreData)
        -- Handle team score update
        print("Team Score Updated:", teamScoreData)
    end)
end

-- Connect to Weapon Events
local function connectWeaponEvents()
    -- Weapon Fired
    weaponEvents.WeaponFired.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon fired
        print("Weapon Fired:", weaponData)
    end)
    
    -- Weapon Reloaded
    weaponEvents.WeaponReloaded.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon reloaded
        print("Weapon Reloaded:", weaponData)
    end)
    
    -- Weapon Switched
    weaponEvents.WeaponSwitched.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon switched
        print("Weapon Switched:", weaponData)
    end)
    
    -- Ammo Update
    weaponEvents.AmmoUpdate.OnClientEvent:Connect(function(ammoData)
        -- Handle ammo update
        print("Ammo Updated:", ammoData)
    end)
    
    -- Damage Dealt
    weaponEvents.DamageDealt.OnClientEvent:Connect(function(damageData)
        -- Handle damage dealt
        print("Damage Dealt:", damageData)
    end)
    
    -- Hit Marker
    weaponEvents.HitMarker.OnClientEvent:Connect(function(hitData)
        -- Handle hit marker
        print("Hit Marker:", hitData)
    end)
end

-- Connect to Map Events
local function connectMapEvents()
    -- Map Vote
    mapEvents.MapVote.OnClientEvent:Connect(function(voteData)
        -- Handle map vote
        print("Map Vote:", voteData)
    end)
    
    -- Map Change
    mapEvents.MapChange.OnClientEvent:Connect(function(mapData)
        -- Handle map change
        print("Map Changed:", mapData)
    end)
    
    -- Spawn Point Update
    mapEvents.SpawnPointUpdate.OnClientEvent:Connect(function(spawnData)
        -- Handle spawn point update
        print("Spawn Points Updated:", spawnData)
    end)
    
    -- Pickup Events
    mapEvents.PickupSpawned.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup spawned
        print("Pickup Spawned:", pickupData)
    end)
    
    mapEvents.PickupCollected.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup collected
        print("Pickup Collected:", pickupData)
    end)
end

-- Connect to Player Events
local function connectPlayerEvents()
    -- Player Joined
    playerEvents.PlayerJoined.OnClientEvent:Connect(function(playerData)
        -- Handle player joined
        print("Player Joined:", playerData)
    end)
    
    -- Player Left
    playerEvents.PlayerLeft.OnClientEvent:Connect(function(playerData)
        -- Handle player left
        print("Player Left:", playerData)
    end)
    
    -- Player Died
    playerEvents.PlayerDied.OnClientEvent:Connect(function(deathData)
        -- Handle player died
        print("Player Died:", deathData)
    end)
    
    -- Player Spawned
    playerEvents.PlayerSpawned.OnClientEvent:Connect(function(spawnData)
        -- Handle player spawned
        print("Player Spawned:", spawnData)
    end)
    
    -- Health Update
    playerEvents.HealthUpdate.OnClientEvent:Connect(function(healthData)
        -- Handle health update
        print("Health Updated:", healthData)
    end)
    
    -- Killstreak Update
    playerEvents.KillstreakUpdate.OnClientEvent:Connect(function(killstreakData)
        -- Handle killstreak update
        print("Killstreak Updated:", killstreakData)
    end)
end

-- Initialize all connections
local function initializeConnections()
    connectGameEvents()
    connectWeaponEvents()
    connectMapEvents()
    connectPlayerEvents()
end

-- Run initialization
initializeConnections() 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Get Remote Events folders
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
local mapEvents = ReplicatedStorage:WaitForChild("MapEvents")
local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")

-- Get Remote Functions folders
local gameFunctions = ReplicatedStorage:WaitForChild("GameFunctions")
local weaponFunctions = ReplicatedStorage:WaitForChild("WeaponFunctions")
local mapFunctions = ReplicatedStorage:WaitForChild("MapFunctions")
local playerFunctions = ReplicatedStorage:WaitForChild("PlayerFunctions")

-- Connect to Game Events
local function connectGameEvents()
    -- Game Status
    gameEvents.GameStatus.OnClientEvent:Connect(function(status, data)
        -- Handle game status changes
        print("Game Status:", status, data)
    end)
    
    -- Match Events
    gameEvents.MatchStart.OnClientEvent:Connect(function(matchData)
        -- Handle match start
        print("Match Started:", matchData)
    end)
    
    gameEvents.MatchEnd.OnClientEvent:Connect(function(matchData)
        -- Handle match end
        print("Match Ended:", matchData)
    end)
    
    -- Round Events
    gameEvents.RoundStart.OnClientEvent:Connect(function(roundData)
        -- Handle round start
        print("Round Started:", roundData)
    end)
    
    gameEvents.RoundEnd.OnClientEvent:Connect(function(roundData)
        -- Handle round end
        print("Round Ended:", roundData)
    end)
    
    -- Score Events
    gameEvents.ScoreUpdate.OnClientEvent:Connect(function(scoreData)
        -- Handle score update
        print("Score Updated:", scoreData)
    end)
    
    gameEvents.TeamScoreUpdate.OnClientEvent:Connect(function(teamScoreData)
        -- Handle team score update
        print("Team Score Updated:", teamScoreData)
    end)
end

-- Connect to Weapon Events
local function connectWeaponEvents()
    -- Weapon Fired
    weaponEvents.WeaponFired.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon fired
        print("Weapon Fired:", weaponData)
    end)
    
    -- Weapon Reloaded
    weaponEvents.WeaponReloaded.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon reloaded
        print("Weapon Reloaded:", weaponData)
    end)
    
    -- Weapon Switched
    weaponEvents.WeaponSwitched.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon switched
        print("Weapon Switched:", weaponData)
    end)
    
    -- Ammo Update
    weaponEvents.AmmoUpdate.OnClientEvent:Connect(function(ammoData)
        -- Handle ammo update
        print("Ammo Updated:", ammoData)
    end)
    
    -- Damage Dealt
    weaponEvents.DamageDealt.OnClientEvent:Connect(function(damageData)
        -- Handle damage dealt
        print("Damage Dealt:", damageData)
    end)
    
    -- Hit Marker
    weaponEvents.HitMarker.OnClientEvent:Connect(function(hitData)
        -- Handle hit marker
        print("Hit Marker:", hitData)
    end)
end

-- Connect to Map Events
local function connectMapEvents()
    -- Map Vote
    mapEvents.MapVote.OnClientEvent:Connect(function(voteData)
        -- Handle map vote
        print("Map Vote:", voteData)
    end)
    
    -- Map Change
    mapEvents.MapChange.OnClientEvent:Connect(function(mapData)
        -- Handle map change
        print("Map Changed:", mapData)
    end)
    
    -- Spawn Point Update
    mapEvents.SpawnPointUpdate.OnClientEvent:Connect(function(spawnData)
        -- Handle spawn point update
        print("Spawn Points Updated:", spawnData)
    end)
    
    -- Pickup Events
    mapEvents.PickupSpawned.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup spawned
        print("Pickup Spawned:", pickupData)
    end)
    
    mapEvents.PickupCollected.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup collected
        print("Pickup Collected:", pickupData)
    end)
end

-- Connect to Player Events
local function connectPlayerEvents()
    -- Player Joined
    playerEvents.PlayerJoined.OnClientEvent:Connect(function(playerData)
        -- Handle player joined
        print("Player Joined:", playerData)
    end)
    
    -- Player Left
    playerEvents.PlayerLeft.OnClientEvent:Connect(function(playerData)
        -- Handle player left
        print("Player Left:", playerData)
    end)
    
    -- Player Died
    playerEvents.PlayerDied.OnClientEvent:Connect(function(deathData)
        -- Handle player died
        print("Player Died:", deathData)
    end)
    
    -- Player Spawned
    playerEvents.PlayerSpawned.OnClientEvent:Connect(function(spawnData)
        -- Handle player spawned
        print("Player Spawned:", spawnData)
    end)
    
    -- Health Update
    playerEvents.HealthUpdate.OnClientEvent:Connect(function(healthData)
        -- Handle health update
        print("Health Updated:", healthData)
    end)
    
    -- Killstreak Update
    playerEvents.KillstreakUpdate.OnClientEvent:Connect(function(killstreakData)
        -- Handle killstreak update
        print("Killstreak Updated:", killstreakData)
    end)
end

-- Initialize all connections
local function initializeConnections()
    connectGameEvents()
    connectWeaponEvents()
    connectMapEvents()
    connectPlayerEvents()
end

-- Run initialization
initializeConnections() 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Get Remote Events folders
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
local mapEvents = ReplicatedStorage:WaitForChild("MapEvents")
local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")

-- Get Remote Functions folders
local gameFunctions = ReplicatedStorage:WaitForChild("GameFunctions")
local weaponFunctions = ReplicatedStorage:WaitForChild("WeaponFunctions")
local mapFunctions = ReplicatedStorage:WaitForChild("MapFunctions")
local playerFunctions = ReplicatedStorage:WaitForChild("PlayerFunctions")

-- Connect to Game Events
local function connectGameEvents()
    -- Game Status
    gameEvents.GameStatus.OnClientEvent:Connect(function(status, data)
        -- Handle game status changes
        print("Game Status:", status, data)
    end)
    
    -- Match Events
    gameEvents.MatchStart.OnClientEvent:Connect(function(matchData)
        -- Handle match start
        print("Match Started:", matchData)
    end)
    
    gameEvents.MatchEnd.OnClientEvent:Connect(function(matchData)
        -- Handle match end
        print("Match Ended:", matchData)
    end)
    
    -- Round Events
    gameEvents.RoundStart.OnClientEvent:Connect(function(roundData)
        -- Handle round start
        print("Round Started:", roundData)
    end)
    
    gameEvents.RoundEnd.OnClientEvent:Connect(function(roundData)
        -- Handle round end
        print("Round Ended:", roundData)
    end)
    
    -- Score Events
    gameEvents.ScoreUpdate.OnClientEvent:Connect(function(scoreData)
        -- Handle score update
        print("Score Updated:", scoreData)
    end)
    
    gameEvents.TeamScoreUpdate.OnClientEvent:Connect(function(teamScoreData)
        -- Handle team score update
        print("Team Score Updated:", teamScoreData)
    end)
end

-- Connect to Weapon Events
local function connectWeaponEvents()
    -- Weapon Fired
    weaponEvents.WeaponFired.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon fired
        print("Weapon Fired:", weaponData)
    end)
    
    -- Weapon Reloaded
    weaponEvents.WeaponReloaded.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon reloaded
        print("Weapon Reloaded:", weaponData)
    end)
    
    -- Weapon Switched
    weaponEvents.WeaponSwitched.OnClientEvent:Connect(function(weaponData)
        -- Handle weapon switched
        print("Weapon Switched:", weaponData)
    end)
    
    -- Ammo Update
    weaponEvents.AmmoUpdate.OnClientEvent:Connect(function(ammoData)
        -- Handle ammo update
        print("Ammo Updated:", ammoData)
    end)
    
    -- Damage Dealt
    weaponEvents.DamageDealt.OnClientEvent:Connect(function(damageData)
        -- Handle damage dealt
        print("Damage Dealt:", damageData)
    end)
    
    -- Hit Marker
    weaponEvents.HitMarker.OnClientEvent:Connect(function(hitData)
        -- Handle hit marker
        print("Hit Marker:", hitData)
    end)
end

-- Connect to Map Events
local function connectMapEvents()
    -- Map Vote
    mapEvents.MapVote.OnClientEvent:Connect(function(voteData)
        -- Handle map vote
        print("Map Vote:", voteData)
    end)
    
    -- Map Change
    mapEvents.MapChange.OnClientEvent:Connect(function(mapData)
        -- Handle map change
        print("Map Changed:", mapData)
    end)
    
    -- Spawn Point Update
    mapEvents.SpawnPointUpdate.OnClientEvent:Connect(function(spawnData)
        -- Handle spawn point update
        print("Spawn Points Updated:", spawnData)
    end)
    
    -- Pickup Events
    mapEvents.PickupSpawned.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup spawned
        print("Pickup Spawned:", pickupData)
    end)
    
    mapEvents.PickupCollected.OnClientEvent:Connect(function(pickupData)
        -- Handle pickup collected
        print("Pickup Collected:", pickupData)
    end)
end

-- Connect to Player Events
local function connectPlayerEvents()
    -- Player Joined
    playerEvents.PlayerJoined.OnClientEvent:Connect(function(playerData)
        -- Handle player joined
        print("Player Joined:", playerData)
    end)
    
    -- Player Left
    playerEvents.PlayerLeft.OnClientEvent:Connect(function(playerData)
        -- Handle player left
        print("Player Left:", playerData)
    end)
    
    -- Player Died
    playerEvents.PlayerDied.OnClientEvent:Connect(function(deathData)
        -- Handle player died
        print("Player Died:", deathData)
    end)
    
    -- Player Spawned
    playerEvents.PlayerSpawned.OnClientEvent:Connect(function(spawnData)
        -- Handle player spawned
        print("Player Spawned:", spawnData)
    end)
    
    -- Health Update
    playerEvents.HealthUpdate.OnClientEvent:Connect(function(healthData)
        -- Handle health update
        print("Health Updated:", healthData)
    end)
    
    -- Killstreak Update
    playerEvents.KillstreakUpdate.OnClientEvent:Connect(function(killstreakData)
        -- Handle killstreak update
        print("Killstreak Updated:", killstreakData)
    end)
end

-- Initialize all connections
local function initializeConnections()
    connectGameEvents()
    connectWeaponEvents()
    connectMapEvents()
    connectPlayerEvents()
end

-- Run initialization
initializeConnections() 