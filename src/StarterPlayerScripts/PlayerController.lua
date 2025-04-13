local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Camera settings
local CAMERA_OFFSET = Vector3.new(0, 1, 0)
local CAMERA_DISTANCE = 10
local CAMERA_ANGLE = Vector2.new(0, math.rad(20))
local CAMERA_SENSITIVITY = 0.5

-- Movement settings
local MOVEMENT_SPEED = 16
local SPRINT_MULTIPLIER = 1.5
local JUMP_POWER = 50

-- Camera variables
local camera = workspace.CurrentCamera
local cameraAngle = CAMERA_ANGLE
local isAiming = false
local isSprinting = false

-- Function to update the camera
local function updateCamera()
    if not character or not rootPart then return end
    
    -- Calculate camera position
    local cameraCFrame = CFrame.new(rootPart.Position + CAMERA_OFFSET)
    local cameraRotation = CFrame.fromEulerAnglesYXZ(cameraAngle.X, cameraAngle.Y, 0)
    local cameraPosition = cameraCFrame * cameraRotation * CFrame.new(0, 0, CAMERA_DISTANCE)
    
    -- Set camera position
    camera.CFrame = CFrame.new(cameraPosition.Position, rootPart.Position + CAMERA_OFFSET)
end

-- Function to handle mouse movement
local function handleMouseMovement(delta)
    if not character or not rootPart then return end
    
    -- Update camera angle
    cameraAngle = Vector2.new(
        cameraAngle.X - delta.X * CAMERA_SENSITIVITY,
        math.clamp(cameraAngle.Y - delta.Y * CAMERA_SENSITIVITY, -math.rad(80), math.rad(80))
    )
    
    -- Update camera
    updateCamera()
    
    -- Update character rotation
    local lookVector = camera.CFrame.LookVector
    local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.fromEulerAnglesYXZ(cameraAngle.X, 0, 0)
end

-- Function to handle keyboard input
local function handleKeyboardInput()
    if not character or not rootPart then return end
    
    -- Get input direction
    local moveDirection = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + Vector3.new(0, 0, -1)
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection + Vector3.new(0, 0, 1)
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection + Vector3.new(-1, 0, 0)
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + Vector3.new(1, 0, 0)
    end
    
    -- Normalize direction
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end
    
    -- Apply movement speed
    local speed = MOVEMENT_SPEED
    if isSprinting then
        speed = speed * SPRINT_MULTIPLIER
    end
    
    -- Apply movement
    local moveVector = moveDirection * speed
    humanoid:Move(moveVector)
end

-- Function to handle jumping
local function handleJumping()
    if not character or not rootPart then return end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid.Jump = true
    end
end

-- Connect to input events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift then
        isSprinting = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift then
        isSprinting = false
    end
end)

-- Connect to mouse movement
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        handleMouseMovement(input.Delta)
    end
end)

-- Connect to character added
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset camera angle
    cameraAngle = CAMERA_ANGLE
    
    -- Update camera
    updateCamera()
end)

-- Update loop
RunService.RenderStepped:Connect(function()
    handleKeyboardInput()
    handleJumping()
end)

-- Initial camera setup
updateCamera() 