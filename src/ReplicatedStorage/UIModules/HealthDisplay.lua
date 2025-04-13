local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local HealthDisplay = {}
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- UI properties
local uiSize = UDim2.new(0, 180, 0, 15)
local uiPosition = UDim2.new(0, 10, 0, 10)
local cornerRadius = UDim.new(0, 4)
local healthAnimationDuration = 0.3

-- Create health bar UI
function HealthDisplay.Initialize(hudContainer)
    local healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = uiSize
    healthFrame.Position = uiPosition
    healthFrame.BorderSizePixel = 0
    healthFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthFrame.Parent = hudContainer
    
    -- Create corner rounding
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = cornerRadius
    frameCorner.Parent = healthFrame
    
    -- Create health bar fill
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BorderSizePixel = 0
    healthBar.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    healthBar.Parent = healthFrame
    
    -- Round the health bar corners
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = cornerRadius
    barCorner.Parent = healthBar
    
    -- Add health text
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.Font = Enum.Font.GothamSemibold
    healthText.TextSize = 14
    healthText.Text = "100/100"
    healthText.Parent = healthFrame
    
    HealthDisplay.healthFrame = healthFrame
    HealthDisplay.healthBar = healthBar
    HealthDisplay.healthText = healthText
    
    -- Connect to character added and health change events
    localPlayer.CharacterAdded:Connect(function(character)
        HealthDisplay.ConnectToCharacter(character)
    end)
    
    if localPlayer.Character then
        HealthDisplay.ConnectToCharacter(localPlayer.Character)
    end
    
    return healthFrame
end

function HealthDisplay.ConnectToCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Update immediately
    HealthDisplay.UpdateHealth(humanoid.Health, humanoid.MaxHealth)
    
    -- Connect to health changed event
    humanoid.HealthChanged:Connect(function(health)
        HealthDisplay.UpdateHealth(health, humanoid.MaxHealth)
    end)
end

function HealthDisplay.UpdateHealth(currentHealth, maxHealth)
    if not HealthDisplay.healthBar or not HealthDisplay.healthText then return end
    
    currentHealth = math.max(0, currentHealth)
    local healthRatio = currentHealth / maxHealth
    
    -- Update text
    HealthDisplay.healthText.Text = math.floor(currentHealth) .. "/" .. math.floor(maxHealth)
    
    -- Animate health bar
    local tweenInfo = TweenInfo.new(healthAnimationDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HealthDisplay.healthBar, tweenInfo, {
        Size = UDim2.new(healthRatio, 0, 1, 0)
    })
    tween:Play()
    
    -- Change color based on health
    local color
    if healthRatio > 0.7 then
        -- Green when health is high
        color = Color3.fromRGB(46, 204, 113)
    elseif healthRatio > 0.3 then
        -- Yellow when health is medium
        color = Color3.fromRGB(241, 196, 15)
    else
        -- Red when health is low
        color = Color3.fromRGB(231, 76, 60)
    end
    
    local colorTween = TweenService:Create(HealthDisplay.healthBar, tweenInfo, {
        BackgroundColor3 = color
    })
    colorTween:Play()
end

function HealthDisplay.Show()
    if HealthDisplay.healthFrame then
        HealthDisplay.healthFrame.Visible = true
    end
end

function HealthDisplay.Hide()
    if HealthDisplay.healthFrame then
        HealthDisplay.healthFrame.Visible = false
    end
end

function HealthDisplay.Destroy()
    if HealthDisplay.healthFrame then
        HealthDisplay.healthFrame:Destroy()
        HealthDisplay.healthFrame = nil
        HealthDisplay.healthBar = nil
        HealthDisplay.healthText = nil
    end
end

return HealthDisplay 