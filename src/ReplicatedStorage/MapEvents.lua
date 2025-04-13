-- MapEvents.lua
-- ModuleScript that creates all map-related remote events

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapEvents = {}

-- Create the MapEvents folder if it doesn't exist
local mapEventsFolder = ReplicatedStorage:FindFirstChild("MapEvents")
if not mapEventsFolder then
    mapEventsFolder = Instance.new("Folder")
    mapEventsFolder.Name = "MapEvents"
    mapEventsFolder.Parent = ReplicatedStorage
end

-- Create MapVote event
local MapVote = Instance.new("RemoteEvent")
MapVote.Name = "MapVote"
MapVote.Parent = mapEventsFolder
MapEvents.MapVote = MapVote

-- Create MapChange event
local MapChange = Instance.new("RemoteEvent")
MapChange.Name = "MapChange"
MapChange.Parent = mapEventsFolder
MapEvents.MapChange = MapChange

-- Create SpawnPointUpdate event
local SpawnPointUpdate = Instance.new("RemoteEvent")
SpawnPointUpdate.Name = "SpawnPointUpdate"
SpawnPointUpdate.Parent = mapEventsFolder
MapEvents.SpawnPointUpdate = SpawnPointUpdate

-- Create PickupSpawned event
local PickupSpawned = Instance.new("RemoteEvent")
PickupSpawned.Name = "PickupSpawned"
PickupSpawned.Parent = mapEventsFolder
MapEvents.PickupSpawned = PickupSpawned

-- Create PickupCollected event
local PickupCollected = Instance.new("RemoteEvent")
PickupCollected.Name = "PickupCollected"
PickupCollected.Parent = mapEventsFolder
MapEvents.PickupCollected = PickupCollected

print("Map events initialized")

return MapEvents 