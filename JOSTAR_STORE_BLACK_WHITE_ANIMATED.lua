-- ============================================================
--  JOSTAR STORE - UI MODERN KECIL + SLIDE 1-45
-- ============================================================
--  CHANGES: UG_SPEED=20, Buy Max=45, JOSTAR STORE
-- ============================================================

-- ============================================================
--  AUTO CLICK PLAY - PASTI JALAN DI AWAL!
-- ============================================================
local function ClickPlay()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return false end
    
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end
    
    local intro = PlayerGui:FindFirstChild("IntroUI")
    if not intro then
        return true
    end
    
    local playButton = nil
    for _, obj in pairs(intro:GetDescendants()) do
        if obj:IsA("ImageButton") and obj.Name == "Play" then
            playButton = obj
            break
        end
    end
    
    if not playButton then
        return false
    end
    
    pcall(function()
        playButton.MouseButton1Click:Fire()
    end)
    
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        if VIM then
            local pos = playButton.AbsolutePosition
            local size = playButton.AbsoluteSize
            if pos.X > 0 and pos.Y > 0 then
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, game, 0)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 0)
            end
        end
    end)
    
    pcall(function()
        local conns = getconnections(playButton.MouseButton1Click)
        if conns then
            for _, conn in pairs(conns) do
                conn:Fire()
            end
        end
    end)
    
    task.wait(1)
    return true
end

-- ============================================================
--  EXECUTE AUTO CLICK PLAY
-- ============================================================
local maxAttempts = 5
local attempts = 0
local clicked = false

while attempts < maxAttempts do
    local success = ClickPlay()
    if success then
        clicked = true
        break
    end
    attempts = attempts + 1
    task.wait(1)
end

-- ============================================================
--  HYPHON EMULATOR
-- ============================================================
if not filtergc then
    filtergc = function(ftype, filters, returnSingle)
        local results = {}
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "function" then
                local ok, info = pcall(debug.getinfo, obj)
                if ok and info then
                    local match = true
                    if filters.StartLine and info.linedefined ~= filters.StartLine then match = false end
                    if filters.Source and info.source ~= filters.Source then match = false end
                    if match then
                        if returnSingle then return obj end; table.insert(results, obj)
                    end
                end
            end
        end
        if returnSingle then return nil end; return results
    end
end

if not getnilinstances then getnilinstances = function() return {} end end
if not bit32 then bit32 = {} end
if not bit32.bxor then
    bit32.bxor = function(a, b)
        local result, bit = 0, 1
        while a > 0 or b > 0 do
            if (a % 2) ~= (b % 2) then result = result + bit end
            a, b, bit = math.floor(a / 2), math.floor(b / 2), bit * 2
        end
        return result
    end
end

local emOk, emErr = pcall(function()
    local gv = getgenv()
    local function tryFind(name, ln)
        local fn = filtergc("function", { StartLine = ln }, true)
        if type(fn) ~= "function" then fn = (type(fn) == "table" and #fn > 0 and fn[1]) or nil end
        if not fn then local all = filtergc("function", { StartLine = ln })
            if type(all) == "table" and #all > 0 then fn = all[1] end end
        if fn then gv[name] = fn end; return fn
    end
    gv.Hyphon_2102 = tryFind("Hyphon_2102", 2102)
    gv.Hyphon_2247 = tryFind("Hyphon_2247", 2247)
    gv.Hyphon_2846 = tryFind("Hyphon_2846", 2846)
    gv.Hyphon_fake_dec = tryFind("Hyphon_fake_dec", 1097)
    if gv.Hyphon_2102 then
        gv.Hyphon_Encode = debug.getupvalue(gv.Hyphon_2102, 1)
        gv.Hyphon_Decode = debug.getupvalue(gv.Hyphon_2102, 21)
    end
    gv.Hyphon_Script = nil
    pcall(function()
        for _, o in pairs(getnilinstances()) do
            if o:IsA("Script") and o.Name:len() == 32 then gv.Hyphon_Script = o; break end
        end
    end)
    if gv.Hyphon_2102 and gv.Hyphon_2247 and gv.Hyphon_2846 and gv.Hyphon_fake_dec then
        pcall(function()
            local HC = cloneref(game:GetService("MemoryStoreService")):FindFirstChild("Hyphon_Check")
            local RF = debug.getupvalue(gv.Hyphon_2247, 6)
            if HC then local o = hookfunction(HC.FireServer, function(s, ...) return o(s, ...) end) end
            if RF then local o = hookfunction(RF.InvokeServer, function(s, ...)
                local a = table.pack(...)
                if type(a[1]) == "table" and a[1][1] then gv.T1 = a[1][1]; gv.T2 = a[1][2]; gv.T3 = a[1][6]; gv.T4 = a[1][11] end
                return o(s, ...)
            end) end
        end)
        if bit32 and bit32.bxor and gv.Hyphon_Script and checkcaller and getcallingscript then
            pcall(function()
                local o = hookfunction(bit32.bxor, function(a, b)
                    if not checkcaller() and getcallingscript() == gv.Hyphon_Script then return task.wait(9e9) end
                    return o(a, b)
                end)
            end)
        end
    end
    pcall(function()
        for _, Object in pairs(getgc(true)) do
            if typeof(Object) == "table" and typeof(rawget(Object, "Homeless")) == "table" then
                if rawget(Object.Homeless, "MaxDistance") then Object.Homeless.MaxDistance = 9e9 end
            end
        end
    end)
end)

getgenv().HyphonReady = true
getgenv().Emulator_Set = true

pcall(function()
    local player = game:GetService("Players").LocalPlayer
    if player then player.Kick = function() return end end
    game:GetService("Players").Kick = function() return end
end)

-- KICK POPUP DESTROYER
task.spawn(function()
    while getgenv().FULLY_MS_V1 do
        pcall(function()
            local coregui = game:GetService("CoreGui")
            local playerGui = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.PlayerGui
            for _, gui in pairs(coregui:GetChildren()) do
                local name = gui.Name or ""
                if name:find("Kick") or name:find("Ban") or name:find("Disconnect") or
                   name:find("Error") or name:find("Moderation") or name:find("Warning") or
                   name:find("Alert") or name:find("Popup") or name:find("Notice") or
                   name:find("Detection") or name:find("Anti") or name:find("Handshake") then
                    gui:Destroy()
                end
            end
            if playerGui then
                for _, gui in pairs(playerGui:GetChildren()) do
                    local name = gui.Name or ""
                    if name:find("Kick") or name:find("Ban") or name:find("Disconnect") or
                       name:find("Error") or name:find("Moderation") or name:find("Warning") or
                       name:find("Detection") or name:find("Anti") or name:find("Handshake") then
                        gui:Destroy()
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

print("✅ HYPHON EMULATOR BYPASS ACTIVE")

-- ============================================================
-- 📦 SERVICES
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LogService = game:GetService("LogService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Player = LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ============================================================
-- 📦 REMOTE EVENT
-- ============================================================
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ReliableRemoteEvent")
local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)

-- ============================================================
-- 🏢 APARTMENT NAMES & COORDINATES
-- ============================================================
local APRT_NAMES = {
    "CompactWalkupAPT1", "CompactWalkupAPT2", "CompactWalkupAPT3",
    "CompactWalkupAPT4", "CompactWalkupAPT5", "CompactWalkupAPT6",
}

local APRT_COORDS = {
    ["CompactWalkupAPT1"] = Vector3.new(897.535, 10.093, 40.186),
    ["CompactWalkupAPT2"] = Vector3.new(925.972, 10.093, 40.267),
    ["CompactWalkupAPT3"] = Vector3.new(985.743, 10.093, 248.035),
    ["CompactWalkupAPT4"] = Vector3.new(985.899, 10.093, 219.997),
    ["CompactWalkupAPT5"] = Vector3.new(1141.123, 10.093, 422.462),
    ["CompactWalkupAPT6"] = Vector3.new(1141.049, 10.093, 451.013),
}

-- ============================================================
-- 🔧 STATE — BUY MAX = 45
-- ============================================================
local BUY_MAX = 45    -- ✅ Max buy amount
local BUY_MIN = 1

local FarmSettings = {
    OffsetY = 5,
    Amount = 8,
    ApartmentCost = 500,
    IngredientCost = 190,
}

local FarmState = {
    Cycles = 0,
    Status = "Idle",
    Sold = 0,
    MarshmallowsMade = 0,
    OwnedAprt = nil,
    TotalIncome = 0,
    TotalExpense = 0,
    PreviousCash = 0,
    CurrentCash = 0,
    CashInitialized = false,
    BatchProgress = "0/0",
    CurrentBatch = 0,
    Step = "Idle",
    Runtime = 0,
    StartTime = os.time(),
    Profit = 0,
}

local FarmRunning = false
local StopRequest = false
local FarmThread = nil
local StartTime = os.time()

-- ============================================================
-- 🔧 KONFIGURASI XRAY
-- ============================================================
local CONFIG = { Enabled = true, MaxDistance = 10, Transparency = 0.95 }

local function GetCleanedObjects()
    local objects = {}
    local map = Workspace:FindFirstChild("Map")
    if not map then return objects end
    local apartments = map:FindFirstChild("Apartments")
    if not apartments then return objects end
    for _, apt in pairs(apartments:GetChildren()) do
        if apt:IsA("Model") or apt:IsA("Folder") then
            local interior = apt:FindFirstChild("Interior") or apt
            interior = apt:FindFirstChild("floor") or apt
            for _, obj in pairs(interior:GetDescendants()) do
                if obj:IsA("BasePart") then
                    if obj.Name == "Cooking Pot" then continue end
                    local parent = obj.Parent
                    local isBoard = false
                    while parent do
                        if parent.Name == "Board" then isBoard = true; break end
                        parent = parent.Parent
                    end
                    if isBoard then continue end
                    local parent2 = obj.Parent
                    local isPlayer = false
                    while parent2 do
                        if parent2:IsA("Model") and parent2:FindFirstChild("Humanoid") then isPlayer = true; break end
                        parent2 = parent2.Parent
                    end
                    if isPlayer then continue end
                    table.insert(objects, obj)
                end
            end
        end
    end
    return objects
end

local objectCache = {}
local transparencyCache = {}
local allObjects = {}
local cacheValid = false
local objectCount = 0

local function UpdateObjectCache()
    allObjects = GetCleanedObjects()
    cacheValid = true
    objectCount = #allObjects
    for _, obj in pairs(allObjects) do
        if not transparencyCache[obj] then
            pcall(function() transparencyCache[obj] = obj.Transparency or 0 end)
        end
    end
end

local updateCounter = 0
local Camera = workspace.CurrentCamera

local function UpdateXRay()
    if not CONFIG.Enabled then
        for obj, trans in pairs(transparencyCache) do
            pcall(function() if obj and obj.Parent then obj.Transparency = trans end end)
        end
        return
    end
    if not cacheValid then UpdateObjectCache(); return end
    if not Camera then return end
    local cameraPos = Camera.CFrame.Position
    local maxDist = CONFIG.MaxDistance
    local targetTrans = CONFIG.Transparency
    for _, obj in pairs(allObjects) do
        if not obj or not obj.Parent then
            transparencyCache[obj] = nil
        else
            local dist = (obj.Position - cameraPos).Magnitude
            local originalTrans = transparencyCache[obj] or 0
            local newTrans = originalTrans
            if dist < maxDist then
                local factor = 1 - (dist / maxDist)
                newTrans = math.min(originalTrans + (targetTrans * factor), 1)
            end
            pcall(function() if obj.Transparency ~= newTrans then obj.Transparency = newTrans end end)
        end
    end
end

local xrayConnection = nil

local function StartXRay()
    if xrayConnection then return end
    CONFIG.Enabled = true
    cacheValid = false
    UpdateObjectCache()
    xrayConnection = RunService.Heartbeat:Connect(function()
        updateCounter = updateCounter + 1
        if updateCounter >= 2 then
            updateCounter = 0
            pcall(UpdateXRay)
        end
    end)
end

local function StopXRay()
    CONFIG.Enabled = false
    if xrayConnection then xrayConnection:Disconnect(); xrayConnection = nil end
    for obj, trans in pairs(transparencyCache) do
        pcall(function() if obj and obj.Parent then obj.Transparency = trans end end)
    end
    print("🔮 X-Ray: OFF")
end

local function RefreshCache()
    cacheValid = false
    print("🔄 Refreshing X-Ray cache...")
end

local function SetupAutoRefresh()
    local map = Workspace:FindFirstChild("Map")
    if map then
        local apartments = map:FindFirstChild("Apartments")
        if apartments then
            apartments.ChildAdded:Connect(function() task.wait(0.5); RefreshCache() end)
            apartments.ChildRemoved:Connect(function() task.wait(0.5); RefreshCache() end)
        end
    end
end

-- ============================================================
-- 🎨 RGB NAME (FERZZ STORE) - AUTO ON
-- ============================================================
local RGBEnabled = false
local CurrentDisplayName = "JOSTAR STORE"
local RGBLoop = nil

local function GenerateRGB()
    local colors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 20, 147),
        Color3.fromRGB(0, 255, 127), Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(255, 215, 0), Color3.fromRGB(0, 191, 255),
        Color3.fromRGB(255, 105, 180), Color3.fromRGB(50, 205, 50),
        Color3.fromRGB(255, 140, 0), Color3.fromRGB(147, 112, 219),
        Color3.fromRGB(0, 250, 154), Color3.fromRGB(255, 69, 0),
        Color3.fromRGB(218, 112, 214), Color3.fromRGB(0, 206, 209),
    }
    return colors[math.random(1, #colors)]
end

local function SetDisplayName(name, color)
    pcall(function()
        local char = workspace.Characters:FindFirstChild(Player.Name)
        if char and char.Head then
            local nameTag = char.Head:FindFirstChild("NameTag")
            if nameTag and nameTag:FindFirstChild("MainFrame") then
                local nameLabel = nameTag.MainFrame:FindFirstChild("NameLabel")
                if nameLabel then
                    if name then nameLabel.Text = name end
                    if color then nameLabel.TextColor3 = color end
                end
            end
            local rankTag = char.Head:FindFirstChild("RankTag")
            if rankTag and rankTag:FindFirstChild("MainFrame") then
                local nameLabel = rankTag.MainFrame:FindFirstChild("NameLabel")
                if nameLabel then
                    if name then nameLabel.Text = name end
                    if color then nameLabel.TextColor3 = color end
                end
            end
            for _, child in pairs(char.Head:GetDescendants()) do
                if child:IsA("TextLabel") and child.Name:find("Name") then
                    if name then child.Text = name end
                    if color then child.TextColor3 = color end
                end
            end
        end
    end)
end

local function ApplyName()
    if RGBEnabled then SetDisplayName(CurrentDisplayName, GenerateRGB())
    else SetDisplayName(CurrentDisplayName, Color3.fromRGB(255, 255, 255)) end
end

local function StartRGBName()
    if RGBLoop then return end
    RGBEnabled = true
    ApplyName()
    RGBLoop = task.spawn(function()
        while RGBEnabled do
            task.wait(0.3)
            if RGBEnabled then SetDisplayName(nil, GenerateRGB()) end
        end
    end)
end

local function StopRGBName()
    RGBEnabled = false
    if RGBLoop then task.cancel(RGBLoop); RGBLoop = nil end
    SetDisplayName(nil, Color3.fromRGB(255, 255, 255))
end

-- ============================================================
-- 💰 CASH DETECTION
-- ============================================================
local function GetCurrentCash()
    local totalCash = 0
    local ls = Player:FindFirstChild("leaderstats")
    if ls then
        for _, stat in pairs(ls:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") or stat:IsA("StringValue") then
                pcall(function()
                    local val = stat.Value
                    if type(val) == "number" then totalCash = totalCash + val
                    elseif type(val) == "string" then
                        local num = tonumber(val)
                        if num then totalCash = totalCash + num end
                    end
                end)
            end
        end
    end
    for _, child in pairs(Player:GetChildren()) do
        if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("StringValue") then
            pcall(function()
                local val = child.Value
                if type(val) == "number" then totalCash = totalCash + val
                elseif type(val) == "string" then
                    local num = tonumber(val)
                    if num then totalCash = totalCash + num end
                end
            end)
        end
    end
    local stats = Player:FindFirstChild("Stats")
    if stats then
        for _, child in pairs(stats:GetChildren()) do
            if child:IsA("NumberValue") or child:IsA("IntValue") or child:IsA("StringValue") then
                pcall(function()
                    local val = child.Value
                    if type(val) == "number" then totalCash = totalCash + val
                    elseif type(val) == "string" then
                        local num = tonumber(val)
                        if num then totalCash = totalCash + num end
                    end
                end)
            end
        end
    end
    return math.floor(totalCash)
end

local function FormatMoney(amount)
    if amount == 0 then return "$0" end
    local formatted = tostring(math.floor(amount))
    local reversed = formatted:reverse()
    local withDots = ""
    for i = 1, #reversed do
        if i > 1 and (i - 1) % 3 == 0 then withDots = withDots .. "." end
        withDots = withDots .. reversed:sub(i, i)
    end
    return "$" .. withDots:reverse()
end

local function UpdateCashTracker()
    local current = GetCurrentCash()
    if not FarmState.CashInitialized and current > 0 then
        FarmState.CashInitialized = true
        FarmState.PreviousCash = current
        FarmState.CurrentCash = current
        return
    end
    if not FarmState.CashInitialized then return end
    local change = current - FarmState.PreviousCash
    if change > 0 then FarmState.TotalIncome = FarmState.TotalIncome + change
    elseif change < 0 then FarmState.TotalExpense = FarmState.TotalExpense + math.abs(change) end
    FarmState.PreviousCash = current
    FarmState.CurrentCash = current
    FarmState.Profit = FarmState.TotalIncome - FarmState.TotalExpense
end

-- ============================================================
-- 🔥 TELEPORT FUNCTIONS - UG_SPEED = 20 ✅
-- ============================================================
local tpActive = false
local tpCancelled = false
local tpBusy = false

local function lerpChar(fromPos, toPos, speed)
    local dist = (toPos - fromPos).Magnitude
    local travelT = dist / speed
    local elapsed = 0
    while elapsed < travelT and not tpCancelled do
        local hrp2 = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp2 then break end
        local t = math.clamp(elapsed / travelT, 0, 1)
        local newPos = fromPos:Lerp(toPos, t)
        local offset = newPos - hrp2.Position
        for _, p in pairs(Player.Character:GetDescendants()) do
            if p:IsA("BasePart") and p ~= hrp2 then
                pcall(function() p.CFrame = p.CFrame + offset end)
            end
        end
        hrp2.CFrame = CFrame.new(newPos) * (hrp2.CFrame - hrp2.CFrame.Position)
        hrp2.AssemblyLinearVelocity = Vector3.zero
        hrp2.AssemblyAngularVelocity = Vector3.zero
        local _, dt = RunService.Stepped:Wait()
        elapsed = elapsed + dt
    end
    if not tpCancelled then
        local hrp3 = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp3 then hrp3.CFrame = CFrame.new(toPos) * (hrp3.CFrame - hrp3.CFrame.Position) end
    end
end

local function tpToPos(cx, cy, cz)
    if tpActive then return end
    tpActive = true
    tpCancelled = false
    local ch = Player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then tpActive = false; return end
    local deathConn
    deathConn = hum.Died:Connect(function()
        tpCancelled = true
        if deathConn then deathConn:Disconnect(); deathConn = nil end
    end)
    local UNDERGROUND_Y = -4.00
    local UG_SPEED = 20              -- ✅ DIUBAH DARI 7 → 20
    local ground = Instance.new("Part")
    ground.Name = "GroundTemp"
    ground.Size = Vector3.new(99999, 1, 99999)
    ground.CFrame = CFrame.new(cx, UNDERGROUND_Y - 4, cz)
    ground.Anchored = true
    ground.CanCollide = true
    ground.Transparency = 1
    ground.Parent = workspace
    local curHrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if curHrp and not tpCancelled then
        local startPos = curHrp.Position
        lerpChar(startPos, Vector3.new(startPos.X, UNDERGROUND_Y, startPos.Z), UG_SPEED)
        curHrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if curHrp and not tpCancelled then lerpChar(curHrp.Position, Vector3.new(cx, UNDERGROUND_Y, cz), UG_SPEED) end
        curHrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if curHrp and not tpCancelled then lerpChar(curHrp.Position, Vector3.new(cx, cy, cz), UG_SPEED) end
    end
    pcall(function() ground:Destroy() end)
    local hum2 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.WalkSpeed = 16 end
    if deathConn then deathConn:Disconnect(); deathConn = nil end
    tpActive = false
end

local function af_TP(cf)
    local x, y, z
    if typeof(cf) == "CFrame" then x, y, z = cf.X, cf.Y, cf.Z
    elseif typeof(cf) == "Vector3" then x, y, z = cf.X, cf.Y, cf.Z
    else return end
    tpToPos(x, y, z)
    local w = 0
    while tpActive and w < 200 do task.wait(0.1); w = w + 1 end
    task.wait(0.3)
end

local function doSuicideTP(loc)
    if tpBusy then return end
    tpBusy = true
    local ch = Player.Character
    local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp0 then tpBusy = false; return end
    hrp0.CFrame = CFrame.new(RESPAWN_WARP)
    local newChar = Player.CharacterAdded:Wait()
    local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
    if not hrp then tpBusy = false; return end
    task.wait(0.8)
    local targetCF = CFrame.new(loc.x, loc.y + 3, loc.z)
    for _ = 1, 4 do hrp.CFrame = targetCF; task.wait(0.15) end
    tpBusy = false
    task.wait(0.2)
    ApplyName()
end

-- ============================================================
-- 🏢 APARTMENT FUNCTIONS
-- ============================================================
local function GetAprtBoardText(board)
    local txt = ""
    local namePart = board:FindFirstChild("name")
    if namePart then
        local sg = namePart:FindFirstChild("SurfaceGui")
        local tl = sg and sg:FindFirstChildWhichIsA("TextLabel", true)
        if tl then txt = tl.Text end
    end
    if txt == "" then
        local sg = board:FindFirstChild("SurfaceGui")
        if sg then
            local occ = sg:FindFirstChild("Occupation")
            if occ then txt = occ.Text
            else
                local tl = sg:FindFirstChildWhichIsA("TextLabel", true)
                if tl then txt = tl.Text end
            end
        end
    end
    return txt
end

local function FindAprt()
    local map = Workspace:FindFirstChild("Map")
    local aptFolder = map and map:FindFirstChild("Apartments")
    if not aptFolder then return nil, nil end
    local owned, vacant = nil, nil
    for _, name in ipairs(APRT_NAMES) do
        local obj = aptFolder:FindFirstChild(name)
        if not obj or not (obj:IsA("Model") or obj:IsA("Folder")) then continue end
        local board = obj:FindFirstChild("Board", true)
        if not board then continue end
        local txt = GetAprtBoardText(board)
        if txt == Player.Name then owned = { obj = obj, board = board }
        elseif txt == "VACANT" and not owned and not vacant then vacant = { obj = obj, board = board } end
    end
    if owned then return owned, "Owned" end
    return vacant, "Vacant"
end

local function getAprtObjByName(name)
    if not name then return nil end
    local map = Workspace:FindFirstChild("Map")
    local folder = map and map:FindFirstChild("Apartments")
    local obj = folder and folder:FindFirstChild(name)
    if obj and (obj:IsA("Model") or obj:IsA("Folder")) then return obj end
    return nil
end

local function GetOwnedAprtTarget()
    local cachedName = getgenv().FA_OWNED_APRT
    if cachedName then
        local coords = APRT_COORDS[cachedName]
        if coords then
            local entry = nil
            local obj = getAprtObjByName(cachedName)
            if obj then entry = { obj = obj } end
            return coords, entry
        end
    end
    local entry, status = FindAprt()
    if entry and status == "Owned" then
        getgenv().FA_OWNED_APRT = entry.obj.Name
        local coords = APRT_COORDS[entry.obj.Name]
        if coords then return coords, entry end
    end
    return nil
end

local function EnsureBuyAprt()
    local entry, status = FindAprt()
    if not entry then return false end
    if status == "Owned" then
        FarmState.OwnedAprt = entry.obj.Name
        getgenv().FA_OWNED_APRT = entry.obj.Name
        return true
    end
    FarmState.Step = "🏠 Buying Apartment (Cost: $500)"
    local board = entry.board
    local backboard = board:FindFirstChild("backboard")
    local bp = backboard and backboard:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not bp then bp = board:FindFirstChildWhichIsA("ProximityPrompt", true) end
    if not bp then return false end
    bp.MaxActivationDistance = 9e9
    bp.HoldDuration = 0
    bp.RequiresLineOfSight = false
    doSuicideTP({x = backboard and backboard.Position.X or board.Position.X,
                 y = backboard and backboard.Position.Y + 3 or board.Position.Y + 3,
                 z = backboard and backboard.Position.Z or board.Position.Z})
    task.wait(0.5)
    for attempt = 1, 8 do
        if StopRequest then return false end
        fireproximityprompt(bp)
        task.wait(1.5)
        local txt = GetAprtBoardText(board)
        if txt == Player.Name then
            FarmState.OwnedAprt = entry.obj.Name
            getgenv().FA_OWNED_APRT = entry.obj.Name
            FarmState.TotalExpense = FarmState.TotalExpense + FarmSettings.ApartmentCost
            task.wait(0.5)
            return true
        end
    end
    return false
end

-- ============================================================
-- 💰 BUY SYSTEM — FIXED MAX 45 ✅
-- ============================================================
local function GetIngredientCount()
    local water, sugar, gelatin = 0, 0, 0
    if Player.Backpack then
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v.Name == "Water" then water = water + 1 end
            if v.Name == "Sugar Block Bag" then sugar = sugar + 1 end
            if v.Name == "Gelatin" then gelatin = gelatin + 1 end
        end
    end
    return water, sugar, gelatin
end

local function BuyWater()
    pcall(function() RemoteEvent:FireServer(buffer.fromstring("\024\019\003")) end)
end
local function BuySugar()
    pcall(function() RemoteEvent:FireServer(buffer.fromstring("\024\019\002")) end)
end
local function BuyGelatin()
    pcall(function() RemoteEvent:FireServer(buffer.fromstring("\024\019\001")) end)
end

-- ✅ FIXED BUY ALL — Anti Overbuy + Max 45
local function BuyAll(amount)
    amount = amount or FarmSettings.Amount
    -- ✅ Clamp agar tidak melebihi 45
    if amount > BUY_MAX then amount = BUY_MAX end
    if amount < BUY_MIN then amount = BUY_MIN end

    FarmState.Step = "🛒 Buying Ingredients (Cost: $" .. (amount * FarmSettings.IngredientCost) .. ")"
    local t0 = tick()
    local maxTime = 240

    -- Strict mode: beli 1x, tunggu inventory bertambah
    local function buyOneAndWait(buyFn, itemName, currentCount, targetCount)
        if currentCount >= targetCount then return currentCount end
        buyFn()
        local w = 0
        while w < 2 do
            task.wait(0.1)
            w = w + 0.1
            local cw, cs, cg = GetIngredientCount()
            local c = 0
            if itemName == "Water" then c = cw
            elseif itemName == "Sugar Block Bag" then c = cs
            elseif itemName == "Gelatin" then c = cg end
            if c > currentCount then return c end
        end
        local cw, cs, cg = GetIngredientCount()
        if itemName == "Water" then return cw end
        if itemName == "Sugar Block Bag" then return cs end
        return cg
    end

    -- WATER
    local w, s, g = GetIngredientCount()
    local stuckW = 0
    while w < amount and tick() - t0 < maxTime do
        if StopRequest then return false end
        local prevW = w
        w = buyOneAndWait(BuyWater, "Water", w, amount)
        if w == prevW then
            stuckW = stuckW + 1
            if stuckW >= 5 then
                warn("[JOSTAR STORE] ❌ Water stuck di " .. w .. " (target " .. amount .. ")")
                break
            end
            task.wait(0.3)
        else
            stuckW = 0
        end
    end

    -- SUGAR
    _, s, _ = GetIngredientCount()
    local stuckS = 0
    while s < amount and tick() - t0 < maxTime do
        if StopRequest then return false end
        local prevS = s
        s = buyOneAndWait(BuySugar, "Sugar Block Bag", s, amount)
        if s == prevS then
            stuckS = stuckS + 1
            if stuckS >= 5 then
                warn("[JOSTAR STORE] ❌ Sugar stuck di " .. s .. " (target " .. amount .. ")")
                break
            end
            task.wait(0.3)
        else
            stuckS = 0
        end
    end

    -- GELATIN
    _, _, g = GetIngredientCount()
    local stuckG = 0
    while g < amount and tick() - t0 < maxTime do
        if StopRequest then return false end
        local prevG = g
        g = buyOneAndWait(BuyGelatin, "Gelatin", g, amount)
        if g == prevG then
            stuckG = stuckG + 1
            if stuckG >= 5 then
                warn("[JOSTAR STORE] ❌ Gelatin stuck di " .. g .. " (target " .. amount .. ")")
                break
            end
            task.wait(0.3)
        else
            stuckG = 0
        end
    end

    task.wait(0.5)
    local fw, fs, fg = GetIngredientCount()
    print("[JOSTAR STORE] 📦 Final inventory — W=" .. fw .. " S=" .. fs .. " G=" .. fg .. " (target " .. amount .. ")")

    if fw >= amount and fs >= amount and fg >= amount then
        FarmState.TotalExpense = FarmState.TotalExpense + (amount * FarmSettings.IngredientCost)
        return true
    end
    warn("[JOSTAR STORE] ❌ Buy FAILED — W=" .. fw .. " S=" .. fs .. " G=" .. fg .. " (target " .. amount .. ")")
    return false
end

local function findLamont()
    if workspace.Folders and workspace.Folders.NPCs then
        for _, v in pairs(workspace.Folders.NPCs:GetChildren()) do
            if v.Name == "Lamont Bell" then return v end
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Lamont Bell" and v:IsA("Model") then return v end
    end
    return nil
end

-- NOCLIP
local noclip_connection = nil
local function EnableNoClipPermanent()
    if noclip_connection then return end
    noclip_connection = RunService.RenderStepped:Connect(function()
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
        end
    end)
end

local function DisableNoClipPermanent()
    if noclip_connection then noclip_connection:Disconnect(); noclip_connection = nil end
    pcall(function()
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.CanCollide = true end) end
            end
        end
    end)
end

-- QUICK TP TO POT
local function QuickTeleportToPot(Pot)
    local char = Player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local cookPos = Pot.CFrame - Vector3.new(0, FarmSettings.OffsetY, 0)
    hrp.CFrame = cookPos
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= hrp then
            pcall(function()
                part.CFrame = cookPos
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end
    hum.PlatformStand = true
    hum.AutoRotate = true
    hum.WalkSpeed = 0
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "FlyLock" then v:Destroy() end
    end
    local bp = Instance.new("BodyPosition")
    bp.Name = "FlyLock"
    bp.Parent = hrp
    bp.MaxForce = Vector3.new(4000, 4000, 4000)
    bp.P = 2000
    bp.D = 100
    bp.Position = cookPos.Position
    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyLock"
    bg.Parent = hrp
    bg.MaxTorque = Vector3.new(4000, 4000, 4000)
    bg.P = 2000
    bg.D = 100
    bg.CFrame = hrp.CFrame
    return true
end

local function DisableFlyLock()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false; hum.WalkSpeed = 16 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlyLock" then v:Destroy() end
        end
    end
end

-- COOK HELPERS
local function af_FirePrompt(prompt)
    if not prompt or not prompt.Parent then return end
    pcall(function()
        local od, ol = prompt.MaxActivationDistance, prompt.RequiresLineOfSight
        prompt.MaxActivationDistance = 9999
        prompt.RequiresLineOfSight = false
        task.wait(0.05)
        fireproximityprompt(prompt)
        task.wait(0.1)
        prompt.MaxActivationDistance = od
        prompt.RequiresLineOfSight = ol
    end)
end

local function af_Equip(toolName)
    local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local tool = (Player.Backpack and Player.Backpack:FindFirstChild(toolName)) or (Player.Character and Player.Character:FindFirstChild(toolName))
    if tool then pcall(function() hum:EquipTool(tool) end) end
end

local function af_Unequip()
    local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:UnequipTools() end) end
end

local function af_Tween(cf)
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist / 20, 0.05), Enum.EasingStyle.Linear), { CFrame = cf })
    tw:Play()
    tw.Completed:Wait()
end

-- COOK MARSHMALLOW
local function CookMarshmallow(amount, skipBuy)
    amount = amount or FarmSettings.Amount
    if amount > BUY_MAX then amount = BUY_MAX end  -- ✅ Cap ke 45
    FarmState.BatchProgress = "0/" .. amount
    FarmState.CurrentBatch = 0
    
    if not skipBuy then
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local isNearStore = false
        if hrp then
            local dist = (hrp.Position - Vector3.new(510, 4, 602)).Magnitude
            if dist < 20 then isNearStore = true end
        end
        if not isNearStore then
            FarmState.Step = "🚗 Going to Store"
            doSuicideTP({ x = 510, y = 4, z = 602 })
            task.wait(1)
        end
        FarmState.Step = "🛒 Buying Ingredients"
        local buySuccess = false
        for retry = 1, 10 do
            buySuccess = BuyAll(amount)
            if buySuccess then break end
            print("⚠️ [BUY] Retry " .. retry .. "/10...")
            task.wait(2)
            doSuicideTP({ x = 510, y = 4, z = 602 })
            task.wait(1)
        end
        if not buySuccess then
            print("⚠️ [COOK] Skip cycle, waiting...")
            task.wait(5)
            return true
        end
        task.wait(0.5)
    end
    
    FarmState.Step = "🚗 Going to Apartment"
    local targetPos, entry = GetOwnedAprtTarget()
    if not targetPos then
        print("⚠️ [COOK] No apartment found, skipping...")
        return true
    end
    af_TP(CFrame.new(targetPos.X, targetPos.Y + 3, targetPos.Z))
    task.wait(1)
    
    local House = entry and entry.obj
    if not House then
        local _, newEntry = GetOwnedAprtTarget()
        House = newEntry and newEntry.obj
    end
    if not House then
        print("⚠️ [COOK] House not found, skipping...")
        return true
    end
    
    local Interior = House:FindFirstChild("Interior") or House
    for _, v in pairs(Interior:GetChildren()) do
        if v.Name == "Floor" then pcall(function() v.CanCollide = false end) end
    end
    
    local Pot = Interior:FindFirstChild("Cooking Pot", true)
    local PotPrompt = nil
    if Pot then
        local att = Pot:FindFirstChild("Attachment")
        PotPrompt = att and att:FindFirstChildOfClass("ProximityPrompt") or Pot:FindFirstChildWhichIsA("ProximityPrompt", true)
    end
    if not Pot or not PotPrompt then
        print("⚠️ [COOK] Pot not found, skipping...")
        return true
    end
    
    EnableNoClipPermanent()
    QuickTeleportToPot(Pot)
    
    for i = 1, amount do
        if StopRequest then return false end
        FarmState.CurrentBatch = i
        FarmState.BatchProgress = i .. "/" .. amount
        
        FarmState.Step = "💧 Pouring Water (" .. i .. "/" .. amount .. ")"
        if not Player.Character:FindFirstChild("Water") then af_Equip("Water") end
        task.wait(1)
        af_FirePrompt(PotPrompt)
        task.wait(2.5)
        
        FarmState.Step = "⏳ Waiting Water (" .. i .. "/" .. amount .. ")"
        local timeout = 0
        while timeout < 21 do
            if StopRequest then return false end
            local timer = Pot:FindFirstChild("Timer")
            if timer and timer:IsA("TextLabel") and timer.Text == "0" then break end
            task.wait(0.5)
            timeout = timeout + 0.5
        end
        
        FarmState.Step = "🧂 Adding Sugar (" .. i .. "/" .. amount .. ")"
        if not Player.Character:FindFirstChild("Sugar Block Bag") then af_Equip("Sugar Block Bag") end
        task.wait(1)
        af_FirePrompt(PotPrompt)
        task.wait(2.5)
        af_Unequip()
        
        FarmState.Step = "⏳ Waiting Sugar (" .. i .. "/" .. amount .. ")"
        timeout = 0
        while timeout < 1 do
            if StopRequest then return false end
            local timer = Pot:FindFirstChild("Timer")
            if timer and timer:IsA("TextLabel") and timer.Text == "0" then break end
            task.wait(0.5)
            timeout = timeout + 0.5
        end
        
        FarmState.Step = "🧪 Adding Gelatin (" .. i .. "/" .. amount .. ")"
        af_Unequip()
        task.wait(1)
        if not Player.Character:FindFirstChild("Gelatin") then af_Equip("Gelatin") end
        af_FirePrompt(PotPrompt)
        task.wait(2.5)
        
        FarmState.Step = "⏳ Waiting Gelatin (" .. i .. "/" .. amount .. ")"
        timeout = 0
        while timeout < 46 do
            if StopRequest then return false end
            local timer = Pot:FindFirstChild("Timer")
            if timer and timer:IsA("TextLabel") and timer.Text == "0" then break end
            task.wait(0.5)
            timeout = timeout + 0.5
        end
        
        FarmState.Step = "🍡 Collecting Marshmallow (" .. i .. "/" .. amount .. ")"
        if not Player.Character:FindFirstChild("Empty Bag") then af_Equip("Empty Bag") end
        task.wait(1)
        af_FirePrompt(PotPrompt)
        task.wait(1)
        af_Unequip()
        
        FarmState.MarshmallowsMade = FarmState.MarshmallowsMade + 1
        UpdateCashTracker()
    end
    
    DisableFlyLock()
    return true
end

-- SELL
local function SellMarshmallow()
    FarmState.Step = "💰 Selling Marshmallows"
    af_TP(CFrame.new(510, 4, 602))
    local timeout = 0
    while not findLamont() and timeout < 10 do task.wait(0.5); timeout = timeout + 0.5 end
    task.wait(1)
    af_Tween(CFrame.new(511, 4, 598))
    local lamont = findLamont()
    local sellP = lamont and lamont:FindFirstChild("UpperTorso") and lamont.UpperTorso:FindFirstChildOfClass("ProximityPrompt")
    local sold = 0
    if Player.Backpack and sellP then
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if StopRequest then break end
            if v:IsA("Tool") and v.Name:find("Marshmallow") then
                local hum2 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if hum2 then pcall(function() hum2:EquipTool(v) end) end
                af_FirePrompt(sellP)
                sold = sold + 1
                FarmState.Sold = FarmState.Sold + 1
                task.wait(0.25)
            end
        end
    end
    UpdateCashTracker()
    return sold > 0
end

-- FULL CYCLE
local CurrentCycle = 0
local isFirstCycle = true

local function FullCycle()
    FarmState.BatchProgress = "0/" .. FarmSettings.Amount
    FarmState.CurrentBatch = 0
    if isFirstCycle then
        FarmState.Step = "🏠 Buying Apartment (Cost: $500)"
        if not EnsureBuyAprt() then
            print("⚠️ [CYCLE] Failed to buy apartment, retrying...")
            task.wait(5)
            return true
        end
        task.wait(1)
        isFirstCycle = false
    end
    local cookSuccess = CookMarshmallow(FarmSettings.Amount, false)
    if not cookSuccess then
        print("⚠️ [CYCLE] Cook failed, skipping...")
        task.wait(5)
        return true
    end
    DisableFlyLock()
    SellMarshmallow()
    task.wait(0.5)
    CurrentCycle = CurrentCycle + 1
    FarmState.Cycles = CurrentCycle
    UpdateCashTracker()
    return true
end

-- START/STOP
local function StartFullyFarm()
    if FarmRunning then return end
    FarmRunning = true
    StopRequest = false
    CurrentCycle = 0
    isFirstCycle = true
    FarmState.Cycles = 0
    FarmState.Sold = 0
    FarmState.MarshmallowsMade = 0
    FarmState.BatchProgress = "0/" .. FarmSettings.Amount
    FarmState.CurrentBatch = 0
    FarmState.CashInitialized = false
    FarmState.CurrentCash = 0
    FarmState.PreviousCash = 0
    FarmState.TotalIncome = 0
    FarmState.TotalExpense = 0
    FarmState.Step = "Starting"
    FarmState.StartTime = os.time()
    StartTime = os.time()
    StartRGBName()
    FarmThread = task.spawn(function()
        while FarmRunning and not StopRequest do
            FullCycle()
            task.wait(1)
        end
        FarmRunning = false
        FarmState.Status = "Stopped"
        FarmState.Step = "Idle"
        StopRGBName()
    end)
end

local function StopFullyFarm()
    StopRequest = true
    FarmRunning = false
    FarmState.Status = "Stopped"
    FarmState.Step = "Idle"
    StopRGBName()
    if FarmThread then task.cancel(FarmThread); FarmThread = nil end
end

_G.StartFullyFarm = StartFullyFarm
_G.StopFullyFarm = StopFullyFarm

-- AUTO REJOIN
local AutoRejoinConfig = {
    Enabled = true,
    ScriptUrl = "https://pastefy.app/82E6hkS0/raw",
    GameId = 10179538382,
}

local IsDeathTeleport = false
local function MarkDeathTeleport() IsDeathTeleport = true end
_G.MarkDeathTeleport = MarkDeathTeleport

local function DoRejoin()
    if not AutoRejoinConfig.Enabled then return end
    if IsDeathTeleport then IsDeathTeleport = false; return end
    print("🔄 [REJOIN] Rejoining...")
    FarmState.Step = "Rejoining"
    FarmRunning = false
    getgenv().FULLY_MS_AFTER_REJOIN = true
    queue_on_teleport([[
        queue_on_teleport("task.wait(30)\ngetgenv().FULLY_MS_AFTER_REJOIN = true\ngetgenv().FULLY_MS_V1 = nil\nloadstring(game:HttpGet(']] .. AutoRejoinConfig.ScriptUrl .. [['))()")
    ]])
    TeleportService:Teleport(AutoRejoinConfig.GameId)
end

task.spawn(function()
    local conn
    conn = LogService.MessageOut:Connect(function(msg, mtype)
        if mtype == Enum.MessageType.MessageError then
            if msg:find("Kicked") or msg:find("Disconnected") or msg:find("Idle") or
               msg:find("Removed") or msg:find("Connection lost") or msg:find("Ban") then
                if conn then conn:Disconnect() end
                task.spawn(DoRejoin)
            end
        end
    end)
end)

local function SetupDeathDetection()
    local function OnCharacterAdded(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        hum.Died:Connect(function()
            if IsDeathTeleport then IsDeathTeleport = false; return end
            print("💀 [REJOIN] Natural death detected! Rejoining...")
            task.spawn(DoRejoin)
        end)
    end
    local char = Player.Character
    if char then task.spawn(function() OnCharacterAdded(char) end) end
    Player.CharacterAdded:Connect(OnCharacterAdded)
end
SetupDeathDetection()

-- AUTO EXECUTE
task.spawn(function()
    task.wait(3)
    if getgenv().FULLY_MS_AFTER_REJOIN then
        print("🔄 [REJOIN] Auto starting farm...")
        getgenv().FULLY_MS_AFTER_REJOIN = nil
        local clickAttempts = 0
        while clickAttempts < 10 do
            local success = ClickPlay()
            if success then break end
            clickAttempts = clickAttempts + 1
            task.wait(2)
        end
        task.wait(2)
        StartFullyFarm()
    else
        print("📌 FERZZ STORE READY - Use F3 to open UI")
    end
end)

-- ANTI AFK
task.spawn(function()
    while getgenv().FULLY_MS_V1 do
        pcall(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        task.wait(60)
    end
end)

Player.Idled:Connect(function()
    if FarmRunning then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- ============================================================
-- 🖥️ CREATE UI (JOSTAR STORE - BLACK/WHITE ANIMATED THEME)
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FERZZ_STORE_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- Compact scale: UI dibuat lebih kecil untuk layar HP
local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.82
UIScale.Parent = ScreenGui


-- Ukuran/proporsi mengikuti panel pada foto referensi
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 212)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -106)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Isi panel tetap gelap; warna hanya pada pinggiran.
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 11)
MainCorner.Parent = MainFrame

local Border = Instance.new("UIStroke")
Border.Thickness = 2
Border.Color = Color3.fromRGB(230, 230, 230)
Border.Transparency = 0
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Border.Parent = MainFrame

-- Gradien hitam-putih bergerak pada pinggiran.
local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(95, 95, 95)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
BorderGradient.Rotation = 0
BorderGradient.Parent = Border

-- Header: tanpa bar terpisah, sama seperti foto
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 0, 22)
TitleLabel.Position = UDim2.new(0, 17, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "JOSTAR STORE"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Animasi judul berubah dari abu gelap ke putih.
task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(TitleLabel, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(Border, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(BorderGradient, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Rotation = 180
        }):Play()
        task.wait(1.25)
        TweenService:Create(TitleLabel, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(95, 95, 95)
        }):Play()
        TweenService:Create(Border, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(35, 35, 35)
        }):Play()
        TweenService:Create(BorderGradient, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Rotation = 360
        }):Play()
        task.wait(1.25)
    end
end)

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Size = UDim2.new(1, -50, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 17, 0, 40)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "JOSTAR STORE"
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextSize = 10
SubtitleLabel.TextColor3 = Color3.fromRGB(155, 155, 155)
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = MainFrame

-- Icon kecil kanan atas seperti referensi
local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.new(0, 18, 0, 18)
MiniButton.Position = UDim2.new(1, -30, 0, 18)
MiniButton.BackgroundTransparency = 1
MiniButton.Text = "□"
MiniButton.Font = Enum.Font.Gotham
MiniButton.TextSize = 10
MiniButton.TextColor3 = Color3.fromRGB(210, 210, 210)
MiniButton.AutoButtonColor = false
MiniButton.Parent = MainFrame

-- Garis header
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -34, 0, 1)
Divider.Position = UDim2.new(0, 17, 0, 64)
Divider.BackgroundColor3 = Color3.fromRGB(135, 135, 135)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Farming row
local FarmingLabel = Instance.new("TextLabel")
FarmingLabel.Size = UDim2.new(1, -105, 0, 25)
FarmingLabel.Position = UDim2.new(0, 17, 0, 76)
FarmingLabel.BackgroundTransparency = 1
FarmingLabel.Text = "Farming"
FarmingLabel.Font = Enum.Font.Gotham
FarmingLabel.TextSize = 13
FarmingLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
FarmingLabel.TextXAlignment = Enum.TextXAlignment.Left
FarmingLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "FarmingToggle"
ToggleBtn.Size = UDim2.new(0, 62, 0, 27)
ToggleBtn.Position = UDim2.new(1, -80, 0, 76)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 10
ToggleBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

local toggleState = false

ToggleBtn.MouseButton1Click:Connect(function()
    toggleState = not toggleState

    if toggleState then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        if _G.StartFullyFarm then
            task.spawn(_G.StartFullyFarm)
        end
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        ToggleBtn.TextColor3 = Color3.fromRGB(190, 190, 190)

        if _G.StopFullyFarm then
            _G.StopFullyFarm()
        end
    end
end)

-- Amount + Cash: posisi seperti "8 | $1520" pada foto
local AmountCashLabel = Instance.new("TextLabel")
AmountCashLabel.Size = UDim2.new(1, -34, 0, 21)
AmountCashLabel.Position = UDim2.new(0, 17, 0, 109)
AmountCashLabel.BackgroundTransparency = 1
AmountCashLabel.Text = tostring(FarmSettings.Amount) .. "   |   " .. FormatMoney(FarmState.CurrentCash or GetCurrentCash())
AmountCashLabel.Font = Enum.Font.GothamBold
AmountCashLabel.TextSize = 13
AmountCashLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
AmountCashLabel.TextXAlignment = Enum.TextXAlignment.Left
AmountCashLabel.Parent = MainFrame

-- Slider persis satu garis
local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "AmountSlider"
SliderTrack.Size = UDim2.new(1, -34, 0, 6)
SliderTrack.Position = UDim2.new(0, 17, 0, 137)
SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SliderTrack.BorderSizePixel = 0
SliderTrack.Active = true
SliderTrack.Parent = MainFrame

local SliderTrackCorner = Instance.new("UICorner")
SliderTrackCorner.CornerRadius = UDim.new(1, 0)
SliderTrackCorner.Parent = SliderTrack

local initialPct = math.clamp((FarmSettings.Amount - BUY_MIN) / (BUY_MAX - BUY_MIN), 0, 1)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(initialPct, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 17, 0, 17)
SliderKnob.Position = UDim2.new(initialPct, -8.5, 0.5, -8.5)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.Active = true
SliderKnob.Parent = SliderTrack

local SliderKnobCorner = Instance.new("UICorner")
SliderKnobCorner.CornerRadius = UDim.new(1, 0)
SliderKnobCorner.Parent = SliderKnob

local sliderDragging = false

local function updateSlider(val)
    val = math.clamp(math.floor(tonumber(val) or BUY_MIN), BUY_MIN, BUY_MAX)
    FarmSettings.Amount = val

    local pct = math.clamp((val - BUY_MIN) / (BUY_MAX - BUY_MIN), 0, 1)
    SliderFill.Size = UDim2.new(pct, 0, 1, 0)
    SliderKnob.Position = UDim2.new(pct, -8.5, 0.5, -8.5)
    AmountCashLabel.Text = tostring(val) .. "   |   " .. FormatMoney(FarmState.CurrentCash or GetCurrentCash())
end

local function sliderFromInput(input)
    local relX = math.clamp(
        (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X,
        0,
        1
    )
    updateSlider(BUY_MIN + relX * (BUY_MAX - BUY_MIN))
end

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        sliderFromInput(input)
    end
end)

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging
        and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        sliderFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

-- Status: "Idle" seperti foto
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -34, 0, 18)
StatusLabel.Position = UDim2.new(0, 17, 0, 153)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Idle"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -34, 0, 18)
StatsLabel.Position = UDim2.new(0, 17, 0, 176)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "MS: [0]   time: [00:00]"
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 10
StatsLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

-- Update text sesuai status script
task.spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            local cash = FarmState.CurrentCash
            if not cash or cash <= 0 then
                cash = GetCurrentCash()
            end

            AmountCashLabel.Text = tostring(FarmSettings.Amount) .. "   |   " .. FormatMoney(cash)

            if FarmRunning then
                StatusLabel.Text = FarmState.Step or "Running"
                StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            else
                StatusLabel.Text = "Idle"
                StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            end

            local ms = 0
            pcall(function()
                ms = math.floor(Player:GetNetworkPing() * 1000)
            end)

            local elapsed = math.max(0, os.time() - StartTime)
            local minutes = math.floor(elapsed / 60)
            local seconds = elapsed % 60

            StatsLabel.Text = string.format(
                "MS: [%d]   time: [%02d:%02d]",
                ms,
                minutes,
                seconds
            )
        end)

        task.wait(0.5)
    end
end)

-- DRAG MOBILE/PC: hanya header area supaya slider tetap mudah disentuh
local dragData = {
    active = false,
    startMouse = Vector2.new(),
    startPos = UDim2.new()
}

local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragData.active = true
        dragData.startMouse = input.Position
        dragData.startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragData.active = false
            end
        end)
    end
end

TitleLabel.InputBegan:Connect(beginDrag)
SubtitleLabel.InputBegan:Connect(beginDrag)
MiniButton.InputBegan:Connect(beginDrag)

UserInputService.InputChanged:Connect(function(input)
    if dragData.active
        and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragData.startMouse

        MainFrame.Position = UDim2.new(
            dragData.startPos.X.Scale,
            dragData.startPos.X.Offset + delta.X,
            dragData.startPos.Y.Scale,
            dragData.startPos.Y.Offset + delta.Y
        )
    end
end)

-- F3 toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F3 then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("========================================")
print("👑 JOSTAR STORE UI LOADED")
print("========================================")
print("✅ Reference layout: 1:1 compact")
print("✅ JOSTAR STORE")
print("✅ Farming ON/OFF")
print("✅ Amount slider 1-45")
print("✅ Mobile draggable")
print("📌 F3 = Toggle UI")
print("========================================")
