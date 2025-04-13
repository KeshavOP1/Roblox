-- SetupTeams.lua
-- Sets up teams and handles team selection

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Create teams
local function createTeams()
    -- Remove existing teams
    for _, team in pairs(Teams:GetTeams()) do
        team:Destroy()
    end
    
    -- Create Team A
    local teamA = Instance.new("Team")
    teamA.Name = "Red Team"
    teamA.TeamColor = BrickColor.new("Really red")
    teamA.AutoAssignable = false
    teamA.Parent = game
    
    -- Create Team B
    local teamB = Instance.new("Team")
    teamB.Name = "Blue Team"
    teamB.TeamColor = BrickColor.new("Really blue")
    teamB.AutoAssignable = false
    teamB.Parent = game
    
    print("Teams created")
end

-- Add player to team with fewer players
local function balanceTeams(player)
    local teamA = Teams:FindFirstChild("Red Team")
    local teamB = Teams:FindFirstChild("Blue Team")
    
    if not teamA or not teamB then return end
    
    local teamACount = #teamA:GetPlayers()
    local teamBCount = #teamB:GetPlayers()
    
    if teamACount <= teamBCount then
        player.Team = teamA
        player.TeamColor = teamA.TeamColor
    else
        player.Team = teamB
        player.TeamColor = teamB.TeamColor
    end
    
    print("Assigned " .. player.Name .. " to " .. player.Team.Name)
end

-- Handle player added
local function onPlayerAdded(player)
    -- Wait for player to fully load
    wait(1)
    
    -- Assign player to team
    balanceTeams(player)
    
    -- Create player stats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Value = 0
    kills.Parent = leaderstats
    
    local deaths = Instance.new("IntValue")
    deaths.Name = "Deaths"
    deaths.Value = 0
    deaths.Parent = leaderstats
    
    print("Set up stats for " .. player.Name)
end

-- Initialize teams
local function initialize()
    print("Initializing teams...")
    
    -- Create teams
    createTeams()
    
    -- Connect player added event
    Players.PlayerAdded:Connect(onPlayerAdded)
    
    -- Handle existing players
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
    
    print("Teams initialized")
end

initialize() 