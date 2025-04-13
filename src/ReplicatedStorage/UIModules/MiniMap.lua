local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local MiniMap = {}
local localPlayer = Players.LocalPlayer

-- Constants
local MINIMAP_SIZE = UDim2.new(0, 180, 0, 180)
local MINIMAP_POSITION = UDim2.new(0.98, -190, 0.02, 10)
local PLAYER_ICON_SIZE = UDim2.new(0, 8, 0, 8)
local TEAMMATE_COLOR = Color3.fromRGB(0, 170, 255)
local ENEMY_COLOR = Color3.fromRGB(255, 50, 50)
local SELF_COLOR = Color3.fromRGB(0, 255, 100)
local UPDATE_INTERVAL = 0.1 -- Seconds between updates
local MINIMAP_SCALE = 0.2 -- Scale of the world to minimap

-- UI elements
local miniMapFrame
local playerIcons = {}
local objectiveIcons = {}
local mapImage

-- Initialize the mini map
function MiniMap.Initialize(hudContainer)
    -- Create mini map container
    miniMapFrame = Instance.new("Frame")
    miniMapFrame.Name = "MiniMapFrame"
    miniMapFrame.Size = MINIMAP_SIZE
    miniMapFrame.Position = MINIMAP_POSITION
    miniMapFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    miniMapFrame.BackgroundTransparency = 0.3
    miniMapFrame.BorderSizePixel = 0
    miniMapFrame.Parent = hudContainer
    
    -- Round corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = miniMapFrame
    
    -- Add border
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(200, 200, 200)
    border.Thickness = 1
    border.Transparency = 0.7
    border.Parent = miniMapFrame
    
    -- Map background
    mapImage = Instance.new("ImageLabel")
    mapImage.Name = "MapBackground"
    mapImage.Size = UDim2.new(1, -10, 1, -10)
    mapImage.Position = UDim2.new(0, 5, 0, 5)
    mapImage.BackgroundTransparency = 1
    mapImage.Image = ""  -- Will be set based on the current map
    mapImage.Parent = miniMapFrame
    
    -- Create heading indicator
    local headingIndicator = Instance.new("Frame")
    headingIndicator.Name = "HeadingIndicator"
    headingIndicator.Size = UDim2.new(0, 3, 0, 30)
    headingIndicator.Position = UDim2.new(0.5, -1.5, 0, 0)
    headingIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    headingIndicator.AnchorPoint = Vector2.new(0.5, 0)
    headingIndicator.BorderSizePixel = 0
    headingIndicator.Visible = false
    headingIndicator.Parent = miniMapFrame
    
    -- Add map title
    local mapTitle = Instance.new("TextLabel")
    mapTitle.Name = "MapTitle"
    mapTitle.Size = UDim2.new(1, 0, 0, 20)
    mapTitle.Position = UDim2.new(0, 0, 0, 0)
    mapTitle.BackgroundTransparency = 1
    mapTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    mapTitle.Font = Enum.Font.GothamBold
    mapTitle.TextSize = 14
    mapTitle.Text = "MAP NAME"
    mapTitle.Parent = miniMapFrame
    
    MiniMap.mapTitle = mapTitle
    MiniMap.headingIndicator = headingIndicator
    
    -- Start updating the minimap
    MiniMap.StartUpdating()
    
    -- Listen for map changes
    local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")
    local mapChangeEvent = gameEvents:FindFirstChild("MapChange")
    
    if mapChangeEvent then
        mapChangeEvent.OnClientEvent:Connect(function(mapName, mapData)
            MiniMap.UpdateMap(mapName, mapData)
        end)
    end
    
    -- Return minimap
    return miniMapFrame
end

-- Update the map background and info
function MiniMap.UpdateMap(mapName, mapData)
    if not miniMapFrame then return end
    
    -- Update map title
    MiniMap.mapTitle.Text = string.upper(mapName)
    
    -- Update map image if available
    if mapData and mapData.MinimapImage then
        mapImage.Image = mapData.MinimapImage
    else
        -- Default to a grid pattern if no map image
        mapImage.Image = "rbxassetid://5357468225"  -- Grid texture
    end
    
    -- Clear existing objective icons
    for _, icon in pairs(objectiveIcons) do
        if icon and icon.Instance then
            icon.Instance:Destroy()
        end
    end
    objectiveIcons = {}
    
    -- Add new objective icons if available
    if mapData and mapData.Objectives then
        for id, objective in pairs(mapData.Objectives) do
            MiniMap.AddObjectiveIcon(id, objective.Position, objective.Type)
        end
    end
end

-- Add an objective icon to the minimap
function MiniMap.AddObjectiveIcon(id, worldPosition, objectiveType)
    if not miniMapFrame or not mapImage then return end
    
    local icon = Instance.new("Frame")
    icon.Name = "Objective_" .. id
    icon.Size = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 0
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BorderSizePixel = 0
    
    -- Set icon appearance based on objective type
    if objectiveType == "CapturePoint" then
        icon.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 2)
        uiCorner.Parent = icon
    elseif objectiveType == "Flag" then
        icon.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0.5, 0)
        uiCorner.Parent = icon
    else
        icon.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    end
    
    -- Calculate position on minimap
    local mapPos = MiniMap.WorldToMinimapPosition(worldPosition)
    icon.Position = mapPos
    icon.Parent = mapImage
    
    -- Store the icon
    objectiveIcons[id] = {
        Instance = icon,
        WorldPosition = worldPosition
    }
    
    return icon
end

-- Convert a world position to a minimap position
function MiniMap.WorldToMinimapPosition(worldPos)
    -- This is a simplified calculation
    -- In a real game, you'd account for map orientation and boundaries
    local center = Vector2.new(mapImage.AbsoluteSize.X/2, mapImage.AbsoluteSize.Y/2)
    local x = center.X + (worldPos.X * MINIMAP_SCALE)
    local y = center.Y + (worldPos.Z * MINIMAP_SCALE) -- Z axis is forward in Roblox
    
    return UDim2.new(0, x, 0, y)
end

-- Add or update a player icon on the minimap
function MiniMap.UpdatePlayerIcon(player, position, rotation)
    if not miniMapFrame or not mapImage then return end
    
    -- Create icon if it doesn't exist
    if not playerIcons[player.UserId] then
        local icon = Instance.new("Frame")
        icon.Name = "Player_" .. player.Name
        icon.Size = PLAYER_ICON_SIZE
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.BorderSizePixel = 0
        
        -- Make it a triangle shape for direction
        local triangleShape = Instance.new("Frame")
        triangleShape.Size = UDim2.new(1, 0, 1, 0)
        triangleShape.BackgroundTransparency = 1
        triangleShape.Parent = icon
        
        -- Add a TextButton as a visual for the triangle (hacky but effective)
        local visualTriangle = Instance.new("TextButton")
        visualTriangle.Text = "▲"
        visualTriangle.TextSize = 10
        visualTriangle.TextColor3 = Color3.fromRGB(0, 0, 0)
        visualTriangle.BackgroundTransparency = 1
        visualTriangle.Size = UDim2.new(1, 0, 1, 0)
        visualTriangle.Rotation = 0
        visualTriangle.Parent = triangleShape
        
        -- Set the color based on if it's local player, teammate, or enemy
        if player == localPlayer then
            icon.BackgroundColor3 = SELF_COLOR
        elseif player.Team == localPlayer.Team then
            icon.BackgroundColor3 = TEAMMATE_COLOR
        else
            icon.BackgroundColor3 = ENEMY_COLOR
        end
        
        -- Store components
        playerIcons[player.UserId] = {
            Instance = icon,
            Triangle = visualTriangle
        }
        
        icon.Parent = mapImage
    end
    
    -- Get the icon
    local iconData = playerIcons[player.UserId]
    local icon = iconData.Instance
    local triangle = iconData.Triangle
    
    -- Update position
    icon.Position = MiniMap.WorldToMinimapPosition(position)
    
    -- Update rotation (heading)
    if triangle then
        -- Convert Roblox rotation (in Y axis) to minimap rotation
        local degrees = math.deg(rotation.Y)
        triangle.Rotation = degrees
    end
    
    -- Update color if team changed
    if player ~= localPlayer then
        if player.Team == localPlayer.Team then
            icon.BackgroundColor3 = TEAMMATE_COLOR
        else
            icon.BackgroundColor3 = ENEMY_COLOR
        end
    end
end

-- Remove a player icon from the minimap
function MiniMap.RemovePlayerIcon(player)
    if playerIcons[player.UserId] and playerIcons[player.UserId].Instance then
        playerIcons[player.UserId].Instance:Destroy()
        playerIcons[player.UserId] = nil
    end
end

-- Start updating the minimap
function MiniMap.StartUpdating()
    -- Connect to RunService to update regularly
    local connection = RunService.Heartbeat:Connect(function()
        MiniMap.UpdateMinimap()
    end)
    
    -- Store the connection
    MiniMap.updateConnection = connection
end

-- Update the minimap with player positions
function MiniMap.UpdateMinimap()
    -- Only update periodically to save performance
    if not MiniMap.lastUpdate or tick() - MiniMap.lastUpdate >= UPDATE_INTERVAL then
        MiniMap.lastUpdate = tick()
        
        -- Update player icons
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                MiniMap.UpdatePlayerIcon(player, rootPart.Position, rootPart.Rotation)
            end
        end
    end
end

-- Show the minimap
function MiniMap.Show()
    if miniMapFrame then
        miniMapFrame.Visible = true
    end
end

-- Hide the minimap
function MiniMap.Hide()
    if miniMapFrame then
        miniMapFrame.Visible = false
    end
end

-- Clean up the minimap
function MiniMap.Destroy()
    if MiniMap.updateConnection then
        MiniMap.updateConnection:Disconnect()
        MiniMap.updateConnection = nil
    end
    
    -- Clear player icons
    for _, iconData in pairs(playerIcons) do
        if iconData.Instance then
            iconData.Instance:Destroy()
        end
    end
    playerIcons = {}
    
    -- Clear objective icons
    for _, iconData in pairs(objectiveIcons) do
        if iconData.Instance then
            iconData.Instance:Destroy()
        end
    end
    objectiveIcons = {}
    
    -- Destroy frame
    if miniMapFrame then
        miniMapFrame:Destroy()
        miniMapFrame = nil
    end
end

return MiniMap 