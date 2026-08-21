local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local NeuroHubs = loadstring(game:HttpGet("https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/refs/heads/main/Script/NeuroHubs.lua"))()

task.wait(2)
-- 1. Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeuroHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Buat ImageLabel & UICorner
local iconImage = Instance.new("ImageLabel")
iconImage.Name = "AnimatedIcon"
iconImage.BackgroundTransparency = 1
iconImage.AnchorPoint = Vector2.new(0.5, 0.5)
iconImage.Position = UDim2.new(0.5, 0, 0.5, 0) -- Posisi awal tengah
iconImage.Size = UDim2.new(0, 0, 0, 0) -- Ukuran awal 0
iconImage.Parent = screenGui

-- Menambahkan UICorner agar sudut/ujungnya melengkung mulus (lingkaran sempurna)
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 5) -- Melengkung penuh / membulat
uiCorner.Parent = iconImage

-- 3. Download & Load Gambar
local imageUrl = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png"
local fileName = "NeuroHub_MainIcon.png"

if not isfile(fileName) then
    writefile(fileName, game:HttpGet(imageUrl))
end

iconImage.Image = getcustomasset(fileName)

-- Tunggu sejenak agar asset ter-register oleh engine
task.wait(0.5)

-- 4. Settings Animasi & Ukuran Lebih Kecil
local tweenInfoAppear = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfoMove = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local tweenInfoRotate = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1) -- Loop selamanya

-- Ukuran diperkecil ke 50x50 pixel agar tidak mengganggu layar
local sizeTarget = UDim2.new(0, 50, 0, 50) 
local posCornerTarget = UDim2.new(0, 35, 1, -35) -- Posisi pojok kiri bawah (disesuaikan dengan ukuran baru)

-- 5. Eksekusi Animasi
-- Animasi 1: Muncul di tengah
local tweenAppear = TweenService:Create(iconImage, tweenInfoAppear, {Size = sizeTarget})
tweenAppear:Play()

tweenAppear.Completed:Connect(function()
    -- Tunggu 2 detik setelah animasi 1 selesai
    task.wait(2)
    
    -- Animasi 2: Pindah ke pojok kiri bawah
    local tweenMove = TweenService:Create(iconImage, tweenInfoMove, {Position = posCornerTarget})
    tweenMove:Play()
    
    tweenMove.Completed:Connect(function()
        -- Animasi 3: Langsung putar loop tanpa delay
        local tweenRotate = TweenService:Create(iconImage, tweenInfoRotate, {Rotation = 360})
        tweenRotate:Play()
    end)
end)

