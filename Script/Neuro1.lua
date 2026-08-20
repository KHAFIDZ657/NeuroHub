local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "NeuroHub", -- window title
    Icon = "atom", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by Khafidz.", -- window subtitle. optional
    Folder = "NeuroHub", -- folder to save keys and images
    
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
    Title = "1.1",
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
    Title = "Not Available",
    Color = Color3.fromRGB(128, 128, 128), -- abu abu
	Icon = "badge-x"
    Callback = function()
			WindUI:Notify({
            Title = "Not available",
            Content = "In searching, In Development",
            Duration = 5
        })
    end
})
