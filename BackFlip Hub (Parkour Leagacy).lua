-- BACKFLIP HUB - ADVANCED MAG RAIL TECH AUTOMATION
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Backflip Hub",
   Icon = 0,
   LoadingTitle = "Backflip Hub",
   LoadingSubtitle = "by ReposeTaPeur",
   ShowText = "Loading...",
   Theme = "Default",
   
   ToggleUIKeybind = Enum.KeyCode.K,
   
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,
   
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "BackflipHub"
   },
   
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   
   KeySystem = false,
})

Rayfield:Notify({
   Title = "Backflip Hub by ReposeTaPeur",
   Content = "Advanced Mag Rail Tech loaded!",
   Duration = 3,
   Image = nil,
})

-- Create Tabs
local MainTab = Window:CreateTab("🏠 Main", nil)
local HelpTab = Window:CreateTab("❓ Help", nil)

local MainSection = MainTab:CreateSection("Mag Rail Tech")

-- MAG RAIL TECH MODULE (ADVANCED)
local MagTechModule = {}
MagTechModule.Enabled = false
MagTechModule.IsPerforming = false
MagTechModule.KeyConnection = nil

-- Advanced Settings (fully adjustable)
MagTechModule.Settings = {
    FirstSpaceDelay = 0,        -- Delay between E and first Space (0 = simultaneous)
    CameraRotationDelay = 0.1,  -- Delay before rotating camera 180°
    SecondSpaceDelay = 0.05,    -- Delay after camera rotation before second Space
    HoldDuration = 0.07,        -- Minimum hold duration for keys
    CameraRotationSpeed = 1,    -- Multiplier for camera rotation (1 = instant)
}

-- Virtual Input Manager
local VIM = game:GetService("VirtualInputManager")

-- Optimized key press function
local function PressKey(keyCode)
    VIM:SendKeyEvent(true, keyCode, false, game)
end

local function ReleaseKey(keyCode)
    VIM:SendKeyEvent(false, keyCode, false, game)
end

local function TapKey(keyCode, holdTime)
    holdTime = holdTime or MagTechModule.Settings.HoldDuration
    PressKey(keyCode)
    task.wait(holdTime)
    ReleaseKey(keyCode)
end

-- Advanced Mag Rail Tech Sequence
function MagTechModule.PerformMagTech()
    if MagTechModule.IsPerforming then return end
    
    MagTechModule.IsPerforming = true
    
    -- STEP 1: Press E (Mag Rail activation)
    PressKey(Enum.KeyCode.E)
    
    -- STEP 2: Immediately (or with tiny delay) press Space (first jump)
    if MagTechModule.Settings.FirstSpaceDelay > 0 then
        task.wait(MagTechModule.Settings.FirstSpaceDelay)
    end
    PressKey(Enum.KeyCode.Space)
    
    -- Hold both keys briefly
    task.wait(MagTechModule.Settings.HoldDuration)
    
    -- Release both
    ReleaseKey(Enum.KeyCode.E)
    ReleaseKey(Enum.KeyCode.Space)
    
    -- STEP 3: Wait before camera rotation
    task.wait(MagTechModule.Settings.CameraRotationDelay)
    
    -- STEP 4: Rotate camera 180° (instant or smooth based on speed setting)
    local rotationAmount = math.rad(180)
    
    if MagTechModule.Settings.CameraRotationSpeed >= 1 then
        -- Instant rotation
        Camera.CFrame = Camera.CFrame * CFrame.Angles(0, rotationAmount, 0)
    else
        -- Smooth rotation (if user wants gradual turn)
        local steps = math.ceil(10 * (1 - MagTechModule.Settings.CameraRotationSpeed + 0.1))
        local anglePerStep = rotationAmount / steps
        for i = 1, steps do
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, anglePerStep, 0)
            task.wait(0.01)
        end
    end
    
    -- STEP 5: Wait before second space
    task.wait(MagTechModule.Settings.SecondSpaceDelay)
    
    -- STEP 6: Press Space again (reverse momentum boost)
    TapKey(Enum.KeyCode.Space, MagTechModule.Settings.HoldDuration)
    
    MagTechModule.IsPerforming = false
end

-- Enable auto mag tech
function MagTechModule.Enable()
    if MagTechModule.Enabled then return end
    
    MagTechModule.Enabled = true
    
    -- Listen for E key press
    MagTechModule.KeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.E then
            if MagTechModule.Enabled and not MagTechModule.IsPerforming then
                task.spawn(MagTechModule.PerformMagTech)
            end
        end
    end)
    
    Rayfield:Notify({
        Title = "Mag Tech",
        Content = "Enabled - Press E on wall contact",
        Duration = 2,
        Image = nil,
    })
end

-- Disable auto mag tech
function MagTechModule.Disable()
    if not MagTechModule.Enabled then return end
    
    MagTechModule.Enabled = false
    
    if MagTechModule.KeyConnection then
        MagTechModule.KeyConnection:Disconnect()
        MagTechModule.KeyConnection = nil
    end
    
    Rayfield:Notify({
        Title = "Mag Tech",
        Content = "Disabled",
        Duration = 2,
        Image = nil,
    })
end

-- ========================================
-- MAIN TAB UI ELEMENTS
-- ========================================

-- Enable Toggle
local MagTechToggle = MainTab:CreateToggle({
   Name = "Auto Mag Tech",
   CurrentValue = false,
   Flag = "MagTechToggle",
   Callback = function(Value)
       if Value then
           MagTechModule.Enable()
       else
           MagTechModule.Disable()
       end
   end,
})

-- Settings Section
local TimingSection = MainTab:CreateSection("Timing Settings")

-- First Space Delay
local FirstSpaceDelaySlider = MainTab:CreateSlider({
   Name = "E → Space Delay",
   Range = {0, 0.2},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0,
   Flag = "FirstSpaceDelay",
   Callback = function(Value)
       MagTechModule.Settings.FirstSpaceDelay = Value
   end,
})

-- Camera Rotation Delay
local CameraDelaySlider = MainTab:CreateSlider({
   Name = "Before Camera Rotation",
   Range = {0.09, 0.5},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.09,
   Flag = "CameraDelay",
   Callback = function(Value)
       MagTechModule.Settings.CameraRotationDelay = Value
   end,
})

-- Second Space Delay
local SecondSpaceDelaySlider = MainTab:CreateSlider({
   Name = "After Camera → Space",
   Range = {0.03, 0.3},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.03,
   Flag = "SecondSpaceDelay",
   Callback = function(Value)
       MagTechModule.Settings.SecondSpaceDelay = Value
   end,
})

-- Hold Duration
local HoldDurationSlider = MainTab:CreateSlider({
   Name = "Key Hold Duration",
   Range = {0.08, 0.5},
   Increment = 0.01,
   Suffix = "s",
   CurrentValue = 0.09,
   Flag = "HoldDuration",
   Callback = function(Value)
       MagTechModule.Settings.HoldDuration = Value
   end,
})

-- Camera Rotation Speed
local CameraSpeedSlider = MainTab:CreateSlider({
   Name = "Camera Rotation Speed",
   Range = {0.1, 1},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "CameraSpeed",
   Callback = function(Value)
       MagTechModule.Settings.CameraRotationSpeed = Value
   end,
})

-- Test Button
local TestSection = MainTab:CreateSection("Testing")

local TestButton = MainTab:CreateButton({
   Name = "Test Mag Tech Now",
   Callback = function()
       if not MagTechModule.IsPerforming then
           task.spawn(MagTechModule.PerformMagTech)
       else
           Rayfield:Notify({
               Title = "Mag Tech",
               Content = "Already performing!",
               Duration = 1,
               Image = nil,
           })
       end
   end,
})

-- Status Section
local StatusSection = MainTab:CreateSection("Status")

local StatusParagraph = MainTab:CreateParagraph({
   Title = "Current Status",
   Content = "Mag Tech: Disabled\nPerforming: No"
})

-- Update status
task.spawn(function()
    while true do
        task.wait(1)
        
        local enabledStatus = MagTechModule.Enabled and "Enabled" or "Disabled"
        local performingStatus = MagTechModule.IsPerforming and "Yes" or "No"
        
        StatusParagraph:Set({
            Title = "Current Status",
            Content = "Mag Tech: " .. enabledStatus .. "\nPerforming: " .. performingStatus
        })
    end
end)

-- Keybinds Section
local KeybindsSection = MainTab:CreateSection("Keybinds")

local KeybindParagraph = MainTab:CreateParagraph({
   Title = "Controls",
   Content = "E - Activate Mag Tech (when enabled)\nRightShift - Toggle UI"
})

-- ========================================
-- HELP TAB
-- ========================================

local MagTechHelpSection = HelpTab:CreateSection("📘 Mag Rail Tech Explained")

local MagTechExplanation = HelpTab:CreateParagraph({
   Title = "What is Mag Rail Tech?",
   Content = "Mag Rail Tech is an advanced parkour technique in Parkour Legacy that combines Mag Rail abilities with momentum manipulation to achieve rapid directional changes and speed boosts."
})

local HowItWorksSection = HelpTab:CreateSection("🔧 How It Works")

local Step1 = HelpTab:CreateParagraph({
   Title = "Step 1: Wall Contact",
   Content = "• You wall-run or hit a wall (either side)\n• Game recognizes you as attached to a surface\n• You're now eligible for Mag Rail abilities"
})

local Step2 = HelpTab:CreateParagraph({
   Title = "Step 2: Mag Activation (E)",
   Content = "• Press E to trigger Mag ability (Mag Bounce/Dash)\n• Creates directional impulse outward from wall\n• Based on camera's facing direction\n• Impulse points away from wall + slightly up/forward"
})

local Step3 = HelpTab:CreateParagraph({
   Title = "Step 3: First Jump (Space)",
   Content = "• Immediately press Space after E\n• Game stacks jump vector on top of Mag impulse\n• Combined force = 'away from wall' + 'jump' momentum\n• Creates initial boost"
})

local Step4 = HelpTab:CreateParagraph({
   Title = "Step 4: Camera Rotation (180°)",
   Content = "• Quickly rotate camera 180 degrees\n• Physics impulse doesn't change\n• But character input direction (WASD/jump) does\n• Your momentum vector now faces opposite direction\n• Reversed travel direction while keeping Mag momentum"
})

local Step5 = HelpTab:CreateParagraph({
   Title = "Step 5: Second Jump (Space)",
   Content = "• Press Space again after camera rotation\n• If near another wall: immediate re-attach possible\n• Game remembers previous Mag impulse\n• Get boost backward = reverse slingshot effect\n• Can wall-run, climb, or Mag Bounce again"
})

local UsageSection = HelpTab:CreateSection("🎮 How to Use This Script")

local Usage = HelpTab:CreateParagraph({
   Title = "Script Usage",
   Content = "1. Toggle 'Auto Mag Tech' ON in Main tab\n2. Position yourself near a wall\n3. Wall-run or touch the wall\n4. Press E - the script automatically:\n   • Presses E + Space\n   • Rotates camera 180°\n   • Presses Space again\n   • Perfect timing every time!\n\n5. Adjust timing sliders to match your playstyle"
})

local SettingsGuideSection = HelpTab:CreateSection("⚙️ Settings Guide")

local SettingsGuide = HelpTab:CreateParagraph({
   Title = "Timing Settings Explained",
   Content = "E → Space Delay: Time between E press and first Space\n• 0s = Simultaneous (recommended)\n• 0.01-0.05s = Slight delay\n\nBefore Camera Rotation: Wait time before turning\n• 0.05-0.15s = Quick rotation\n• 0.2-0.5s = Delayed rotation\n\nAfter Camera → Space: Time after rotation before 2nd Space\n• 0s = Instant\n• 0.05-0.1s = Standard timing\n\nKey Hold Duration: How long to hold keys\n• 0.07s = Minimum (fastest)\n• 0.1-0.2s = Standard\n• 0.3-0.5s = Extended hold\n\nCamera Rotation Speed:\n• 1 = Instant 180° turn\n• 0.5 = Smooth rotation\n• 0.1 = Very smooth (slower)"
})

local TipsSection = HelpTab:CreateSection("💡 Pro Tips")

local Tips = HelpTab:CreateParagraph({
   Title = "Tips for Success",
   Content = "• Start with default settings, then adjust\n• Practice on simple walls first\n• Make sure you have wall contact before pressing E\n• If it feels too fast, increase delays\n• If it feels slow, decrease delays\n• Camera rotation speed affects consistency\n• Lower hold duration = faster execution\n• Test button helps you find perfect timing"
})

-- Credits Section
local CreditsSection = HelpTab:CreateSection("📝 Credits")

local Credits = HelpTab:CreateParagraph({
   Title = "Backflip Hub v2.0",
   Content = "Advanced Mag Rail Tech Automation\n\nMade for: Parkour Legacy\nFeatures:\n• Fully automated Mag Rail Tech\n• Adjustable timing system\n• No lag/performance impact\n• Organized help system\n• Real-time status updates\n\nCreated for advanced parkour players who want consistent Mag Tech execution."
})
