-- ========================================================
-- BL4CK HUB - UPDATED BACKGROUND IMAGE (ID: 88672860440331)
-- ========================================================

local function RandomString(length)
    local str = ""
    for i = 1, length do
        str = string.char(math.random(97, 122)) .. str
    end
    return str
end

local GuiName = RandomString(12)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

local aimbotEnabled = false
local legitAimbotEnabled = false 
local espEnabled = false
local flyEnabled = false
local noclipEnabled = false 
local wallCheckEnabled = false 
local bv, bg
local renderConnection

local playerGui = player:WaitForChild("PlayerGui")
for _, old in pairs(playerGui:GetChildren()) do
    if old:IsA("ScreenGui") and old.Name:find("Bl4ck") then
        old:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 440)
Frame.Position = UDim2.new(0.5, -190, 0.5, -220)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5

-- Imagem de Fundo (Acesso direto via API assetdelivery com o novo ID)
local BackgroundImage = Instance.new("ImageLabel", Frame)
BackgroundImage.Name = "CustomBG"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "https://assetdelivery.roblox.com/v1/asset/?id=88672860440331"
BackgroundImage.ImageTransparency = 0.15
BackgroundImage.ScaleType = Enum.ScaleType.Stretch
BackgroundImage.ZIndex = 0

local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
TitleBar.BackgroundTransparency = 0.4
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "BL4CK <font color=\"rgb(0,170,255)\">HUB</font>"
Title.RichText = true
Title.ZIndex = 2

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -38, 0, 6.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Text = "X"
CloseButton.ZIndex = 2
local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 8)

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function CreateButton(parent, text, position)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 168, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BackgroundTransparency = 0.4
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Text = text
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1
    
    return btn
end

local AimbotButton = CreateButton(Frame, "Ativar Aimbot (E)", UDim2.new(0, 15, 0, 60))
local LegitButton = CreateButton(Frame, "Legit Aimbot (Segurar Q)", UDim2.new(0, 197, 0, 60))
local ESPButton = CreateButton(Frame, "Ativar ESP (R)", UDim2.new(0, 15, 0, 115))
local WallCheckButton = CreateButton(Frame, "WallCheck: OFF (T)", UDim2.new(0, 197, 0, 115))
local FlyButton = CreateButton(Frame, "Ativar Fly (F)", UDim2.new(0, 15, 0, 170))
local NoclipButton = CreateButton(Frame, "Noclip: OFF (X)", UDim2.new(0, 197, 0, 170))

local SpeedLabel = Instance.new("TextLabel", Frame)
SpeedLabel.Size = UDim2.new(0, 85, 0, 40)
SpeedLabel.Position = UDim2.new(0, 15, 0, 230)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 13
SpeedLabel.Text = "Velocidade:"
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 2

local SpeedTextbox = Instance.new("TextBox", Frame)
SpeedTextbox.Size = UDim2.new(0, 75, 0, 35)
SpeedTextbox.Position = UDim2.new(0, 108, 0, 233)
SpeedTextbox.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
SpeedTextbox.BackgroundTransparency = 0.4
SpeedTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextbox.Font = Enum.Font.GothamSemibold
SpeedTextbox.TextSize = 14
SpeedTextbox.Text = "50"
SpeedTextbox.ZIndex = 2
local SpeedCorner = Instance.new("UICorner", SpeedTextbox)
SpeedCorner.CornerRadius = UDim.new(0, 6)

local FOVLabel = Instance.new("TextLabel", Frame)
FOVLabel.Size = UDim2.new(0, 85, 0, 35)
FOVLabel.Position = UDim2.new(0, 197, 0, 230)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
FOVLabel.Font = Enum.Font.GothamSemibold
FOVLabel.TextSize = 13
FOVLabel.Text = "Raio FOV:"
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.ZIndex = 2

local FOVTextbox = Instance.new("TextBox", Frame)
FOVTextbox.Size = UDim2.new(0, 75, 0, 35)
FOVTextbox.Position = UDim2.new(0, 290, 0, 233)
FOVTextbox.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
FOVTextbox.BackgroundTransparency = 0.4
FOVTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVTextbox.Font = Enum.Font.GothamSemibold
FOVTextbox.TextSize = 14
FOVTextbox.Text = "100"
FOVTextbox.ZIndex = 2
local FOVCorner = Instance.new("UICorner", FOVTextbox)
FOVCorner.CornerRadius = UDim.new(0, 6)

pcall(function()
    local function IsTeammate(targetPlayer)
        if player.Team and targetPlayer.Team then
            return player.Team == targetPlayer.Team
        end
        return false
    end

    local function GetCameraCenter()
        local viewportSize = camera.ViewportSize
        local inset = GuiService:GetGuiInset()
        return Vector2.new(viewportSize.X / 2, (viewportSize.Y / 2) + (inset.Y / 2))
    end

    local function IsVisible(targetPart)
        if not wallCheckEnabled then return true end
        local origin = camera.CFrame.Position
        local direction = targetPart.Position - origin
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {player.Character, camera}
        raycastParams.IgnoreWater = true
        
        local result = workspace:Raycast(origin, direction, raycastParams)
        if result then
            local hitPart = result.Instance
            if hitPart:IsDescendantOf(targetPart.Parent) then
                return true
            end
            return false
        end
        return true
    end

    local function GetClosestPlayerToCenter()
        local closestPlayer = nil
        local smallestDistance = tonumber(FOVTextbox.Text) or 100
        local center = GetCameraCenter()
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and not IsTeammate(targetPlayer) and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") and targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.Health > 0 then
                local head = targetPlayer.
