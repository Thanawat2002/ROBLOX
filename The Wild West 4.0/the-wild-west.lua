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

local espPlayerEnabled = false
local espAnimalEnabled = false
local playerESPColor = Color3.fromRGB(0, 120, 255)
local animalESPColor = Color3.fromRGB(255, 128, 128)

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
MainTab:CreateToggle({
  Name = "ESP Animals",
  CurrentValue = false,
  Callback = function(Value)
    espAnimalEnabled = Value
  end,
})
MainTab:CreateColorPicker({
  Name = "Animal ESP Color",
  Color = animalESPColor,
  Callback = function(color)
    animalESPColor = color
  end,
})

-- Main Script Functions
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

  local animalFolder = workspace:FindFirstChild("WORKSPACE_Entities") and workspace.WORKSPACE_Entities:FindFirstChild("Animals")
  if animalFolder then
    for _, animal in ipairs(animalFolder:GetChildren()) do
      if animal:IsA("Model") and animal:FindFirstChild("HumanoidRootPart") then
        if espAnimalEnabled then
          highlightObject(animal, "Animal", animalESPColor)
        else
          removeHighlight(animal, "Animal")
        end
      end
    end
  end
end)
