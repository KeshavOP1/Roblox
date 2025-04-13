local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local GameManager = {}

-- Game settings
GameManager.Settings = {
    MinPlayers = 2,
    MaxPlayers = 16,
    RoundTime = 600, -- 10 minutes
    IntermissionTime = 30, -- 30 seconds
    ScoreLimit = 50,
    FriendlyFire = false,
    RespawnTime = 5,
    GameModes = {
        "TeamDeathmatch",
        "FreeForAll",
        "CaptureTheFlag"
    }
}

-- Game state
GameManager.State = {
    CurrentMode = "TeamDeathmatch",
    CurrentMap = "Urban",
    GameStatus = "Waiting", -- Waiting, Intermission, InProgress, Ended
    TimeRemaining = 0,
    Teams = {
        TeamA = {
            Score = 0,
            Players = {}
        },
        TeamB = {
            Score = 0,
            Players = {}
        }
    },
    PlayerStats = {} -- Stores individual player stats
}

-- Initialize the game manager
function GameManager.Initialize()
    print("Initializing Game Manager")
    
    -- Create teams if they don't exist
    local teamA = Teams:FindFirstChild("TeamA") or Instance.new("Team")
    teamA.Name = "TeamA"
    teamA.TeamColor = BrickColor.new("Bright blue")
    teamA.AutoAssignable = true
    teamA.Parent = Teams
    
    local teamB = Teams:FindFirstChild("TeamB") or Instance.new("Team")
    teamB.Name = "TeamB"
    teamB.TeamColor = BrickColor.new("Bright red")
    teamB.AutoAssignable = true
    teamB.Parent = Teams
    
    -- Set up player events
    Players.PlayerAdded:Connect(function(player)
        GameManager.OnPlayerJoined(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        GameManager.OnPlayerLeft(player)
    end)
    
    -- Start game loop
    GameManager.StartGameLoop()
end

-- Handle new player joining
function GameManager.OnPlayerJoined(player)
    -- Initialize player stats
    GameManager.State.PlayerStats[player.UserId] = {
        Kills = 0,
        Deaths = 0,
        Score = 0,
        KillStreak = 0
    }
    
    -- Add to team list when team is assigned
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if player.Team then
            local teamName = player.Team.Name
            table.insert(GameManager.State.Teams[teamName].Players, player)
        end
    end)
    
    -- Notify all players
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.PlayerJoined:FireAllClients(player.Name)
    
    -- Check if we can start the game
    GameManager.CheckGameStart()
end

-- Handle player leaving
function GameManager.OnPlayerLeft(player)
    -- Remove from team list
    if player.Team then
        local teamName = player.Team.Name
        local players = GameManager.State.Teams[teamName].Players
        for i, p in ipairs(players) do
            if p == player then
                table.remove(players, i)
                break
            end
        end
    end
    
    -- Clear player stats
    GameManager.State.PlayerStats[player.UserId] = nil
    
    -- Notify all players
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.PlayerLeft:FireAllClients(player.Name)
    
    -- Check if we need to end the game
    GameManager.CheckGameEnd()
end

-- Record a kill
function GameManager.RecordKill(killer, victim, weaponName, isHeadshot)
    if not killer or not victim then return end
    
    -- Update killer stats
    local killerStats = GameManager.State.PlayerStats[killer.UserId]
    if killerStats then
        killerStats.Kills = killerStats.Kills + 1
        killerStats.Score = killerStats.Score + (isHeadshot and 150 or 100)
        killerStats.KillStreak = killerStats.KillStreak + 1
        
        -- Update team score
        if killer.Team then
            GameManager.State.Teams[killer.Team.Name].Score = GameManager.State.Teams[killer.Team.Name].Score + 1
        end
    end
    
    -- Update victim stats
    local victimStats = GameManager.State.PlayerStats[victim.UserId]
    if victimStats then
        victimStats.Deaths = victimStats.Deaths + 1
        victimStats.KillStreak = 0
    end
    
    -- Broadcast kill feed update
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.KillFeed:FireAllClients({
        Killer = killer.Name,
        Victim = victim.Name,
        Weapon = weaponName,
        IsHeadshot = isHeadshot
    })
    
    -- Update score display
    gameEvents.ScoreUpdate:FireAllClients(GameManager.GetScoreboardData())
    
    -- Check if game should end
    GameManager.CheckGameEnd()
end

-- Get current scoreboard data
function GameManager.GetScoreboardData()
    local scoreData = {
        TeamA = {
            Score = GameManager.State.Teams.TeamA.Score,
            Players = {}
        },
        TeamB = {
            Score = GameManager.State.Teams.TeamB.Score,
            Players = {}
        }
    }
    
    -- Compile player stats
    for _, player in ipairs(Players:GetPlayers()) do
        local stats = GameManager.State.PlayerStats[player.UserId]
        if stats and player.Team then
            table.insert(scoreData[player.Team.Name].Players, {
                Name = player.Name,
                Kills = stats.Kills,
                Deaths = stats.Deaths,
                Score = stats.Score,
                KillStreak = stats.KillStreak
            })
        end
    end
    
    return scoreData
end

-- Check if game should start
function GameManager.CheckGameStart()
    if GameManager.State.GameStatus == "Waiting" then
        local playerCount = #Players:GetPlayers()
        if playerCount >= GameManager.Settings.MinPlayers then
            GameManager.StartGame()
        end
    end
end

-- Check if game should end
function GameManager.CheckGameEnd()
    if GameManager.State.GameStatus ~= "InProgress" then return end
    
    local playerCount = #Players:GetPlayers()
    if playerCount < GameManager.Settings.MinPlayers then
        GameManager.EndGame("Not enough players")
        return
    end
    
    -- Check score limit
    for teamName, teamData in pairs(GameManager.State.Teams) do
        if teamData.Score >= GameManager.Settings.ScoreLimit then
            GameManager.EndGame(teamName .. " wins!")
            return
        end
    end
end

-- Start the game
function GameManager.StartGame()
    GameManager.State.GameStatus = "InProgress"
    GameManager.State.TimeRemaining = GameManager.Settings.RoundTime
    
    -- Reset scores
    for _, teamData in pairs(GameManager.State.Teams) do
        teamData.Score = 0
    end
    
    -- Notify clients
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.GameStatus:FireAllClients("MatchStart", {
        Mode = GameManager.State.CurrentMode,
        Map = GameManager.State.CurrentMap,
        Duration = GameManager.Settings.RoundTime
    })
end

-- End the game
function GameManager.EndGame(reason)
    GameManager.State.GameStatus = "Ended"
    
    -- Notify clients
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.GameStatus:FireAllClients("MatchEnd", {
        Winner = reason,
        Scores = GameManager.GetScoreboardData()
    })
    
    -- Start intermission
    wait(3) -- Show end game stats for 3 seconds
    GameManager.StartIntermission()
end

-- Start intermission
function GameManager.StartIntermission()
    GameManager.State.GameStatus = "Intermission"
    GameManager.State.TimeRemaining = GameManager.Settings.IntermissionTime
    
    -- Notify clients
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    gameEvents.GameStatus:FireAllClients("Intermission", {
        Duration = GameManager.Settings.IntermissionTime
    })
    
    -- Wait for intermission to end
    wait(GameManager.Settings.IntermissionTime)
    
    -- Start new game if enough players
    GameManager.CheckGameStart()
end

-- Game loop
function GameManager.StartGameLoop()
    spawn(function()
        while true do
            if GameManager.State.GameStatus == "InProgress" then
                if GameManager.State.TimeRemaining <= 0 then
                    -- Time's up
                    local teamAScore = GameManager.State.Teams.TeamA.Score
                    local teamBScore = GameManager.State.Teams.TeamB.Score
                    
                    if teamAScore > teamBScore then
                        GameManager.EndGame("Team A wins!")
                    elseif teamBScore > teamAScore then
                        GameManager.EndGame("Team B wins!")
                    else
                        GameManager.EndGame("Draw!")
                    end
                else
                    GameManager.State.TimeRemaining = GameManager.State.TimeRemaining - 1
                end
            end
            wait(1)
        end
    end)
end

-- Handle map voting
function GameManager.HandleMapVote(player, votedMap)
    -- This would implement map voting logic
    -- For now, we just use the default map
end

return GameManager 