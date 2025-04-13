-- RemoteEventsInit.lua
-- ModuleScript that initializes all remote events and functions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Initialize all remote event modules
local weaponEvents = require(script.Parent.WeaponEvents)
local gameEvents = require(script.Parent.GameEvents)
local mapEvents = require(script.Parent.MapEvents)
local playerEvents = require(script.Parent.PlayerEvents)

-- Initialize all remote function modules
local weaponFunctions = require(script.Parent.WeaponFunctions)
local gameFunctions = require(script.Parent.GameFunctions)
local mapFunctions = require(script.Parent.MapFunctions)
local playerFunctions = require(script.Parent.PlayerFunctions)

print("All remote events and functions initialized")

return {
    WeaponEvents = weaponEvents,
    GameEvents = gameEvents,
    MapEvents = mapEvents,
    PlayerEvents = playerEvents,
    WeaponFunctions = weaponFunctions,
    GameFunctions = gameFunctions,
    MapFunctions = mapFunctions,
    PlayerFunctions = playerFunctions
} 