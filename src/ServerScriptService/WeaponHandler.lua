-- WeaponHandler.lua
-- Handles equipping players with weapons

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Wait for the weapon events to be set up
local WeaponEvents = ReplicatedStorage:WaitForChild("WeaponEvents")

-- Basic weapon models (these should be created in ReplicatedStorage)
local function createWeaponModels()
    -- Create a weapons folder in ReplicatedStorage if it doesn't exist
    local weaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not weaponsFolder then
        weaponsFolder = Instance.new("Folder")
        weaponsFolder.Name = "Weapons"
        weaponsFolder.Parent = ReplicatedStorage
    end
    
    -- Create a simple AK47 model if it doesn't exist
    local ak47 = weaponsFolder:FindFirstChild("AK47")
    if not ak47 then
        ak47 = Instance.new("Model")
        ak47.Name = "AK47"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.5, 0.5, 2)
        handle.BrickColor = BrickColor.new("Black")
        handle.CFrame = CFrame.new(0, 0, 0)
        handle.Anchored = false
        handle.CanCollide = false
        handle.Material = Enum.Material.Metal
        handle.Parent = ak47
        
        local barrel = Instance.new("Part")
        barrel.Name = "Barrel"
        barrel.Size = Vector3.new(0.2, 0.2, 3)
        barrel.BrickColor = BrickColor.new("Dark stone grey")
        barrel.CFrame = CFrame.new(0, 0, 1.5)
        barrel.Anchored = false
        barrel.CanCollide = false
        barrel.Material = Enum.Material.Metal
        barrel.Parent = ak47
        
        local magazine = Instance.new("Part")
        magazine.Name = "Magazine"
        magazine.Size = Vector3.new(0.3, 0.8, 0.4)
        magazine.BrickColor = BrickColor.new("Really black")
        magazine.CFrame = CFrame.new(0, -0.5, 0.5)
        magazine.Anchored = false
        magazine.CanCollide = false
        magazine.Material = Enum.Material.Metal
        magazine.Parent = ak47
        
        local stock = Instance.new("Part")
        stock.Name = "Stock"
        stock.Size = Vector3.new(0.4, 0.4, 1.5)
        stock.BrickColor = BrickColor.new("Brown")
        stock.CFrame = CFrame.new(0, 0, -1)
        stock.Anchored = false
        stock.CanCollide = false
        stock.Material = Enum.Material.Wood
        stock.Parent = ak47
        
        local weld1 = Instance.new("WeldConstraint")
        weld1.Part0 = handle
        weld1.Part1 = barrel
        weld1.Parent = handle
        
        local weld2 = Instance.new("WeldConstraint")
        weld2.Part0 = handle
        weld2.Part1 = magazine
        weld2.Parent = handle
        
        local weld3 = Instance.new("WeldConstraint")
        weld3.Part0 = handle
        weld3.Part1 = stock
        weld3.Parent = handle
        
        ak47.PrimaryPart = handle
        ak47.Parent = weaponsFolder
    end
    
    -- Create a simple Glock model if it doesn't exist
    local glock = weaponsFolder:FindFirstChild("Glock")
    if not glock then
        glock = Instance.new("Model")
        glock.Name = "Glock"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.4, 0.8, 0.8)
        handle.BrickColor = BrickColor.new("Black")
        handle.CFrame = CFrame.new(0, 0, 0)
        handle.Anchored = false
        handle.CanCollide = false
        handle.Parent = glock
        
        local barrel = Instance.new("Part")
        barrel.Name = "Barrel"
        barrel.Size = Vector3.new(0.2, 0.2, 1)
        barrel.BrickColor = BrickColor.new("Dark stone grey")
        barrel.CFrame = CFrame.new(0, 0.3, 0.5)
        barrel.Anchored = false
        barrel.CanCollide = false
        barrel.Parent = glock
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = barrel
        weld.Parent = handle
        
        glock.PrimaryPart = handle
        glock.Parent = weaponsFolder
    end
    
    -- Create a simple Knife model if it doesn't exist
    local knife = weaponsFolder:FindFirstChild("Knife")
    if not knife then
        knife = Instance.new("Model")
        knife.Name = "Knife"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.2, 0.2, 0.8)
        handle.BrickColor = BrickColor.new("Brown")
        handle.CFrame = CFrame.new(0, 0, 0)
        handle.Anchored = false
        handle.CanCollide = false
        handle.Parent = knife
        
        local blade = Instance.new("Part")
        blade.Name = "Blade"
        blade.Size = Vector3.new(0.1, 0.4, 1.5)
        blade.BrickColor = BrickColor.new("Institutional white")
        blade.CFrame = CFrame.new(0, 0, 1)
        blade.Anchored = false
        blade.CanCollide = false
        blade.Parent = knife
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = blade
        weld.Parent = handle
        
        knife.PrimaryPart = handle
        knife.Parent = weaponsFolder
    end
    
    print("Basic weapon models created")
    return weaponsFolder
end

-- Equip player with a weapon
local function equipWeapon(player, weaponName)
    if not player.Character then return end
    
    local weaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not weaponsFolder then return end
    
    local weaponModel = weaponsFolder:FindFirstChild(weaponName)
    if not weaponModel then return end
    
    -- Clone the weapon model
    local weaponClone = weaponModel:Clone()
    weaponClone.Name = "EquippedWeapon"
    
    -- Find or create a right hand attachment
    local rightHand = player.Character:FindFirstChild("RightHand") or player.Character:FindFirstChild("Right Arm")
    if not rightHand then return end
    
    local attachment = rightHand:FindFirstChild("RightGripAttachment")
    if not attachment then
        attachment = Instance.new("Attachment")
        attachment.Name = "RightGripAttachment"
        attachment.Position = Vector3.new(0, -0.5, 0)
        attachment.Parent = rightHand
    end
    
    -- Position the weapon relative to the hand
    if weaponName == "AK47" then
        weaponClone:SetPrimaryPartCFrame(attachment.WorldCFrame * CFrame.new(0.5, 0, 0.5) * CFrame.Angles(0, math.rad(90), 0))
    elseif weaponName == "Glock" then
        weaponClone:SetPrimaryPartCFrame(attachment.WorldCFrame * CFrame.new(0.2, 0, 0) * CFrame.Angles(0, math.rad(90), 0))
    else
        weaponClone:SetPrimaryPartCFrame(attachment.WorldCFrame)
    end
    
    -- Weld the weapon to the hand
    local weld = Instance.new("WeldConstraint")
    weld.Name = "WeaponWeld"
    weld.Part0 = rightHand
    weld.Part1 = weaponClone.PrimaryPart
    weld.Parent = rightHand
    
    -- Parent the weapon to the character
    weaponClone.Parent = player.Character
    
    -- Fire the weapon equipped event
    WeaponEvents.WeaponSwitched:FireClient(player, {
        Name = weaponName,
        Ammo = 30,
        ReserveAmmo = 90
    })
    
    print("Equipped player " .. player.Name .. " with " .. weaponName)
    return weaponClone
end

-- Default loadout for players
local defaultLoadout = {
    Primary = "AK47",
    Secondary = "Glock",
    Melee = "Knife"
}

-- Handle player spawning
local function onPlayerSpawned(player)
    -- Give player the default primary weapon
    task.wait(1) -- Wait for character to fully load
    equipWeapon(player, defaultLoadout.Primary)
end

-- Handle player added
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        onPlayerSpawned(player)
    end)
    
    if player.Character then
        onPlayerSpawned(player)
    end
end

-- Initialize weapon handler
local function initialize()
    print("Initializing WeaponHandler...")
    
    -- Create basic weapon models
    local weaponsFolder = createWeaponModels()
    
    -- Connect to player events
    Players.PlayerAdded:Connect(onPlayerAdded)
    
    -- Handle existing players
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
    
    print("WeaponHandler initialized")
end

initialize() 