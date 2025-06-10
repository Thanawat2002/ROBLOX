local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ignoreAnimalNames = {
  ["Horse"] = true,
  ["WendigoHorse"] = true,
  ["Cow"] = true
}

local Window = Rayfield:CreateWindow({
  Name = "The Wild West 4.0",
  LoadingTitle = "Loading...",
  LoadingSubtitle = "By Thanawat",

  ConfigurationSaving = { Enabled = false },
  Discord = { Enabled = false },
  KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Section = MainTab:CreateSection("Main")
local PlayerTab = Window:CreateTab("PVP", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

local espPlayerEnabled = false
local espAnimalEnabled = false
local showAnimalName = false
local showAnimalHP = false
local showAnimalDistance = false

local playerESPColor = Color3.fromRGB(0, 120, 255)
local animalESPColor = Color3.fromRGB(255, 128, 128)

local Lighting = game:GetService("Lighting")

MainTab:CreateToggle({
  Name = "Fullbright",
  CurrentValue = false,
  Callback = function(value)
    if value then
      Lighting.Ambient = Color3.new(1, 1, 1)
      Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
      Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    else
      Lighting.Ambient = Color3.new(0, 0, 0)
      Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
      Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    end
    Lighting.Changed:Connect(function()
      if value then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
      else
        Lighting.Ambient = Color3.fromHex("#000000")
        Lighting.ColorShift_Bottom = Color3.fromHex("#000000")
        Lighting.ColorShift_Top = Color3.fromHex("#000000")
      end
    end)
  end
})

-- MainTab:CreateToggle({
--   Name = "Infinite Stamina",
--   CurrentValue = false,
--   Callback = function(value)
--     local OldNameCall
--     OldNameCall = hookmetamethod(game, "__namecall", function (...)
--       local Args = {...}
--       local self = Args[1]
--       local Method = getnamecallmethod()
--       if Method == "FireServer" and tostring(self) == "LowerStamina" and value then
--         return task.wait(9e9)
--       end
--       return OldNameCall(...)
--     end)
--   end
-- })

-- MainTab:CreateToggle({
--   Name = "No Fall Damage",
--   CurrentValue = false,
--   Callback = function(value)
--     local oldNameCall
--     oldNameCall = hookmetamethod(game, "__namecall", function (...)
--       local args = {...}
--       local self = args[1]
--       if getnamecallmethod() == "FireServer" and tostring(self) == "DamageSelf" and value then
--         return
--       end
--       return oldNameCall(...)
--     end)
--   end
-- })

MainTab:CreateToggle({
  Name = "Auto Sprint",
  CurrentValue = false,
  Callback = function(value) 
    game:GetService("RunService").Stepped:Connect(function()
      if value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 25
      else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
    end)
  end
})

PlayerTab:CreateToggle({
  Name = "Instant reload",
  CurrentValue = false,
  Callback = function(Value)
    for i, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "BaseRecoil")  then
          if value then
            v.ReloadSpeed = 1000
            v.LoadSpeed = 1000
            v.LoadEndSpeed = 1000
          end
        end
    end
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


Rayfield:LoadConfiguration()