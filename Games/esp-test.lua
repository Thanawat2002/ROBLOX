_G.ESPToggle = false -- This is the variable used for enabling/disabling ESP.
_G.CreateGui = false -- Change this to false to disable the popup gui.
_G.KeyBind = Enum.KeyCode.H -- Change 'H' to whatever keybind. If on mobile, use the _G.CreateGui

--[[
    *This is commented out, don't worry about deleting it.*
    *READ!*
    If you would like a popup gui to enable/disable esp, set _G.CreateGui to true
    Change _G.KeyBind to whatever keybind you want, by default it is 'H'. If you are on mobile, use the _G.CreateGui
    Keybind to enable/disable is H by default.
]]

-- Table of colours to choose from
local colourTable = {
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128)
}
local colourChosen = colourTable.Red -- 'Red' is the colour, only use colours from the above table.

-- Services and lp
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

if _G.CreateGui then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESPToggleGui"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create a frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0) 
    mainFrame.BackgroundTransparency = 1  
    mainFrame.Parent = screenGui
    
    -- Create the button
    local toggleButton = Instance.new("TextButton") 
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 200, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -100, 0.5, -25)
    toggleButton.Text = "Toggle ESP"
    toggleButton.Parent = mainFrame
end

local function getCharacter(player)
    for _, descendant in pairs(workspace:GetDescendants()) do
        pcall(function()
            if descendant.Name == player.Name and descendant:FindFirstChild("HumanoidRootPart") then
                return descendant
            end
        end)
    end   
    return Workspace:FindFirstChild(player.Name)
end

-- Add highlights to players
local function addHighlightToCharacter(player, character)
    if player == LocalPlayer then return end  -- Skip local player
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = Instance.new("Highlight")  -- Create a new Highlight instance
        highlightClone.Name = "Highlight"
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlightClone.FillColor = colourChosen
        highlightClone.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlightClone.FillTransparency = 0.5
    end
end

-- Remove highlights from player
local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlightInstance = humanoidRootPart:FindFirstChild("Highlight")
        if highlightInstance then
            highlightInstance:Destroy()
        end
    end
end

-- Function to update highlights based on the value of _G.ESPToggle
local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = getCharacter(player)
        if character then
            if _G.ESPToggle then
                addHighlightToCharacter(player, character)
            else
                removeHighlightFromCharacter(character)
            end
        end
    end
end

-- Connect events through RenderStepped to loop
RunService.RenderStepped:Connect(function()
    updateHighlights()
end)

-- Add highlight to joining players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if _G.ESPToggle then
            addHighlightToCharacter(player, character)
        end
    end)
end)

-- Remove highlights from leaving players
Players.PlayerRemoving:Connect(function(playerRemoved)
    local character = playerRemoved.Character
    if character then
        removeHighlightFromCharacter(character)
    end
end)


if _G.CreateGui then
    toggleButton.MouseButton1Click:Connect(function()
        _G.ESPToggle = not _G.ESPToggle
        if _G.ESPToggle then
            toggleButton.Text = "ESP ON"
        else
            toggleButton.Text = "ESP OFF"
        end
    end)
    
    -- Initial button text
    if _G.ESPToggle then
        toggleButton.Text = "ESP ON"
    else
        toggleButton.Text = "ESP OFF"
    end
end

-- Keybind to toggle ESP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == _G.KeyBind then
        _G.ESPToggle = not _G.ESPToggle
        if _G.CreateGui then
            mainFrame.Visible = not mainFrame.Visible
        end
    end
end)