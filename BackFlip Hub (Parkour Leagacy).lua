-- BACKFLIP SCRIPT WITH SIRIUS UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Backflip Script",
   Icon = 0,
   LoadingTitle = "Backflip Script",
   LoadingSubtitle = "by ReposeTaPeur",
   ShowText = "Backflip Script Loading...",
   Theme = "Default",
   
   ToggleUIKeybind = "RightShift",
   
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,
   
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "BackflipScript"
   },
   
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   
   KeySystem = false,
})

-- Show notification
Rayfield:Notify({
   Title = "Backflip Script",
   Content = "Script loaded successfully!",
   Duration = 3,
   Image = nil,
})

-- Create Main Tab
local MainTab = Window:CreateTab("🏠 Main", nil)
local MainSection = MainTab:CreateSection("Backflip Feature")

-- BACKFLIP MODULE
local BackflipModule = {}
BackflipModule.Enabled = false
BackflipModule.IsPerforming = false
BackflipModule.KeyConnection = nil

-- Function to simulate key press
local function PressKey(keyCode)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
end

-- Function to simulate key release
local function ReleaseKey(keyCode)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

-- Function to perform the backflip
function BackflipModule.PerformBackflip()
    if BackflipModule.IsPerforming then 
        return 
    end
    
    BackflipModule.IsPerforming = true
    
    -- Get current camera orientation
    local originalCFrame = Camera.CFrame
    local originalCameraType = Camera.CameraType
    
    -- Make sure camera can be controlled
    Camera.CameraType = Enum.CameraType.Custom
    
    -- Step 1: Turn camera 180 degrees
    local turnAmount = math.rad(180)
    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, turnAmount, 0)
    
    -- Small delay to let camera update
    task.wait(0.05)
    
    -- Step 2: Press Space (jump) immediately
    PressKey(Enum.KeyCode.Space)
    task.wait(0.05)
    ReleaseKey(Enum.KeyCode.Space)
    
    -- Step 3: Hold S (backward) for 1 second
    PressKey(Enum.KeyCode.S)
    task.wait(1)
    ReleaseKey(Enum.KeyCode.S)
    
    -- Step 4: Turn camera back to original orientation (-180 degrees)
    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, -turnAmount, 0)
    
    -- Restore camera type
    Camera.CameraType = originalCameraType
    
    BackflipModule.IsPerforming = false
    
    Rayfield:Notify({
        Title = "Backflip",
        Content = "Backflip completed!",
        Duration = 1.5,
        Image = nil,
    })
end

-- Function to enable backflip listener
function BackflipModule.Enable()
    if BackflipModule.Enabled then return end
    
    BackflipModule.Enabled = true
    
    -- Listen for E key press
    BackflipModule.KeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.E then
            if BackflipModule.Enabled and not BackflipModule.IsPerforming then
                -- Perform backflip in a separate thread
                task.spawn(function()
                    BackflipModule.PerformBackflip()
                end)
            end
        end
    end)
    
    Rayfield:Notify({
        Title = "Backflip",
        Content = "Enabled - Press E to perform backflip",
        Duration = 3,
        Image = nil,
    })
end

-- Function to disable backflip listener
function BackflipModule.Disable()
    if not BackflipModule.Enabled then return end
    
    BackflipModule.Enabled = false
    
    if BackflipModule.KeyConnection then
        BackflipModule.KeyConnection:Disconnect()
        BackflipModule.KeyConnection = nil
    end
    
    Rayfield:Notify({
        Title = "Backflip",
        Content = "Disabled",
        Duration = 2,
        Image = nil,
    })
end

-- Function to toggle backflip
function BackflipModule.Toggle()
    if BackflipModule.Enabled then
        BackflipModule.Disable()
    else
        BackflipModule.Enable()
    end
end

-- UI ELEMENTS

-- Backflip Toggle
local BackflipToggle = MainTab:CreateToggle({
   Name = "Enable Backflip",
   CurrentValue = false,
   Flag = "BackflipToggle",
   Callback = function(Value)
       if Value then
           BackflipModule.Enable()
       else
           BackflipModule.Disable()
       end
   end,
})

-- Instructions
local InstructionsParagraph = MainTab:CreateParagraph({
   Title = "How to Use",
   Content = "1. Toggle 'Enable Backflip' ON\n2. Press 'E' key in-game\n3. Your character will:\n   - Turn 180°\n   - Jump and move backward for 1 second\n   - Turn back to original direction\n\nNote: Make sure you're not in a menu when pressing E"
})

-- Manual Test Button (for testing without E key)
local TestButton = MainTab:CreateButton({
   Name = "Test Backflip Now",
   Callback = function()
       if not BackflipModule.IsPerforming then
           task.spawn(function()
               BackflipModule.PerformBackflip()
           end)
       else
           Rayfield:Notify({
               Title = "Backflip",
               Content = "Already performing a backflip!",
               Duration = 1.5,
               Image = nil,
           })
       end
   end,
})

-- Settings Section
local SettingsSection = MainTab:CreateSection("Settings")

-- Keybind Display
local KeybindParagraph = MainTab:CreateParagraph({
   Title = "Keybinds",
   Content = "E - Perform Backflip (when enabled)\nRightShift - Toggle UI"
})

-- Status Section
local StatusSection = MainTab:CreateSection("Status")

local StatusParagraph = MainTab:CreateParagraph({
   Title = "Current Status",
   Content = "Backflip: Disabled\nPerforming: No"
})

-- Update status display
task.spawn(function()
    while true do
        local enabledStatus = BackflipModule.Enabled and "Enabled" or "Disabled"
        local performingStatus = BackflipModule.IsPerforming and "Yes" or "No"
        
        StatusParagraph:Set({
            Title = "Current Status",
            Content = "Backflip: " .. enabledStatus .. "\nPerforming: " .. performingStatus
        })
        
        task.wait(0.5)
    end
end)

-- Credits Section
local CreditsSection = MainTab:CreateSection("Credits")

local CreditsParagraph = MainTab:CreateParagraph({
   Title = "Backflip Script v1.0",
   Content = "A simple script that performs a backflip move when you press E.\n\nFeatures:\n• 180° camera turn\n• Auto jump + backward movement\n• Camera restoration\n• Toggle on/off system"
})