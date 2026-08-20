local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "NeuroHub", -- window title
    Icon = "atom", -- lucide icon or "rbxassetid://" or URL. optional
    Author = "by Khafidz.", -- window subtitle. optional
    Folder = "NeuroHub", -- folder to save keys and images
    
    User = { -- user information located at the bottom left
        Enabled = true, -- can be toggled with Window.User:Enable() or Window.User:Disable()
        Anonymous = true, -- can be toggled with Window.User:SetAnonymous(true) --(true or false)
        Callback = function() -- callback on click. optional. it can be removed
            print("You name is 'user' ")
        end,
    },
})

local Tab = Window:Tab({
    Title = "About",
    Desc = "About NeuroHub", -- optional
    Icon = "info", -- lucide icon or "rbxassetid://" or URL. optional
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

Tab:Tag({
    Title = "1.0",
    Icon = "rocket", -- optional
    Color = Color3.fromRGB(0, 0, 128), -- custom color
})

