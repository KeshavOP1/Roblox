-- ScoreDisplay.lua
-- Displays the current score for team-based game modes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local ScoreDisplay = {}
ScoreDisplay.__index = ScoreDisplay

-- UI Components
ScoreDisplay.UI = {
    Frame = nil,
    AlphaScore = nil,
    BravoScore = nil,
    TimerLabel = nil,
    ModeLabel = nil
}

-- Initialize the score display UI
function ScoreDisplay.Initialize(parent)
    local self = setmetatable({}, ScoreDisplay)
    
    -- Create main frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "ScoreDisplay"
    self.Frame.Size = UDim2.new(0, 200, 0, 60)
    self.Frame.Position = UDim2.new(0.5, -100, 0, 20)
    self.Frame.BackgroundTransparency = 0.5
    self.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.Frame.Parent = parent
    
    -- Create team scores
    self.TeamScores = {
        Blue = self:CreateTeamScore("Blue Team", Color3.fromRGB(0, 100, 255), UDim2.new(0, 0, 0, 0)),
        Red = self:CreateTeamScore("Red Team", Color3.fromRGB(255, 50, 50), UDim2.new(0.5, 0, 0, 0))
    }
    
    -- Connect to score update events
    self:ConnectEvents()
    
    return self
end

function ScoreDisplay:CreateTeamScore(teamName, teamColor, position)
    local teamFrame = Instance.new("Frame")
    teamFrame.Name = teamName
    teamFrame.Size = UDim2.new(0.5, -5, 1, 0)
    teamFrame.Position = position
    teamFrame.BackgroundTransparency = 1
    teamFrame.Parent = self.Frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "TeamName"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = teamColor
    nameLabel.Text = teamName
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = teamFrame
    
    local scoreLabel = Instance.new("TextLabel")
    scoreLabel.Name = "Score"
    scoreLabel.Size = UDim2.new(1, 0, 0.5, 0)
    scoreLabel.Position = UDim2.new(0, 0, 0.5, 0)
    scoreLabel.BackgroundTransparency = 1
    scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    scoreLabel.Text = "0"
    scoreLabel.TextSize = 24
    scoreLabel.Font = Enum.Font.GothamBold
    scoreLabel.Parent = teamFrame
    
    return {
        Frame = teamFrame,
        NameLabel = nameLabel,
        ScoreLabel = scoreLabel,
        Score = 0
    }
end

function ScoreDisplay:ConnectEvents()
    -- Wait for UI events folder
    local uiEvents = ReplicatedStorage:WaitForChild("UIEvents")
    local scoreUpdateEvent = uiEvents:WaitForChild("ScoreUpdate")
    
    -- Connect to score update event
    scoreUpdateEvent.OnClientEvent:Connect(function(team, score)
        self:UpdateScore(team, score)
    end)
end

function ScoreDisplay:UpdateScore(team, score)
    local teamScore = self.TeamScores[team]
    if teamScore then
        teamScore.Score = score
        teamScore.ScoreLabel.Text = tostring(score)
        
        -- Animate score change
        self:AnimateScoreChange(teamScore.ScoreLabel)
    end
end

function ScoreDisplay:AnimateScoreChange(label)
    -- Scale up
    label.TextSize = 28
    
    -- Scale back down
    spawn(function()
        wait(0.1)
        label.TextSize = 24
    end)
end

-- Update game status info
function ScoreDisplay.UpdateGameStatus(status, data)
    if not ScoreDisplay.UI.ModeLabel then return end
    
    if status == "MatchStart" or status == "MatchInProgress" then
        -- Update game mode display
        ScoreDisplay.UI.ModeLabel.Text = string.upper(data.Mode or "TEAM DEATHMATCH")
        
        -- Show score display
        ScoreDisplay.UI.Frame.Visible = true
        
        -- Set match end time
        ScoreDisplay.matchStartTime = os.time()
        ScoreDisplay.matchDuration = data.Duration or 600 -- Default 10 minutes
    elseif status == "MatchEnd" then
        -- Fade out timer and show "GAME OVER"
        ScoreDisplay.UI.TimerLabel.Text = "GAME OVER"
    elseif status == "Lobby" then
        -- Hide score display in lobby
        ScoreDisplay.UI.Frame.Visible = false
    end
end

-- Start updating the timer
function ScoreDisplay.StartTimerUpdates()
    -- Default match info
    ScoreDisplay.matchStartTime = 0
    ScoreDisplay.matchDuration = 600 -- 10 minutes
    
    -- Update timer every second
    spawn(function()
        while true do
            if ScoreDisplay.UI.TimerLabel then
                ScoreDisplay.UpdateTimer()
            end
            wait(1)
        end
    end)
end

-- Update the timer display
function ScoreDisplay.UpdateTimer()
    if ScoreDisplay.matchStartTime == 0 then
        ScoreDisplay.UI.TimerLabel.Text = "--:--"
        return
    end
    
    local currentTime = os.time()
    local elapsedTime = currentTime - ScoreDisplay.matchStartTime
    local remainingTime = ScoreDisplay.matchDuration - elapsedTime
    
    if remainingTime <= 0 then
        ScoreDisplay.UI.TimerLabel.Text = "00:00"
        return
    end
    
    -- Format the time as MM:SS
    local minutes = math.floor(remainingTime / 60)
    local seconds = remainingTime % 60
    ScoreDisplay.UI.TimerLabel.Text = string.format("%02d:%02d", minutes, seconds)
    
    -- Change color when time is running out
    if remainingTime <= 30 then
        ScoreDisplay.UI.TimerLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red for low time
    else
        ScoreDisplay.UI.TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Show/hide the score display
function ScoreDisplay.SetVisible(isVisible)
    if not ScoreDisplay.UI.Frame then return end
    
    ScoreDisplay.UI.Frame.Visible = isVisible
end

-- Clean up resources
function ScoreDisplay:Destroy()
    if self.Frame then
        self.Frame:Destroy()
    end
end

return ScoreDisplay 