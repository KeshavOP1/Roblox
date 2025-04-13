-- PlayerFunctions.lua
-- ModuleScript that creates all player-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerFunctions = {}

-- Create the PlayerFunctions folder if it doesn't exist
local playerFunctionsFolder = ReplicatedStorage:FindFirstChild("PlayerFunctions")
if not playerFunctionsFolder then
    playerFunctionsFolder = Instance.new("Folder")
    playerFunctionsFolder.Name = "PlayerFunctions"
    playerFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetPlayerStats function
local GetPlayerStats = Instance.new("RemoteFunction")
GetPlayerStats.Name = "GetPlayerStats"
GetPlayerStats.Parent = playerFunctionsFolder
PlayerFunctions.GetPlayerStats = GetPlayerStats

-- Create GetPlayerLoadout function
local GetPlayerLoadout = Instance.new("RemoteFunction")
GetPlayerLoadout.Name = "GetPlayerLoadout"
GetPlayerLoadout.Parent = playerFunctionsFolder
PlayerFunctions.GetPlayerLoadout = GetPlayerLoadout

-- Create GetTeamPlayers function
local GetTeamPlayers = Instance.new("RemoteFunction")
GetTeamPlayers.Name = "GetTeamPlayers"
GetTeamPlayers.Parent = playerFunctionsFolder
PlayerFunctions.GetTeamPlayers = GetTeamPlayers

-- Create GetPlayerKillstreak function
local GetPlayerKillstreak = Instance.new("RemoteFunction")
GetPlayerKillstreak.Name = "GetPlayerKillstreak"
GetPlayerKillstreak.Parent = playerFunctionsFolder
PlayerFunctions.GetPlayerKillstreak = GetPlayerKillstreak

-- Create GetPlayerHealth function
local GetPlayerHealth = Instance.new("RemoteFunction")
GetPlayerHealth.Name = "GetPlayerHealth"
GetPlayerHealth.Parent = playerFunctionsFolder
PlayerFunctions.GetPlayerHealth = GetPlayerHealth

print("Player functions initialized")

return PlayerFunctions 