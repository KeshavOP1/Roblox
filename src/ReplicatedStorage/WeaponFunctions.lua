-- WeaponFunctions.lua
-- ModuleScript that creates all weapon-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponFunctions = {}

-- Create the WeaponFunctions folder if it doesn't exist
local weaponFunctionsFolder = ReplicatedStorage:FindFirstChild("WeaponFunctions")
if not weaponFunctionsFolder then
    weaponFunctionsFolder = Instance.new("Folder")
    weaponFunctionsFolder.Name = "WeaponFunctions"
    weaponFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetWeaponData function
local GetWeaponData = Instance.new("RemoteFunction")
GetWeaponData.Name = "GetWeaponData"
GetWeaponData.Parent = weaponFunctionsFolder
WeaponFunctions.GetWeaponData = GetWeaponData

-- Create GetPlayerLoadout function
local GetPlayerLoadout = Instance.new("RemoteFunction")
GetPlayerLoadout.Name = "GetPlayerLoadout"
GetPlayerLoadout.Parent = weaponFunctionsFolder
WeaponFunctions.GetPlayerLoadout = GetPlayerLoadout

-- Create CanSwitchWeapon function
local CanSwitchWeapon = Instance.new("RemoteFunction")
CanSwitchWeapon.Name = "CanSwitchWeapon"
CanSwitchWeapon.Parent = weaponFunctionsFolder
WeaponFunctions.CanSwitchWeapon = CanSwitchWeapon

print("Weapon functions initialized")

return WeaponFunctions 
 
-- ModuleScript that creates all weapon-related remote functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponFunctions = {}

-- Create the WeaponFunctions folder if it doesn't exist
local weaponFunctionsFolder = ReplicatedStorage:FindFirstChild("WeaponFunctions")
if not weaponFunctionsFolder then
    weaponFunctionsFolder = Instance.new("Folder")
    weaponFunctionsFolder.Name = "WeaponFunctions"
    weaponFunctionsFolder.Parent = ReplicatedStorage
end

-- Create GetWeaponData function
local GetWeaponData = Instance.new("RemoteFunction")
GetWeaponData.Name = "GetWeaponData"
GetWeaponData.Parent = weaponFunctionsFolder
WeaponFunctions.GetWeaponData = GetWeaponData

-- Create GetPlayerLoadout function
local GetPlayerLoadout = Instance.new("RemoteFunction")
GetPlayerLoadout.Name = "GetPlayerLoadout"
GetPlayerLoadout.Parent = weaponFunctionsFolder
WeaponFunctions.GetPlayerLoadout = GetPlayerLoadout

-- Create CanSwitchWeapon function
local CanSwitchWeapon = Instance.new("RemoteFunction")
CanSwitchWeapon.Name = "CanSwitchWeapon"
CanSwitchWeapon.Parent = weaponFunctionsFolder
WeaponFunctions.CanSwitchWeapon = CanSwitchWeapon

print("Weapon functions initialized")

return WeaponFunctions 