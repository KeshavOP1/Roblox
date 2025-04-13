-- MapFunctions.lua
-- ModuleScript that creates all map-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapFunctions = {}

-- Create the MapFunctions folder if it doesn't exist
local mapFunctionsFolder = ReplicatedStorage:FindFirstChild("MapFunctions")
if not mapFunctionsFolder then
    mapFunctionsFolder = Instance.new("Folder")
    mapFunctionsFolder.Name = "MapFunctions"
    mapFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetMapList function
local GetMapList = Instance.new("RemoteFunction")
GetMapList.Name = "GetMapList"
GetMapList.Parent = mapFunctionsFolder
MapFunctions.GetMapList = GetMapList

-- Create GetMapInfo function
local GetMapInfo = Instance.new("RemoteFunction")
GetMapInfo.Name = "GetMapInfo"
GetMapInfo.Parent = mapFunctionsFolder
MapFunctions.GetMapInfo = GetMapInfo

-- Create GetSpawnPoint function
local GetSpawnPoint = Instance.new("RemoteFunction")
GetSpawnPoint.Name = "GetSpawnPoint"
GetSpawnPoint.Parent = mapFunctionsFolder
MapFunctions.GetSpawnPoint = GetSpawnPoint

-- Create GetCurrentMap function
local GetCurrentMap = Instance.new("RemoteFunction")
GetCurrentMap.Name = "GetCurrentMap"
GetCurrentMap.Parent = mapFunctionsFolder
MapFunctions.GetCurrentMap = GetCurrentMap

-- Create GetSpawnPoints function
local GetSpawnPoints = Instance.new("RemoteFunction")
GetSpawnPoints.Name = "GetSpawnPoints"
GetSpawnPoints.Parent = mapFunctionsFolder
MapFunctions.GetSpawnPoints = GetSpawnPoints

-- Create GetMapVotes function
local GetMapVotes = Instance.new("RemoteFunction")
GetMapVotes.Name = "GetMapVotes"
GetMapVotes.Parent = mapFunctionsFolder
MapFunctions.GetMapVotes = GetMapVotes

print("Map functions initialized")

return MapFunctions 