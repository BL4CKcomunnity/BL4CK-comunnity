-- ========================================================
-- BL4CK HUB - WHITELIST & UI HORIZONTAL ANIMADA COM NEON AZUL
-- ========================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Link RAW do teu ficheiro whitelist.json no GitHub com anti-cache
local WhitelistURL = "https://raw.githubusercontent.com/BL4CKcomunnity/BL4CK-comunnity/refs/heads/main/whitelist.json?nocache=" .. tick()

local function CheckAccess()
    local success, response = pcall(function()
        return game:HttpGet(WhitelistURL)
    end)
    
    if success then
        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if successDecode and data then
            -- Aceita qualquer variação da chave, incluindo chaves traduzidas pelo navegador
            local listaUsers = data.whitelisted_users or data.usuarios or data.users or data.usuários_da_lista_de_permissões
            if listaUsers then
                for _, name in pairs(listaUsers) do
                    if name:lower() == player.Name:lower() then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Verificação de Whitelist (Dá Kick se não estiver autorizado)
if not CheckAccess() then
    player:Kick("BL4CK HUB: Acesso negado! Pede whitelist no servidor do Discord.")
    return
end

-- ========================================================
-- CÓDIGO DA UI DO BL4CK HUB
-- ========================================================

local function RandomString(length)
    local str = ""
    for i = 1, length do
        str = string.char(math.random(97, 122)) .. str
    end
    return str
end

local GuiName = RandomString(12)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

local aimbotEnabled = false
local legitAimbotEnabled = false 
local espEnabled = false
local flyEnabled = false
local noclipEnabled = false 
local wallCheckEnabled = false 
local bv, bg
local renderConnection

-- Tabela de Binds Configuráveis
local Binds = {
    Aimbot = Enum.KeyCode.E,
    LegitAimbot = Enum.KeyCode.Q,
    ESP = Enum.KeyCode.R,
    WallCheck = Enum.KeyCode.T,
    Fly = Enum.KeyCode.F,
    Noclip = Enum.KeyCode.X,
    TabGeral = Enum.KeyCode.G,
    TabExtras = Enum.KeyCode.H,
    TabBinds = Enum.KeyCode.J
}

local listeningForBind = nil

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

-- Frame Principal Horizontal e Animado
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 460, 0, 220)
Frame.Position = UDim2.new(0.5, -230, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = false
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Contorno Principal com Brilho/Raios Azuis Neon
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2.5

task.spawn(function()
    while Frame.Parent do
        TweenService:Create(UIStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.1, Thickness = 3}):Play()
        task.wait(0.8)
        TweenService:Create(UIStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.5, Thickness = 2}):Play()
        task.wait(0.8)
    end
end)

-- Animação inicial
Frame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 460, 0, 220)}):Play()

-- Imagem de Fundo
local BackgroundImage = Instance.new("ImageLabel", Frame)
BackgroundImage.Name = "CustomBG"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxthumb://type=Asset&id=91414165325665&w=420&h=420"
BackgroundImage.ImageTransparency = 0.25
BackgroundImage.ScaleType = Enum.ScaleType.Stretch
BackgroundImage.ZIndex = 0

-- Barra Superior
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0, 110, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "BL4CK <font color=\"rgb(0,170,255)\">HUB</font>"
Title.RichText = true
Title.ZIndex = 2

-- Seletor de Abas (G, H e J)
local TabBar = Instance.new("Frame", TitleBar)
TabBar.Size = UDim2.new(0, 220, 0, 24)
TabBar.Position = UDim2.new(1, -260, 0, 5.5)
TabBar.BackgroundTransparency = 1
TabBar.ZIndex = 3

local TabGeralBtn = Instance.new("TextButton", TabBar)
TabGeralBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabGeralBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabGeralBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabGeralBtn.Font = Enum.Font.GothamBold
TabGeralBtn.TextSize = 9
TabGeralBtn.Text = "GERAL [G]"
TabGeralBtn.ZIndex = 3
Instance.new("UICorner", TabGeralBtn).CornerRadius = UDim.new(0, 5)

local TabExtrasBtn = Instance.new("TextButton", TabBar)
TabExtrasBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabExtrasBtn.Position = UDim2.new(0.34, 0, 0, 0)
TabExtrasBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
TabExtrasBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
TabExtrasBtn.Font = Enum.Font.GothamBold
TabExtrasBtn.TextSize = 9
TabExtrasBtn.Text = "EXTRAS [H]"
TabExtrasBtn.ZIndex = 3
Instance.new("UICorner", TabExtrasBtn).CornerRadius = UDim.new(0, 5)

local TabBindsBtn = Instance.new("TextButton", TabBar)
TabBindsBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabBindsBtn.Position = UDim2.new(0.68, 0, 0, 0)
TabBindsBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
TabBindsBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
TabBindsBtn.Font = Enum.Font.GothamBold
TabBindsBtn.TextSize = 9
TabBindsBtn.Text = "BINDS [J]"
TabBindsBtn.ZIndex = 3
Instance.new("UICorner", TabBindsBtn).CornerRadius = UDim.new(0, 5)

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -30, 0, 5.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.Text = "X"
CloseButton.ZIndex = 3
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)

-- Containers das Abas
local ContainerGeral = Instance.new("Frame", Frame)
ContainerGeral.Size = UDim2.new(1, -20, 1, -45)
ContainerGeral.Position = UDim2.new(0, 10, 0, 40)
ContainerGeral.BackgroundTransparency = 1
ContainerGeral.Visible = true
ContainerGeral.ZIndex = 2

local ContainerExtras = Instance.new("Frame", Frame)
ContainerExtras.Size = UDim2.new(1, -20, 1, -45)
ContainerExtras.Position = UDim2.new(0, 10, 0, 40)
ContainerExtras.BackgroundTransparency = 1
ContainerExtras.Visible = false
ContainerExtras.ZIndex = 2

local ContainerBinds = Instance.new("ScrollingFrame", Frame)
ContainerBinds.Size = UDim2.new(1, -20, 1, -45)
ContainerBinds.Position = UDim2.new(0, 10, 0, 40)
ContainerBinds.BackgroundTransparency = 1
ContainerBinds.Visible = false
ContainerBinds.ScrollBarThickness = 3
ContainerBinds.CanvasSize = UDim2.new(0, 0, 0, 220)
ContainerBinds.ZIndex = 2

local BindsLayout = Instance.new("UIGridLayout", ContainerBinds)
BindsLayout.CellSize = UDim2.new(0, 210, 0, 32)
BindsLayout.CellPadding = UDim2.new(0, 10, 0, 8)

-- Função de Troca de Abas
local function SwitchTab(tabName)
    ContainerGeral.Visible = (tabName == "Geral")
    ContainerExtras.Visible = (tabName == "Extras")
    ContainerBinds.Visible = (tabName == "Binds")

    TabGeralBtn.BackgroundColor3 = (tabName == "Geral") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(32, 32, 42)
    TabGeralBtn.TextColor3 = (tabName == "Geral") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)

    TabExtrasBtn.BackgroundColor3 = (tabName == "Extras") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(32, 32, 42)
    TabExtrasBtn.TextColor3 = (tabName == "Extras") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)

    TabBindsBtn.BackgroundColor3 = (tabName == "Binds") and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(32, 32, 42)
    TabBindsBtn.TextColor3 = (tabName == "Binds") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
end

TabGeralBtn.MouseButton1Click:Connect(function() SwitchTab("Geral") end)
TabExtrasBtn.MouseButton1Click:Connect(function() SwitchTab("Extras") end)
TabBindsBtn.MouseButton1Click:Connect(function() SwitchTab("Binds") end)

-- Criar Botões Animados
local function CreateButton(parent, text, position)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 212, 0, 34)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(210, 210, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.Text = text
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Thickness = 1
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(36, 36, 48)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if not btn:GetAttribute("ActiveState") then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 36)}):Play()
        end
    end)
    
    return btn
end

-- Botões Aba Geral
local AimbotButton = CreateButton(ContainerGeral, "Ativar Aimbot ("..Binds.Aimbot.Name..")", UDim2.new(0, 0, 0, 12))
local LegitButton = CreateButton(ContainerGeral, "Legit Aimbot ("..Binds.LegitAimbot.Name..")", UDim2.new(0, 222, 0, 12))
local ESPButton = CreateButton(ContainerGeral, "Ativar ESP ("..Binds.ESP.Name..")", UDim2.new(0, 0, 0, 54))
local WallCheckButton = CreateButton(ContainerGeral, "WallCheck: OFF ("..Binds.WallCheck.Name..")", UDim2.new(0, 222, 0, 54))

local FOVLabel = Instance.new("TextLabel", ContainerGeral)
FOVLabel.Size = UDim2.new(0, 75, 0, 32)
FOVLabel.Position = UDim2.new(0, 0, 0, 96)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
FOVLabel.Font = Enum.Font.GothamSemibold
FOVLabel.TextSize = 11
FOVLabel.Text = "Raio FOV:"
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.ZIndex = 2

local FOVTextbox = Instance.new("TextBox", ContainerGeral)
FOVTextbox.Size = UDim2.new(0, 137, 0, 32)
FOVTextbox.Position = UDim2.new(0, 75, 0, 96)
FOVTextbox.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
FOVTextbox.BackgroundTransparency = 0.3
FOVTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVTextbox.Font = Enum.Font.GothamSemibold
FOVTextbox.TextSize = 12
FOVTextbox.Text = "100"
FOVTextbox.ZIndex = 2
Instance.new("UICorner", FOVTextbox).CornerRadius = UDim.new(0, 6)

-- Botões Aba Extras
local FlyButton = CreateButton(ContainerExtras, "Ativar Fly ("..Binds.Fly.Name..")", UDim2.new(0, 0, 0, 12))
local NoclipButton = CreateButton(ContainerExtras, "Noclip: OFF ("..Binds.Noclip.Name..")", UDim2.new(0, 222, 0, 12))

local SpeedLabel = Instance.new("TextLabel", ContainerExtras)
SpeedLabel.Size = UDim2.new(0, 85, 0, 32)
SpeedLabel.Position = UDim2.new(0, 0, 0, 54)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 11
SpeedLabel.Text = "Velocidade Fly:"
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 2

local SpeedTextbox = Instance.new("TextBox", ContainerExtras)
SpeedTextbox.Size = UDim2.new(0, 127, 0, 32)
SpeedTextbox.Position = UDim2.new(0, 85, 0, 54)
SpeedTextbox.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
SpeedTextbox.BackgroundTransparency = 0.3
SpeedTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextbox.Font = Enum.Font.GothamSemibold
SpeedTextbox.TextSize = 12
SpeedTextbox.Text = "50"
SpeedTextbox.ZIndex = 2
Instance.new("UICorner", SpeedTextbox).CornerRadius = UDim.new(0, 6)

-- Atualizar textos de botões com novas chaves
local function RefreshButtonTexts()
    AimbotButton.Text = aimbotEnabled and "Desativar Aimbot ("..Binds.Aimbot.Name..")" or "Ativar Aimbot ("..Binds.Aimbot.Name..")"
    LegitButton.Text = legitAimbotEnabled and "A segurar ("..Binds.LegitAimbot.Name..")..." or "Legit Aimbot ("..Binds.LegitAimbot.Name..")"
    ESPButton.Text = espEnabled and "Desativar ESP ("..Binds.ESP.Name..")" or "Ativar ESP ("..Binds.ESP.Name..")"
    WallCheckButton.Text = wallCheckEnabled and "WallCheck: ON ("..Binds.WallCheck.Name..")" or "WallCheck: OFF ("..Binds.WallCheck.Name..")"
    FlyButton.Text = flyEnabled and "Desativar Fly ("..Binds.Fly.Name..")" or "Ativar Fly ("..Binds.Fly.Name..")"
    NoclipButton.Text = noclipEnabled and "Noclip: ON ("..Binds.Noclip.Name..")" or "Noclip: OFF ("..Binds.Noclip.Name..")"
    TabGeralBtn.Text = "GERAL ["..Binds.TabGeral.Name.."]"
    TabExtrasBtn.Text = "EXTRAS ["..Binds.TabExtras.Name.."]"
    TabBindsBtn.Text = "BINDS ["..Binds.TabBinds.Name.."]"
end

-- Gerador de Botões de Bind na Aba Binds
local bindButtons = {}
local function CreateBindOption(bindName)
    local btn = CreateButton(ContainerBinds, bindName .. ": [" .. Binds[bindName].Name .. "]", UDim2.new(0, 0, 0, 0))
    bindButtons[bindName] = btn
    
    btn.MouseButton1Click:Connect(function()
        listeningForBind = bindName
        btn.Text = bindName .. ": [PRESSIONE...]"
        btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)
end

for actionName, _ in pairs(Binds) do
    CreateBindOption(actionName)
end

-- Movimentação por Arraste
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

-- Lógica e Funcionalidades dos Cheats
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
                local head = targetPlayer.Character.Head
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen and IsVisible(head) then
                    local screenPos = Vector2.new(headPos.X, headPos.Y)
                    local distanceFromCenter = (screenPos - center).Magnitude
                    
                    if distanceFromCenter <= smallestDistance then
                        smallestDistance = distanceFromCenter
                        closestPlayer = targetPlayer
                    end
                end
            end
        end
        return closestPlayer
    end

    local function ClearESP(char)
        if not char then return end
        for _, item in pairs(char:GetDescendants()) do
            if (item:IsA("BoxHandleAdornment") and item.Name == "Bl4ckBoxESP") or (item:IsA("BillboardGui") and item.Name == "Bl4ckNameESP") then
                item:Destroy()
            end
        end
    end

    local function ApplyBasicESP(targetPlayer, char)
        if not char then return end
        ClearESP(char)
        if not espEnabled then return end

        local humanoid = char:WaitForChild("Humanoid", 3)
        local head = char:WaitForChild("Head", 3)
        if not humanoid or humanoid.Health <= 0 or not head then return end

        local isTeam = IsTeammate(targetPlayer)
        local color = isTeam and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)

        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "Bl4ckBoxESP"
                box.Size = part.Size
                box.Color3 = color
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Adornee = part
                box.Parent = part
            end
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Bl4ckNameESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = head
        billboard.Parent = head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = targetPlayer.Name
        textLabel.TextColor3 = color
        textLabel.TextSize = 13
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextStrokeTransparency = 0.2
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Parent = billboard
    end

    local function UpdateAllESP()
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                ApplyBasicESP(targetPlayer, targetPlayer.Character)
            end
        end
    end

    local function SetupPlayer(targetPlayer)
        if targetPlayer.Character then
            ApplyBasicESP(targetPlayer, targetPlayer.Character)
        end
        targetPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(0.3)
            ApplyBasicESP(targetPlayer, newChar)
        end)
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then SetupPlayer(p) end
    end
    Players.PlayerAdded:Connect(function(p) SetupPlayer(p) end)

    local function ToggleWallCheck()
        wallCheckEnabled = not wallCheckEnabled
        RefreshButtonTexts()
    end

    local function ToggleFly()
        flyEnabled = not flyEnabled
        RefreshButtonTexts()
        
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = character.HumanoidRootPart
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if flyEnabled then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
            
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp
            
            if humanoid then humanoid.PlatformStand = true end
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end
    end

    local function ToggleNoclip()
        noclipEnabled = not noclipEnabled
        RefreshButtonTexts()
    end

    local function UnloadScript()
        aimbotEnabled = false
        legitAimbotEnabled = false
        espEnabled = false
        flyEnabled = false
        noclipEnabled = false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then ClearESP(p.Character) end
        end
        if renderConnection then renderConnection:Disconnect() end
        ScreenGui:Destroy()
    end

    -- RenderStepped: Movimento fluido pelas 4 SETAS + Lógica de Cheats
    renderConnection = RunService.RenderStepped:Connect(function(dt)
        if not listeningForBind and not UserInputService:GetFocusedTextBox() then
            local moveSpeed = 6
            local posX = Frame.Position.X.Offset
            local posY = Frame.Position.Y.Offset
            local scaleX = Frame.Position.X.Scale
            local scaleY = Frame.Position.Y.Scale

            if UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                posX = posX - moveSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Right) then
                posX = posX + moveSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                posY = posY - moveSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                posY = posY + moveSpeed
            end

            Frame.Position = UDim2.new(scaleX, posX, scaleY, posY)
        end

        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        if aimbotEnabled then
            local target = GetClosestPlayerToCenter()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            end
        end

        if legitAimbotEnabled then
            local target = GetClosestPlayerToCenter()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local targetPos = target.Character.Head.Position
                local goalCFrame = CFrame.new(camera.CFrame.Position, targetPos)
                local smoothness = math.clamp(dt * 4.5, 0.02, 0.08)
                camera.CFrame = camera.CFrame:Lerp(goalCFrame, smoothness)
            end
        end

        if flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local moveDir = Vector3.new(0, 0, 0)
            local currentSpeed = tonumber(SpeedTextbox.Text) or 50
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            if bv and bg then
                bv.Velocity = moveDir * currentSpeed
                bg.CFrame = camera.CFrame
            end
        end

        if noclipEnabled and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    local function UpdateButtonStyle(btn, state)
        btn:SetAttribute("ActiveState", state)
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(26, 26, 36),
            TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 220)
        }):Play()
    end

    AimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then 
            legitAimbotEnabled = false 
            UpdateButtonStyle(LegitButton, false)
        end
        RefreshButtonTexts()
        UpdateButtonStyle(AimbotButton, aimbotEnabled)
    end)

    ESPButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        RefreshButtonTexts()
        UpdateButtonStyle(ESPButton, espEnabled)
        UpdateAllESP()
    end)

    WallCheckButton.MouseButton1Click:Connect(function() ToggleWallCheck() end)
    FlyButton.MouseButton1Click:Connect(function() ToggleFly() end)
    NoclipButton.MouseButton1Click:Connect(function() ToggleNoclip() end)

    -- Leitura do Teclado (Atalhos + Configuração de Bind)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            -- Se estiver a aguardar para alterar uma Bind
            if listeningForBind then
                Binds[listeningForBind] = input.KeyCode
                bindButtons[listeningForBind].Text = listeningForBind .. ": [" .. input.KeyCode.Name .. "]"
                bindButtons[listeningForBind].TextColor3 = Color3.fromRGB(210, 210, 220)
                listeningForBind = nil
                RefreshButtonTexts()
                return
            end

            -- Acionamento de Cheats pelas Binds Dinâmicas
            if input.KeyCode == Binds.Aimbot then
                aimbotEnabled = not aimbotEnabled
                if aimbotEnabled then 
                    legitAimbotEnabled = false 
                    UpdateButtonStyle(LegitButton, false)
                end
                RefreshButtonTexts()
                UpdateButtonStyle(AimbotButton, aimbotEnabled)
            elseif input.KeyCode == Binds.LegitAimbot then
                legitAimbotEnabled = true
                aimbotEnabled = false 
                UpdateButtonStyle(AimbotButton, false)
                RefreshButtonTexts()
                UpdateButtonStyle(LegitButton, true)
            elseif input.KeyCode == Binds.ESP then
                espEnabled = not espEnabled
                RefreshButtonTexts()
                UpdateButtonStyle(ESPButton, espEnabled)
                UpdateAllESP()
            elseif input.KeyCode == Binds.WallCheck then
                ToggleWallCheck()
            elseif input.KeyCode == Binds.Fly then
                ToggleFly()
            elseif input.KeyCode == Binds.Noclip then
                ToggleNoclip()
            elseif input.KeyCode == Binds.TabGeral then
                SwitchTab("Geral")
            elseif input.KeyCode == Binds.TabExtras then
                SwitchTab("Extras")
            elseif input.KeyCode == Binds.TabBinds then
                SwitchTab("Binds")
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Binds.LegitAimbot then
            legitAimbotEnabled = false
            RefreshButtonTexts()
            UpdateButtonStyle(LegitButton, false)
        end
    end)

    CloseButton.MouseButton1Click:Connect(function() UnloadScript() end)
end)
