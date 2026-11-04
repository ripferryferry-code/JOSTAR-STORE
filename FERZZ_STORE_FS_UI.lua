--[[
    FERZZ STORE [ FS ] - SAFE UI TEMPLATE
    File: FERZZ_STORE_FS_UI.lua

    Intended for a Roblox experience you own, used as a LocalScript
    under StarterPlayer > StarterPlayerScripts or StarterGui.

    This is a UI template, not the original South Bronx executor script.
    It does not include executor APIs, farming automation, anti-kick,
    anti-ban, remote-event abuse, or queue-on-teleport code.
]]

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FERZZ_STORE_UI")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FERZZ_STORE_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local scale = Instance.new("UIScale")
scale.Scale = 0.82
scale.Parent = gui

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.fromOffset(310, 212)
main.Position = UDim2.new(0.5, -155, 0.5, -106)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 11)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 35, 35)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 25)
title.Position = UDim2.fromOffset(15, 10)
title.BackgroundTransparency = 1
title.Text = "FERZZ STORE [ FS ]"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 55, 55)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 16)
subtitle.Position = UDim2.fromOffset(15, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SAFE UI TEMPLATE"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9
subtitle.TextColor3 = Color3.fromRGB(145, 145, 155)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.fromOffset(15, 59)
divider.BackgroundColor3 = Color3.fromRGB(55, 35, 35)
divider.BorderSizePixel = 0
divider.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 30)
status.Position = UDim2.fromOffset(15, 70)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextColor3 = Color3.fromRGB(220, 220, 225)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextWrapped = true
status.Parent = main

local rejoin = Instance.new("TextButton")
rejoin.Name = "RejoinButton"
rejoin.Size = UDim2.new(1, -30, 0, 32)
rejoin.Position = UDim2.fromOffset(15, 108)
rejoin.BackgroundColor3 = Color3.fromRGB(190, 25, 25)
rejoin.BorderSizePixel = 0
rejoin.Text = "REJOIN SERVER"
rejoin.Font = Enum.Font.GothamBold
rejoin.TextSize = 11
rejoin.TextColor3 = Color3.new(1, 1, 1)
rejoin.AutoButtonColor = true
rejoin.Parent = main

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoin

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -30, 0, 42)
note.Position = UDim2.fromOffset(15, 151)
note.BackgroundTransparency = 1
note.Text = "Rejoin works in experiences you own or are authorized to test."
note.Font = Enum.Font.Gotham
note.TextSize = 9
note.TextColor3 = Color3.fromRGB(145, 145, 155)
note.TextWrapped = true
note.TextXAlignment = Enum.TextXAlignment.Left
note.TextYAlignment = Enum.TextYAlignment.Top
note.Parent = main

local busy = false
rejoin.Activated:Connect(function()
    if busy then return end
    busy = true
    status.Text = "Status: Requesting rejoin..."
    rejoin.Text = "CONNECTING..."
    local ok, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
    if not ok then
        status.Text = "Status: Rejoin failed"
        rejoin.Text = "REJOIN SERVER"
        busy = false
        warn("[FERZZ STORE] Teleport failed: " .. tostring(err))
    end
end)

TeleportService.TeleportInitFailed:Connect(function(failedPlayer, result, message)
    if failedPlayer ~= player then return end
    busy = false
    rejoin.Text = "REJOIN SERVER"
    status.Text = "Status: Teleport failed (" .. tostring(result) .. ")"
    warn("[FERZZ STORE] Teleport init failed: " .. tostring(message))
end)

-- Drag panel by the header; works with touch and mouse.
local dragging = false
local dragInput
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- F3 toggles the panel on keyboard devices.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F3 then
        gui.Enabled = not gui.Enabled
    end
end)

print("[FERZZ STORE] Safe UI template loaded.")
