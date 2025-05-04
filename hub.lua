--[[ DEXTER HUB 🏡BROOKHAVEN RP ]]--

-- Carregar UI externa (Luarmor-like RGB GUI)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MeGustaLeche/OrionLib/main/Source"))()

local Window = OrionLib:MakeWindow({
    Name = "DEXTER HUB 🏡BROOKHAVEN RP",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DexterConfig"
})

-- TABS
local CarTab = Window:MakeTab({
    Name = "Carro",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Music Section
CarTab:AddParagraph("Músicas Personalizadas", "Clique para tocar para todos!")

CarTab:AddButton({
    Name = "Carregar músicas do GitHub",
    Callback = function()
        local success, result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPOSITORIO/main/musicas.txt")
        end)
        if success then
            for id in result:gmatch("%d+") do
                CarTab:AddButton({
                    Name = "Tocar ID: "..id,
                    Callback = function()
                        local Players = game:GetService("Players")
                        local Char = Players.LocalPlayer.Character
                        local Sound = Instance.new("Sound", Char)
                        Sound.SoundId = "rbxassetid://"..id
                        Sound.Volume = 5
                        Sound:Play()
                    end
                })
            end
        else
            warn("Erro ao carregar músicas:", result)
        end
    end
})

-- Exemplo: aba de troll
local TrollTab = Window:MakeTab({
    Name = "Troll",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TrollTab:AddButton({
    Name = "Ficar gigante",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        char.Humanoid.BodyHeightScale.Value = 5
        char.Humanoid.BodyWidthScale.Value = 5
        char.Humanoid.BodyDepthScale.Value = 5
    end
})

-- Sistema de farm (exemplo simples)
local FarmTab = Window:MakeTab({
    Name = "Farms",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddButton({
    Name = "Farm de Dinheiro (Gari)",
    Callback = function()
        -- Código de farm automático aqui
    end
})

OrionLib:Init()