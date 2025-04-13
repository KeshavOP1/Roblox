-- KillFeed.lua
-- Displays kills in the game

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local KillFeed = {}
local ui = {}
local killEntries = {}

-- Max number of kill entries to show
local MAX_KILL_ENTRIES = 5
-- How long to display each kill (in seconds)
local KILL_DISPLAY_TIME = 5

-- Wait for game events
local function waitForGameEvents()
    local gameEventsFolder = ReplicatedStorage:WaitForChild("GameEvents", 10)
    if not gameEventsFolder then
        warn("GameEvents folder not found")
        return false
    end
    
    -- Connect to KillFeedUpdated event
    local killFeedEvent = gameEventsFolder:WaitForChild("KillFeedUpdated", 5)
    if killFeedEvent then
        killFeedEvent.OnClientEvent:Connect(function(data)
            KillFeed.AddKill(data)
        end)
        return true
    else
        warn("KillFeedUpdated event not found")
        return false
    end
end

-- Initialize the kill feed
function KillFeed.Initialize()
    print("Initializing KillFeed...")
    
    -- Create the UI if it doesn't exist
    if not ui.Frame then
        -- Find or create HUD
        local hud = playerGui:FindFirstChild("HUD")
        if not hud then
            hud = Instance.new("ScreenGui")
            hud.Name = "HUD"
            hud.ResetOnSpawn = false
            hud.Parent = playerGui
        end
        
        -- Create the main frame
        ui.Frame = Instance.new("Frame")
        ui.Frame.Name = "KillFeed"
        ui.Frame.Size = UDim2.new(0.3, 0, 0.3, 0)
        ui.Frame.Position = UDim2.new(0.7, -10, 0, 10)
        ui.Frame.BackgroundTransparency = 1
        ui.Frame.BorderSizePixel = 0
        ui.Frame.Parent = hud
        
        -- Create a layout for kill entries
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = ui.Frame
    end
    
    -- Connect to game events
    waitForGameEvents()
    
    print("KillFeed initialized")
end

-- Create a kill entry
local function createKillEntry(data)
    local entry = Instance.new("Frame")
    entry.Name = "KillEntry"
    entry.Size = UDim2.new(1, 0, 0, 30)
    entry.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    entry.BackgroundTransparency = 0.5
    entry.BorderSizePixel = 0
    
    local killerName = Instance.new("TextLabel")
    killerName.Name = "KillerName"
    killerName.Size = UDim2.new(0.4, 0, 1, 0)
    killerName.Position = UDim2.new(0, 5, 0, 0)
    killerName.Text = data.KillerName
    killerName.TextColor3 = data.KillerTeam == "Red Team" and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 255)
    killerName.TextXAlignment = Enum.TextXAlignment.Left
    killerName.BackgroundTransparency = 1
    killerName.Font = Enum.Font.SourceSansBold
    killerName.TextSize = 16
    killerName.Parent = entry
    
    local weaponIcon = Instance.new("ImageLabel")
    weaponIcon.Name = "WeaponIcon"
    weaponIcon.Size = UDim2.new(0.2, 0, 0.8, 0)
    weaponIcon.Position = UDim2.new(0.4, 0, 0.1, 0)
    weaponIcon.BackgroundTransparency = 1
    weaponIcon.Image = "rbxassetid://6404951071" -- Default weapon icon
    weaponIcon.Parent = entry
    
    local victimName = Instance.new("TextLabel")
    victimName.Name = "VictimName"
    victimName.Size = UDim2.new(0.4, 0, 1, 0)
    victimName.Position = UDim2.new(0.6, 0, 0, 0)
    victimName.Text = data.VictimName
    victimName.TextColor3 = data.VictimTeam == "Red Team" and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 100, 255)
    victimName.TextXAlignment = Enum.TextXAlignment.Right
    victimName.BackgroundTransparency = 1
    victimName.Font = Enum.Font.SourceSansBold
    victimName.TextSize = 16
    victimName.Parent = entry
    
    return entry
end

-- Add a kill to the feed
function KillFeed.AddKill(data)
    if not ui.Frame then return end
    
    -- Create a new kill entry
    local entry = createKillEntry(data)
    entry.LayoutOrder = #killEntries + 1
    entry.Parent = ui.Frame
    
    -- Add to our entries list
    table.insert(killEntries, {
        UI = entry,
        Time = tick()
    })
    
    -- Remove old entries if we have too many
    while #killEntries > MAX_KILL_ENTRIES do
        local oldestEntry = table.remove(killEntries, 1)
        if oldestEntry and oldestEntry.UI then
            oldestEntry.UI:Destroy()
        end
    end
    
    -- Schedule removal after display time
    task.delay(KILL_DISPLAY_TIME, function()
        for i, entryData in ipairs(killEntries) do
            if entryData.UI == entry then
                table.remove(killEntries, i)
                entry:Destroy()
                break
            end
        end
    end)
end

-- Show the kill feed
function KillFeed.Show()
    if ui.Frame then
        ui.Frame.Visible = true
    end
end

-- Hide the kill feed
function KillFeed.Hide()
    if ui.Frame then
        ui.Frame.Visible = false
    end
end

-- Clean up resources when needed
function KillFeed.Cleanup()
    if ui.Frame then
        ui.Frame:Destroy()
        ui = {}
    end
    
    killEntries = {}
end

return KillFeed 