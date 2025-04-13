-- AmmoCounter.lua
-- Displays the current ammo count for the equipped weapon

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AmmoCounter = {}

-- UI Component
AmmoCounter.UI = {
    Frame = nil,
    CurrentAmmoLabel = nil,
    ReserveAmmoLabel = nil,
    WeaponNameLabel = nil,
    FireModeLabel = nil
}

-- Initialize the ammo counter UI
function AmmoCounter.Initialize(parent)
    -- Create the main frame
    local frame = Instance.new("Frame")
    frame.Name = "AmmoCounter"
    frame.Size = UDim2.new(0, 250, 0, 100)
    frame.Position = UDim2.new(1, -270, 1, -120)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.Parent = parent
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Create ammo display
    local currentAmmoLabel = Instance.new("TextLabel")
    currentAmmoLabel.Name = "CurrentAmmo"
    currentAmmoLabel.Size = UDim2.new(0, 100, 0, 60)
    currentAmmoLabel.Position = UDim2.new(0, 20, 0, 20)
    currentAmmoLabel.BackgroundTransparency = 1
    currentAmmoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    currentAmmoLabel.TextSize = 40
    currentAmmoLabel.Font = Enum.Font.GothamBold
    currentAmmoLabel.Text = "30"
    currentAmmoLabel.TextXAlignment = Enum.TextXAlignment.Right
    currentAmmoLabel.Parent = frame
    
    -- Create ammo separator
    local ammoSeparator = Instance.new("TextLabel")
    ammoSeparator.Name = "AmmoSeparator"
    ammoSeparator.Size = UDim2.new(0, 20, 0, 60)
    ammoSeparator.Position = UDim2.new(0, 120, 0, 20)
    ammoSeparator.BackgroundTransparency = 1
    ammoSeparator.TextColor3 = Color3.fromRGB(200, 200, 200)
    ammoSeparator.TextSize = 40
    ammoSeparator.Font = Enum.Font.GothamBold
    ammoSeparator.Text = "/"
    ammoSeparator.TextXAlignment = Enum.TextXAlignment.Center
    ammoSeparator.Parent = frame
    
    -- Create reserve ammo display
    local reserveAmmoLabel = Instance.new("TextLabel")
    reserveAmmoLabel.Name = "ReserveAmmo"
    reserveAmmoLabel.Size = UDim2.new(0, 80, 0, 60)
    reserveAmmoLabel.Position = UDim2.new(0, 140, 0, 20)
    reserveAmmoLabel.BackgroundTransparency = 1
    reserveAmmoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    reserveAmmoLabel.TextSize = 30
    reserveAmmoLabel.Font = Enum.Font.GothamSemibold
    reserveAmmoLabel.Text = "120"
    reserveAmmoLabel.TextXAlignment = Enum.TextXAlignment.Left
    reserveAmmoLabel.Parent = frame
    
    -- Create weapon name display
    local weaponNameLabel = Instance.new("TextLabel")
    weaponNameLabel.Name = "WeaponName"
    weaponNameLabel.Size = UDim2.new(1, -40, 0, 20)
    weaponNameLabel.Position = UDim2.new(0, 20, 0, 5)
    weaponNameLabel.BackgroundTransparency = 1
    weaponNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponNameLabel.TextSize = 16
    weaponNameLabel.Font = Enum.Font.GothamSemibold
    weaponNameLabel.Text = "AK-47"
    weaponNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    weaponNameLabel.Parent = frame
    
    -- Create fire mode display
    local fireModeLabel = Instance.new("TextLabel")
    fireModeLabel.Name = "FireMode"
    fireModeLabel.Size = UDim2.new(0, 60, 0, 20)
    fireModeLabel.Position = UDim2.new(1, -80, 0, 5)
    fireModeLabel.BackgroundTransparency = 1
    fireModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    fireModeLabel.TextSize = 14
    fireModeLabel.Font = Enum.Font.GothamSemibold
    fireModeLabel.Text = "AUTO"
    fireModeLabel.TextXAlignment = Enum.TextXAlignment.Right
    fireModeLabel.Parent = frame
    
    -- Store UI components for later use
    AmmoCounter.UI.Frame = frame
    AmmoCounter.UI.CurrentAmmoLabel = currentAmmoLabel
    AmmoCounter.UI.ReserveAmmoLabel = reserveAmmoLabel
    AmmoCounter.UI.WeaponNameLabel = weaponNameLabel
    AmmoCounter.UI.FireModeLabel = fireModeLabel
    
    -- Set default visibility
    AmmoCounter.SetVisible(false)
    
    return AmmoCounter
end

-- Update the ammo display
function AmmoCounter.UpdateAmmo(currentAmmo, reserveAmmo)
    if not AmmoCounter.UI.CurrentAmmoLabel or not AmmoCounter.UI.ReserveAmmoLabel then
        return
    end
    
    AmmoCounter.UI.CurrentAmmoLabel.Text = tostring(currentAmmo)
    AmmoCounter.UI.ReserveAmmoLabel.Text = tostring(reserveAmmo)
    
    -- Change color when low on ammo
    if currentAmmo <= 5 then
        AmmoCounter.UI.CurrentAmmoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        AmmoCounter.UI.CurrentAmmoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Update the weapon info display
function AmmoCounter.UpdateWeaponInfo(weaponName, fireMode)
    if not AmmoCounter.UI.WeaponNameLabel or not AmmoCounter.UI.FireModeLabel then
        return
    end
    
    AmmoCounter.UI.WeaponNameLabel.Text = weaponName
    AmmoCounter.UI.FireModeLabel.Text = fireMode
end

-- Show/hide the ammo counter
function AmmoCounter.SetVisible(isVisible)
    if not AmmoCounter.UI.Frame then
        return
    end
    
    AmmoCounter.UI.Frame.Visible = isVisible
end

-- Animate the ammo counter during reload
function AmmoCounter.AnimateReload()
    if not AmmoCounter.UI.CurrentAmmoLabel then
        return
    end
    
    -- Save original color
    local originalColor = AmmoCounter.UI.CurrentAmmoLabel.TextColor3
    
    -- Flash effect
    AmmoCounter.UI.CurrentAmmoLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    AmmoCounter.UI.CurrentAmmoLabel.Text = "..."
    
    -- Restore after reload
    delay(2, function()
        AmmoCounter.UI.CurrentAmmoLabel.TextColor3 = originalColor
    end)
end

-- Clean up resources
function AmmoCounter.Destroy()
    if AmmoCounter.UI.Frame then
        AmmoCounter.UI.Frame:Destroy()
        AmmoCounter.UI.Frame = nil
    end
end

return AmmoCounter 