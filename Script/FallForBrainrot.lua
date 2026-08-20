local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function getCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char:WaitForChild("Humanoid")
end

local FARM_COORDINATES = Vector3.new(110.91, 14599.43, -2510.77)
local farmPart = Instance.new("Part")
farmPart.Name = "NeuroHub_FarmAnchor"
farmPart.Size = Vector3.new(6, 1, 6)
farmPart.Position = FARM_COORDINATES
farmPart.Anchored = true
farmPart.CanCollide = false
farmPart.Transparency = 0.7
farmPart.Color = Color3.fromRGB(0, 255, 255)
farmPart.Material = Enum.Material.SmoothPlastic
farmPart.Parent = workspace

local Window = WindUI:CreateWindow({
    Title = "NeuroHub [Beta]",
    Icon = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png",
    Author = "by Khafidz.",
    Folder = "NeuroFall",
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
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

local Dropdown = Farm:Dropdown({
    Title = "Select Guard to teleport",
    Values = {"Scan first..."},
    Callback = function(selected)
        local targetObj = scannedModels[selected]
        if targetObj then
            local hrp = getRootPart()
            local targetCFrame = nil

            if targetObj:IsA("Model") then
                local cframe, size = targetObj:GetBoundingBox()
                targetCFrame = cframe + Vector3.new(0, (size.Y / 2) + 3, 0)
            elseif targetObj:IsA("BasePart") then
                targetCFrame = targetObj.CFrame + Vector3.new(0, (targetObj.Size.Y / 2) + 3, 0)
            else
                local anyPart = targetObj:FindFirstChildWhichIsA("BasePart", true)
                if anyPart then targetCFrame = anyPart.CFrame + Vector3.new(0, (anyPart.Size.Y / 2) + 3, 0) end
            end

            if targetCFrame and hrp then
                hrp.CFrame = targetCFrame
                WindUI:Notify({Title = "Teleported", Content = "Teleported to: " .. selected, Duration = 3})
            else
                WindUI:Notify({Title = "Error", Content = "Could not find a valid position for " .. selected, Duration = 3})
            end
        end
    end
})

local Scan = Farm:Button({
    Title = "Scan",
    Desc = "Save current position & scan Guards",
    Icon = "search",
    Color = Color3.fromRGB(100, 100, 255),
    Callback = function()
        local hrp = getRootPart()
        if hrp then lastSavedCFrame = hrp.CFrame end
        
        local dropperParts = workspace:FindFirstChild("DropperParts")
        local guardsFolder = dropperParts and dropperParts:FindFirstChild("Guards")
        
        if not guardsFolder then
            WindUI:Notify({Title = "Error", Content = "Folder DropperParts.Guards not found!", Duration = 4})
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
            if Dropdown.SetValues then Dropdown:SetValues(optionsList)
            elseif Dropdown.SetOptions then Dropdown:SetOptions(optionsList)
            elseif Dropdown.Refresh then Dropdown:Refresh(optionsList) end
            WindUI:Notify({Title = "Success", Content = "Position Saved & Found " .. tostring(#optionsList) .. " Guards.", Duration = 3})
        else
            if Dropdown.SetValues then Dropdown:SetValues({"No Guards Found"}) end
            WindUI:Notify({Title = "Empty", Content = "Guards folder is empty.", Duration = 3})
        end
    end
})

local BackButton = Farm:Button({
    Title = "Back to Start",
    Desc = "Return to saved position",
    Icon = "undo-2",
    Color = Color3.fromRGB(80, 150, 80),
    Callback = function()
        local hrp = getRootPart()
        if lastSavedCFrame and hrp then
            hrp.CFrame = lastSavedCFrame
            WindUI:Notify({Title = "Returning", Content = "Back to saved position.", Duration = 2})
        else
            WindUI:Notify({Title = "Error", Content = "No position saved! Click Scan first.", Duration = 3})
        end
    end
})

Farm:Divider()

local autoFarmActive = false
local preFarmCFrame = nil

local function isFalling(humanoid)
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.FallingDown then
        return true
    end
    local animator = humanoid:FindFirstChildWhichIsA("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            local animName = track.Name:lower()
            if animName:find("fall") or animName:find("drop") or animName:find("freefall") then
                return true
            end
        end
    end
    return false
end

local Auto = Farm:Toggle({
    Title = "Farming brick",
    Desc = "Use One part to Farming",
    Icon = "pickaxe",
    Value = false,
    Type = "Toggle",
    Locked = false,
    Flag = "my_farm",
    Callback = function(state)
        autoFarmActive = state

        if autoFarmActive then
            local hrp = getRootPart()
            if hrp then preFarmCFrame = hrp.CFrame end

            task.spawn(function()
                while autoFarmActive do
                    local currentHrp = getRootPart()
                    local currentHumanoid = getHumanoid()

                    if currentHrp and currentHumanoid then
                        currentHrp.CFrame = farmPart.CFrame + Vector3.new(0, 3, 0)

                        while autoFarmActive and isFalling(currentHumanoid) do
                            task.wait(0.2)
                        end

                        if autoFarmActive then
                            local idleStartTime = tick()
                            local stillIdle = true

                            while autoFarmActive and (tick() - idleStartTime < 8) do
                                if isFalling(currentHumanoid) then
                                    stillIdle = false
                                    break
                                end
                                task.wait(0.2)
                            end

                            if stillIdle then
                                WindUI:Notify({Title = "Cycle Complete", Content = "Verified 8s Idle. Repeating cycle...", Duration = 2})
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            local hrp = getRootPart()
            if hrp and preFarmCFrame then
                hrp.CFrame = preFarmCFrame
                WindUI:Notify({Title = "Farm Stopped", Content = "Returned to previous position.", Duration = 3})
            end
        end
    end
})
