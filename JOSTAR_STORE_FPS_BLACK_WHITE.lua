--[[
    JOSTAR STORE | FPS OPTIMIZER
    Black & White Edition | Mobile / PC
    Note: This client-side visual optimizer cannot guarantee higher FPS.
]]

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local settings = {
    removePostEffects = true,
    disableShadows = true,
    flatMaterials = true,
    hideDecals = true,
    flatTerrain = true,
    qualityLevel = 1,
    physicsSleep = true,
}

local originalData = {
    effects = {},
    parts = {},
    decals = {},
    terrain = nil,
    globalShadows = Lighting.GlobalShadows,
    fogEnd = Lighting.FogEnd,
    brightness = Lighting.Brightness,
}

local masterEnabled = false
local minimized = false

local function isCharacterPart(instance)
    return player.Character and instance:IsDescendantOf(player.Character)
end

local function applyPostEffects(enabled)
    if enabled then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") and originalData.effects[v] == nil then
                originalData.effects[v] = v.Enabled
                v.Enabled = false
            end
        end
    else
        for effect, wasEnabled in pairs(originalData.effects) do
            if effect and effect.Parent then
                effect.Enabled = wasEnabled
            end
        end
    end
end

local function applyShadows(disabled)
    Lighting.GlobalShadows = not disabled
end

local function applyMaterials(enabled)
    for _, instance in ipairs(workspace:GetDescendants()) do
        if instance:IsA("BasePart") and not isCharacterPart(instance) then
            if enabled then
                if not originalData.parts[instance] then
                    originalData.parts[instance] = {
                        Material = instance.Material,
                        Reflectance = instance.Reflectance,
                    }
                end
                instance.Material = Enum.Material.SmoothPlastic
                instance.Reflectance = 0
            elseif originalData.parts[instance] then
                instance.Material = originalData.parts[instance].Material
                instance.Reflectance = originalData.parts[instance].Reflectance
            end
        end
    end
end

local function applyDecals(enabled)
    for _, instance in ipairs(workspace:GetDescendants()) do
        if (instance:IsA("Texture") or instance:IsA("Decal")) and not isCharacterPart(instance) then
            if enabled then
                if originalData.decals[instance] == nil then
                    originalData.decals[instance] = instance.Transparency
                end
                instance.Transparency = 1
            elseif originalData.decals[instance] ~= nil then
                instance.Transparency = originalData.decals[instance]
            end
        end
    end
end

local function applyTerrain(enabled)
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if not terrain then return end

    if enabled then
        if not originalData.terrain then
            originalData.terrain = {
                WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed,
                WaterReflectance = terrain.WaterReflectance,
                WaterTransparency = terrain.WaterTransparency,
            }
        end
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
    elseif originalData.terrain then
        terrain.WaterWaveSize = originalData.terrain.WaterWaveSize
        terrain.WaterWaveSpeed = originalData.terrain.WaterWaveSpeed
        terrain.WaterReflectance = originalData.terrain.WaterReflectance
        terrain.WaterTransparency = originalData.terrain.WaterTransparency
    end
end

local function applyQuality(level)
    -- Roblox does not expose a supported universal client API for forcing
    -- render quality from an ordinary LocalScript; keep this best-effort.
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel =
            Enum.SavedQualitySetting["QualityLevel" .. tostring(math.clamp(level, 1, 10))]
    end)
end

local function applyPhysics(enabled)
    -- Physics settings are not reliably writable from a normal LocalScript.
    pcall(function()
        settings().Physics.AllowSleep = enabled
    end)
end

local function applyAll()
    applyPostEffects(settings.removePostEffects)
    applyShadows(settings.disableShadows)
    applyMaterials(settings.flatMaterials)
    applyDecals(settings.hideDecals)
    applyTerrain(settings.flatTerrain)
    applyQuality(settings.qualityLevel)
    applyPhysics(settings.physicsSleep)
end

local function revertAll()
    applyPostEffects(false)
    applyShadows(false)
    applyMaterials(false)
    applyDecals(false)
    applyTerrain(false)
    Lighting.GlobalShadows = originalData.globalShadows
    Lighting.FogEnd = originalData.fogEnd
    Lighting.Brightness = originalData.brightness
end

workspace.DescendantAdded:Connect(function(instance)
    if not masterEnabled then return end
    if isCharacterPart(instance) then return end

    if settings.flatMaterials and instance:IsA("BasePart") then
        originalData.parts[instance] = originalData.parts[instance] or {
            Material = instance.Material,
            Reflectance = instance.Reflectance,
        }
        instance.Material = Enum.Material.SmoothPlastic
        instance.Reflectance = 0
    end

    if settings.hideDecals and (instance:IsA("Texture") or instance:IsA("Decal")) then
        if originalData.decals[instance] == nil then
            originalData.decals[instance] = instance.Transparency
        end
        instance.Transparency = 1
    end
end)

local oldGui = playerGui:FindFirstChild("JOSTAR_STORE_FPS")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JOSTAR_STORE_FPS"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0, 16, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(235, 235, 235)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "JOSTAR STORE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local masterBtn = Instance.new("TextButton")
masterBtn.Size = UDim2.new(0, 42, 0, 24)
masterBtn.Position = UDim2.new(1, -82, 0.5, -12)
masterBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
masterBtn.Text = "OFF"
masterBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
masterBtn.TextSize = 11
masterBtn.Font = Enum.Font.GothamBold
masterBtn.BorderSizePixel = 0
masterBtn.Parent = titleBar

local masterCorner = Instance.new("UICorner")
masterCorner.CornerRadius = UDim.new(0, 6)
masterCorner.Parent = masterBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -34, 0.5, -14)
minBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minBtn

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -44)
content.Position = UDim2.new(0, 0, 0, 44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(220, 220, 220)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 0)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft = UDim.new(0, 14)
contentPad.PaddingRight = UDim.new(0, 14)
contentPad.PaddingTop = UDim.new(0, 10)
contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.Parent = content

local function makeToggle(labelText, description, defaultOn, layoutOrder, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 56)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    row.BorderSizePixel = 0
    row.LayoutOrder = layoutOrder
    row.Parent = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -64, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(245, 245, 245)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -64, 0, 16)
    desc.Position = UDim2.new(0, 12, 0, 30)
    desc.BackgroundTransparency = 1
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(165, 165, 165)
    desc.TextSize = 11
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = row

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 22)
    toggleBg.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBg.BackgroundColor3 = defaultOn and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(65, 65, 65)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = row

    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = toggleBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local spacer = Instance.new("Frame")
    spacer.Size = UDim2.new(1, 0, 0, 6)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = layoutOrder + 0.1
    spacer.Parent = content

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    local isOn = defaultOn
    btn.Activated:Connect(function()
        isOn = not isOn
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        TweenService:Create(toggleBg, tweenInfo, {
            BackgroundColor3 = isOn and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(65, 65, 65)
        }):Play()
        TweenService:Create(knob, tweenInfo, {
            Position = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        callback(isOn)
    end)
end

local function makeSection(sectionText, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.BackgroundTransparency = 1
    lbl.Text = sectionText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = layoutOrder
    lbl.Parent = content
end

local function makeSlider(labelText, min, max, default, layoutOrder, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 64)
    row.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    row.BorderSizePixel = 0
    row.LayoutOrder = layoutOrder
    row.Parent = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(245, 245, 245)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 38, 0, 18)
    valLabel.Position = UDim2.new(1, -50, 0, 10)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    valLabel.TextSize = 13
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0, 40)
    track.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    track.BorderSizePixel = 0
    track.Parent = row

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local pct = (default - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 14, 0, 14)
    thumb.Position = UDim2.new(pct, -7, 0.5, -7)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 2
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb

    local spacer = Instance.new("Frame")
    spacer.Size = UDim2.new(1, 0, 0, 6)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = layoutOrder + 0.1
    spacer.Parent = content

    local dragging = false
    local trackBtn = Instance.new("TextButton")
    trackBtn.Size = UDim2.new(1, 0, 0, 24)
    trackBtn.Position = UDim2.new(0, 0, 0, 32)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text = ""
    trackBtn.ZIndex = 3
    trackBtn.Parent = row

    local function updateSlider(screenX)
        local trackAbs = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        if trackSize.X <= 0 then return end
        local relX = math.clamp((screenX - trackAbs.X) / trackSize.X, 0, 1)
        local value = math.round(min + relX * (max - min))
        valLabel.Text = tostring(value)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        thumb.Position = UDim2.new(relX, -7, 0.5, -7)
        callback(value)
    end

    trackBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeSection("LIGHTING", 0)
makeToggle("Remove Post Effects", "Disable bloom, blur and color effects", settings.removePostEffects, 1, function(v)
    settings.removePostEffects = v
    if masterEnabled then applyPostEffects(v) end
end)
makeToggle("Disable Shadows", "Turn off global shadows", settings.disableShadows, 2, function(v)
    settings.disableShadows = v
    if masterEnabled then applyShadows(v) end
end)

makeSection("WORLD", 10)
makeToggle("Flat Materials", "Use SmoothPlastic on parts", settings.flatMaterials, 11, function(v)
    settings.flatMaterials = v
    if masterEnabled then applyMaterials(v) end
end)
makeToggle("Hide Decals & Textures", "Hide world decals and textures", settings.hideDecals, 12, function(v)
    settings.hideDecals = v
    if masterEnabled then applyDecals(v) end
end)
makeToggle("Flat Terrain Water", "Reduce water effects", settings.flatTerrain, 13, function(v)
    settings.flatTerrain = v
    if masterEnabled then applyTerrain(v) end
end)

makeSection("PERFORMANCE", 20)
makeSlider("Render Quality (best effort)", 1, 10, settings.qualityLevel, 21, function(v)
    settings.qualityLevel = v
    if masterEnabled then applyQuality(v) end
end)
makeToggle("Physics Sleep (best effort)", "May not be writable in every executor", settings.physicsSleep, 22, function(v)
    settings.physicsSleep = v
    if masterEnabled then applyPhysics(v) end
end)

-- Minimize / restore
minBtn.Activated:Connect(function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 44)}):Play()
        content.Visible = false
        minBtn.Text = "+"
    else
        content.Visible = true
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 280, 0, 380)}):Play()
        minBtn.Text = "–"
    end
end)

masterBtn.Activated:Connect(function()
    masterEnabled = not masterEnabled
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
    if masterEnabled then
        masterBtn.Text = "ON"
        TweenService:Create(masterBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(235, 235, 235),
            TextColor3 = Color3.fromRGB(15, 15, 15),
        }):Play()
        applyAll()
    else
        masterBtn.Text = "OFF"
        TweenService:Create(masterBtn, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(65, 65, 65),
            TextColor3 = Color3.fromRGB(220, 220, 220),
        }):Play()
        revertAll()
    end
end)

-- Drag support for touch and mouse (header only).
local dragging = false
local dragInput
local dragStart
local startPosition

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)
