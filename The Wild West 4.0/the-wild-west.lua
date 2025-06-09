local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
  Name = "The Wild West 4.0",
  LoadingTitle = "Loading Scripts",
  LoadingSubtitle = "By Thanawat",
  ConfigurationSaving = {
    Enabled = false
  },
  Discord = {
    Enabled = false
  },
  KeySystem = false
})

local MainTab = Window:CreateTab("ESP", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

local espPlayerEnabled = false
local espAnimalEnabled = false
local showAnimalName = true
local showAnimalHP = false
local showAnimalDistance = false
local playerESPColor = Color3.fromRGB(0, 120, 255)
local animalESPColor = Color3.fromRGB(255, 128, 128)

local ignoreAnimalNames = {
  ["Horse"] = true,
  ["Cow"] = true
}

MainTab:Set("ESP", 4483362458, Color3.fromRGB(255, 255, 255), false)
MainTab:CreateToggle({
  Name = "ESP Players",
  CurrentValue = false,
  Callback = function(Value)
    espPlayerEnabled = Value
  end,
})
MainTab:CreateColorPicker({
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
  CurrentValue = true,
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

-- ====== ESP Utility ======
local function createBillboard(obj)
  local gui = Instance.new("BillboardGui")
  gui.Name = "ESP_Board"
  gui.Size = UDim2.new(0, 200, 0, 50)
  gui.Adornee = obj
  gui.AlwaysOnTop = true
  gui.StudsOffset = Vector3.new(0, 4, 0)

  local label = Instance.new("TextLabel")
  label.Name = "InfoLabel"
  label.Size = UDim2.new(1, 0, 1, 0)
  label.BackgroundTransparency = 1
  label.TextColor3 = animalESPColor
  label.TextStrokeTransparency = 0.5
  label.Font = Enum.Font.SourceSansBold
  label.TextScaled = true
  label.Parent = gui

  gui.Parent = obj
end

local function updateBillboard(obj)
  local gui = obj:FindFirstChild("ESP_Board")
  if not gui then
    createBillboard(obj)
    gui = obj:FindFirstChild("ESP_Board")
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

    if showAnimalDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("HumanoidRootPart") then
      local dist = (obj.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
      text = text .. (text ~= "" and " | " or "") .. "Dist: " .. math.floor(dist) .. "m"
    end

    label.Text = text
    label.TextColor3 = animalESPColor
  end
end

local function removeBillboard(obj)
  local b = obj:FindFirstChild("ESP_Board")
  if b then
    b:Destroy()
  end
end

-- ====== ESP Highlight ======
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

-- ====== ESP Player ======
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

-- ====== ESP Render Loop ======
RunService.Heartbeat:Connect(function()
  local playerFolder = workspace:FindFirstChild("WORKSPACE_Entities") and workspace.WORKSPACE_Entities:FindFirstChild("Players")
  if playerFolder then
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

  -- ====== ESP Animal ======
  local animalFolder = workspace:FindFirstChild("WORKSPACE_Entities") and workspace.WORKSPACE_Entities:FindFirstChild("Animals")
  if animalFolder then
    for _, animal in ipairs(animalFolder:GetChildren()) do
      if animal:IsA("Model") and animal:FindFirstChild("HumanoidRootPart") then
        if not ignoreAnimalNames[animal.Name] then
          if espAnimalEnabled then
            highlightObject(animal, "Animal", animalESPColor)
            updateBillboard(animal)
          else
            removeHighlight(animal, "Animal")
            removeBillboard(animal)
          end
        else
          removeHighlight(animal, "Animal")
          removeBillboard(animal)
        end
      end
    end
  end
end)
