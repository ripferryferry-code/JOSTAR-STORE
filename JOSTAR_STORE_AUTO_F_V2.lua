-- JOSTAR STORE | AUTO F V2
-- Mobile UI | Black & White
-- Toggle ON/OFF
-- Note: VirtualInputManager may be restricted by some mobile executors.

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local enabled = false
local running = true

local gui = Instance.new("ScreenGui")
gui.Name = "JOSTAR_AUTO_F"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(170, 85)
frame.Position = UDim2.new(0.5, -85, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "JOSTAR STORE"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -16, 0, 36)
btn.Position = UDim2.new(0, 8, 0, 40)
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 13
btn.Text = "AUTO F : OFF"
btn.Parent = frame

btn.Activated:Connect(function()
    enabled = not enabled
    btn.Text = enabled and "AUTO F : ON" or "AUTO F : OFF"
end)

gui.Destroying:Connect(function()
    running = false
    enabled = false
end)

task.spawn(function()
    while running and gui.Parent do
        if enabled then
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end)
            task.wait(0.1)
        else
            task.wait(0.1)
        end
    end
end)
