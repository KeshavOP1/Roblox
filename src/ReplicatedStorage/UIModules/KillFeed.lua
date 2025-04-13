-- KillFeed.lua
-- Displays recent kills and other game events

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local KillFeed = {}
KillFeed.__index = KillFeed

-- Maximum entries in kill feed
KillFeed.MAX_ENTRIES = 5

-- Entry lifetime in seconds
KillFeed.ENTRY_LIFETIME = 5

-- UI Components
KillFeed.UI = {
    Frame = nil,
    Entries = {}
}

-- Initialize the kill feed UI
function KillFeed.Initialize(parent)
    local self = setmetatable({}, KillFeed)
    
    -- Create main frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "KillFeed"
    self.Frame.Size = UDim2.new(0, 300, 0, 200)
    self.Frame.Position = UDim2.new(1, -320, 0, 20)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Parent = parent
    
    -- Create list layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    listLayout.Parent = self.Frame
    
    -- Connect to kill feed events
    self:ConnectEvents()
    
    return self
end

function KillFeed:ConnectEvents()
    spawn(function()
        print("KillFeed: Setting up UI events...")
        
        -- Create UIEvents folder if it doesn't exist
        local uiEvents = ReplicatedStorage:FindFirstChild("UIEvents")
        if not uiEvents then
            uiEvents = Instance.new("Folder")
            uiEvents.Name = "UIEvents"
            uiEvents.Parent = ReplicatedStorage
            print("KillFeed: Created UIEvents folder")
        end
        
        -- Create KillFeed event if it doesn't exist
        local killFeedEvent = uiEvents:FindFirstChild("KillFeed")
        if not killFeedEvent then
            killFeedEvent = Instance.new("RemoteEvent")
            killFeedEvent.Name = "KillFeed"
            killFeedEvent.Parent = uiEvents
            print("KillFeed: Created KillFeed event")
        end
        
        print("KillFeed: Successfully connected to events")
        
        -- Connect to kill feed event
        killFeedEvent.OnClientEvent:Connect(function(killer, victim, weapon)
            self:AddKillEntry(killer, victim, weapon)
        end)
    end)
end

-- Add a kill entry to the feed
function KillFeed:AddKillEntry(killer, victim, weapon)
    if not self.Frame then return end
    
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, 0, 0, 24)
    entry.BackgroundTransparency = 0.5
    entry.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    entry.TextColor3 = Color3.fromRGB(255, 255, 255)
    entry.Text = string.format("%s killed %s with %s", killer, victim, weapon)
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.TextSize = 14
    entry.Parent = self.Frame
    
    -- Fade out and remove after 5 seconds
    spawn(function()
        wait(4)
        for i = 1, 10 do
            entry.TextTransparency = i/10
            entry.BackgroundTransparency = 0.5 + (i/10)/2
            wait(0.1)
        end
        entry:Destroy()
    end)
end

-- Add a system message to the kill feed
function KillFeed:AddSystemMessage(message)
    if not self.Frame then return end
    
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, 0, 0, 24)
    entry.BackgroundTransparency = 0.5
    entry.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
    entry.TextColor3 = Color3.fromRGB(255, 255, 255)
    entry.Text = message
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.TextSize = 14
    entry.Parent = self.Frame
    
    -- Fade out and remove after 5 seconds
    spawn(function()
        wait(4)
        for i = 1, 10 do
            entry.TextTransparency = i/10
            entry.BackgroundTransparency = 0.5 + (i/10)/2
            wait(0.1)
        end
        entry:Destroy()
    end)
end

-- Clear all entries
function KillFeed:Clear()
    for _, entry in ipairs(KillFeed.UI.Entries) do
        entry:Destroy()
    end
    
    KillFeed.UI.Entries = {}
end

-- Clean up resources
function KillFeed:Destroy()
    self:Clear()
    
    if self.Frame then
        self.Frame:Destroy()
    end
end

return KillFeed 