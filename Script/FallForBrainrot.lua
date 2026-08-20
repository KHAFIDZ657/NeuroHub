local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local Window = WindUI:CreateWindow({
    Title = "NeuroHub [Beta]", -- window title
    Icon = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by Khafidz.", -- window subtitle. optional
    Folder = "NeuroFall", -- folder to save keys and images
    
    User = { -- user information located at the bottom left
        Enabled = true, -- can be toggled with Window.User:Enable() or Window.User:Disable()
        Anonymous = false, -- can be toggled with Window.User:SetAnonymous(true) --(true or false)
        Callback = function() -- callback on click. optional. it can be removed
            print("Just Callback of User button. ")
        end,
    },
})

local About = Window:Tab({
    Title = "About",
    Desc = "About NeuroHub", -- optional
    Icon = "badge-info", -- lucide icon or "rbxassetid://" or URL. optional
    IconColor = Color3.fromRGB(173, 216, 230), -- custom icon color. optional
    IconShape = "Square", -- "Square" or "Circle". optional
    IconThemed = true, -- use theme colors. optional
    Locked = false, -- disable tab interaction. optional
    ShowTabTitle = false, -- show title inside tab. optional
    Border = true, -- add border around tab. optional
    CustomEmptyPage = { -- custom empty page when no elements are added to the tab. optional
		Icon = "lucide:smile", -- icon for empty page. optional
		Title = "empty", -- title for empty page. optional
		Desc = "Just a tabs normal", -- description for empty page. optional
	},
})

local Version = Window:Tag({
    Title = "Fall For Brainrot",
    Icon = "rocket", -- optional
    Color = Color3.fromRGB(0, 0, 128), -- custom color
})

local Paragraph = About:Paragraph({
    Title = "About",
    Desc = "NeuroHub is a script designed to provide basic yet useful features.\nVersion 1.0 "
})

local Farm = Window:Tab({
    Title = "Farm",
    Desc = "Auto Farming", -- optional
    Icon = "repeat", -- lucide icon or "rbxassetid://" or URL. optional
    IconColor = Color3.fromRGB(255, 100, 100), -- custom icon color. optional
    IconShape = "Square", -- "Square" or "Circle". optional
    IconThemed = true, -- use theme colors. optional
    Locked = false, -- disable tab interaction. optional
    ShowTabTitle = false, -- show title inside tab. optional
    Border = true, -- add border around tab. optional
    CustomEmptyPage = { -- custom empty page when no elements are added to the tab. optional
		Icon = "lucide:smile", -- icon for empty page. optional
		Title = "Empty", -- title for empty page. optional
		Desc = "Maybe In Development", -- description for empty page. optional
	},
})

local scannedParts = {}

local Dropdown = Farm:Dropdown({
    Title = "Select To teleport",
    Values = {"None"},
    Callback = function(selected)
        -- Cek apakah opsi yang dipilih ada di dalam daftar part hasil scan
        if scannedParts[selected] and scannedParts[selected]:IsA("BasePart") then
            -- Teleport pemain ke posisi part (+3 studs ke atas)
            RootPart.CFrame = scannedParts[selected].CFrame + Vector3.new(0, 3, 0)
            
            WindUI:Notify({
                Title = "Teleported",
                Content = "Teleported to: " .. selected,
                Duration = 3
            })
        end
    end
})

-- 2. BUTTON (Scan)
local Scan = Farm:Button({
    Title = "Scan",
    Desc = "Scan Folder ItemSpawners",
    Icon = "search",
    IconAlign = "Right",
    IconColor = Color3.fromHex("#ffffff"),
    Color = Color3.fromRGB(100, 100, 255),
    Locked = false,
    
    Callback = function()
        -- Cari Folder Spawner
        local spawnerFolder = workspace:FindFirstChild("DropperParts") and workspace.DropperParts:FindFirstChild("ItemSpawners")
        
        if not spawnerFolder then
            WindUI:Notify({
                Title = "Error",
                Content = "Folder ItemSpawners tidak ditemukan!",
                Duration = 4
            })
            return
        end

        local optionsList = {}
        scannedParts = {} -- Reset tabel part

        -- Loop semua folder (Common, Rare, Legendary, dll.)
        for _, folder in pairs(spawnerFolder:GetChildren()) do
            for _, item in pairs(folder:GetChildren()) do
                if item:IsA("BasePart") then
                    -- Format nama item di dropdown: "Rare - PartName"
                    local itemLabel = folder.Name .. " - " .. item.Name
                    
                    table.insert(optionsList, itemLabel)
                    scannedParts[itemLabel] = item -- Simpan referensi objek part
                end
            end
        end

        -- Jika tidak ada part yang ditemukan
        if #optionsList == 0 then
            table.insert(optionsList, "No Items Found")
        end

        -- Perbarui pilihan pada Dropdown WindUI
        Dropdown:SetValues(optionsList)

        WindUI:Notify({
            Title = "Scan Complete",
            Content = "Ditemukan " .. tostring(#optionsList) .. " item.",
            Duration = 3
        })
    end
})
