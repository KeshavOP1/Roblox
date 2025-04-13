-- CameraController.lua
-- First-person camera controller module

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local CameraController = {}
CameraController.__index = CameraController

-- Constants
local CAMERA_SENSITIVITY = 0.5
local MAX_Y_ANGLE = 80 -- degrees
local FIRST_PERSON_OFFSET = Vector3.new(0, 0.7, 0) -- position offset from head

-- Create a new camera controller
function CameraController.new(player)
    local self = setmetatable({}, CameraController)
    
    self.Player = player or Players.LocalPlayer
    self.Camera = workspace.CurrentCamera
    self.Character = self.Player.Character or self.Player.CharacterAdded:Wait()
    self.Head = self.Character:WaitForChild("Head")
    
    self.CameraEnabled = false
    self.CameraType = Enum.CameraType.Custom
    self.CameraSubject = nil
    self.CameraOffset = FIRST_PERSON_OFFSET
    
    self.LastMousePosition = Vector2.new()
    self.RotationX = 0
    self.RotationY = 0
    
    -- Initialize
    self:Initialize()
    
    return self
end

-- Initialize the camera controller
function CameraController:Initialize()
    print("Initializing CameraController...")
    
    -- Set up camera
    self.Camera.CameraType = self.CameraType
    
    -- Lock the mouse
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    
    -- Connect character events
    self.Player.CharacterAdded:Connect(function(character)
        self.Character = character
        self.Head = character:WaitForChild("Head")
    end)
    
    -- Connect input events
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            self:HandleMouseMovement(input)
        end
    end)
    
    -- Connect render events for camera update
    RunService:BindToRenderStep("CameraController", Enum.RenderPriority.Camera.Value, function()
        self:UpdateCamera()
    end)
    
    -- Enable the camera
    self:Enable()
    
    print("CameraController initialized")
end

-- Enable the camera controller
function CameraController:Enable()
    self.CameraEnabled = true
    
    -- Hide character for first-person view
    if self.Character then
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                if part.Name == "Right Arm" or part.Name == "RightHand" or part.Name == "RightUpperArm" or part.Name == "RightLowerArm" or part.Name == "RightHand" then
                    -- Keep the right arm visible for weapon holding
                    part.LocalTransparencyModifier = 0
                else
                    part.LocalTransparencyModifier = 1
                end
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.LocalTransparencyModifier = 1
            end
        end
    end
end

-- Disable the camera controller
function CameraController:Disable()
    self.CameraEnabled = false
    
    -- Show character
    if self.Character then
        for _, part in pairs(self.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

-- Handle mouse movement
function CameraController:HandleMouseMovement(input)
    if not self.CameraEnabled then return end
    
    local mouseDelta = input.Delta
    
    -- Update rotation based on mouse movement
    self.RotationY = self.RotationY - mouseDelta.X * CAMERA_SENSITIVITY
    self.RotationX = math.clamp(
        self.RotationX - mouseDelta.Y * CAMERA_SENSITIVITY, 
        -MAX_Y_ANGLE, 
        MAX_Y_ANGLE
    )
end

-- Update the camera position and orientation
function CameraController:UpdateCamera()
    if not self.CameraEnabled or not self.Character then return end
    
    -- Get head position
    local headPosition = self.Head.Position
    
    -- Calculate camera position
    local cameraPosition = headPosition + self.CameraOffset
    
    -- Calculate camera CFrame based on rotation
    local cameraRotation = CFrame.Angles(math.rad(self.RotationX), math.rad(self.RotationY), 0)
    self.Camera.CFrame = CFrame.new(cameraPosition) * cameraRotation
    
    -- Apply rotation to the character's HumanoidRootPart
    local humanoid = self.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.AutoRotate = false
        
        local rootPart = self.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Only rotate the Y axis (left/right)
            rootPart.CFrame = CFrame.new(rootPart.Position) * 
                              CFrame.Angles(0, math.rad(self.RotationY), 0)
        end
    end
end

-- Clean up the camera controller
function CameraController:Cleanup()
    RunService:UnbindFromRenderStep("CameraController")
    
    -- Show character
    self:Disable()
    
    -- Reset camera
    self.Camera.CameraType = Enum.CameraType.Custom
    self.Camera.CameraSubject = self.Character:FindFirstChild("Humanoid")
    
    -- Unlock the mouse
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    
    print("CameraController cleaned up")
end

return CameraController 