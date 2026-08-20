local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. BUAT SCREENGUI OTOMATIS
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemScannerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- 2. FRAME UTAMA (Hitam Elegan)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- Hitam Elegan
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- GUI dapat digeser
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 50, 50) -- Border Garis Halus
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- 3. JUDUL GUI
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SPAWNED ITEM SCANNER"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- 4. SCROLLING FRAME (Daftar List Item)
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ItemScroll"
scrollingFrame.Size = UDim2.new(1, -20, 0, 290)
scrollingFrame.Position = UDim2.new(0, 10, 0, 55)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollingFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollingFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.PaddingBottom = UDim.new(0, 6)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = scrollingFrame

-- 5. TOMBOL SCAN
local scanButton = Instance.new("TextButton")
scanButton.Name = "ScanButton"
scanButton.Size = UDim2.new(1, -20, 0, 45)
scanButton.Position = UDim2.new(0, 10, 1, -55)
scanButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scanButton.Font = Enum.Font.GothamMedium
scanButton.TextSize = 14
scanButton.Text = "SCAN SPAWNED ITEMS"
scanButton.AutoButtonColor = true
scanButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = scanButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(70, 70, 70)
buttonStroke.Thickness = 1
buttonStroke.Parent = scanButton

-- FUNGSIONALITAS MEMBUAT CARD UNTUK LIST
local function createListItem(itemName)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 32)
	label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	label.BorderSizePixel = 0
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.Text = "  • " .. itemName
	label.TextXAlignment = Enum.TextXAlignment.Left

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = label

	return label
end

-- LOGIKA SCAN ITEM KETIKA TOMBOL DITEKAN
scanButton.MouseButton1Click:Connect(function()
	-- Bersihkan list lama
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	-- Cari folder target di Workspace secara aman
	local dropperParts = workspace:FindFirstChild("DropperParts")
	if not dropperParts then warn("DropperParts tidak ditemukan!") return end

	local itemSpawners = dropperParts:FindFirstChild("ItemSpawners")
	if not itemSpawners then warn("ItemSpawners tidak ditemukan!") return end

	local uncommonFolder = itemSpawners:FindFirstChild("Uncommon")
	if not uncommonFolder then warn("Folder Uncommon tidak ditemukan!") return end

	local itemFoundCount = 0

	-- Cek semua object di folder Uncommon
	for _, item in pairs(uncommonFolder:GetChildren()) do
		if item.Name == "SpawnedItem" then
			local infoGUI = item:FindFirstChild("InfoGUI")
			if infoGUI then
				local textLabels = infoGUI:FindFirstChild("TextLabels")
				if textLabels then
					local nameObject = textLabels:FindFirstChild("Name")
					if nameObject and nameObject:IsA("TextLabel") then
						itemFoundCount = itemFoundCount + 1
						local textContext = nameObject.Text
						
						-- Tambahkan ke daftar UI
						local itemCard = createListItem(textContext)
						itemCard.Parent = scrollingFrame
					end
				end
			end
		end
	end

	-- Tampilkan pesan jika tidak ada item ditemukan
	if itemFoundCount == 0 then
		local emptyLabel = createListItem("Tidak ada SpawnedItem ditemukan.")
		emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		emptyLabel.Parent = scrollingFrame
	end
end)

