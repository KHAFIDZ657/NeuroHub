local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()
local TeleportService = game:GetService("TeleportService")

local Window = WindUI:CreateWindow({
    Title = "NeuroHub", -- window title
    Icon = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by Khafidz.", -- window subtitle. optional
    Folder = "NeuroHub", -- folder to save keys and images
	Theme = "Dark",
    
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
    Title = "1.2",
    Icon = "rocket", -- optional
    Color = Color3.fromRGB(0, 0, 128), -- custom color
})

local Paragraph = About:Paragraph({
    Title = "About",
    Desc = "NeuroHub is a script designed to provide basic yet useful features.\nVersion 1.0 "
})

local Game = Window:Tab({
    Title = "Game",
    Icon = "gamepad-2", -- optional
})

local game1 = Game:Button({
    Title = "Fall For Brainrot",
    Color = Color3.fromRGB(255, 255, 0), -- Yellow
    Icon = "code-xml",
    Callback = function()
        Window:Notify({
            Title = "Please Wait..",
            Content = "Loading..",
            Duration = 5
        })

        task.wait(1.5)

        local TARGET_GAME_ID = 9793308933
        local scriptUrl = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Script/FallForBrainrot.lua"

        if game.PlaceId == TARGET_GAME_ID or game.GameId == TARGET_GAME_ID then
            -- Execute script if the player is in the correct game
            local success, result = pcall(function()
                return game:HttpGet(scriptUrl)
            end)

            if success and result then
                local execSuccess, execErr = pcall(function()
                    loadstring(result)()
                end)
                
                -- Catch error if loadstring fails
                if not execSuccess then
                    Window:Notify({
                        Title = "[SCRIPT ERROR]",
                        Content = tostring(execErr),
                        Duration = 8
                    })
                end
            else
                Window:Notify({
                    Title = "[FETCH ERROR]",
                    Content = "Failed to fetch script from GitHub.\nDetails: " .. tostring(result),
                    Duration = 8
                })
            end
        else
            -- Random logic when the player is in the WRONG game
            local chance = math.random(1, 100)

            if chance <= 30 then
                -- 30% CHANCE: Teleport to the official game & auto-execute script
                Window:Notify({
                    Title = "Redirecting..",
                    Content = "Wrong game! Teleporting to the correct game...",
                    Duration = 5
                })

                -- Save script to automatically run after server teleport
                local queueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
                if queueOnTeleport then
                    queueOnTeleport('loadstring(game:HttpGet("' .. scriptUrl .. '"))()')
                end

                task.wait(1)
                TeleportService:Teleport(TARGET_GAME_ID, game.Players.LocalPlayer)
            else
                -- 70% CHANCE: Kick from the game
                game.Players.LocalPlayer:Kick("NeuroHub Protection\n\nExecution Blocked: Unsafe Game Environment.")
            end
        end
    end
})

local Setting = Window:Tab({
    Title = "Setting",
    Desc = "Settings", -- optional
    Icon = "cog", -- lucide icon or "rbxassetid://" or URL. optional
    IconColor = Color3.fromRGB(255, 255, 255), -- custom icon color. optional
    IconShape = "Square", -- "Square" or "Circle". optional
    IconThemed = true, -- use theme colors. optional
    Locked = false, -- disable tab interaction. optional
    ShowTabTitle = false, -- show title inside tab. optional
    Border = true, -- add border around tab. optional
    CustomEmptyPage = { -- custom empty page when no elements are added to the tab. optional
		Icon = "lucide:smile", -- icon for empty page. optional
		Title = "Empty", -- title for empty page. optional
		Desc = "In Development.", -- description for empty page. optional
	},
})

local ColorGUI = Setting:Colorpicker({
    Title = "ColorGui",
    Desc = "Pick a color",
    Default = Color3.fromRGB(128, 128, 128),
    Locked = false,
    Flag = "custom_colorGUI",
    Callback = function(color)
        -- Mengubah warna aksen tema WindUI secara langsung
        if WindUI.Theme then
            WindUI.Theme.Accent = color
        end
    end
})
