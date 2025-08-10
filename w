local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local teleportPoints = {
    {"TP1", Vector3.new(4479, 44, 1642)},
    {"TP2", Vector3.new(4949, -64, 1201)},
    {"TP3", Vector3.new(-1228, -165, -999)},
    {"TP4", Vector3.new(-1341, -122, -941)},
    {"TP5", Vector3.new(-3910, -255, -1103)},
    {"TP6", Vector3.new(-95, 0, -2334)},
    {"TP7", Vector3.new(34, 6, 0)},
    {"TP8", Vector3.new(-97, 47, -5)},
    {"TP9", Vector3.new(171, 53, -2937)},
    {"TP10", Vector3.new(117, 45, -2470)},
    {"TP11", Vector3.new(-61, 52, -2930)},
}

-- Create GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 110, 0.6, 0) -- width 110px, height 60% of screen
scrollFrame.Position = UDim2.new(1, -120, 0.2, 0) -- right side of screen
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- will update dynamically
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.Parent = screenGui

-- Layout manager
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = scrollFrame

-- Create buttons
local buttonWidth = 100
local buttonHeight = 30

for i, tp in ipairs(teleportPoints) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = tp[1]
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(tp[2])
        end
    end)
end

-- Adjust scroll size automatically
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)
