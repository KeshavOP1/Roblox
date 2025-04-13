-- WeaponSystem.lua
-- Core module for weapon functionality in the FPS game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local WeaponSystem = {}
WeaponSystem.__index = WeaponSystem

-- Weapon configurations
local WEAPONS = {
    AK47 = {
        Name = "AK-47",
        Type = "AssaultRifle",
        Damage = 25,
        HeadshotMultiplier = 2.5,
        FireRate = 600, -- RPM
        ClipSize = 30,
        ReserveAmmo = 90,
        ReloadTime = 2.5,
        Range = 1000,
        Spread = 2,
        Recoil = {
            Vertical = 1.2,
            Horizontal = 0.3,
            Recovery = 0.95,
            Pattern = { -- Recoil pattern (multipliers)
                {1.0, 0.0},   -- First shot
                {1.2, 0.1},   -- Second shot
                {1.3, -0.2},  -- Third shot
                {1.4, 0.3},   -- Fourth shot
                {1.5, -0.1}   -- Fifth shot and beyond
            }
        },
        Automatic = true
    },
    M4A1 = {
        Name = "M4A1",
        Type = "AssaultRifle",
        Damage = 22,
        HeadshotMultiplier = 2.2,
        FireRate = 700,
        ClipSize = 30,
        ReserveAmmo = 90,
        ReloadTime = 2.2,
        Range = 900,
        Spread = 1.5,
        Recoil = {
            Vertical = 1.0,
            Horizontal = 0.25,
            Recovery = 0.97,
            Pattern = {
                {0.8, 0.0},
                {1.0, 0.1},
                {1.1, -0.1},
                {1.2, 0.2},
                {1.3, -0.2}
            }
        },
        Automatic = true
    },
    AWP = {
        Name = "AWP",
        Type = "SniperRifle",
        Damage = 110,
        HeadshotMultiplier = 3.0,
        FireRate = 50,
        ClipSize = 5,
        ReserveAmmo = 30,
        ReloadTime = 3.5,
        Range = 2000,
        Spread = 0.1,
        Recoil = {
            Vertical = 4.0,
            Horizontal = 0.1,
            Recovery = 0.8,
            Pattern = {
                {4.0, 0.0},  -- Heavy vertical recoil
                {3.0, 0.1},
                {3.0, -0.1},
                {3.0, 0.0},
                {3.0, 0.0}
            }
        },
        Automatic = false
    }
}

-- Create a new weapon instance
function WeaponSystem.new(player, weaponName)
    local self = setmetatable({}, WeaponSystem)
    
    self.Player = player
    self.WeaponName = weaponName
    self.Config = WEAPONS[weaponName]
    
    -- Current state
    self.CurrentAmmo = self.Config.ClipSize
    self.ReserveAmmo = self.Config.ReserveAmmo
    self.IsReloading = false
    self.LastShotTime = 0
    self.Equipped = false
    self.ShotsFired = 0 -- Track number of shots fired for recoil pattern
    self.RecoilRecoveryTime = 0.5 -- Time to start recovering recoil
    self.LastRecoilTime = 0
    
    -- Get camera controller
    self.CameraController = require(ReplicatedStorage.Modules.CameraController).new(player)
    
    -- Create weapon model
    self:CreateWeaponModel()
    
    return self
end

-- Create the weapon model
function WeaponSystem:CreateWeaponModel()
    -- This would normally load a proper weapon model
    -- For this example, we'll create a simple placeholder
    local model = Instance.new("Model")
    model.Name = self.WeaponName
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 0.5, 2)
    handle.Color = Color3.fromRGB(50, 50, 50)
    handle.Material = Enum.Material.Metal
    handle.Parent = model
    
    local barrel = Instance.new("Part")
    barrel.Name = "Barrel"
    barrel.Size = Vector3.new(0.2, 0.2, 2)
    barrel.Color = Color3.fromRGB(30, 30, 30)
    barrel.Material = Enum.Material.Metal
    barrel.CFrame = handle.CFrame * CFrame.new(0, 0.3, 1)
    barrel.Parent = model
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = barrel
    weld.Parent = handle
    
    self.Model = model
end

-- Equip the weapon
function WeaponSystem:Equip()
    if not self.Model then return end
    
    local character = self.Player.Character
    if not character then return end
    
    local rightArm = character:FindFirstChild("Right Arm")
    if not rightArm then return end
    
    self.Model.Parent = character
    self.Model:SetPrimaryPartCFrame(rightArm.CFrame * CFrame.new(0, -1, 0))
    
    -- Create weld
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rightArm
    weld.Part1 = self.Model.Handle
    weld.Parent = self.Model.Handle
    
    self.Equipped = true
end

-- Unequip the weapon
function WeaponSystem:Unequip()
    if self.Model then
        self.Model:Destroy()
        self.Model = nil
    end
    self.Equipped = false
end

-- Fire the weapon
function WeaponSystem:Fire(targetPosition)
    if not self.Equipped or self.IsReloading then return end
    
    -- Check fire rate
    local currentTime = tick()
    local timeSinceLastShot = currentTime - self.LastShotTime
    local minimumTimeBetweenShots = 60 / self.Config.FireRate
    
    if timeSinceLastShot < minimumTimeBetweenShots then
        return
    end
    
    -- Check ammo
    if self.CurrentAmmo <= 0 then
        self:Reload()
        return
    end
    
    -- Update ammo and shot tracking
    self.CurrentAmmo = self.CurrentAmmo - 1
    self.LastShotTime = currentTime
    self.ShotsFired = self.ShotsFired + 1
    
    -- Apply recoil
    self:ApplyRecoil()
    
    -- Calculate spread
    local spread = self.Config.Spread
    if self.CameraController.IsAiming then
        spread = spread * 0.5 -- Reduce spread while aiming
    end
    local spreadX = (math.random() - 0.5) * spread
    local spreadY = (math.random() - 0.5) * spread
    
    -- Create bullet trail effect
    self:CreateBulletTrail(targetPosition, spreadX, spreadY)
    
    -- Fire weapon event for other clients
    local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
    if weaponEvents and weaponEvents:FindFirstChild("FireWeapon") then
        weaponEvents.FireWeapon:FireServer(targetPosition)
    end
end

-- Apply recoil effect
function WeaponSystem:ApplyRecoil()
    local recoilConfig = self.Config.Recoil
    local patternIndex = math.min(self.ShotsFired, #recoilConfig.Pattern)
    local pattern = recoilConfig.Pattern[patternIndex]
    
    -- Calculate recoil values
    local verticalRecoil = recoilConfig.Vertical * pattern[1]
    local horizontalRecoil = recoilConfig.Horizontal * pattern[2]
    
    -- Reduce recoil while aiming
    if self.CameraController.IsAiming then
        verticalRecoil = verticalRecoil * 0.7
        horizontalRecoil = horizontalRecoil * 0.7
    end
    
    -- Apply recoil to camera
    self.CameraController:AddRecoil(verticalRecoil, horizontalRecoil)
    
    -- Add screen shake for powerful weapons
    if self.Config.Type == "SniperRifle" then
        self.CameraController:AddShake(0.5)
    end
    
    -- Reset recoil after not firing
    self.LastRecoilTime = tick()
    
    -- Start recoil recovery
    if not self._recoilRecoveryConnection then
        self._recoilRecoveryConnection = RunService.Heartbeat:Connect(function()
            self:UpdateRecoilRecovery()
        end)
    end
end

-- Update recoil recovery
function WeaponSystem:UpdateRecoilRecovery()
    local currentTime = tick()
    local timeSinceLastRecoil = currentTime - self.LastRecoilTime
    
    if timeSinceLastRecoil >= self.RecoilRecoveryTime then
        -- Gradually reset shots fired count
        if self.ShotsFired > 0 then
            self.ShotsFired = math.max(0, self.ShotsFired - 1)
        else
            -- Disconnect recovery update if fully recovered
            if self._recoilRecoveryConnection then
                self._recoilRecoveryConnection:Disconnect()
                self._recoilRecoveryConnection = nil
            end
        end
    end
end

-- Create bullet trail effect
function WeaponSystem:CreateBulletTrail(targetPosition, spreadX, spreadY)
    local character = self.Player.Character
    if not character then return end
    
    local barrel = self.Model and self.Model:FindFirstChild("Barrel")
    if not barrel then return end
    
    -- Create bullet trail
    local trail = Instance.new("Part")
    trail.Name = "BulletTrail"
    trail.Size = Vector3.new(0.1, 0.1, 0.1)
    trail.Transparency = 0.5
    trail.Color = Color3.fromRGB(255, 200, 0)
    trail.Material = Enum.Material.Neon
    trail.CanCollide = false
    trail.CFrame = barrel.CFrame
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = trail
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(0, 0, -1)
    attachment1.Parent = trail
    
    local trailEffect = Instance.new("Trail")
    trailEffect.Attachment0 = attachment0
    trailEffect.Attachment1 = attachment1
    trailEffect.Color = ColorSequence.new(Color3.fromRGB(255, 200, 0))
    trailEffect.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trailEffect.Lifetime = 0.1
    trailEffect.Parent = trail
    
    trail.Parent = workspace
    
    -- Animate bullet trail
    local startPos = barrel.Position
    local direction = (targetPosition - startPos).Unit
    direction = direction + Vector3.new(spreadX, spreadY, 0)
    
    local bulletSpeed = 1000 -- studs per second
    local distance = (targetPosition - startPos).Magnitude
    local travelTime = distance / bulletSpeed
    
    local function updateBulletPosition(alpha)
        if trail.Parent then
            trail.CFrame = CFrame.new(startPos + direction * distance * alpha)
        end
    end
    
    -- Animate the bullet
    for i = 0, 1, 0.1 do
        updateBulletPosition(i)
        RunService.Heartbeat:Wait()
    end
    
    -- Clean up
    trail:Destroy()
end

-- Reload the weapon
function WeaponSystem:Reload()
    if self.IsReloading or self.CurrentAmmo >= self.Config.ClipSize or self.ReserveAmmo <= 0 then
        return
    end
    
    self.IsReloading = true
    
    -- Notify server
    local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")
    if weaponEvents and weaponEvents:FindFirstChild("ReloadWeapon") then
        weaponEvents.ReloadWeapon:FireServer()
    end
    
    -- Wait for reload time
    wait(self.Config.ReloadTime)
    
    -- Calculate new ammo counts
    local ammoNeeded = self.Config.ClipSize - self.CurrentAmmo
    local ammoToAdd = math.min(ammoNeeded, self.ReserveAmmo)
    
    self.CurrentAmmo = self.CurrentAmmo + ammoToAdd
    self.ReserveAmmo = self.ReserveAmmo - ammoToAdd
    
    self.IsReloading = false
end

-- Get current weapon info
function WeaponSystem:GetWeaponInfo()
    return {
        Name = self.WeaponName,
        CurrentAmmo = self.CurrentAmmo,
        ReserveAmmo = self.ReserveAmmo,
        IsReloading = self.IsReloading
    }
end

-- Clean up
function WeaponSystem:Destroy()
    if self._recoilRecoveryConnection then
        self._recoilRecoveryConnection:Disconnect()
        self._recoilRecoveryConnection = nil
    end
    
    if self.Model then
        self.Model:Destroy()
        self.Model = nil
    end
end

return WeaponSystem 