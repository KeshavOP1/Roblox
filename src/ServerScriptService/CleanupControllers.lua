
-- CleanupControllers.lua
-- This script removes any client-side controllers that may have been mistakenly placed in ServerScriptService

local ServerScriptService = game:GetService("ServerScriptService")

-- List of client-side controllers that should not be in ServerScriptService
local clientControllers = {
    "WeaponController"
}

-- Check for and remove client controllers
for _, controllerName in ipairs(clientControllers) do
    local controller = ServerScriptService:FindFirstChild(controllerName)
    if controller then
        print("Removing client-side controller from server:", controllerName)
        controller:Destroy()
    end
end

print("Cleanup complete") 