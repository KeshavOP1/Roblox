-- GameModeController.lua
-- Controls the game modes and win conditions

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for game events
local GameEvents
local function waitForGameEvents()
    -- Wait for the GameEvents folder
    local gameEventsFolder = ReplicatedStorage:WaitForChild("GameEvents", 10)
    if not gameEventsFolder then
        warn("GameEvents folder not found in ReplicatedStorage")
        return false
    end
    
    -- Wait for the specific events we need
    local statusEvent = gameEventsFolder:WaitForChild("GameStatusChanged", 5)
    local killFeedEvent = gameEventsFolder:WaitForChild("KillFeedUpdated", 5)
    
    if not statusEvent or not killFeedEvent then
        warn("Required game events not found")
        return false
    end
    
    -- Set the GameEvents local reference
    GameEvents = {
        GameStatusChanged = statusEvent,
        KillFeedUpdated = killFeedEvent
    }
    
    print("GameEvents successfully loaded")
    return true
end

-- Game state
local gameState = {
    InProgress = false,
    TimeLimit = 300, -- 5 minutes
    TimeRemaining = 300,
    ScoreLimit = 30,
    TeamScores = {
        ["Red Team"] = 0,
        ["Blue Team"] = 0
    }
}

-- Start a new game
local function startGame()
    if gameState.InProgress then return end
    
    print("Starting new game...")
    
    -- Reset scores
    gameState.TeamScores["Red Team"] = 0
    gameState.TeamScores["Blue Team"] = 0
    
    -- Reset time
    gameState.TimeRemaining = gameState.TimeLimit
    
    -- Set game in progress
    gameState.InProgress = true
    
    -- Announce game start
    GameEvents.GameStatusChanged:FireAllClients({
        Status = "InProgress",
        RedScore = 0,
        BlueScore = 0,
        TimeRemaining = gameState.TimeRemaining
    })
    
    -- Start timer
    task.spawn(function()
        while gameState.InProgress and gameState.TimeRemaining > 0 do
            task.wait(1)
            gameState.TimeRemaining = gameState.TimeRemaining - 1
            
            -- Update clients every 5 seconds
            if gameState.TimeRemaining % 5 == 0 or gameState.TimeRemaining <= 10 then
                GameEvents.GameStatusChanged:FireAllClients({
                    Status = "InProgress",
                    RedScore = gameState.TeamScores["Red Team"],
                    BlueScore = gameState.TeamScores["Blue Team"],
                    TimeRemaining = gameState.TimeRemaining
                })
            end
            
            -- Check if time ran out
            if gameState.TimeRemaining <= 0 then
                endGame("TimeUp")
                break
            end
        end
    end)
    
    print("Game started")
end

-- End the current game
local function endGame(reason)
    if not gameState.InProgress then return end
    
    local winningTeam = nil
    local isTie = false
    
    if gameState.TeamScores["Red Team"] > gameState.TeamScores["Blue Team"] then
        winningTeam = "Red Team"
    elseif gameState.TeamScores["Blue Team"] > gameState.TeamScores["Red Team"] then
        winningTeam = "Blue Team"
    else
        isTie = true
    end
    
    -- Set game not in progress
    gameState.InProgress = false
    
    -- Announce game end
    GameEvents.GameStatusChanged:FireAllClients({
        Status = "GameOver",
        Reason = reason,
        WinningTeam = winningTeam,
        IsTie = isTie,
        RedScore = gameState.TeamScores["Red Team"],
        BlueScore = gameState.TeamScores["Blue Team"]
    })
    
    print("Game ended: " .. reason)
    
    -- Start a new game after a delay
    task.delay(10, startGame)
end

-- Handle player killed
local function onPlayerKilled(killer, victim)
    if not gameState.InProgress then return end
    
    if not killer or not killer.Team then return end
    
    -- Update killer's stats
    local killerStats = killer:FindFirstChild("leaderstats")
    if killerStats then
        local kills = killerStats:FindFirstChild("Kills")
        if kills then
            kills.Value = kills.Value + 1
        end
    end
    
    -- Update victim's stats
    if victim then
        local victimStats = victim:FindFirstChild("leaderstats")
        if victimStats then
            local deaths = victimStats:FindFirstChild("Deaths")
            if deaths then
                deaths.Value = deaths.Value + 1
            end
        end
    end
    
    -- Update team score
    if killer.Team then
        local teamName = killer.Team.Name
        gameState.TeamScores[teamName] = gameState.TeamScores[teamName] + 1
        
        -- Send kill feed update
        GameEvents.KillFeedUpdated:FireAllClients({
            KillerName = killer.Name,
            KillerTeam = killer.Team.Name,
            VictimName = victim and victim.Name or "Unknown",
            VictimTeam = victim and victim.Team and victim.Team.Name or "Unknown",
            Weapon = "AK47" -- Default weapon, update this with actual weapon data
        })
        
        -- Update score display
        GameEvents.GameStatusChanged:FireAllClients({
            Status = "ScoreUpdate",
            RedScore = gameState.TeamScores["Red Team"],
            BlueScore = gameState.TeamScores["Blue Team"],
            TimeRemaining = gameState.TimeRemaining
        })
        
        -- Check if score limit reached
        if gameState.TeamScores[teamName] >= gameState.ScoreLimit then
            endGame("ScoreLimit")
        end
    end
end

-- Handle player damage
local function onPlayerDamaged(player, attacker, damage)
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Apply damage
    humanoid.Health = humanoid.Health - damage
    
    -- Check if player died
    if humanoid.Health <= 0 then
        onPlayerKilled(attacker, player)
    end
end

-- Connect to weapon events
local function connectWeaponEvents()
    local WeaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
    
    WeaponEvents.WeaponFired.OnServerEvent:Connect(function(player, data)
        if not player or not data then return end
        
        local character = player.Character
        if not character then return end
        
        -- Simple hit detection
        local origin = data.Origin
        local direction = data.Direction
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = workspace:Raycast(origin, direction * 100, raycastParams)
        if raycastResult then
            local hit = raycastResult.Instance
            local hitCharacter = hit:FindFirstAncestorOfClass("Model")
            
            if hitCharacter and hitCharacter:FindFirstChild("Humanoid") then
                local hitPlayer = Players:GetPlayerFromCharacter(hitCharacter)
                
                if hitPlayer and hitPlayer ~= player and hitPlayer.Team ~= player.Team then
                    -- Apply damage
                    onPlayerDamaged(hitPlayer, player, 25) -- 25 damage per hit, 4 hits to kill
                end
            end
        end
    end)
end

-- Initialize game mode controller
local function initialize()
    print("Initializing GameModeController...")
    
    -- Wait for game events to be ready
    if not waitForGameEvents() then
        warn("Failed to initialize GameModeController due to missing events")
        return
    end
    
    -- Connect weapon events
    connectWeaponEvents()
    
    -- Start the first game
    startGame()
    
    print("GameModeController initialized")
end

initialize() 