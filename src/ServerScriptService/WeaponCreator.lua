local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create a basic AK47 weapon model
local function createAK47()
    -- Create the tool
    local tool = Instance.new("Tool")
    tool.Name = "AK47"
    tool.ToolTip = "Assault Rifle"
    
    -- Create the handle
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 0.5, 1)
    handle.BrickColor = BrickColor.new("Really black")
    handle.Material = Enum.Material.Metal
    handle.Parent = tool
    
    -- Create the barrel
    local barrel = Instance.new("Part")
    barrel.Name = "Barrel"
    barrel.Size = Vector3.new(0.2, 0.2, 3)
    barrel.BrickColor = BrickColor.new("Really black")
    barrel.Material = Enum.Material.Metal
    barrel.Parent = tool
    
    -- Create the magazine
    local magazine = Instance.new("Part")
    magazine.Name = "Magazine"
    magazine.Size = Vector3.new(0.3, 0.8, 0.3)
    magazine.BrickColor = BrickColor.new("Really black")
    magazine.Material = Enum.Material.Metal
    magazine.Parent = tool
    
    -- Create the stock
    local stock = Instance.new("Part")
    stock.Name = "Stock"
    stock.Size = Vector3.new(0.4, 0.4, 1.5)
    stock.BrickColor = BrickColor.new("Really black")
    stock.Material = Enum.Material.Metal
    stock.Parent = tool
    
    -- Create the sight
    local sight = Instance.new("Part")
    sight.Name = "Sight"
    sight.Size = Vector3.new(0.1, 0.2, 0.1)
    sight.BrickColor = BrickColor.new("Really black")
    sight.Material = Enum.Material.Metal
    sight.Parent = tool
    
    -- Position the parts
    handle.Position = Vector3.new(0, 0, 0)
    barrel.Position = Vector3.new(0, 0, 1.5)
    magazine.Position = Vector3.new(0, -0.5, 0)
    stock.Position = Vector3.new(0, 0, -0.75)
    sight.Position = Vector3.new(0, 0.3, 0.5)
    
    -- Create a weld to hold the parts together
    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = barrel
    weld.C0 = CFrame.new(0, 0, 1.5)
    weld.Parent = handle
    
    local weld2 = Instance.new("Weld")
    weld2.Part0 = handle
    weld2.Part1 = magazine
    weld2.C0 = CFrame.new(0, -0.5, 0)
    weld2.Parent = handle
    
    local weld3 = Instance.new("Weld")
    weld3.Part0 = handle
    weld3.Part1 = stock
    weld3.C0 = CFrame.new(0, 0, -0.75)
    weld3.Parent = handle
    
    local weld4 = Instance.new("Weld")
    weld4.Part0 = handle
    weld4.Part1 = sight
    weld4.C0 = CFrame.new(0, 0.3, 0.5)
    weld4.Parent = handle
    
    -- Set the handle as the primary part
    tool.PrimaryPart = handle
    
    -- Create a script for the weapon
    local script = Instance.new("Script")
    script.Name = "WeaponScript"
    script.Parent = tool
    
    -- Add the weapon script
    local weaponScript = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tool = script.Parent
local player = Players:GetPlayerFromCharacter(tool.Parent)
local mouse = player:GetMouse()

-- Weapon properties
local properties = {
    Damage = 25,
    FireRate = 600, -- Rounds per minute
    ReloadTime = 2, -- Seconds
    ClipSize = 30,
    ReserveAmmo = 90,
    CurrentAmmo = 30,
    IsReloading = false,
    LastFired = 0
}

-- Get remote events
local weaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")

-- Function to fire the weapon
local function fire()
    if properties.IsReloading then return end
    if properties.CurrentAmmo <= 0 then
        -- Play empty sound
        return
    end
    
    -- Check fire rate
    local currentTime = tick()
    if currentTime - properties.LastFired < 60 / properties.FireRate then
        return
    end
    
    -- Update ammo
    properties.CurrentAmmo = properties.CurrentAmmo - 1
    properties.LastFired = currentTime
    
    -- Fire the weapon
    weaponEvents.WeaponFired:FireServer({
        WeaponName = tool.Name,
        AmmoRemaining = properties.CurrentAmmo,
        ReserveAmmo = properties.ReserveAmmo
    })
    
    -- Create muzzle flash
    local muzzleFlash = Instance.new("PointLight")
    muzzleFlash.Color = Color3.new(1, 0.5, 0)
    muzzleFlash.Range = 5
    muzzleFlash.Brightness = 2
    muzzleFlash.Parent = tool.Barrel
    
    -- Remove muzzle flash after a short time
    game:GetService("Debris"):AddItem(muzzleFlash, 0.1)
    
    -- Play fire sound
    local fireSound = Instance.new("Sound")
    fireSound.SoundId = "rbxasset://sounds/weapons/ak47_fire.mp3"
    fireSound.Volume = 1
    fireSound.Parent = tool
    fireSound:Play()
    game:GetService("Debris"):AddItem(fireSound, 1)
end

-- Function to reload the weapon
local function reload()
    if properties.IsReloading then return end
    if properties.ReserveAmmo <= 0 then
        -- Play empty sound
        return
    end
    
    properties.IsReloading = true
    
    -- Play reload sound
    local reloadSound = Instance.new("Sound")
    reloadSound.SoundId = "rbxasset://sounds/weapons/ak47_reload.mp3"
    reloadSound.Volume = 1
    reloadSound.Parent = tool
    reloadSound:Play()
    
    -- Wait for reload time
    wait(properties.ReloadTime)
    
    -- Calculate ammo to reload
    local ammoToReload = math.min(properties.ClipSize - properties.CurrentAmmo, properties.ReserveAmmo)
    properties.CurrentAmmo = properties.CurrentAmmo + ammoToReload
    properties.ReserveAmmo = properties.ReserveAmmo - ammoToReload
    properties.IsReloading = false
    
    -- Notify server of reload
    weaponEvents.WeaponReloaded:FireServer({
        WeaponName = tool.Name,
        AmmoRemaining = properties.CurrentAmmo,
        ReserveAmmo = properties.ReserveAmmo
    })
end

-- Connect mouse events
mouse.Button1Down:Connect(function()
    fire()
end)

mouse.Button1Up:Connect(function()
    -- Stop firing
end)

mouse.Button2Down:Connect(function()
    -- Aim down sights
end)

mouse.Button2Up:Connect(function()
    -- Stop aiming
end)

-- Connect keyboard events
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        reload()
    end
end)

-- Equip the weapon
tool.Equipped:Connect(function()
    -- Play equip sound
    local equipSound = Instance.new("Sound")
    equipSound.SoundId = "rbxasset://sounds/weapons/ak47_equip.mp3"
    equipSound.Volume = 1
    equipSound.Parent = tool
    equipSound:Play()
    
    -- Notify server of weapon equipped
    weaponEvents.WeaponSwitched:FireServer({
        WeaponName = tool.Name,
        AmmoRemaining = properties.CurrentAmmo,
        ReserveAmmo = properties.ReserveAmmo
    })
end)

-- Unequip the weapon
tool.Unequipped:Connect(function()
    -- Stop any ongoing actions
    properties.IsReloading = false
end)
]]
    
    script.Source = weaponScript
    
    return tool
end

-- Create the weapon and add it to ReplicatedStorage
local ak47 = createAK47()
ak47.Parent = ReplicatedStorage

-- Create a function to spawn weapons in the world
local function spawnWeapon(weaponName, position)
    local weapon = ReplicatedStorage:FindFirstChild(weaponName):Clone()
    weapon.Parent = workspace
    
    -- Position the weapon
    local handle = weapon:FindFirstChild("Handle")
    if handle then
        handle.Position = position
    end
    
    -- Make the weapon pickupable
    local function onTouched(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        
        if player then
            -- Give the weapon to the player
            local tool = ReplicatedStorage:FindFirstChild(weaponName):Clone()
            tool.Parent = player.Backpack
            
            -- Remove the weapon from the world
            weapon:Destroy()
        end
    end
    
    handle.Touched:Connect(onTouched)
end

-- Spawn some weapons in the world
spawnWeapon("AK47", Vector3.new(0, 5, 10))
spawnWeapon("AK47", Vector3.new(10, 5, 0))
spawnWeapon("AK47", Vector3.new(-10, 5, 0)) 