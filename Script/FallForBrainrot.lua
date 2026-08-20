local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function getRootPart()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local Window = WindUI:CreateWindow({
    Title = "NeuroHub [Beta]",
    Icon = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png",
    Author = "by Khafidz.",
    Folder = "NeuroFall",
    
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User callback clicked")
        end,
    },
})

local About = Window:Tab({
    Title = "About",
    Desc = "About NeuroHub",
    Icon = "badge-info",
    IconColor = Color3.fromRGB(173, 216, 230),
    IconShape = "Square",
    IconThemed = true,
    Locked = false,
    ShowTabTitle = false,
    Border = true,
})

local Version = Window:Tag({
    Title = "Fall For Brainrot",
    Icon = "rocket",
    Color = Color3.fromRGB(0, 0, 128),
})

local Paragraph = About:Paragraph({
    Title = "About",
    Desc = "NeuroHub is a script designed to provide basic yet useful features.\nVersion 1.0 "
})

local Farm = Window:Tab({
    Title = "Farm",
    Desc = "Auto Farming",
    Icon = "repeat",
    IconColor = Color3.fromRGB(255, 100, 100),
    IconShape = "Square",
    IconThemed = true,
    Locked = false,
    ShowTabTitle = false,
    Border = true,
})

local lastSavedCFrame = nil
local scannedModels = {}

-- 1. DROPDOWN (Teleportasi Otomatis Menyesuaikan Ukuran Guard)
local Dropdown = Farm:Dropdown({
    Title = "Select Guard to teleport",
    Values = {"Scan first..."},
    Callback = function(selected)
        local targetObj = scannedModels[selected]
        
        if targetObj then
            local hrp = getRootPart()
            local targetCFrame = nil
            local offsetY = 3 -- Jarak bawaan jika berupa objek tunggal

            if targetObj:IsA("Model") then
                -- Hitung posisi pusat dan ukuran tinggi (size.Y) dari Model Guard
                local cframe, size = targetObj:GetBoundingBox()
                -- Tempatkan tepat di atas puncak Guard (+ setengah tingginya + 3 studs)
                targetCFrame = cframe + Vector3.new(0, (size.Y / 2) + 3, 0)
            elseif targetObj:IsA("BasePart") then
                targetCFrame = targetObj.CFrame + Vector3.new(0, (targetObj.Size.Y / 2) + 3, 0)
            else
                -- Jika berupa Folder/Configuration, cari part di dalamnya
                local anyPart = targetObj:FindFirstChildWhichIsA("BasePart", true)
                if anyPart then 
                    targetCFrame = anyPart.CFrame + Vector3.new(0, (anyPart.Size.Y / 2) + 3, 0) 
                end
            end

            if targetCFrame and hrp then
                hrp.CFrame = targetCFrame
                
                WindUI:Notify({
                    Title = "Teleported",
                    Content = "Teleported to: " .. selected,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Could not find a valid position for " .. selected,
                    Duration = 3
                })
            end
        end
    end
})

-- 2. SCAN BUTTON
local Scan = Farm:Button({
    Title = "Scan",
    Desc = "Save current position & scan Guards",
    Icon = "search",
    Color = Color3.fromRGB(100, 100, 255),
    
    Callback = function()
        local hrp = getRootPart()
        if hrp then
            lastSavedCFrame = hrp.CFrame
        end
        
        local dropperParts = workspace:FindFirstChild("DropperParts")
        local guardsFolder = dropperParts and dropperParts:FindFirstChild("Guards")
        
        if not guardsFolder then
            WindUI:Notify({
                Title = "Error",
                Content = "Folder DropperParts.Guards not found!",
                Duration = 4
            })
            return
        end

        local optionsList = {}
        scannedModels = {} 

        for _, child in pairs(guardsFolder:GetChildren()) do
            local itemName = child.Name
            table.insert(optionsList, itemName)
            scannedModels[itemName] = child
        end

        if #optionsList > 0 then
            if Dropdown.SetValues then
                Dropdown:SetValues(optionsList)
            elseif Dropdown.SetOptions then
                Dropdown:SetOptions(optionsList)
            elseif Dropdown.Refresh then
                Dropdown:Refresh(optionsList)
            end

            WindUI:Notify({
                Title = "Success",
                Content = "Position Saved & Found " .. tostring(#optionsList) .. " Guards.",
                Duration = 3
            })
        else
            if Dropdown.SetValues then Dropdown:SetValues({"No Guards Found"}) end
            
            WindUI:Notify({
                Title = "Empty",
                Content = "Guards folder is empty.",
                Duration = 3
            })
        end
    end
})

-- 3. BACK BUTTON
local BackButton = Farm:Button({
    Title = "Back to Start",
    Desc = "Return to saved position",
    Icon = "undo-2",
    Color = Color3.fromRGB(80, 150, 80),
    Callback = function()
        local hrp = getRootPart()
        if lastSavedCFrame and hrp then
            hrp.CFrame = lastSavedCFrame
            WindUI:Notify({
                Title = "Returning",
                Content = "Back to saved position.",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "No position saved! Click Scan first.",
                Duration = 3
            })
        end
    end
})

Farm:Divider()

local Auto = Farm:Toggle({
    Title = "Farming brick",
    Desc = "Use One part to Farming", -- optional
    Icon = "pickaxe", -- lucide icon or "rbxassetid://". optional
    Value = false, -- initial state. optional
    Type = "Toggle", -- "Toggle" or "Checkbox". optional
    Locked = false, -- disable toggle. optional
    Flag = "my_farm", -- for config saving. optional
    Callback = function(state)
        print("State changed:", state)
    end
})
