-- PlayerController.lua
-- Handles player movement and advanced mechanics like sliding, crouching, etc.

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerController = {}
PlayerController.__index = PlayerController

-- Movement States
PlayerController.MOVEMENT_STATE = {
    WALKING = "Walking",
    RUNNING = "Running",
    CROUCHING = "Crouching",
    SLIDING = "Sliding",
    JUMPING = "Jumping",
    FALLING = "Falling",
    PRONE = "Prone"
}

-- Constructor
function PlayerController.new(player)
    local self = setmetatable({}, PlayerController)
    
    self.Player = player or Players.LocalPlayer
    self.Character = self.Player.Character or self.Player.CharacterAdded:Wait()
    self.Humanoid = self.Character:WaitForChild("Humanoid")
    self.HumanoidRootPart = self.Character:WaitForChild("HumanoidRootPart")
    
    -- Movement settings
    self.WalkSpeed = 16
    self.RunSpeed = 24
    self.CrouchSpeed = 8
    self.JumpPower = 50
    self.SlideForce = 50
    self.SlideDuration = 1.0
    self.SlideDecay = 0.9 -- Slide speed decay per second
    
    -- Current movement state
    self.MovementState = PlayerController.MOVEMENT_STATE.WALKING
    
    -- Control flags
    self.IsJumping = false
    self.IsSprinting = false
    self.IsCrouching = false
    self.IsSliding = false
    self.SlideStartTime = 0
    self.SlideDirection = Vector3.new(0, 0, 0)
    self.SlideVelocity = 0
    
    -- Advanced movement cooldowns
    self.SlideCooldown = 1.0 -- Seconds before can slide again
    self.LastSlideTime = 0
    
    -- Mobile controls support
    self.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    self.MobileControls = nil -- Will be set up if on mobile
    
    -- Initialize controller
    self:Initialize()
    
    return self
end

function PlayerController:Initialize()
    -- Set initial character properties
    self.Humanoid.WalkSpeed = self.WalkSpeed
    self.Humanoid.JumpPower = self.JumpPower
    
    -- Connect character events
    self.Player.CharacterAdded:Connect(function(char)
        self.Character = char
        self.Humanoid = self.Character:WaitForChild("Humanoid")
        self.HumanoidRootPart = self.Character:WaitForChild("HumanoidRootPart")
        
        -- Reset state
        self.MovementState = PlayerController.MOVEMENT_STATE.WALKING
        self.IsJumping = false
        self.IsSprinting = false
        self.IsCrouching = false
        self.IsSliding = false
        
        -- Reconnect humanoid events
        self:ConnectHumanoidEvents()
    end)
    
    -- Connect input events
    self:ConnectInputEvents()
    
    -- Connect humanoid events
    self:ConnectHumanoidEvents()
    
    -- Set up mobile controls if needed
    if self.IsMobile then
        self:SetupMobileControls()
    end
    
    -- Set up the render step for sliding physics
    RunService:BindToRenderStep("PlayerMovement", Enum.RenderPriority.Character.Value, function(deltaTime)
        self:UpdateMovement(deltaTime)
    end)
end

function PlayerController:ConnectInputEvents()
    -- Handle keyboard input for PC
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.LeftShift then
            self:StartSprinting()
        elseif input.KeyCode == Enum.KeyCode.C then
            self:ToggleCrouch()
        elseif input.KeyCode == Enum.KeyCode.X and self.IsSprinting then
            self:StartSliding()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.LeftShift then
            self:StopSprinting()
        end
    end)
end

function PlayerController:ConnectHumanoidEvents()
    -- Handle humanoid state changes
    self.Humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            self.IsJumping = true
            self.MovementState = PlayerController.MOVEMENT_STATE.JUMPING
        elseif newState == Enum.HumanoidStateType.Freefall then
            self.IsJumping = false
            self.MovementState = PlayerController.MOVEMENT_STATE.FALLING
        elseif newState == Enum.HumanoidStateType.Landed then
            self.IsJumping = false
            
            -- End sliding if landing from a jump
            if self.IsSliding then
                self:EndSliding()
            end
            
            -- Restore previous movement state
            if self.IsCrouching then
                self.MovementState = PlayerController.MOVEMENT_STATE.CROUCHING
            elseif self.IsSprinting then
                self.MovementState = PlayerController.MOVEMENT_STATE.RUNNING
            else
                self.MovementState = PlayerController.MOVEMENT_STATE.WALKING
            end
        end
    end)
end

function PlayerController:SetupMobileControls()
    -- For a real implementation, create mobile UI buttons for sprint, crouch, slide
    -- This is a simplified version
    self.MobileControls = {}
    
    -- Add mobile buttons here
    -- Example: Create sprint button, crouch button, etc.
    -- These would be proper GUI elements in a real implementation
end

function PlayerController:UpdateMovement(deltaTime)
    -- Handle sliding physics if sliding
    if self.IsSliding then
        self:UpdateSliding(deltaTime)
    end
    
    -- Update animations based on movement state
    self:UpdateAnimations()
end

function PlayerController:StartSprinting()
    if self.IsCrouching or self.IsSliding then
        self:StopCrouching()
        self:EndSliding()
    end
    
    self.IsSprinting = true
    self.Humanoid.WalkSpeed = self.RunSpeed
    
    if self.MovementState ~= PlayerController.MOVEMENT_STATE.JUMPING and 
       self.MovementState ~= PlayerController.MOVEMENT_STATE.FALLING then
        self.MovementState = PlayerController.MOVEMENT_STATE.RUNNING
    end
end

function PlayerController:StopSprinting()
    self.IsSprinting = false
    
    if not self.IsCrouching and not self.IsSliding then
        self.Humanoid.WalkSpeed = self.WalkSpeed
        
        if self.MovementState ~= PlayerController.MOVEMENT_STATE.JUMPING and 
           self.MovementState ~= PlayerController.MOVEMENT_STATE.FALLING then
            self.MovementState = PlayerController.MOVEMENT_STATE.WALKING
        end
    end
end

function PlayerController:ToggleCrouch()
    if self.IsSliding then
        self:EndSliding()
    end
    
    if self.IsCrouching then
        self:StopCrouching()
    else
        self:StartCrouching()
    end
end

function PlayerController:StartCrouching()
    self.IsCrouching = true
    self.IsSprinting = false
    self.Humanoid.WalkSpeed = self.CrouchSpeed
    
    -- Adjust character height for crouching
    self:SetCharacterHeight(0.7) -- Scale to 70% of normal height
    
    if self.MovementState ~= PlayerController.MOVEMENT_STATE.JUMPING and 
       self.MovementState ~= PlayerController.MOVEMENT_STATE.FALLING then
        self.MovementState = PlayerController.MOVEMENT_STATE.CROUCHING
    end
end

function PlayerController:StopCrouching()
    self.IsCrouching = false
    
    -- Restore character height
    self:SetCharacterHeight(1.0)
    
    if self.IsSprinting then
        self.Humanoid.WalkSpeed = self.RunSpeed
        
        if self.MovementState ~= PlayerController.MOVEMENT_STATE.JUMPING and 
           self.MovementState ~= PlayerController.MOVEMENT_STATE.FALLING then
            self.MovementState = PlayerController.MOVEMENT_STATE.RUNNING
        end
    else
        self.Humanoid.WalkSpeed = self.WalkSpeed
        
        if self.MovementState ~= PlayerController.MOVEMENT_STATE.JUMPING and 
           self.MovementState ~= PlayerController.MOVEMENT_STATE.FALLING then
            self.MovementState = PlayerController.MOVEMENT_STATE.WALKING
        end
    end
end

function PlayerController:StartSliding()
    -- Check if sliding is on cooldown
    local currentTime = tick()
    if currentTime - self.LastSlideTime < self.SlideCooldown then
        return
    end
    
    -- Can only slide if sprinting
    if not self.IsSprinting then
        return
    end
    
    self.IsSliding = true
    self.IsCrouching = true
    self.SlideStartTime = currentTime
    self.LastSlideTime = currentTime
    
    -- Calculate slide direction and initial velocity
    self.SlideDirection = self.HumanoidRootPart.CFrame.LookVector
    self.SlideVelocity = self.SlideForce
    
    -- Adjust character height for sliding
    self:SetCharacterHeight(0.5) -- Even lower than crouching
    
    self.MovementState = PlayerController.MOVEMENT_STATE.SLIDING
    
    -- Apply initial slide force
    self.HumanoidRootPart:ApplyImpulse(self.SlideDirection * self.SlideForce)
end

function PlayerController:UpdateSliding(deltaTime)
    local currentTime = tick()
    local slideDuration = currentTime - self.SlideStartTime
    
    if slideDuration >= self.SlideDuration then
        -- End sliding after duration
        self:EndSliding()
        return
    end
    
    -- Apply sliding physics
    self.SlideVelocity = self.SlideVelocity * math.pow(self.SlideDecay, deltaTime)
    
    -- Apply sliding velocity
    self.HumanoidRootPart.Velocity = Vector3.new(
        self.SlideDirection.X * self.SlideVelocity,
        self.HumanoidRootPart.Velocity.Y,
        self.SlideDirection.Z * self.SlideVelocity
    )
end

function PlayerController:EndSliding()
    if not self.IsSliding then return end
    
    self.IsSliding = false
    
    -- Keep crouching after sliding
    self.IsCrouching = true
    self.Humanoid.WalkSpeed = self.CrouchSpeed
    
    -- Adjust character height back to crouch height
    self:SetCharacterHeight(0.7)
    
    self.MovementState = PlayerController.MOVEMENT_STATE.CROUCHING
end

function PlayerController:SetCharacterHeight(scale)
    -- Adjust character height by scaling parts
    -- Note: This is a simplified implementation
    -- In a real game, you would use animations and constraints
    
    local humanoidRootPart = self.Character:FindFirstChild("HumanoidRootPart")
    local head = self.Character:FindFirstChild("Head")
    
    if humanoidRootPart and head then
        -- Adjust the root part position to keep feet on ground
        local originalHeight = 5 -- Approximate R15 height
        local heightDiff = originalHeight * (1 - scale)
        
        -- Adjust position of HumanoidRootPart
        humanoidRootPart.Position = Vector3.new(
            humanoidRootPart.Position.X,
            humanoidRootPart.Position.Y - heightDiff/2,
            humanoidRootPart.Position.Z
        )
    end
end

function PlayerController:UpdateAnimations()
    -- In a real implementation, play appropriate animations based on movement state
    -- This would use the Roblox Animation system
    
    if self.MovementState == PlayerController.MOVEMENT_STATE.WALKING then
        -- Play walking animation
    elseif self.MovementState == PlayerController.MOVEMENT_STATE.RUNNING then
        -- Play running animation
    elseif self.MovementState == PlayerController.MOVEMENT_STATE.CROUCHING then
        -- Play crouching animation
    elseif self.MovementState == PlayerController.MOVEMENT_STATE.SLIDING then
        -- Play sliding animation
    elseif self.MovementState == PlayerController.MOVEMENT_STATE.JUMPING then
        -- Play jumping animation
    elseif self.MovementState == PlayerController.MOVEMENT_STATE.FALLING then
        -- Play falling animation
    end
end

function PlayerController:GetMovementState()
    return self.MovementState
end

function PlayerController:Destroy()
    -- Clean up
    RunService:UnbindFromRenderStep("PlayerMovement")
    
    -- Reset character
    if self.Humanoid then
        self.Humanoid.WalkSpeed = self.WalkSpeed
        self.Humanoid.JumpPower = self.JumpPower
    end
    
    -- Reset character height
    self:SetCharacterHeight(1.0)
    
    -- Clean up mobile controls if they exist
    if self.MobileControls then
        -- Remove mobile UI elements
    end
end

return PlayerController 