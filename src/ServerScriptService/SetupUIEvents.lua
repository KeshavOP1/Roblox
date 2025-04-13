-- SetupUIEvents.lua
-- Sets up the UI events folder in ReplicatedStorage

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create UIEvents folder if it doesn't exist
local function setupUIEvents()
    print("Setting up UI events...")
    
    local uiEvents = ReplicatedStorage:FindFirstChild("UIEvents")
    if not uiEvents then
        uiEvents = Instance.new("Folder")
        uiEvents.Name = "UIEvents"
        uiEvents.Parent = ReplicatedStorage
        print("Created UIEvents folder")
    end
    
    -- Create GameEvents folder if it doesn't exist
    local gameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
    if not gameEvents then
        gameEvents = Instance.new("Folder")
        gameEvents.Name = "GameEvents"
        gameEvents.Parent = ReplicatedStorage
        print("Created GameEvents folder")
    end
    
    -- Create GameStatus event if it doesn't exist
    local gameStatusEvent = gameEvents:FindFirstChild("GameStatus")
    if not gameStatusEvent then
        gameStatusEvent = Instance.new("RemoteEvent")
        gameStatusEvent.Name = "GameStatus"
        gameStatusEvent.Parent = gameEvents
        print("Created GameStatus event")
    end
    
    -- Create KillFeed event if it doesn't exist
    local killFeedEvent = uiEvents:FindFirstChild("KillFeed")
    if not killFeedEvent then
        killFeedEvent = Instance.new("RemoteEvent")
        killFeedEvent.Name = "KillFeed"
        killFeedEvent.Parent = uiEvents
        print("Created KillFeed event")
    end
    
    -- Create AmmoUpdate event
    local ammoUpdateEvent = Instance.new("RemoteEvent")
    ammoUpdateEvent.Name = "AmmoUpdate"
    ammoUpdateEvent.Parent = uiEvents

    -- Create HealthUpdate event
    local healthUpdateEvent = Instance.new("RemoteEvent")
    healthUpdateEvent.Name = "HealthUpdate"
    healthUpdateEvent.Parent = uiEvents

    -- Create ScoreUpdate event
    local scoreUpdateEvent = Instance.new("RemoteEvent")
    scoreUpdateEvent.Name = "ScoreUpdate"
    scoreUpdateEvent.Parent = uiEvents

    -- Create MapUpdate event
    local mapUpdateEvent = Instance.new("RemoteEvent")
    mapUpdateEvent.Name = "MapUpdate"
    mapUpdateEvent.Parent = uiEvents
    
    print("UI Events setup complete")
end

-- Run setup
setupUIEvents() 