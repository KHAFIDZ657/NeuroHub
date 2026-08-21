local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "NeuroHub", -- window title
    Icon = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Image/MainIcon.png", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by Khafidz.", -- window subtitle. optional
    Folder = "NeuroHub", -- folder to save keys and images
	Theme = "Dark"
    
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
    Color = Color3.fromRGB(255, 255, 0), -- abu abu
	Icon = "code-xml",
    Callback = function()
			 -- 1. Display loading notification first
        WindUI:Notify({
            Title = "Please Wait..",
            Content = "Loading..",
            Duration = 5
        })

        -- Brief pause for UX before processing verification
        task.wait(1.5)

        -- 2. Game ID verification
        local TARGET_GAME_ID = 9793308933
        
        if game.PlaceId == TARGET_GAME_ID or game.GameId == TARGET_GAME_ID then
            -- 3. Execute GitHub script if Game ID matches
            -- Replace with your GitHub RAW URL
            local url = "https://raw.githubusercontent.com/KHAFIDZ657/NeuroHub/main/Script/FallForBrainrot.lua"
            
            local success, result = pcall(function()
                return game:HttpGet(url)
            end)

            if success and result then
                loadstring(result)()
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Failed to fetch script from GitHub.",
                    Duration = 5
                })
            end
        else
            -- 4. Kick local player if Game ID differs
            game.Players.LocalPlayer:Kick("NeuroHub Protection\n\nYou in Different Game.")
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
