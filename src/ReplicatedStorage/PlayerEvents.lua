-- PlayerEvents.lua
-- ModuleScript that creates all player-related remote events

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerEvents = {}

-- Create the PlayerEvents folder if it doesn't exist
local playerEventsFolder = ReplicatedStorage:FindFirstChild("PlayerEvents")
if not playerEventsFolder then
    playerEventsFolder = Instance.new("Folder")
    playerEventsFolder.Name = "PlayerEvents"
    playerEventsFolder.Parent = ReplicatedStorage
end

-- Create PlayerDamage event
local PlayerDamage = Instance.new("RemoteEvent")
PlayerDamage.Name = "PlayerDamage"
PlayerDamage.Parent = playerEventsFolder
PlayerEvents.PlayerDamage = PlayerDamage

-- Create PlayerJoined event
local PlayerJoined = Instance.new("RemoteEvent")
PlayerJoined.Name = "PlayerJoined"
PlayerJoined.Parent = playerEventsFolder
PlayerEvents.PlayerJoined = PlayerJoined

-- Create PlayerLeft event
local PlayerLeft = Instance.new("RemoteEvent")
PlayerLeft.Name = "PlayerLeft"
PlayerLeft.Parent = playerEventsFolder
PlayerEvents.PlayerLeft = PlayerLeft

-- Create PlayerDied event
local PlayerDied = Instance.new("RemoteEvent")
PlayerDied.Name = "PlayerDied"
PlayerDied.Parent = playerEventsFolder
PlayerEvents.PlayerDied = PlayerDied

-- Create PlayerSpawned event
local PlayerSpawned = Instance.new("RemoteEvent")
PlayerSpawned.Name = "PlayerSpawned"
PlayerSpawned.Parent = playerEventsFolder
PlayerEvents.PlayerSpawned = PlayerSpawned

-- Create HealthUpdate event
local HealthUpdate = Instance.new("RemoteEvent")
HealthUpdate.Name = "HealthUpdate"
HealthUpdate.Parent = playerEventsFolder
PlayerEvents.HealthUpdate = HealthUpdate

-- Create KillstreakUpdate event
local KillstreakUpdate = Instance.new("RemoteEvent")
KillstreakUpdate.Name = "KillstreakUpdate"
KillstreakUpdate.Parent = playerEventsFolder
PlayerEvents.KillstreakUpdate = KillstreakUpdate

print("Player events initialized")

return PlayerEvents 
PlayerJoined.Parent = playerEventsFolder
PlayerEvents.PlayerJoined = PlayerJoined

-- Create PlayerLeft event
local PlayerLeft = Instance.new("RemoteEvent")
PlayerLeft.Name = "PlayerLeft"
PlayerLeft.Parent = playerEventsFolder
PlayerEvents.PlayerLeft = PlayerLeft

-- Create PlayerDied event
local PlayerDied = Instance.new("RemoteEvent")
PlayerDied.Name = "PlayerDied"
PlayerDied.Parent = playerEventsFolder
PlayerEvents.PlayerDied = PlayerDied

-- Create PlayerSpawned event
local PlayerSpawned = Instance.new("RemoteEvent")
PlayerSpawned.Name = "PlayerSpawned"
PlayerSpawned.Parent = playerEventsFolder
PlayerEvents.PlayerSpawned = PlayerSpawned

-- Create HealthUpdate event
local HealthUpdate = Instance.new("RemoteEvent")
HealthUpdate.Name = "HealthUpdate"
HealthUpdate.Parent = playerEventsFolder
PlayerEvents.HealthUpdate = HealthUpdate

-- Create KillstreakUpdate event
local KillstreakUpdate = Instance.new("RemoteEvent")
KillstreakUpdate.Name = "KillstreakUpdate"
KillstreakUpdate.Parent = playerEventsFolder
PlayerEvents.KillstreakUpdate = KillstreakUpdate

print("Player events initialized")

return PlayerEvents 
PlayerJoined.Parent = playerEventsFolder
PlayerEvents.PlayerJoined = PlayerJoined

-- Create PlayerLeft event
local PlayerLeft = Instance.new("RemoteEvent")
PlayerLeft.Name = "PlayerLeft"
PlayerLeft.Parent = playerEventsFolder
PlayerEvents.PlayerLeft = PlayerLeft

-- Create PlayerDied event
local PlayerDied = Instance.new("RemoteEvent")
PlayerDied.Name = "PlayerDied"
PlayerDied.Parent = playerEventsFolder
PlayerEvents.PlayerDied = PlayerDied

-- Create PlayerSpawned event
local PlayerSpawned = Instance.new("RemoteEvent")
PlayerSpawned.Name = "PlayerSpawned"
PlayerSpawned.Parent = playerEventsFolder
PlayerEvents.PlayerSpawned = PlayerSpawned

-- Create HealthUpdate event
local HealthUpdate = Instance.new("RemoteEvent")
HealthUpdate.Name = "HealthUpdate"
HealthUpdate.Parent = playerEventsFolder
PlayerEvents.HealthUpdate = HealthUpdate

-- Create KillstreakUpdate event
local KillstreakUpdate = Instance.new("RemoteEvent")
KillstreakUpdate.Name = "KillstreakUpdate"
KillstreakUpdate.Parent = playerEventsFolder
PlayerEvents.KillstreakUpdate = KillstreakUpdate

print("Player events initialized")

return PlayerEvents 