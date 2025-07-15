
-- KDML GUI - Roubei um Brainrot (by Darllan)

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")

-- GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "KDML_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", frame)

local function createBtn(name, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.Position = UDim2.new(0.05, 0, y, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	Instance.new("UICorner", btn)
	return btn
end

local btn1 = createBtn("Steal", 0.05)
local btn2 = createBtn("TP INSIDE NEAREST BASE", 0.4)
local btn3 = createBtn("TWEEN STEAL", 0.7)

local function foiRoubado()
	local holder = plr.PlayerGui:FindFirstChild("Index")
	if not holder then return false end
	local lista = holder:FindFirstChild("Main") and holder.Main:FindFirstChild("Content") and holder.Main.Content:FindFirstChild("Holder") and holder.Main.Content.Holder:FindFirstChild("List")
	if not lista then return false end
	for _, v in pairs(lista:GetChildren()) do
		if v:IsA("Model") or v:IsA("TextLabel") then
			return true
		end
	end
	return false
end

btn1.MouseButton1Click:Connect(function()
	while not foiRoubado() do
		for _, base in pairs(rs.Bases.ThirdFloor.AnimalPodiums:GetChildren()) do
			local teleport = base:FindFirstChild("Base")
			if teleport then
				plr.Character:MoveTo(teleport.Position + Vector3.new(0,3,0))
				wait(0.5)
			end
		end
	end
end)

btn2.MouseButton1Click:Connect(function()
	for _, base in pairs(rs.Bases.ThirdFloor.AnimalPodiums:GetChildren()) do
		local p = base:FindFirstChild("Base")
		if p then
			plr.Character:MoveTo(p.Position + Vector3.new(0,3,0))
			break
		end
	end
end)

btn3.MouseButton1Click:Connect(function()
	for _, base in pairs(rs.Bases.ThirdFloor.AnimalPodiums:GetChildren()) do
		local ponto = base:FindFirstChild("Base")
		if ponto then
			local humanoideRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local origem = humanoideRoot.Position
			local tween = ts:Create(humanoideRoot, TweenInfo.new(2), {CFrame = ponto.CFrame + Vector3.new(0,3,0)})
			tween:Play()
			tween.Completed:Wait()
			wait(0.5)
			if not foiRoubado() then
				local voltar = ts:Create(humanoideRoot, TweenInfo.new(2), {CFrame = CFrame.new(origem)})
				voltar:Play()
				voltar.Completed:Wait()
			else
				break
			end
		end
	end
end)

-- ESP Brainrots GOD / SECRET
local function criarESP(objeto, cor)
	local billboard = Instance.new("BillboardGui", objeto)
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.AlwaysOnTop = true
	billboard.Name = "ESP"

	local texto = Instance.new("TextLabel", billboard)
	texto.Size = UDim2.new(1, 0, 1, 0)
	texto.BackgroundTransparency = 1
	texto.Text = objeto.Name
	texto.TextColor3 = cor
	texto.TextStrokeTransparency = 0.5
	texto.Font = Enum.Font.SourceSansBold
	texto.TextScaled = true
end

task.spawn(function()
	while true do
		task.wait(5)
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("Model") or v:IsA("Part") then
				local nome = v.Name:lower()
				if nome:find("god") or nome:find("secret") then
					if not v:FindFirstChild("ESP") then
						criarESP(v, Color3.fromRGB(255, 0, 0))
					end
				end
			end
		end
	end
end)

-- ESP Players
local function criarPlayerESP(player)
	if player == plr then return end
	local char = player.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if head and not head:FindFirstChild("ESP") then
		local esp = Instance.new("BillboardGui", head)
		esp.Name = "ESP"
		esp.Size = UDim2.new(0, 100, 0, 25)
		esp.AlwaysOnTop = true
		esp.StudsOffset = Vector3.new(0, 2, 0)

		local label = Instance.new("TextLabel", esp)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 0)
		label.TextStrokeTransparency = 0.3
		label.Text = player.Name
		label.Font = Enum.Font.SourceSansBold
		label.TextScaled = true
	end
end

for _, player in pairs(game.Players:GetPlayers()) do
	criarPlayerESP(player)
end

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		criarPlayerESP(player)
	end)
end)

task.spawn(function()
	while true do
		task.wait(5)
		for _, player in pairs(game.Players:GetPlayers()) do
			criarPlayerESP(player)
		end
	end
end)
