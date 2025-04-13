-- WeaponEvents.lua
-- ModuleScript that creates all weapon-related remote events

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WeaponEvents = {}

-- Create the WeaponEvents folder if it doesn't exist
local weaponEventsFolder = ReplicatedStorage:FindFirstChild("WeaponEvents")
if not weaponEventsFolder then
    weaponEventsFolder = Instance.new("Folder")
    weaponEventsFolder.Name = "WeaponEvents"
    weaponEventsFolder.Parent = ReplicatedStorage
end

-- Create WeaponFired event
local WeaponFired = Instance.new("RemoteEvent")
WeaponFired.Name = "WeaponFired"
WeaponFired.Parent = weaponEventsFolder
WeaponEvents.WeaponFired = WeaponFired

-- Create WeaponReloaded event
local WeaponReloaded = Instance.new("RemoteEvent")
WeaponReloaded.Name = "WeaponReloaded"
WeaponReloaded.Parent = weaponEventsFolder
WeaponEvents.WeaponReloaded = WeaponReloaded

-- Create WeaponSwitched event
local WeaponSwitched = Instance.new("RemoteEvent")
WeaponSwitched.Name = "WeaponSwitched"
WeaponSwitched.Parent = weaponEventsFolder
WeaponEvents.WeaponSwitched = WeaponSwitched

-- Create WeaponAmmoChanged event
local WeaponAmmoChanged = Instance.new("RemoteEvent")
WeaponAmmoChanged.Name = "WeaponAmmoChanged"
WeaponAmmoChanged.Parent = weaponEventsFolder
WeaponEvents.WeaponAmmoChanged = WeaponAmmoChanged

-- Create AmmoUpdate event
local AmmoUpdate = Instance.new("RemoteEvent")
AmmoUpdate.Name = "AmmoUpdate"
AmmoUpdate.Parent = weaponEventsFolder
WeaponEvents.AmmoUpdate = AmmoUpdate

-- Create DamageDealt event
local DamageDealt = Instance.new("RemoteEvent")
DamageDealt.Name = "DamageDealt"
DamageDealt.Parent = weaponEventsFolder
WeaponEvents.DamageDealt = DamageDealt

-- Create HitMarker event
local HitMarker = Instance.new("RemoteEvent")
HitMarker.Name = "HitMarker"
HitMarker.Parent = weaponEventsFolder
WeaponEvents.HitMarker = HitMarker

print("Weapon events initialized")

return WeaponEvents 