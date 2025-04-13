-- AmmoCounter.lua
-- Displays current ammo and weapon name

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local AmmoCounter = {}
local ui = {}

-- Initialize the ammo counter
function AmmoCounter.Initialize()
    print("Initializing AmmoCounter...")
    
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
        ui.Frame.Name = "AmmoCounter"
        ui.Frame.Size = UDim2.new(0, 200, 0, 80)
        ui.Frame.Position = UDim2.new(1, -210, 1, -90)
        ui.Frame.BackgroundTransparency = 0.7
        ui.Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ui.Frame.BorderSizePixel = 0
        ui.Frame.Parent = hud
        
        -- Create the ammo text
        ui.AmmoText = Instance.new("TextLabel")
        ui.AmmoText.Name = "AmmoText"
        ui.AmmoText.Size = UDim2.new(1, 0, 0.6, 0)
        ui.AmmoText.Text = "30 / 90"
        ui.AmmoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ui.AmmoText.BackgroundTransparency = 1
        ui.AmmoText.Font = Enum.Font.SourceSansBold
        ui.AmmoText.TextSize = 36
        ui.AmmoText.Parent = ui.Frame
        
        -- Create the weapon name text
        ui.WeaponName = Instance.new("TextLabel")
        ui.WeaponName.Name = "WeaponName"
        ui.WeaponName.Size = UDim2.new(1, 0, 0.4, 0)
        ui.WeaponName.Position = UDim2.new(0, 0, 0.6, 0)
        ui.WeaponName.Text = "AK47"
        ui.WeaponName.TextColor3 = Color3.fromRGB(200, 200, 200)
        ui.WeaponName.BackgroundTransparency = 1
        ui.WeaponName.Font = Enum.Font.SourceSans
        ui.WeaponName.TextSize = 20
        ui.WeaponName.Parent = ui.Frame
    end
    
    print("AmmoCounter initialized")
end

-- Update the ammo display
function AmmoCounter.UpdateAmmo(currentAmmo, reserveAmmo)
    if ui.AmmoText then
        ui.AmmoText.Text = currentAmmo .. " / " .. reserveAmmo
        
        -- Change color based on ammo remaining
        if currentAmmo <= 5 then
            ui.AmmoText.TextColor3 = Color3.fromRGB(255, 50, 50) -- Red when low
        else
            ui.AmmoText.TextColor3 = Color3.fromRGB(255, 255, 255) -- White normally
        end
    end
end

-- Update the weapon name display
function AmmoCounter.UpdateWeaponName(weaponName)
    if ui.WeaponName then
        ui.WeaponName.Text = weaponName
    end
end

-- Show the ammo counter
function AmmoCounter.Show()
    if ui.Frame then
        ui.Frame.Visible = true
    end
end

-- Hide the ammo counter
function AmmoCounter.Hide()
    if ui.Frame then
        ui.Frame.Visible = false
    end
end

-- Reset the ammo counter
function AmmoCounter.Reset()
    AmmoCounter.UpdateAmmo(0, 0)
    AmmoCounter.UpdateWeaponName("")
end

-- Clean up resources when needed
function AmmoCounter.Cleanup()
    if ui.Frame then
        ui.Frame:Destroy()
        ui = {}
    end
end

return AmmoCounter 