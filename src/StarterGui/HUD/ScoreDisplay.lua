-- ScoreDisplay.lua
-- Displays team scores and game time

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScoreDisplay = {}
local ui = {}

-- Wait for game events
local function waitForGameEvents()
    local gameEventsFolder = ReplicatedStorage:WaitForChild("GameEvents", 10)
    if not gameEventsFolder then
        warn("GameEvents folder not found")
        return false
    end
    
    -- Connect to GameStatusChanged event
    local statusEvent = gameEventsFolder:WaitForChild("GameStatusChanged", 5)
    if statusEvent then
        statusEvent.OnClientEvent:Connect(function(data)
            ScoreDisplay.UpdateGameStatus(data)
        end)
        return true
    else
        warn("GameStatusChanged event not found")
        return false
    end
end

-- Format time as MM:SS
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-- Initialize the score display
function ScoreDisplay.Initialize()
    print("Initializing ScoreDisplay...")
    
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
        ui.Frame.Name = "ScoreDisplay"
        ui.Frame.Size = UDim2.new(0.5, 0, 0.1, 0)
        ui.Frame.Position = UDim2.new(0.25, 0, 0, 10)
        ui.Frame.BackgroundTransparency = 0.7
        ui.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ui.Frame.BorderSizePixel = 0
        ui.Frame.Parent = hud
        
        -- Create team score frames
        ui.RedTeam = Instance.new("Frame")
        ui.RedTeam.Name = "RedTeam"
        ui.RedTeam.Size = UDim2.new(0.45, 0, 1, 0)
        ui.RedTeam.Position = UDim2.new(0, 0, 0, 0)
        ui.RedTeam.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        ui.RedTeam.BackgroundTransparency = 0.3
        ui.RedTeam.BorderSizePixel = 0
        ui.RedTeam.Parent = ui.Frame
        
        ui.BlueTeam = Instance.new("Frame")
        ui.BlueTeam.Name = "BlueTeam"
        ui.BlueTeam.Size = UDim2.new(0.45, 0, 1, 0)
        ui.BlueTeam.Position = UDim2.new(0.55, 0, 0, 0)
        ui.BlueTeam.BackgroundColor3 = Color3.fromRGB(0, 0, 170)
        ui.BlueTeam.BackgroundTransparency = 0.3
        ui.BlueTeam.BorderSizePixel = 0
        ui.BlueTeam.Parent = ui.Frame
        
        -- Create team score texts
        ui.RedScore = Instance.new("TextLabel")
        ui.RedScore.Name = "RedScore"
        ui.RedScore.Size = UDim2.new(1, 0, 1, 0)
        ui.RedScore.Text = "0"
        ui.RedScore.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.RedScore.BackgroundTransparency = 1
        ui.RedScore.Font = Enum.Font.SourceSansBold
        ui.RedScore.TextSize = 36
        ui.RedScore.Parent = ui.RedTeam
        
        ui.BlueScore = Instance.new("TextLabel")
        ui.BlueScore.Name = "BlueScore"
        ui.BlueScore.Size = UDim2.new(1, 0, 1, 0)
        ui.BlueScore.Text = "0"
        ui.BlueScore.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.BlueScore.BackgroundTransparency = 1
        ui.BlueScore.Font = Enum.Font.SourceSansBold
        ui.BlueScore.TextSize = 36
        ui.BlueScore.Parent = ui.BlueTeam
        
        -- Create timer
        ui.Timer = Instance.new("TextLabel")
        ui.Timer.Name = "Timer"
        ui.Timer.Size = UDim2.new(0.1, 0, 1, 0)
        ui.Timer.Position = UDim2.new(0.45, 0, 0, 0)
        ui.Timer.Text = "5:00"
        ui.Timer.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.Timer.BackgroundTransparency = 0.3
        ui.Timer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ui.Timer.Font = Enum.Font.SourceSansBold
        ui.Timer.TextSize = 28
        ui.Timer.Parent = ui.Frame
        
        -- Create mode label
        ui.ModeLabel = Instance.new("TextLabel")
        ui.ModeLabel.Name = "ModeLabel"
        ui.ModeLabel.Size = UDim2.new(0.5, 0, 0.3, 0)
        ui.ModeLabel.Position = UDim2.new(0.25, 0, -0.4, 0)
        ui.ModeLabel.Text = "TEAM DEATHMATCH"
        ui.ModeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.ModeLabel.BackgroundTransparency = 0.3
        ui.ModeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ui.ModeLabel.Font = Enum.Font.SourceSansBold
        ui.ModeLabel.TextSize = 18
        ui.ModeLabel.Parent = ui.Frame
    end
    
    -- Connect to game events
    waitForGameEvents()
    
    print("ScoreDisplay initialized")
end

-- Update the team scores
function ScoreDisplay.UpdateScores(redScore, blueScore)
    if ui.RedScore and ui.BlueScore then
        ui.RedScore.Text = tostring(redScore)
        ui.BlueScore.Text = tostring(blueScore)
    end
end

-- Update the timer
function ScoreDisplay.UpdateTimer(timeRemaining)
    if ui.Timer then
        ui.Timer.Text = formatTime(timeRemaining)
        
        -- Change color if time is running out
        if timeRemaining <= 10 then
            ui.Timer.TextColor3 = Color3.fromRGB(255, 50, 50) -- Red when low
        else
            ui.Timer.TextColor3 = Color3.fromRGB(255, 255, 255) -- White normally
        end
    end
end

-- Update game status
function ScoreDisplay.UpdateGameStatus(data)
    if not ui.Frame then return end
    
    if data.Status == "InProgress" or data.Status == "ScoreUpdate" then
        -- Update scores and timer
        ScoreDisplay.UpdateScores(data.RedScore, data.BlueScore)
        ScoreDisplay.UpdateTimer(data.TimeRemaining)
        
        -- Show the score display
        ScoreDisplay.Show()
        
    elseif data.Status == "GameOver" then
        -- Update scores
        ScoreDisplay.UpdateScores(data.RedScore, data.BlueScore)
        
        -- Show game over message
        local gameOverText = "GAME OVER"
        if data.IsTie then
            gameOverText = gameOverText .. " - TIE"
        else
            gameOverText = gameOverText .. " - " .. (data.WinningTeam or "")
        end
        
        if ui.ModeLabel then
            ui.ModeLabel.Text = gameOverText
            ui.ModeLabel.TextColor3 = Color3.fromRGB(255, 220, 50) -- Yellow for game over
        end
    end
end

-- Show the score display
function ScoreDisplay.Show()
    if ui.Frame then
        ui.Frame.Visible = true
    end
end

-- Hide the score display
function ScoreDisplay.Hide()
    if ui.Frame then
        ui.Frame.Visible = false
    end
end

-- Clean up resources when needed
function ScoreDisplay.Cleanup()
    if ui.Frame then
        ui.Frame:Destroy()
        ui = {}
    end
end

return ScoreDisplay 