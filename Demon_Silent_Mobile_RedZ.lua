-- Demon Silent Aim Mobile
-- Integrated with RedZ / Axion-style Toggle & Slider logic

-- LOAD GUI LIBRARY (RedZHub-based)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDZ-HUB/REDZ-LIB-V5/main/GuiLibrary.lua"))()

local Window = Library:CreateWindow({
    Name = "Demon Silent Mobile",
    Subtitle = "Touch Silent + ESP",
    Size = UDim2.fromOffset(550,380),
    Theme = "Darker"
})

local MainTab = Window:CreateTab("Main")
local VisualTab = Window:CreateTab("Visual")

local MainSection = MainTab:CreateSection("Mobile Aim")
local VisualSection = VisualTab:CreateSection("Visuals")

-- SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- VARIABLES
local SnapEnabled = false
local SilentEnabled = false
local ESPEnabled = false
local TouchActive = false

local currentTarget = nil
local FOVRadius = 200
local TargetPart = "Head"
local origFogEnd = Lighting.FogEnd

-- RAYCAST HOOK (SILENT AIM)
local oldRaycast = Workspace.Raycast
Workspace.Raycast = function(self, origin, direction, params)
    if SilentEnabled and currentTarget then
        local toTarget = (currentTarget.Position - origin)
        return oldRaycast(self, origin, toTarget.Unit * direction.Magnitude, params)
    end
    return oldRaycast(self, origin, direction, params)
end

-- FOV CIRCLE
local FOVGui = Instance.new("ScreenGui", game.CoreGui)
local FOV = Instance.new("Frame", FOVGui)
FOV.AnchorPoint = Vector2.new(0.5,0.5)
FOV.Position = UDim2.fromScale(0.5,0.5)
FOV.Size = UDim2.fromOffset(FOVRadius*2, FOVRadius*2)
FOV.BackgroundTransparency = 1
FOV.Visible = false

Instance.new("UICorner", FOV).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", FOV)
stroke.Thickness = 3
stroke.Transparency = 0.2

-- TARGET FUNCTION
local function GetClosestTarget()
    local closest, dist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(TargetPart) then
            local part = plr.Character[TargetPart]
            local pos, visible = Camera:WorldToViewportPoint(part.Position)
            if visible then
                local mag = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                if mag < FOVRadius and mag < dist then
                    dist = mag
                    closest = part
                end
            end
        end
    end
    return closest
end

-- TOUCH INPUT
UserInputService.TouchStarted:Connect(function()
    if SnapEnabled then TouchActive = true end
end)

UserInputService.TouchEnded:Connect(function()
    TouchActive = false
    currentTarget = nil
end)

-- LOOP
RunService.RenderStepped:Connect(function()
    FOV.Size = UDim2.fromOffset(FOVRadius*2, FOVRadius*2)

    if SnapEnabled then
        FOV.Visible = true
        if TouchActive then
            local target = GetClosestTarget()
            if target then
                if SilentEnabled then
                    currentTarget = target
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            end
        end
    else
        FOV.Visible = false
    end
end)

-- UI BINDS (TOGGLES / SLIDERS)

MainSection:Add("Toggle", {
    Name = "Aim on Touch",
    Default = false,
    Callback = function(v)
        SnapEnabled = v
    end
})

MainSection:Add("Toggle", {
    Name = "Silent Aim",
    Default = false,
    Callback = function(v)
        SilentEnabled = v
    end
})

MainSection:Add("Slider", {
    Name = "FOV Radius",
    Min = 100,
    Max = 500,
    Default = 200,
    Increase = 10,
    Callback = function(v)
        FOVRadius = v
    end
})

MainSection:Add("Dropdown", {
    Name = "Target Part",
    Options = {"Head","HumanoidRootPart"},
    Default = "Head",
    Callback = function(v)
        TargetPart = v
    end
})

VisualSection:Add("Toggle", {
    Name = "No Fog",
    Default = false,
    Callback = function(v)
        Lighting.FogEnd = v and 9e9 or origFogEnd
    end
})

Window:Notify({
    Title = "Demon Mobile",
    Content = "Script carregado com sucesso."
})
