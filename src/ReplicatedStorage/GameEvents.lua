-- GameEvents.lua
-- Defines the remote events for game status

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a folder for game events if it doesn't exist
local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
if not gameEvents then
    gameEvents = Instance.new("Folder")
    gameEvents.Name = "GameEvents"
    gameEvents.Parent = ReplicatedStorage
end

-- Game status event
local gameStatusChanged = gameEvents:FindFirstChild("GameStatusChanged")
if not gameStatusChanged then
    gameStatusChanged = Instance.new("RemoteEvent")
    gameStatusChanged.Name = "GameStatusChanged"
    gameStatusChanged.Parent = gameEvents
end

-- Kill feed event
local killFeedUpdated = gameEvents:FindFirstChild("KillFeedUpdated")
if not killFeedUpdated then
    killFeedUpdated = Instance.new("RemoteEvent")
    killFeedUpdated.Name = "KillFeedUpdated"
    killFeedUpdated.Parent = gameEvents
end

-- Player damage event
local playerDamaged = gameEvents:FindFirstChild("PlayerDamaged")
if not playerDamaged then
    playerDamaged = Instance.new("RemoteEvent")
    playerDamaged.Name = "PlayerDamaged"
    playerDamaged.Parent = gameEvents
end

-- Game start event
local gameStarted = gameEvents:FindFirstChild("GameStarted")
if not gameStarted then
    gameStarted = Instance.new("RemoteEvent")
    gameStarted.Name = "GameStarted"
    gameStarted.Parent = gameEvents
end

-- Game end event
local gameEnded = gameEvents:FindFirstChild("GameEnded")
if not gameEnded then
    gameEnded = Instance.new("RemoteEvent")
    gameEnded.Name = "GameEnded"
    gameEnded.Parent = gameEvents
end

print("Game events initialized")

return {
    GameStatusChanged = gameStatusChanged,
    KillFeedUpdated = killFeedUpdated,
    PlayerDamaged = playerDamaged,
    GameStarted = gameStarted,
    GameEnded = gameEnded
} 