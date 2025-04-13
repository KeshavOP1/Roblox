-- GameFunctions.lua
-- ModuleScript that creates all game-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameFunctions = {}

-- Create the GameFunctions folder if it doesn't exist
local gameFunctionsFolder = ReplicatedStorage:FindFirstChild("GameFunctions")
if not gameFunctionsFolder then
    gameFunctionsFolder = Instance.new("Folder")
    gameFunctionsFolder.Name = "GameFunctions"
    gameFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetGameState function
local GetGameState = Instance.new("RemoteFunction")
GetGameState.Name = "GetGameState"
GetGameState.Parent = gameFunctionsFolder
GameFunctions.GetGameState = GetGameState

-- Create GetMatchInfo function
local GetMatchInfo = Instance.new("RemoteFunction")
GetMatchInfo.Name = "GetMatchInfo"
GetMatchInfo.Parent = gameFunctionsFolder
GameFunctions.GetMatchInfo = GetMatchInfo

-- Create GetTeamInfo function
local GetTeamInfo = Instance.new("RemoteFunction")
GetTeamInfo.Name = "GetTeamInfo"
GetTeamInfo.Parent = gameFunctionsFolder
GameFunctions.GetTeamInfo = GetTeamInfo

print("Game functions initialized")

return GameFunctions 
 
-- ModuleScript that creates all game-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameFunctions = {}

-- Create the GameFunctions folder if it doesn't exist
local gameFunctionsFolder = ReplicatedStorage:FindFirstChild("GameFunctions")
if not gameFunctionsFolder then
    gameFunctionsFolder = Instance.new("Folder")
    gameFunctionsFolder.Name = "GameFunctions"
    gameFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetGameState function
local GetGameState = Instance.new("RemoteFunction")
GetGameState.Name = "GetGameState"
GetGameState.Parent = gameFunctionsFolder
GameFunctions.GetGameState = GetGameState

-- Create GetMatchInfo function
local GetMatchInfo = Instance.new("RemoteFunction")
GetMatchInfo.Name = "GetMatchInfo"
GetMatchInfo.Parent = gameFunctionsFolder
GameFunctions.GetMatchInfo = GetMatchInfo

-- Create GetTeamInfo function
local GetTeamInfo = Instance.new("RemoteFunction")
GetTeamInfo.Name = "GetTeamInfo"
GetTeamInfo.Parent = gameFunctionsFolder
GameFunctions.GetTeamInfo = GetTeamInfo

print("Game functions initialized")

return GameFunctions 