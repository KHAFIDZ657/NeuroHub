
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

local lastSavedCFrame = nil
local scannedModels = {} -- Menyimpan referensi model

local Dropdown = Farm:Dropdown({
    Title = "Select Guard to teleport",
    Values = {"Scan first..."},
    Callback = function(selected)
        -- Check if model exists
        local targetModel = scannedModels[selected]
        
        if targetModel then
            -- Find a valid target part (HumanoidRootPart or any BasePart)
            local targetPart = targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChildWhichIsA("BasePart")
            
            if targetPart then
                RootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                
                WindUI:Notify({
                    Title = "Teleported",
                    Content = "Teleporting to: " .. selected,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Model does not have a valid position.",
                    Duration = 3
                })
            end
        end
    end
})

-- 2. BUTTON (Scan & Remember Position)
local Scan = Farm:Button({
    Title = "Scan",
    Desc = "Save current position & scan Guards",
    Icon = "search",
    Color = Color3.fromRGB(100, 100, 255),
    
    Callback = function()
        -- A. Save current standing position
        lastSavedCFrame = RootPart.CFrame
        
        -- B. Locate the Guards Folder
        local guardsFolder = workspace:FindFirstChild("DropperParts") and workspace.DropperParts:FindFirstChild("Guards")
        
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

        -- C. Scan all Models inside the Guards folder
        for _, model in pairs(guardsFolder:GetChildren()) do
            if model:IsA("Model") or model:IsA("Folder") then
                local modelName = model.Name
                table.insert(optionsList, modelName)
                scannedModels[modelName] = model
            end
        end

        -- D. Update Dropdown
        if #optionsList > 0 then
            Dropdown:SetValues(optionsList)
            WindUI:Notify({
                Title = "Success",
                Content = "Position Saved & Found " .. tostring(#optionsList) .. " Guards.",
                Duration = 3
            })
        else
            Dropdown:SetValues({"No Guards Found"})
            WindUI:Notify({
                Title = "Empty",
                Content = "No models found in Guards folder.",
                Duration = 3
            })
        end
    end
})

-- 3. BUTTON (Return to saved position)
local BackButton = Farm:Button({
    Title = "Back to Start",
    Desc = "Return to saved position",
    Icon = "undo-2",
    Color = Color3.fromRGB(80, 150, 80),
    Callback = function()
        if lastSavedCFrame then
            RootPart.CFrame = lastSavedCFrame
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
