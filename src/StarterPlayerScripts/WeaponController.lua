-- WeaponController.lua
-- Client-side weapon controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Wait for remote events to be set up
local WeaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")

-- Current equipped weapon
local currentWeapon = {
    Name = "",
    Ammo = 0,
    ReserveAmmo = 0,
    Model = nil,
    Reloading = false,
    Firing = false,
    LastFire = 0,
    FireRate = 0.1 -- 10 shots per second default
}

-- UI references
local StarterGui = game:GetService("StarterGui")
local AmmoCounter = nil
local function getAmmoCounter()
    if not AmmoCounter then
        local ammoCounterScript = StarterGui:FindFirstChild("HUD"):FindFirstChild("AmmoCounter")
        if ammoCounterScript then
            AmmoCounter = require(ammoCounterScript)
            AmmoCounter.Initialize()
        end
    end
    return AmmoCounter
end

-- Initialize crosshair
local function initializeCrosshair()
    -- Wait for the player's PlayerGui to be available 
    while not player:FindFirstChild("PlayerGui") do
        task.wait(0.1)
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CrosshairGui"
    screenGui.Parent = player.PlayerGui
    
    local crosshair = Instance.new("Frame")
    crosshair.Name = "Crosshair"
    crosshair.Size = UDim2.new(0, 2, 0, 20)
    crosshair.Position = UDim2.new(0.5, -1, 0.5, -10)
    crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
    crosshair.BorderSizePixel = 0
    crosshair.Parent = screenGui
    
    local crosshairHorizontal = Instance.new("Frame")
    crosshairHorizontal.Name = "CrosshairHorizontal"
    crosshairHorizontal.Size = UDim2.new(0, 20, 0, 2)
    crosshairHorizontal.Position = UDim2.new(0.5, -10, 0.5, -1)
    crosshairHorizontal.BackgroundColor3 = Color3.new(1, 1, 1)
    crosshairHorizontal.BorderSizePixel = 0
    crosshairHorizontal.Parent = screenGui
    
    local centerDot = Instance.new("Frame")
    centerDot.Name = "CenterDot"
    centerDot.Size = UDim2.new(0, 2, 0, 2)
    centerDot.Position = UDim2.new(0.5, -1, 0.5, -1)
    centerDot.BackgroundColor3 = Color3.new(1, 0, 0)
    centerDot.BorderSizePixel = 0
    centerDot.Parent = screenGui
end

-- Handle weapon switching
local function onWeaponSwitched(weaponData)
    currentWeapon.Name = weaponData.Name
    currentWeapon.Ammo = weaponData.Ammo
    currentWeapon.ReserveAmmo = weaponData.ReserveAmmo
    currentWeapon.Reloading = false
    currentWeapon.Firing = false
    
    -- Update the UI
    local ammoCounter = getAmmoCounter()
    if ammoCounter then
        ammoCounter.UpdateAmmo(currentWeapon.Ammo, currentWeapon.ReserveAmmo)
        ammoCounter.UpdateWeaponName(currentWeapon.Name)
    end
    
    print("Switched to weapon:", currentWeapon.Name)
end

-- Handle weapon firing
local function fireWeapon()
    if currentWeapon.Reloading or currentWeapon.Firing or currentWeapon.Ammo <= 0 then
        return
    end
    
    local now = tick()
    if now - currentWeapon.LastFire < currentWeapon.FireRate then
        return
    end
    
    currentWeapon.LastFire = now
    currentWeapon.Ammo = currentWeapon.Ammo - 1
    
    -- Play firing effects
    local character = player.Character
    if character then
        -- Find weapon model
        local equippedWeapon = character:FindFirstChild("EquippedWeapon")
        if equippedWeapon then
            -- Create muzzle flash
            local barrel = equippedWeapon:FindFirstChild("Barrel")
            if barrel then
                local muzzleFlash = Instance.new("Part")
                muzzleFlash.Size = Vector3.new(0.2, 0.2, 0.2)
                muzzleFlash.CFrame = barrel.CFrame * CFrame.new(0, 0, barrel.Size.Z/2 + 0.1)
                muzzleFlash.Anchored = true
                muzzleFlash.CanCollide = false
                muzzleFlash.Material = Enum.Material.Neon
                muzzleFlash.BrickColor = BrickColor.new("Bright yellow")
                muzzleFlash.Parent = workspace
                
                -- Create bullet trail
                local bulletStart = barrel.Position + barrel.CFrame.LookVector * (barrel.Size.Z/2)
                local bulletEnd = bulletStart + camera.CFrame.LookVector * 100
                
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local raycastResult = workspace:Raycast(bulletStart, camera.CFrame.LookVector * 100, raycastParams)
                if raycastResult then
                    bulletEnd = raycastResult.Position
                end
                
                local bulletTrail = Instance.new("Part")
                bulletTrail.Size = Vector3.new(0.1, 0.1, (bulletEnd - bulletStart).Magnitude)
                bulletTrail.CFrame = CFrame.new(bulletStart, bulletEnd) * CFrame.new(0, 0, -bulletTrail.Size.Z/2)
                bulletTrail.Anchored = true
                bulletTrail.CanCollide = false
                bulletTrail.Material = Enum.Material.Neon
                bulletTrail.BrickColor = BrickColor.new("Bright yellow")
                bulletTrail.Transparency = 0.3
                bulletTrail.Parent = workspace
                
                -- Create bullet hit effect if there was a hit
                if raycastResult then
                    local bulletHit = Instance.new("Part")
                    bulletHit.Size = Vector3.new(0.3, 0.3, 0.3)
                    bulletHit.CFrame = CFrame.new(bulletEnd)
                    bulletHit.Anchored = true
                    bulletHit.CanCollide = false
                    bulletHit.Material = Enum.Material.Neon
                    bulletHit.BrickColor = BrickColor.new("Bright red")
                    bulletHit.Shape = Enum.PartType.Ball
                    bulletHit.Parent = workspace
                    
                    -- Cleanup hit effect
                    task.delay(0.1, function()
                        bulletHit:Destroy()
                    end)
                end
                
                -- Play sound effect
                local gunshot = Instance.new("Sound")
                gunshot.SoundId = "rbxassetid://5055054056" -- Generic gunshot sound
                gunshot.Volume = 1
                gunshot.PlayOnRemove = true
                gunshot.Parent = barrel
                gunshot:Destroy()
                
                -- Cleanup effects
                task.delay(0.05, function()
                    muzzleFlash:Destroy()
                end)
                
                task.delay(0.1, function()
                    bulletTrail:Destroy()
                end)
            end
        end
    end
    
    -- Fire the remote event
    WeaponEvents.WeaponFired:FireServer({
        Name = currentWeapon.Name,
        Origin = camera.CFrame.Position,
        Direction = camera.CFrame.LookVector
    })
    
    -- Update the UI
    local ammoCounter = getAmmoCounter()
    if ammoCounter then
        ammoCounter.UpdateAmmo(currentWeapon.Ammo, currentWeapon.ReserveAmmo)
    end
    
    -- Check if we need to reload
    if currentWeapon.Ammo <= 0 then
        reloadWeapon()
    end
end

-- Handle weapon reloading
local function reloadWeapon()
    if currentWeapon.Reloading or currentWeapon.ReserveAmmo <= 0 or currentWeapon.Ammo >= 30 then
        return
    end
    
    currentWeapon.Reloading = true
    
    -- Play reload animation
    -- Here you would add reload animation
    
    -- Fire the remote event
    WeaponEvents.WeaponReloaded:FireServer({
        Name = currentWeapon.Name
    })
    
    -- Simulate reload time
    task.wait(2) -- 2 second reload
    
    -- Calculate reload amount
    local reloadAmount = math.min(30 - currentWeapon.Ammo, currentWeapon.ReserveAmmo)
    currentWeapon.Ammo = currentWeapon.Ammo + reloadAmount
    currentWeapon.ReserveAmmo = currentWeapon.ReserveAmmo - reloadAmount
    
    -- Update the UI
    local ammoCounter = getAmmoCounter()
    if ammoCounter then
        ammoCounter.UpdateAmmo(currentWeapon.Ammo, currentWeapon.ReserveAmmo)
    end
    
    currentWeapon.Reloading = false
end

-- Handle input
local function setupInputHandling()
    -- Mouse button 1 (fire)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            fireWeapon()
        elseif input.KeyCode == Enum.KeyCode.R then
            reloadWeapon()
        end
    end)
end

-- Connect to remote events
local function connectRemoteEvents()
    WeaponEvents.WeaponSwitched.OnClientEvent:Connect(onWeaponSwitched)
    
    WeaponEvents.WeaponAmmoChanged.OnClientEvent:Connect(function(ammoData)
        currentWeapon.Ammo = ammoData.Ammo
        currentWeapon.ReserveAmmo = ammoData.ReserveAmmo
        
        -- Update the UI
        local ammoCounter = getAmmoCounter()
        if ammoCounter then
            ammoCounter.UpdateAmmo(currentWeapon.Ammo, currentWeapon.ReserveAmmo)
        end
    end)
end

-- Initialize the weapon controller
local function initialize()
    print("Initializing WeaponController...")
    
    -- Initialize UI components
    initializeCrosshair()
    
    -- Connect to remote events
    connectRemoteEvents()
    
    -- Setup input handling
    setupInputHandling()
    
    print("WeaponController initialized")
end

initialize() 