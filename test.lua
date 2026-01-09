-- Script completo atualizado para automação de farm em Roblox usando WindUI e TweenService
-- Este script deve ser executado em um LocalScript via executor no Roblox
-- Autor: Gerado por IA baseado nas especificações atualizadas
-- Data: Janeiro 2026
-- ATUALIZAÇÃO: Integrado Silent Aim avançado do script fornecido (Stefanuk12/Aiming), adaptado para WindUI; Mantido ESP existente

-- Serviços do Roblox
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

-- Jogador local
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()

-- Função para atualizar Character e HRP (caso respawne)
local function updateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end

-- Carregar WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Criar janela principal
local Window = WindUI:CreateWindow({
    Title = "EnergyStudios",
    Folder = "EnergyStudios",
    Theme = "Dark",
    Transparent = true,
    Size = UDim2.new(0, 580, 0, 460)
})

-- Criar aba AutoFarm
local AutoTab = Window:Tab({
    Title = "AutoFarm",
    Icon = "bird",
    Locked = false,
})

-- Variáveis globais para controle (AutoFarm)
local boxesFarmEnabled = false
local originalWalkSpeed = 16  -- Valor padrão comum
local originalJumpPower = 50  -- Valor padrão comum
local tweenDuration = 2  -- Duração padrão do tween em segundos (global)
local waitTimeBoxes = 10           -- Tempo para Boxes
local shortWait = 2                -- Espera fixa de 2s após E (global)

-- Funções auxiliares (AutoFarm)

-- Função para mover suavemente o jogador para uma posição usando TweenService
local function tweenTo(targetCFrame)
    updateCharacter()  -- Garantir Character atualizado
    local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Função para obter uma posição aleatória dentro de um modelo/pasta
local function getRandomPositionInModel(model)
    local parts = model:GetChildren()
    if #parts == 0 then return nil end
    
    local randomPart = parts[math.random(1, #parts)]
    if not randomPart:IsA("BasePart") then return nil end
    
    local size = randomPart.Size
    local pos = randomPart.Position
    local randomOffset = Vector3.new(
        math.random(-size.X/2, size.X/2),
        size.Y/2 + 5,  -- Acima para evitar colisão
        math.random(-size.Z/2, size.Z/2)
    )
    return CFrame.new(pos + randomOffset)
end

-- Função para simular pressionar a tecla "E"
local function simulateKeyPressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Função principal do loop de Boxes Farm
local function startBoxesFarm()
    spawn(function()
        while boxesFarmEnabled do
            local success, err = pcall(function()
                updateCharacter()
                originalWalkSpeed = Humanoid.WalkSpeed
                originalJumpPower = Humanoid.JumpPower
                
                -- Verificar existência dos objetos necessários
                local boxesFolder = Workspace:FindFirstChild("Boxes")
                if not boxesFolder then
                    print("Erro: Boxes não encontrado (Boxes Farm).")
                    boxesFarmEnabled = false
                    return
                end
                local boxGoal = Workspace:FindFirstChild("BoxGoal")
                if not boxGoal then
                    print("Erro: BoxGoal não encontrado (Boxes Farm).")
                    boxesFarmEnabled = false
                    return
                end
                
                -- Passo 1: Mover para random Part em Boxes
                local randomCFrame1 = getRandomPositionInModel(boxesFolder)
                if randomCFrame1 then
                    tweenTo(randomCFrame1)
                    print("Movido para posição aleatória em Boxes.")
                else
                    print("Erro: Posição aleatória em Boxes.")
                    return
                end
                
                -- Passo 2: Esperar 2s
                wait(shortWait)
                print("Esperado " .. shortWait .. "s em Boxes.")
                
                -- Passo 3: Simular "E"
                simulateKeyPressE()
                print("Tecla 'E' simulada em Boxes.")
                
                -- Passo 4: Mover para random em BoxGoal
                local randomCFrameGoal = getRandomPositionInModel(boxGoal)
                if randomCFrameGoal then
                    tweenTo(randomCFrameGoal)
                    print("Movido para posição aleatória em BoxGoal.")
                else
                    print("Erro: Posição aleatória em BoxGoal.")
                    return
                end
                
                -- Passo 5: Congelar por 10s (sem plataforma, parado no chão)
                Humanoid.WalkSpeed = 0
                Humanoid.JumpPower = 0
                print("Congelado por " .. waitTimeBoxes .. "s em BoxGoal.")
                wait(waitTimeBoxes)
                Humanoid.WalkSpeed = originalWalkSpeed
                Humanoid.JumpPower = originalJumpPower
                print("Movimento restaurado (Boxes).")
            end)
            
            if not success then
                print("Erro no ciclo Boxes: " .. tostring(err))
                boxesFarmEnabled = false
            end
            
            wait(1)
        end
        print("Boxes Farm desligado.")
    end)
end

-- Toggle para Farm Boxes
AutoTab:Toggle({
    Title = "Farm Boxes",
    Type = "Checkbox",
    Description = "Ativa farm automático de boxes (loop Boxes -> E -> BoxGoal)",
    Callback = function(state)
        boxesFarmEnabled = state
        if state then
            print("Boxes Farm ativado.")
            startBoxesFarm()
        else
            print("Boxes Farm desativado.")
        end
    end
})

-- Sliders (AutoFarm)

-- Slider Duração Tween (global)
AutoTab:Slider({
    Title = "Duração do Tween",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        tweenDuration = value
        print("Duração do tween: " .. value)
    end
})

-- Slider Tempo Boxes
AutoTab:Slider({
    Title = "Tempo Boxes",
    Min = 5,
    Max = 20,
    Default = 10,
    Callback = function(value)
        waitTimeBoxes = value
        print("Tempo Boxes: " .. value)
    end
})

-- Nova aba Combat para Silent Aim e ESP
local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "sword",
    Locked = false,
})

-- Carregar o módulo Aiming (Silent Aim base)
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()("Module")
local AimingChecks = Aiming.Checks
local AimingSelected = Aiming.Selected
local AimingSettingsIgnored = Aiming.Settings.Ignored
local AimingSettingsIgnoredPlayers = Aiming.Settings.Ignored.Players
local AimingSettingsIgnoredWhitelistMode = AimingSettingsIgnored.WhitelistMode

-- Configuração do Silent Aim (do script fornecido)
local Configuration = {
    -- // The ones under this you may change - if you are a normal user
    Enabled = true,
    Method = "FindPartOnRay",
    FocusMode = false, -- // Stays locked on to that player only. If true then uses the silent aim keybind, if a input type is entered, then that is used
    ToggleBind = false, -- // true = Toggle, false = Hold (to enable)
    Keybind = Enum.UserInputType.MouseButton2, -- // You can also have Enum.KeyCode.E, etc.

    -- // Do not change anything below here - if you are not a normal user
    CurrentlyFocused = nil,

    MethodResolve = {
        -- // __namecall methods
        raycast = {
            Real = "Raycast",
            Metamethod = "__namecall",
            Aliases = {"raycast"}
        },
        findpartonray = {
            Real = "FindPartOnRay",
            Metamethod = "__namecall",
            Aliases = {"findPartOnRay"}
        },
        findpartonraywithwhitelist = {
            Real = "FindPartOnRayWithWhitelist",
            Metamethod = "__namecall",
            Aliases = {"findPartOnRayWithWhitelist"}
        },
        findpartonraywithignorelist = {
            Real = "FindPartOnRayWithIgnoreList",
            Metamethod = "__namecall",
            Aliases = {"findPartOnRayWithIgnoreList"}
        },

        -- // __index methods
        target = {
            Real = "Target",
            Metamethod = "__index",
            Aliases = {"target"}
        },
        hit = {
            Real = "Hit",
            Metamethod = "__index",
            Aliases = {"hit"}
        },
        x = {
            Real = "X",
            Metamethod = "__index",
            Aliases = {"x"}
        },
        y = {
            Real = "Y",
            Metamethod = "__index",
            Aliases = {"y"}
        },
        unitray = {
            Real = "UnitRay",
            Metamethod = "__index",
            Aliases = {"unitray"}
        },
    },

    ExpectedArguments = {
        FindPartOnRayWithIgnoreList = {
            ArgCountRequired = 3,
            Args = {
                "Instance", "Ray", "table", "boolean", "boolean"
            }
        },
        FindPartOnRayWithWhitelist = {
            ArgCountRequired = 3,
            Args = {
                "Instance", "Ray", "table", "boolean"
            }
        },
        FindPartOnRay = {
            ArgCountRequired = 2,
            Args = {
                "Instance", "Ray", "Instance", "boolean", "boolean"
            }
        },
        Raycast = {
            ArgCountRequired = 3,
            Args = {
                "Instance", "Vector3", "Vector3", "RaycastParams"
            }
        }
    }
}
local IsToggled = false
Aiming.SilentAim = Configuration

-- Funções do Silent Aim (do script fornecido)
local function CalculateDirection(Origin, Destination, Length)
    return (Destination - Origin).Unit * Length
end

-- // Validate arguments passed through namecall
local function ValidateArguments(Args, Method)
	--// Get Type Information from Method
	local TypeInformation = Configuration.ExpectedArguments[Method]
	if (not TypeInformation) then
        return false
    end

	--// Make new table for successful matches
	local Matches = 0

	-- // Go through every argument passed
	for ArgumentPosition, Argument in pairs(Args) do
		-- // Check if argument type is a certain type
		if (typeof(Argument) == TypeInformation.Args[ArgumentPosition]) then
			Matches = Matches + 1
		end
	end

	-- // Get information
	local ExpectedValid = #Args
	local GotValid = Matches

	-- // Return whether or not arguments are valid
	return ExpectedValid == GotValid
end

-- // Additional checks you can add yourself, e.g. upvalue checks
function Configuration.AdditionalCheck(metamethod, method, callingscript, ...)
    return true
end

-- // Checks if a certain method is enabled
local stringsplit = string.split
local stringlower = string.lower
local tablefind = table.find
local function IsMethodEnabled(Method, Given, PossibleMethods)
    -- // Split it all up
    PossibleMethods = PossibleMethods or stringsplit(Configuration.Method, ",")
    Given = Given or Method

    -- // Vars
    local LoweredMethod = stringlower(Method)
    local MethodData = Configuration.MethodResolve[LoweredMethod]
    if (not MethodData) then
        return false, nil
    end

    -- //
    local Matches = LoweredMethod == stringlower(Given)
    local RealMethod = MethodData.Real
    local Found = tablefind(PossibleMethods, RealMethod)

    -- // Return
    return (Matches and Found), RealMethod
end

-- // Allows you to easily toggle multiple methods on and off
function Configuration.ToggleMethod(Method, State)
    -- // Vars
    local EnabledMethods = Configuration.Method:split(",")
    local FoundI = table.find(EnabledMethods, Method)

    -- //
    if (State) then
        if (not FoundI) then
            table.insert(EnabledMethods, Method)
        end
    else
        if (FoundI) then
            table.remove(EnabledMethods, FoundI)
        end
    end

    -- // Set
    Configuration.Method = table.concat(EnabledMethods, ",")
end

-- // Modify the position/cframe, add prediction yourself (use Aiming.Selected)
function Configuration.ModifyCFrame(OnScreen)
    return OnScreen and AimingSelected.Position or AimingSelected.Part.CFrame
end

-- // Focuses a player
local Backup = {table.unpack(AimingSettingsIgnoredPlayers)}
function Configuration.FocusPlayer(Player)
    table.insert(AimingSettingsIgnoredPlayers, Player)
    AimingSettingsIgnoredWhitelistMode.Players = true
end

-- // Unfocuses a player
function Configuration.Unfocus(Player)
    -- // Find it within ignored, and remove if found
    local PlayerI = table.find(AimingSettingsIgnoredPlayers, Player)
    if (PlayerI) then
        table.remove(AimingSettingsIgnoredPlayers, PlayerI)
    end

    -- // Disable whitelist mode
    AimingSettingsIgnoredWhitelistMode.Players = false
end

-- // Unfocuses everything
function Configuration.UnfocusAll(Replacement)
    Replacement = Replacement or Backup
    AimingSettingsIgnored.Players = Replacement
    AimingSettingsIgnoredWhitelistMode.Players = false
end

-- //
function Configuration.FocusHandler()
    if (Configuration.CurrentlyFocused) then
        Configuration.Unfocus(Configuration.CurrentlyFocused)
        Configuration.CurrentlyFocused = nil
        return
    end

    if (AimingChecks.IsAvailable()) then
        Configuration.FocusPlayer(AimingSelected.Instance)
        Configuration.CurrentlyFocused = AimingSelected.Instance
    end
end

-- // For the toggle and stuff
local function CheckInput(Input, Expected)
    local InputType = Expected.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType"
    return Input[InputType] == Expected
end

UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    -- // Make sure is not processed
    if (GameProcessedEvent) then
        return
    end

    -- // Check if matches bind
    local FocusMode = Configuration.FocusMode
    if (CheckInput(Input, Configuration.Keybind)) then
        if (Configuration.ToggleBind) then
            IsToggled = not IsToggled
        else
            IsToggled = true
        end

        if (FocusMode == true) then
            Configuration.FocusHandler()
        end
    end

    -- // FocusMode check
    if (typeof(FocusMode) == "EnumItem" and CheckInput(Input, FocusMode)) then
        Configuration.FocusHandler()
    end
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessedEvent)
    -- // Make sure is not processed
    if (GameProcessedEvent) then
        return
    end

    -- // Check if matches bind
    if (CheckInput(Input, Configuration.Keybind) and not Configuration.ToggleBind) then
        IsToggled = false
    end
end)

-- // Hooks
local __index
__index = hookmetamethod(game, "__index", function(t, k)
    -- // Vars
    local callingscript = getcallingscript()

    -- // Make sure everything is in order
    if (t:IsA("Mouse") and not checkcaller() and IsToggled and Configuration.Enabled and AimingChecks.IsAvailable()) then
        -- // Vars
        local MethodEnabled, RealMethod = IsMethodEnabled(k)

        -- // Make sure everything is in order 2
        if (not MethodEnabled or not Configuration.AdditionalCheck("__index", nil, callingscript, t, RealMethod)) then
            return __index(t, k)
        end

        -- // Target
        if (RealMethod == "Target") then
            return AimingSelected.Part
        end

        -- // Hit
        if (RealMethod == "Hit") then
            return Configuration.ModifyCFrame(false)
        end

        -- // X/Y
        if (RealMethod == "X" or RealMethod == "Y") then
            return Configuration.ModifyCFrame(true)[k]
        end

        -- // UnitRay
        if (RealMethod == "UnitRay") then
            local Origin = __index(t, k).Origin
            local Direction = CalculateDirection(Origin, Configuration.ModifyCFrame(false).Position)
            return Ray.new(Origin, Direction)
        end
    end

    -- // Return
    return __index(t, k)
end)

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(...)
    -- // Vars
    local args = {...}
    local self = args[1]
    local method = getnamecallmethod()
    local callingscript = getcallingscript()

    -- // Make sure everything is in order
    if (self == workspace and not checkcaller() and IsToggled and Configuration.Enabled and AimingChecks.IsAvailable()) then
        -- // Vars
        local MethodEnabled, RealMethod = IsMethodEnabled(method)

        -- // Make sure all is in order 2
        if (not MethodEnabled or not ValidateArguments(args, RealMethod) and Configuration.AdditionalCheck("__namecall", RealMethod, callingscript, ...)) then
            return __namecall(...)
        end

        -- // Raycast
        if (RealMethod == "Raycast") then
            -- // Modify args
            args[3] = CalculateDirection(args[2], Configuration.ModifyCFrame(false).Position, 1000)

            -- // Return
            return __namecall(unpack(args))
        end

        -- // The rest pretty much, modify args
        local Origin = args[2].Origin
        local Direction = CalculateDirection(Origin, __index(AimingSelected.Part, "Position"), 1000)
        args[2] = Ray.new(Origin, Direction)

        -- // Return
        return __namecall(unpack(args))
    end

    -- //
    return __namecall(...)
end)

-- Função auxiliar para dropdown multi
local function GetDictKeys(Dictionary)
    local Keys = {}
    for key, _ in pairs(Dictionary) do
        table.insert(Keys, key)
    end
    return Keys
end

-- GUI para Silent Aim no CombatTab (adaptado para WindUI)
CombatTab:Toggle({
    Title = "Silent Aim Enabled",
    Type = "Checkbox",
    Description = "Toggle the Silent Aim on and off",
    Callback = function(Value)
        Configuration.Enabled = Value
    end
}):AddKeyPicker({
    Default = Configuration.Keybind,
    SyncToggleState = false,
    Mode = Configuration.ToggleBind and "Toggle" or "Hold",
    Text = "Silent Aim",
    NoUI = false,
    ChangedCallback = function(Key)
        Configuration.Keybind = Key
    end
})

CombatTab:Toggle({
    Title = "Toggle Mode",
    Type = "Checkbox",
    Description = "When disabled, it is hold to activate.",
    Callback = function(Value)
        Configuration.ToggleBind = Value
    end
})

CombatTab:Toggle({
    Title = "Focus Mode",
    Type = "Checkbox",
    Description = "Only targets the current targetted player",
    Callback = function(Value)
        Configuration.FocusMode = Value
    end
}):AddKeyPicker({
    Default = Configuration.Keybind,
    SyncToggleState = false,
    Text = "Focus Mode",
    NoUI = false,
    ChangedCallback = function(Key)
        Configuration.FocusMode = Key
    end
})

-- Methods Dropdown
local Methods = {}
for _, method in pairs(Configuration.MethodResolve) do
    table.insert(Methods, method.Real)
end

CombatTab:Dropdown({
    Title = "Methods",
    Values = Methods,
    Multi = true,
    Default = Configuration.Method:split(","),
    Description = "The possible silent aim methods to enable",
    Callback = function(Value)
        Configuration.Method = table.concat(GetDictKeys(Value), ",")
    end
})

-- ESP (mantido do anterior)
local espEnabled = false
local espObjects = {}
local espConnections = {}
local function addESP(player)
    local connection = player.CharacterAdded:Connect(function(char)
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.fromRGB(255, 0, 0)
        box.Thickness = 1
        box.Transparency = 1
        box.Filled = false

        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Color = Color3.fromRGB(255, 255, 255)
        nameText.Size = 16
        nameText.Center = true
        nameText.Outline = true
        nameText.Font = 2  -- Default font

        table.insert(espObjects, box)
        table.insert(espObjects, nameText)

        local renderConn = RunService.RenderStepped:Connect(function()
            if espEnabled and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local rootPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                local headPos = Workspace.CurrentCamera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                if onScreen then
                    box.Size = Vector2.new(2000 / rootPos.Z, headPos.Y - legPos.Y)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                    box.Visible = true

                    nameText.Text = player.Name
                    nameText.Position = Vector2.new(rootPos.X, (rootPos.Y - box.Size.Y / 2) - nameText.Size)
                    nameText.Visible = true
                else
                    box.Visible = false
                    nameText.Visible = false
                end
            else
                box.Visible = false
                nameText.Visible = false
            end
        end)

        table.insert(espConnections, renderConn)
    end)

    table.insert(espConnections, connection)

    if player.Character then
        addESP(player)  -- Chama para personagem existente
    end
end

local function startESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addESP(player)
        end
    end
    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            addESP(player)
        end
    end)
    table.insert(espConnections, playerAddedConn)
end

local function stopESP()
    for _, conn in ipairs(espConnections) do
        conn:Disconnect()
    end
    for _, obj in ipairs(espObjects) do
        obj:Remove()
    end
    espConnections = {}
    espObjects = {}
end

-- Toggle para ESP
CombatTab:Toggle({
    Title = "ESP",
    Type = "Checkbox",
    Description = "Ativa ESP para visualizar jogadores através de paredes",
    Callback = function(state)
        espEnabled = state
        if state then
            startESP()
        else
            stopESP()
        end
    end
})

-- Fim do script
print("Script EnergyStudios carregado com sucesso! (Boxes Farm + Silent Aim avançado e ESP)")