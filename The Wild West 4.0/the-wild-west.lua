local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ignoreAnimalNames = {
    ["Horse"] = true,
    ["WendigoHorse"] = true,
    ["Cow"] = true
}

local Window = Rayfield:CreateWindow({
    Name = "The Wild West 4.0",
    LoadingTitle = "Loading Scripts",
    LoadingSubtitle = "By Thanawat",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("PVP", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

local espPlayerEnabled = false
local espAnimalEnabled = false
local showAnimalName = false
local showAnimalHP = false
local showAnimalDistance = false

local playerESPColor = Color3.fromRGB(0, 120, 255)
local animalESPColor = Color3.fromRGB(255, 128, 128)

local lightingSettings = {
    FogEnd = 100000,
    FogStart = 0,
    ClockTime = 14,
    Brightness = 5,
    GlobalShadows = false
}

local Lighting = game:GetService("Lighting")

local function applyLightingSettings()
    Lighting.FogEnd = lightingSettings.FogEnd
    Lighting.FogStart = lightingSettings.FogStart
    Lighting.ClockTime = lightingSettings.ClockTime
    Lighting.Brightness = lightingSettings.Brightness
    Lighting.GlobalShadows = lightingSettings.GlobalShadows
end

applyLightingSettings()

MainTab:CreateSlider({
    Name = "FogEnd",
    Range = {0, 200000},
    Increment = 1000,
    CurrentValue = lightingSettings.FogEnd,
    Callback = function(Value)
        lightingSettings.FogEnd = Value
        applyLightingSettings()
    end,
})

MainTab:CreateSlider({
    Name = "FogStart",
    Range = {0, 10000},
    Increment = 100,
    CurrentValue = lightingSettings.FogStart,
    Callback = function(Value)
        lightingSettings.FogStart = Value
        applyLightingSettings()
    end,
})

MainTab:CreateSlider({
    Name = "ClockTime",
    Range = {0, 24},
    Increment = 0.1,
    CurrentValue = lightingSettings.ClockTime,
    Callback = function(Value)
        lightingSettings.ClockTime = Value
        applyLightingSettings()
    end,
})

MainTab:CreateSlider({
    Name = "Brightness",
    Range = {0, 10},
    Increment = 0.1,
    CurrentValue = lightingSettings.Brightness,
    Callback = function(Value)
        lightingSettings.Brightness = Value
        applyLightingSettings()
    end,
})

MainTab:CreateToggle({
    Name = "Global Shadows",
    CurrentValue = lightingSettings.GlobalShadows,
    Callback = function(Value)
        lightingSettings.GlobalShadows = Value
        applyLightingSettings()
    end,
})

PlayerTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(Value)
        espPlayerEnabled = Value
    end,
})

PlayerTab:CreateColorPicker({
    Name = "Player ESP Color",
    Color = playerESPColor,
    Callback = function(color)
        playerESPColor = color
    end,
})

FarmTab:CreateToggle({
    Name = "ESP Animals",
    CurrentValue = false,
    Callback = function(Value)
        espAnimalEnabled = Value
    end,
})

FarmTab:CreateColorPicker({
    Name = "Animal ESP Color",
    Color = animalESPColor,
    Callback = function(color)
        animalESPColor = color
    end,
})

FarmTab:CreateToggle({
    Name = "Show Animal Name",
    CurrentValue = false,
    Callback = function(Value)
        showAnimalName = Value
    end,
})
FarmTab:CreateToggle({
    Name = "Show Animal HP",
    CurrentValue = false,
    Callback = function(Value)
        showAnimalHP = Value
    end,
})
FarmTab:CreateToggle({
    Name = "Show Animal Distance",
    CurrentValue = false,
    Callback = function(Value)
        showAnimalDistance = Value
    end,
})

local function createBillboard(obj)
    local hrp = obj:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP_Board"
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.Adornee = hrp
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.Parent = hrp

    local label = Instance.new("TextLabel")
    label.Name = "InfoLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = animalESPColor
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = false
    label.TextSize = 12
    label.Parent = gui
end

local function updateBillboard(obj)
    local hrp = obj:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local gui = hrp:FindFirstChild("ESP_Board")
    if not gui then
        createBillboard(obj)
        gui = hrp:FindFirstChild("ESP_Board")
    end

    local label = gui and gui:FindFirstChild("InfoLabel")
    if label then
        local text = ""

        if showAnimalName then
            text = text .. obj.Name
        end

        if showAnimalHP and obj:FindFirstChild("Humanoid") then
            local hp = math.floor(obj.Humanoid.Health)
            text = text .. (text ~= "" and " | " or "") .. "HP: " .. hp
        end

        if showAnimalDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and hrp then
            local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            text = text .. (text ~= "" and " | " or "") .. "Dist: " .. math.floor(dist) .. "m"
        end

        label.Text = text
        label.TextColor3 = animalESPColor
    end
end

local function removeBillboard(obj)
    local hrp = obj:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local b = hrp:FindFirstChild("ESP_Board")
    if b then
        b:Destroy()
    end
end

local function highlightObject(obj, tagName, color)
    if not obj:FindFirstChild("Highlight_" .. tagName) then
        local hl = Instance.new("Highlight")
        hl.Name = "Highlight_" .. tagName
        hl.FillColor = color
        hl.OutlineColor = Color3.new(0, 0, 0)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = obj
        hl.Parent = obj
    else
        obj["Highlight_" .. tagName].FillColor = color
    end
end

local function removeHighlight(obj, tagName)
    local h = obj:FindFirstChild("Highlight_" .. tagName)
    if h then h:Destroy() end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.5) 
        if espPlayerEnabled then
            highlightObject(char, "Player", playerESPColor)
        end
    end)
end)

local function processPlayers()
    local playerFolder = workspace:FindFirstChild("WORKSPACE_Entities") and workspace.WORKSPACE_Entities:FindFirstChild("Players")
    if not playerFolder then return end

    for _, char in ipairs(playerFolder:GetChildren()) do
        if char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") then
            if espPlayerEnabled then
                highlightObject(char, "Player", playerESPColor)
            else
                removeHighlight(char, "Player")
            end
        end
    end
end

local function processAnimals()
    local animalFolder = workspace:FindFirstChild("WORKSPACE_Entities") and workspace.WORKSPACE_Entities:FindFirstChild("Animals")
    if not animalFolder then return end

    for _, animal in ipairs(animalFolder:GetChildren()) do
        if animal:IsA("Model") and animal:FindFirstChild("HumanoidRootPart") and not ignoreAnimalNames[animal.Name] then
            if espAnimalEnabled then
                highlightObject(animal, "Animal", animalESPColor)
                updateBillboard(animal)
            else
                removeHighlight(animal, "Animal")
                removeBillboard(animal)
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    processPlayers()
    processAnimals()
end)