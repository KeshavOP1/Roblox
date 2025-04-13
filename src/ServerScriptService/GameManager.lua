-- GameManager.lua
-- Handles game modes, match logic, and player management

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Teams = game:GetService("Teams")

local GameManager = {}

-- Game mode enum
GameManager.GAME_MODES = {
    TEAM_DEATHMATCH = "TeamDeathmatch",
    FREE_FOR_ALL = "FreeForAll",
    CAPTURE_THE_FLAG = "CaptureTheFlag"
}

-- Maps enum
GameManager.MAPS = {
    "Urban",
    "Desert",
    "SnowBase"
}

-- Game state
GameManager.State = {
    CurrentMode = nil,
    CurrentMap = nil,
    IsMatchActive = false,
    MatchStartTime = 0,
    MatchDuration = 10 * 60, -- 10 minutes default
    PlayersReady = {},
    Teams = {
        Alpha = {},
        Bravo = {}
    },
    Scores = {
        Players = {},
        Teams = {
            Alpha = 0,
            Bravo = 0
        }
    }
}

-- Game settings
GameManager.Settings = {
    MinPlayersToStart = 2,
    MaxPlayers = 16,
    RespawnTime = 5,
    KillScore = 100,
    AssistScore = 50,
    FlagCaptureScore = 300,
    WinScore = 1000,
    TeamBalance = true,
    FriendlyFire = false
}

-- Get remote events
local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local playerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")

-- Function to start a game
local function startGame(mode)
    if GameManager.State.IsMatchActive then
        return false
    end
    
    -- Set game mode
    GameManager.State.CurrentMode = mode
    GameManager.State.IsMatchActive = true
    GameManager.State.MatchStartTime = os.time()
    GameManager.State.MatchDuration = GameManager.Settings.TimeLimit
    GameManager.State.Scores.Teams.Alpha = 0
    GameManager.State.Scores.Teams.Bravo = 0
    GameManager.State.Scores.Players = {}
    
    -- Reset team scores if team mode
    if GameManager.GAME_MODES[mode] == GameManager.GAME_MODES.TEAM_DEATHMATCH then
        GameManager.State.Teams.Alpha = {}
        GameManager.State.Teams.Bravo = {}
    end
    
    -- Assign players to teams
    local players = Players:GetPlayers()
    if GameManager.GAME_MODES[mode] == GameManager.GAME_MODES.TEAM_DEATHMATCH then
        local alphaTeam = GameManager.State.Teams.Alpha
        local bravoTeam = GameManager.State.Teams.Bravo
        
        for i, player in ipairs(players) do
            if i % 2 == 0 then
                table.insert(alphaTeam, player)
                GameManager.State.Scores.Players[player.Name] = {
                    Kills = 0,
                    Deaths = 0,
                    Assists = 0,
                    Score = 0
                }
            else
                table.insert(bravoTeam, player)
                GameManager.State.Scores.Players[player.Name] = {
                    Kills = 0,
                    Deaths = 0,
                    Assists = 0,
                    Score = 0
                }
            end
        end
    else
        for _, player in ipairs(players) do
            GameManager.State.Scores.Players[player.Name] = {
                Kills = 0,
                Deaths = 0,
                Assists = 0,
                Score = 0
            }
        end
    end
    
    -- Notify clients
    gameEvents.GameStatus:FireAllClients("MatchStart", {
        Mode = GameManager.GAME_MODES[mode],
        TimeLimit = GameManager.State.MatchDuration,
        ScoreLimit = GameManager.Settings.WinScore
    })
    
    -- Start game timer
    delay(GameManager.State.MatchDuration, function()
        -- End game if time runs out
        if GameManager.State.IsMatchActive then
            GameManager.CheckWinConditions()
        end
    end)
    
    return true
end

-- Function to end a game
local function endGame()
    if not GameManager.State.IsMatchActive then
        return false
    end
    
    GameManager.State.IsMatchActive = false
    
    -- Determine winner
    local winner = nil
    if GameManager.GAME_MODES[GameManager.State.CurrentMode] == GameManager.GAME_MODES.TEAM_DEATHMATCH then
        local alphaScore = GameManager.State.Scores.Teams.Alpha
        local bravoScore = GameManager.State.Scores.Teams.Bravo
        
        if alphaScore > bravoScore then
            winner = "Alpha"
        elseif bravoScore > alphaScore then
            winner = "Bravo"
        else
            winner = "Draw"
        end
    else
        local highestScore = 0
        local winningPlayer = nil
        
        for playerName, stats in pairs(GameManager.State.Scores.Players) do
            if stats.Score > highestScore then
                highestScore = stats.Score
                winningPlayer = playerName
            end
        end
        
        if winningPlayer then
            winner = winningPlayer
        else
            winner = "Time Expired"
        end
    end
    
    -- Notify clients
    gameEvents.GameStatus:FireAllClients("MatchEnd", {
        Winner = winner,
        Scores = GameManager.State.Scores,
        Teams = GameManager.State.Teams
    })
    
    -- Reset game state after a delay
    delay(5, function()
        GameManager.EnterLobbyState()
    end)
    
    return true
end

-- Function to handle player kills
local function handlePlayerKill(killer, victim)
    if not GameManager.State.IsMatchActive then
        return
    end
    
    -- Update scores
    if killer and GameManager.State.Scores.Players[killer.Name] then
        GameManager.State.Scores.Players[killer.Name].Kills += 1
        GameManager.State.Scores.Players[killer.Name].Score += GameManager.Settings.KillScore
        
        -- Update team score for team-based modes
        if GameManager.GAME_MODES[GameManager.State.CurrentMode] ~= GameManager.GAME_MODES.FREE_FOR_ALL then
            if killer.Team.Name == "Alpha" then
                GameManager.State.Scores.Teams.Alpha += GameManager.Settings.KillScore
            elseif killer.Team.Name == "Bravo" then
                GameManager.State.Scores.Teams.Bravo += GameManager.Settings.KillScore
            end
        end
    end
    
    -- Update victim stats
    if victim and GameManager.State.Scores.Players[victim.Name] then
        GameManager.State.Scores.Players[victim.Name].Deaths += 1
    end
    
    -- Notify clients
    gameEvents.PlayerKilled:FireAllClients({
        Killer = killer and killer.Name or "Unknown",
        Victim = victim and victim.Name or "Unknown",
        Weapon = "AK47", -- This would come from the weapon system
        Headshot = false -- This would come from the weapon system
    })
    
    -- Update scores for all clients
    gameEvents.ScoreUpdate:FireAllClients(GameManager.State.Scores)
    
    -- Update team scores for all clients
    if GameManager.GAME_MODES[GameManager.State.CurrentMode] == GameManager.GAME_MODES.TEAM_DEATHMATCH then
        gameEvents.TeamScoreUpdate:FireAllClients({
            Alpha = GameManager.State.Scores.Teams.Alpha,
            Bravo = GameManager.State.Scores.Teams.Bravo
        })
    end
end

-- Function to handle player joining
local function handlePlayerJoin(player)
    print("Player joined: " .. player.Name)
    
    -- Add player to game state
    GameManager.State.Scores.Players[player.Name] = {
        Kills = 0,
        Deaths = 0,
        Assists = 0,
        Score = 0
    }
    
    -- Auto-assign team if match is not active
    if not GameManager.State.IsMatchActive then
        -- Put player in lobby state
        player.Team = nil
    end
    
    -- Notify clients
    playerEvents.PlayerJoined:FireAllClients({
        Name = player.Name,
        UserId = player.UserId
    })
    
    -- If game is in lobby, check if we can start
    if GameManager.State.IsMatchActive == false then
        local playerCount = #Players:GetPlayers()
        if playerCount >= GameManager.Settings.MinPlayersToStart then
            startGame(GameManager.State.CurrentMode)
        end
    end
    
    -- Set up player character
    player.CharacterAdded:Connect(function(character)
        GameManager.SetupPlayerCharacter(player, character)
    end)
end

-- Function to handle player leaving
local function handlePlayerLeave(player)
    print("Player left: " .. player.Name)
    
    -- Remove from active players list
    GameManager.State.PlayersReady[player.Name] = nil
    
    -- Remove from team if assigned
    if player.Team then
        if player.Team.Name == "Alpha" then
            for i, p in ipairs(GameManager.State.Teams.Alpha) do
                if p == player then
                    table.remove(GameManager.State.Teams.Alpha, i)
                    break
                end
            end
        elseif player.Team.Name == "Bravo" then
            for i, p in ipairs(GameManager.State.Teams.Bravo) do
                if p == player then
                    table.remove(GameManager.State.Teams.Bravo, i)
                    break
                end
            end
        end
    end
    
    -- Clean up player score data
    GameManager.State.Scores.Players[player.Name] = nil
    
    -- Notify clients
    playerEvents.PlayerLeft:FireAllClients({
        Name = player.Name,
        UserId = player.UserId
    })
    
    -- Check if we need to end the match due to not enough players
    GameManager.CheckMatchStatus()
end

-- Connect to player events
Players.PlayerAdded:Connect(handlePlayerJoin)
Players.PlayerRemoving:Connect(handlePlayerLeave)

-- Connect to weapon events
local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
weaponEvents.DamageDealt.OnServerEvent:Connect(function(player, data)
    local victim = data.Victim
    local damage = data.Damage
    
    if victim and victim.Character and victim.Character:FindFirstChild("Humanoid") then
        local humanoid = victim.Character.Humanoid
        humanoid.Health = humanoid.Health - damage
        
        if humanoid.Health <= 0 then
            handlePlayerKill(player, victim)
        end
    end
end)

-- Initialize game
GameManager.State.IsMatchActive = false
GameManager.State.PlayersReady = {}
GameManager.State.Teams.Alpha = {}
GameManager.State.Teams.Bravo = {}
GameManager.State.CurrentMode = GameManager.GAME_MODES.TEAM_DEATHMATCH
GameManager.State.CurrentMap = GameManager.MAPS[1]

-- Start a test game after 5 seconds
delay(5, function()
    startGame(GameManager.GAME_MODES.TEAM_DEATHMATCH)
end)

-- Create team objects
function GameManager.CreateTeams()
    -- Create Alpha team (blue)
    local alphaTeam = Instance.new("Team")
    alphaTeam.Name = "Alpha"
    alphaTeam.TeamColor = BrickColor.new("Bright blue")
    alphaTeam.AutoAssignable = false
    alphaTeam.Parent = Teams
    
    -- Create Bravo team (red)
    local bravoTeam = Instance.new("Team")
    bravoTeam.Name = "Bravo"
    bravoTeam.TeamColor = BrickColor.new("Bright red")
    bravoTeam.AutoAssignable = false
    bravoTeam.Parent = Teams
end

-- Set up events for game communication
function GameManager.SetupEvents()
    -- Create remote events
    local remoteEvents = Instance.new("Folder")
    remoteEvents.Name = "GameEvents"
    remoteEvents.Parent = ReplicatedStorage
    
    -- Player join/leave match events
    local joinMatchEvent = Instance.new("RemoteEvent")
    joinMatchEvent.Name = "JoinMatch"
    joinMatchEvent.Parent = remoteEvents
    
    local leaveMatchEvent = Instance.new("RemoteEvent")
    leaveMatchEvent.Name = "LeaveMatch"
    leaveMatchEvent.Parent = remoteEvents
    
    -- Game status events
    local gameStatusEvent = Instance.new("RemoteEvent")
    gameStatusEvent.Name = "GameStatus"
    gameStatusEvent.Parent = remoteEvents
    
    -- Player/team score events
    local scoreUpdateEvent = Instance.new("RemoteEvent")
    scoreUpdateEvent.Name = "ScoreUpdate"
    scoreUpdateEvent.Parent = remoteEvents
    
    -- Kill feed events
    local killFeedEvent = Instance.new("RemoteEvent")
    killFeedEvent.Name = "KillFeed"
    killFeedEvent.Parent = remoteEvents
    
    -- Map vote events
    local mapVoteEvent = Instance.new("RemoteEvent")
    mapVoteEvent.Name = "MapVote"
    mapVoteEvent.Parent = remoteEvents
    
    -- Game mode events
    local gameModeEvent = Instance.new("RemoteEvent")
    gameModeEvent.Name = "GameMode"
    gameModeEvent.Parent = remoteEvents
    
    -- Connect event handlers
    joinMatchEvent.OnServerEvent:Connect(GameManager.HandlePlayerJoinMatch)
    leaveMatchEvent.OnServerEvent:Connect(GameManager.HandlePlayerLeaveMatch)
    mapVoteEvent.OnServerEvent:Connect(GameManager.HandleMapVote)
    gameModeEvent.OnServerEvent:Connect(GameManager.HandleGameModeChange)
    
    -- Store events for easy access
    GameManager.Events = {
        JoinMatch = joinMatchEvent,
        LeaveMatch = leaveMatchEvent,
        GameStatus = gameStatusEvent,
        ScoreUpdate = scoreUpdateEvent,
        KillFeed = killFeedEvent,
        MapVote = mapVoteEvent,
        GameMode = gameModeEvent
    }
end

-- Connect player join/leave events
function GameManager.ConnectPlayerEvents()
    -- Player joined game
    Players.PlayerAdded:Connect(function(player)
        GameManager.HandlePlayerJoin(player)
    end)
    
    -- Player left game
    Players.PlayerRemoving:Connect(function(player)
        GameManager.HandlePlayerLeave(player)
    end)
end

-- Set up player character for gameplay
function GameManager.SetupPlayerCharacter(player, character)
    -- Add gameplay components
    
    -- Set up health and damage handling
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Handle character death
    humanoid.Died:Connect(function()
        GameManager.HandlePlayerDeath(player)
    end)
    
    -- Add team colors
    if player.Team then
        -- Set team colors on character
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "Head" then
                part.BrickColor = player.Team.TeamColor
            end
        end
    end
    
    -- Spawn with starting weapon
    -- This would be handled by the weapon system
end

-- Handle player death
function GameManager.HandlePlayerDeath(player)
    -- Update death count
    if GameManager.State.Scores.Players[player.Name] then
        GameManager.State.Scores.Players[player.Name].Deaths += 1
    end
    
    -- Schedule respawn
    delay(GameManager.Settings.RespawnTime, function()
        -- Respawn player if still in game and match is active
        if player and player.Parent and GameManager.State.IsMatchActive then
            -- This will fire CharacterAdded which will set up the character again
            player:LoadCharacter()
        end
    end)
    
    -- Broadcast score update
    GameManager.BroadcastScoreUpdate()
end

-- Record a kill
function GameManager.RecordKill(killer, victim, weaponName, isHeadshot)
    print(killer.Name .. " killed " .. victim.Name .. " with " .. weaponName)
    
    -- Update killer stats
    if GameManager.State.Scores.Players[killer.Name] then
        GameManager.State.Scores.Players[killer.Name].Kills += 1
        local killScore = GameManager.Settings.KillScore
        if isHeadshot then
            killScore = killScore * 1.5 -- 50% bonus for headshot
        end
        GameManager.State.Scores.Players[killer.Name].Score += killScore
        
        -- Update team score for team-based modes
        if GameManager.State.CurrentMode ~= GameManager.GAME_MODES.FREE_FOR_ALL then
            if killer.Team.Name == "Alpha" then
                GameManager.State.Scores.Teams.Alpha += killScore
            elseif killer.Team.Name == "Bravo" then
                GameManager.State.Scores.Teams.Bravo += killScore
            end
        end
    end
    
    -- Update victim stats
    if GameManager.State.Scores.Players[victim.Name] then
        GameManager.State.Scores.Players[victim.Name].Deaths += 1
    end
    
    -- Broadcast kill to killfeed
    GameManager.Events.KillFeed:FireAllClients(killer.Name, victim.Name, weaponName, isHeadshot)
    
    -- Broadcast score update
    GameManager.BroadcastScoreUpdate()
    
    -- Check win conditions
    GameManager.CheckWinConditions()
end

-- Record flag capture
function GameManager.RecordFlagCapture(player)
    print(player.Name .. " captured the flag")
    
    -- Update player score
    if GameManager.State.Scores.Players[player.Name] then
        GameManager.State.Scores.Players[player.Name].Score += GameManager.Settings.FlagCaptureScore
        
        -- Update team score
        if player.Team.Name == "Alpha" then
            GameManager.State.Scores.Teams.Alpha += GameManager.Settings.FlagCaptureScore
        elseif player.Team.Name == "Bravo" then
            GameManager.State.Scores.Teams.Bravo += GameManager.Settings.FlagCaptureScore
        end
    end
    
    -- Broadcast score update
    GameManager.BroadcastScoreUpdate()
    
    -- Check win conditions
    GameManager.CheckWinConditions()
end

-- Check if a team has won
function GameManager.CheckWinConditions()
    if not GameManager.State.IsMatchActive then
        return
    end
    
    -- Different win conditions based on game mode
    if GameManager.State.CurrentMode == GameManager.GAME_MODES.TEAM_DEATHMATCH then
        -- Team with highest score wins when time expires or score threshold reached
        if GameManager.State.Scores.Teams.Alpha >= GameManager.Settings.WinScore then
            GameManager.EndMatch("Alpha")
        elseif GameManager.State.Scores.Teams.Bravo >= GameManager.Settings.WinScore then
            GameManager.EndMatch("Bravo")
        end
    elseif GameManager.State.CurrentMode == GameManager.GAME_MODES.FREE_FOR_ALL then
        -- Player with highest score wins when time expires or score threshold reached
        local highestScore = 0
        local highestPlayer = nil
        
        for playerName, stats in pairs(GameManager.State.Scores.Players) do
            if stats.Score >= GameManager.Settings.WinScore and stats.Score > highestScore then
                highestScore = stats.Score
                highestPlayer = playerName
            end
        end
        
        if highestPlayer then
            GameManager.EndMatch(highestPlayer)
        end
    elseif GameManager.State.CurrentMode == GameManager.GAME_MODES.CAPTURE_THE_FLAG then
        -- First team to reach score threshold with flag captures
        if GameManager.State.Scores.Teams.Alpha >= GameManager.Settings.WinScore then
            GameManager.EndMatch("Alpha")
        elseif GameManager.State.Scores.Teams.Bravo >= GameManager.Settings.WinScore then
            GameManager.EndMatch("Bravo")
        end
    end
    
    -- Also check time limit
    local currentTime = os.time()
    if currentTime - GameManager.State.MatchStartTime >= GameManager.State.MatchDuration then
        -- Time expired, determine winner
        if GameManager.State.CurrentMode == GameManager.GAME_MODES.FREE_FOR_ALL then
            -- FFA time expiry - find player with highest score
            local highestScore = 0
            local highestPlayer = nil
            
            for playerName, stats in pairs(GameManager.State.Scores.Players) do
                if stats.Score > highestScore then
                    highestScore = stats.Score
                    highestPlayer = playerName
                end
            end
            
            GameManager.EndMatch(highestPlayer or "Time Expired")
        else
            -- Team-based time expiry
            if GameManager.State.Scores.Teams.Alpha > GameManager.State.Scores.Teams.Bravo then
                GameManager.EndMatch("Alpha")
            elseif GameManager.State.Scores.Teams.Bravo > GameManager.State.Scores.Teams.Alpha then
                GameManager.EndMatch("Bravo")
            else
                GameManager.EndMatch("Draw")
            end
        end
    end
end

-- Check if match can start
function GameManager.CheckMatchStart()
    -- Count number of ready players
    local readyCount = 0
    for _ in pairs(GameManager.State.PlayersReady) do
        readyCount += 1
    end
    
    -- Start match if enough players are ready
    if readyCount >= GameManager.Settings.MinPlayersToStart and not GameManager.State.IsMatchActive then
        GameManager.StartMatch()
    end
end

-- Check ongoing match status
function GameManager.CheckMatchStatus()
    -- If match is active, check if we still have enough players
    if GameManager.State.IsMatchActive then
        local playerCount = 0
        for _ in pairs(GameManager.State.PlayersReady) do
            playerCount += 1
        end
        
        if playerCount < GameManager.Settings.MinPlayersToStart then
            -- Not enough players, end the match
            GameManager.EndMatch("Cancelled")
        end
    end
end

-- Start a match
function GameManager.StartMatch()
    print("Starting match")
    
    -- Set match state
    GameManager.State.IsMatchActive = true
    GameManager.State.MatchStartTime = os.time()
    
    -- Reset scores
    GameManager.ResetScores()
    
    -- Spawn all players
    for playerName in pairs(GameManager.State.PlayersReady) do
        local player = Players:FindFirstChild(playerName)
        if player then
            -- Reset player
            player:LoadCharacter()
        end
    end
    
    -- Broadcast match start
    GameManager.Events.GameStatus:FireAllClients("MatchStart", {
        Mode = GameManager.State.CurrentMode,
        Map = GameManager.State.CurrentMap,
        Duration = GameManager.State.MatchDuration
    })
    
    -- Start match timer
    delay(GameManager.State.MatchDuration, function()
        -- Match time expired
        if GameManager.State.IsMatchActive then
            GameManager.CheckWinConditions()
        end
    end)
    
    print("Match started: " .. GameManager.State.CurrentMode .. " on " .. GameManager.State.CurrentMap)
end

-- End a match with winner
function GameManager.EndMatch(winner)
    if not GameManager.State.IsMatchActive then
        return
    end
    
    print("Ending match, winner: " .. winner)
    
    -- Set match state
    GameManager.State.IsMatchActive = false
    
    -- Broadcast match end
    GameManager.Events.GameStatus:FireAllClients("MatchEnd", {
        Winner = winner,
        Scores = GameManager.State.Scores
    })
    
    -- Return to lobby after a delay
    delay(10, function()
        GameManager.EnterLobbyState()
    end)
end

-- Enter lobby state
function GameManager.EnterLobbyState()
    print("Entering lobby state")
    
    -- Reset state
    GameManager.State.IsMatchActive = false
    GameManager.State.PlayersReady = {}
    GameManager.State.Teams.Alpha = {}
    GameManager.State.Teams.Bravo = {}
    
    -- Reset all player teams
    for _, player in pairs(Players:GetPlayers()) do
        player.Team = nil
    end
    
    -- Reset scores
    GameManager.ResetScores()
    
    -- Start map voting phase
    GameManager.StartMapVoting()
    
    -- Broadcast lobby state
    GameManager.Events.GameStatus:FireAllClients("Lobby", {
        Maps = GameManager.MAPS,
        Modes = GameManager.GAME_MODES
    })
end

-- Start map voting phase
function GameManager.StartMapVoting()
    print("Starting map voting phase")
    
    -- This would implement a voting system
    -- For this example, we'll just select a random map
    GameManager.State.CurrentMap = GameManager.MAPS[math.random(1, #GameManager.MAPS)]
end

-- Handle map vote
function GameManager.HandleMapVote(player, mapName)
    print("Player " .. player.Name .. " voted for map: " .. mapName)
    
    -- In a real implementation, this would count the vote
    -- For this example, we'll just acknowledge it
end

-- Handle game mode change
function GameManager.HandleGameModeChange(player, modeName)
    print("Player " .. player.Name .. " requested game mode: " .. modeName)
    
    -- Check if player has permission to change mode
    -- For this example, we'll allow any player to change it
    if GameManager.GAME_MODES[modeName] then
        GameManager.State.CurrentMode = GameManager.GAME_MODES[modeName]
        
        -- Broadcast mode change
        GameManager.Events.GameMode:FireAllClients(modeName)
    end
end

-- Reset all scores
function GameManager.ResetScores()
    -- Reset team scores
    GameManager.State.Scores.Teams.Alpha = 0
    GameManager.State.Scores.Teams.Bravo = 0
    
    -- Reset player scores
    for playerName, _ in pairs(GameManager.State.Scores.Players) do
        GameManager.State.Scores.Players[playerName] = {
            Kills = 0,
            Deaths = 0,
            Assists = 0,
            Score = 0
        }
    end
    
    -- Broadcast score reset
    GameManager.BroadcastScoreUpdate()
end

-- Send current game state to a player
function GameManager.SendGameStateToPlayer(player)
    if GameManager.State.IsMatchActive then
        -- Send match state
        GameManager.Events.GameStatus:FireClient(player, "MatchInProgress", {
            Mode = GameManager.State.CurrentMode,
            Map = GameManager.State.CurrentMap,
            ElapsedTime = os.time() - GameManager.State.MatchStartTime,
            Duration = GameManager.State.MatchDuration
        })
    else
        -- Send lobby state
        GameManager.Events.GameStatus:FireClient(player, "Lobby", {
            Maps = GameManager.MAPS,
            Modes = GameManager.GAME_MODES
        })
    end
    
    -- Send current scores
    GameManager.Events.ScoreUpdate:FireClient(player, GameManager.State.Scores)
end

-- Broadcast game state to all players
function GameManager.BroadcastGameState()
    for _, player in pairs(Players:GetPlayers()) do
        GameManager.SendGameStateToPlayer(player)
    end
end

-- Broadcast score update to all players
function GameManager.BroadcastScoreUpdate()
    GameManager.Events.ScoreUpdate:FireAllClients(GameManager.State.Scores)
end

return GameManager 