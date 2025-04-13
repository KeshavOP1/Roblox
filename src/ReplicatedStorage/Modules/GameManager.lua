-- GameManager.lua
-- Manages game state, player scores, and game modes

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameManager = {}
GameManager.__index = GameManager

-- Game states
GameManager.GameState = {
    LOBBY = "Lobby",
    MATCH_STARTING = "MatchStarting",
    MATCH_IN_PROGRESS = "MatchInProgress",
    MATCH_ENDING = "MatchEnding",
    ROUND_STARTING = "RoundStarting",
    ROUND_IN_PROGRESS = "RoundInProgress",
    ROUND_ENDING = "RoundEnding"
}

-- Game modes
GameManager.GameModes = {
    TEAM_DEATHMATCH = "TeamDeathmatch",
    FREE_FOR_ALL = "FreeForAll",
    CAPTURE_THE_FLAG = "CaptureTheFlag",
    DOMINATION = "Domination"
}

-- Create a new game manager instance
function GameManager.new()
    local self = setmetatable({}, GameManager)
    
    -- Initialize game state
    self.CurrentState = GameManager.GameState.LOBBY
    self.CurrentGameMode = GameManager.GameModes.TEAM_DEATHMATCH
    self.CurrentMap = nil
    
    -- Player data
    self.PlayerData = {}
    
    -- Team data
    self.TeamData = {
        Red = {
            Score = 0,
            Players = {}
        },
        Blue = {
            Score = 0,
            Players = {}
        }
    }
    
    -- Match settings
    self.MatchSettings = {
        RoundTime = 600, -- 10 minutes
        ScoreLimit = 100,
        TimeLimit = 1800, -- 30 minutes
        FriendlyFire = false
    }
    
    -- Initialize player data for all current players
    for _, player in ipairs(Players:GetPlayers()) do
        self:InitializePlayerData(player)
    end
    
    -- Connect to player events
    Players.PlayerAdded:Connect(function(player)
        self:InitializePlayerData(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayerData(player)
    end)
    
    return self
end

-- Initialize player data
function GameManager:InitializePlayerData(player)
    self.PlayerData[player.UserId] = {
        Kills = 0,
        Deaths = 0,
        Assists = 0,
        Score = 0,
        Team = nil,
        Loadout = {
            Primary = "AK47",
            Secondary = "Glock",
            Melee = "Knife"
        }
    }
    
    -- Assign to a team
    self:AssignPlayerToTeam(player)
    
    -- Notify clients
    self:BroadcastGameStatus()
end

-- Remove player data
function GameManager:RemovePlayerData(player)
    -- Remove from team
    if self.PlayerData[player.UserId] and self.PlayerData[player.UserId].Team then
        local team = self.PlayerData[player.UserId].Team
        for i, playerId in ipairs(self.TeamData[team].Players) do
            if playerId == player.UserId then
                table.remove(self.TeamData[team].Players, i)
                break
            end
        end
    end
    
    -- Remove player data
    self.PlayerData[player.UserId] = nil
    
    -- Notify clients
    self:BroadcastGameStatus()
end

-- Assign player to a team
function GameManager:AssignPlayerToTeam(player)
    -- Simple team balancing
    local redCount = #self.TeamData.Red.Players
    local blueCount = #self.TeamData.Blue.Players
    
    local team
    if redCount <= blueCount then
        team = "Red"
    else
        team = "Blue"
    end
    
    -- Assign team
    self.PlayerData[player.UserId].Team = team
    table.insert(self.TeamData[team].Players, player.UserId)
    
    -- Set player team in Roblox
    if player.Team then
        player.Team = game.Teams[team]
    end
end

-- Start a match
function GameManager:StartMatch(gameMode, mapName)
    self.CurrentState = GameManager.GameState.MATCH_STARTING
    self.CurrentGameMode = gameMode
    self.CurrentMap = mapName
    
    -- Reset scores
    self.TeamData.Red.Score = 0
    self.TeamData.Blue.Score = 0
    
    -- Reset player stats
    for userId, data in pairs(self.PlayerData) do
        data.Kills = 0
        data.Deaths = 0
        data.Assists = 0
        data.Score = 0
    end
    
    -- Notify clients
    self:BroadcastGameStatus()
    
    -- Start match after delay
    delay(5, function()
        self.CurrentState = GameManager.GameState.MATCH_IN_PROGRESS
        self:BroadcastGameStatus()
    end)
end

-- End a match
function GameManager:EndMatch()
    self.CurrentState = GameManager.GameState.MATCH_ENDING
    
    -- Determine winner
    local winner
    if self.TeamData.Red.Score > self.TeamData.Blue.Score then
        winner = "Red"
    elseif self.TeamData.Blue.Score > self.TeamData.Red.Score then
        winner = "Blue"
    else
        winner = "Tie"
    end
    
    -- Notify clients
    self:BroadcastGameStatus({
        Winner = winner,
        RedScore = self.TeamData.Red.Score,
        BlueScore = self.TeamData.Blue.Score
    })
    
    -- Return to lobby after delay
    delay(10, function()
        self.CurrentState = GameManager.GameState.LOBBY
        self:BroadcastGameStatus()
    end)
end

-- Record a kill
function GameManager:RecordKill(killer, victim, weaponName, isHeadshot)
    if not killer or not victim then return end
    
    -- Update killer stats
    if self.PlayerData[killer.UserId] then
        self.PlayerData[killer.UserId].Kills = self.PlayerData[killer.UserId].Kills + 1
        self.PlayerData[killer.UserId].Score = self.PlayerData[killer.UserId].Score + 100
        
        -- Update team score
        if self.PlayerData[killer.UserId].Team then
            self.TeamData[self.PlayerData[killer.UserId].Team].Score = self.TeamData[self.PlayerData[killer.UserId].Team].Score + 100
        end
    end
    
    -- Update victim stats
    if self.PlayerData[victim.UserId] then
        self.PlayerData[victim.UserId].Deaths = self.PlayerData[victim.UserId].Deaths + 1
    end
    
    -- Check win conditions
    self:CheckWinConditions()
    
    -- Notify clients
    self:BroadcastGameStatus()
end

-- Check win conditions
function GameManager:CheckWinConditions()
    if self.CurrentState ~= GameManager.GameState.MATCH_IN_PROGRESS then
        return
    end
    
    -- Check team score limit
    if self.TeamData.Red.Score and self.TeamData.Red.Score >= self.MatchSettings.ScoreLimit then
        self:EndMatch()
        return
    end
    
    if self.TeamData.Blue.Score and self.TeamData.Blue.Score >= self.MatchSettings.ScoreLimit then
        self:EndMatch()
        return
    end
    
    -- Check time limit
    local currentTime = os.time()
    if currentTime and self.MatchStartTime and (currentTime - self.MatchStartTime) >= self.MatchSettings.TimeLimit then
        self:EndMatch()
        return
    end
end

-- Broadcast game status to all clients
function GameManager:BroadcastGameStatus(additionalData)
    local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
    if not gameEvents then return end
    
    local gameStatusEvent = gameEvents:FindFirstChild("GameStatus")
    if not gameStatusEvent then return end
    
    local statusData = {
        State = self.CurrentState,
        GameMode = self.CurrentGameMode,
        Map = self.CurrentMap,
        RedScore = self.TeamData.Red.Score,
        BlueScore = self.TeamData.Blue.Score,
        PlayerData = self.PlayerData
    }
    
    if additionalData then
        for key, value in pairs(additionalData) do
            statusData[key] = value
        end
    end
    
    gameStatusEvent:FireAllClients(statusData)
end

return GameManager 