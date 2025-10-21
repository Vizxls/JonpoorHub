{\rtf1\ansi\ansicpg1252\cocoartf2866
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 local WindUI\
local GuiService = game:GetService("GuiService")\
\
do\
    local ok, result = pcall(function()\
        return require("./src/init")\
    end)\
    \
    if ok then\
        WindUI = result\
    else \
        WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()\
    end\
end\
\
\
-- */  Window  /* --\
local Window = WindUI:CreateWindow(\{\
    Title = "Jonpoor Hub",\
    Author = "By tgh0 & yapzer",\
    Folder = "Jonfiles",\
    NewElements = true,\
    \
    HideSearchBar = true,\
    \
    OpenButton = \{\
        Title = "Jonpoor is Jonrich", -- can be changed\
        CornerRadius = UDim.new(1,0), -- fully rounded\
        StrokeThickness = 3, -- removing outline\
        Enabled = true, -- enable or disable openbutton\
        Draggable = true,\
        OnlyMobile = false,\
        \
        Color = ColorSequence.new( -- gradient\
            Color3.fromHex("#30FF6A"), \
            Color3.fromHex("#e7ff2f")\
        )\
    \}\
\})\
\
Window:Tag(\{\
    Title = "v0.5",\
    Color = Color3.fromHex("#FBFF1F"),\
    Radius = 13, -- from 0 to 13\
\})\
\
Window:Tag(\{\
    Title = "Alpha",\
    Color = Color3.fromHex("#FF1C00"),\
    Radius = 13, -- from 0 to 13\
\})\
\
\
\
-- */  Elements Section  /* --\
local MainSection = Window:Section(\{\
    Title = "Main",\
\})\
local MiscSection = Window:Section(\{\
    Title = "Misc",\
\})\
local SettingsSection = Window:Section(\{\
    Title = "Settings",\
\})\
\
\
-- */ Using Nebula Icons /* --\
do\
    local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()\
    \
    -- Adding icons (e.g. Fluency)\
    WindUI.Creator.AddIcons("fluency",    NebulaIcons.Fluency)\
    --               ^ Icon name          ^ Table of Icons\
    \
    -- You can also add nebula icons\
    WindUI.Creator.AddIcons("nebula",    NebulaIcons.nebulaIcons)\
    \
    -- Usage \uc0\u8593  \u8595 \
    \
    local TestSection = Window:Section(\{\
        Title = "Custom icons usage test (nebula)",\
        Icon = "nebula:nebula",\
    \})\
end\
\
\
\
-- */  Toggle Tab  /* --\
do\
-- Create Home Tab\
local HomeTab = MainSection:Tab(\{\
    Title = "Home",\
    Icon = "house"\
\})\
\
local Paragraph5 = HomeTab:Paragraph(\{\
    Title = "Update 0.5 Alpha!",\
    Desc = "\'95 Codes Tab Added\\n\'95 Easy Code Access\\n\'95 Fixed Expired Discord Link",\
\})\
local Paragraph4 = HomeTab:Paragraph(\{\
    Title = "Update 0.4 Alpha!",\
    Desc = "\'95 Added Egg Prices in 'Buy Egg' tab\\n\'95 Added new tab 'Buy Eggs' in Main\\n\'95 Fixed Some Bugs with Script Buttons.",\
\})\
\
local Paragraph3 = HomeTab:Paragraph(\{\
    Title = "Update 0.3 Alpha!",\
    Desc = "\'95 Minor Changes\\n\'95 Updated Script",\
\})\
\
local Paragraph2 = HomeTab:Paragraph(\{\
    Title = "Update 0.2 Alpha!",\
    Desc = "\'95 Added Buttons\\n\'95 Added Discord Server\\n\'95 A Barbershop haircut that cost a quarter\\n\'95 Fixed UI not functioning properly",\
\})\
\
local Paragraph1 = HomeTab:Paragraph(\{\
    Title = "Update 0.1 Alpha!",\
    Desc = "\'95 Fixed UI Problems\\n\'95 Made Jonpoor into Jonrich\\n\'95 UI no longer takes a long time to load",\
\})\
\
-- Discord Button\
HomeTab:Button(\{\
    Title = "Join Discord",\
    Callback = function()\
        local discordLink = "https://discord.gg/9vU6SkgP"\
        \
        -- Copy to clipboard\
        if setclipboard then\
            setclipboard(discordLink)\
        end\
\
        -- Show notification using WindUI\
        WindUI:Notify(\{\
            Title = "Discord Link Copied",\
            Desc = "The invite link has been copied to your clipboard!",\
            Icon = "check",\
            Duration = 3\
        \})\
    end\
\})\
\
end\
\
\
\
-- Eggs Tab\
local EggsTab = MainSection:Tab(\{\
    Title = "Buy Eggs",\
    Icon = "egg"\
\})\
\
-- Variables to store user choices\
local selectedEgg = "Lucky"\
local selectedAmount = 1\
\
-- Dropdown for egg type selection\
EggsTab:Dropdown(\{\
    Title = "Select Egg Type",\
    Desc = "Choose which egg you want to buy",\
    Values = \{ "Spooky", "Lucky", "Special", "Classic" \},\
    Value = "Classic", -- default\
    Callback = function(value)\
        selectedEgg = value\
        print("Selected Egg:", selectedEgg)\
    end\
\})\
\
-- Dropdown for amount selection\
EggsTab:Dropdown(\{\
    Title = "Select Amount",\
    Desc = "Choose how many eggs to buy",\
    Values = \{ "1", "10" \},\
    Value = "1", -- default\
    Callback = function(value)\
        selectedAmount = tonumber(value)\
        print("Selected Amount:", selectedAmount)\
    end\
\})\
\
-- Buy Button\
EggsTab:Button(\{\
    Title = "Buy Egg",\
    Callback = function()\
        local args = \{ selectedEgg, selectedAmount \}\
        local success, err = pcall(function()\
            game:GetService("ReplicatedStorage")\
                :WaitForChild("Events")\
                :WaitForChild("Data")\
                :WaitForChild("Buy")\
                :InvokeServer(unpack(args))\
        end)\
\
        if success then\
            WindUI:Notify(\{\
                Title = "Purchase Complete",\
                Desc = "Bought " .. selectedAmount .. "x " .. selectedEgg .. " Egg(s)!",\
                Icon = "check",\
                Duration = 3\
            \})\
        else\
            WindUI:Notify(\{\
                Title = "Purchase Failed",\
                Desc = tostring(err),\
                Icon = "x",\
                Duration = 3\
            \})\
        end\
    end\
\})\
\
-- Optional extra button\
EggsTab:Space()\
EggsTab:Button(\{\
    Title = "Button Example",\
    Desc = "Example Locked Button",\
    Locked = true,\
\})\
  EggsTab:Space()\
\
local Paragraph2 = EggsTab:Paragraph(\{\
    Title = "Egg's Prices (1 | 10 eggs)",\
    Desc = "Classic: 150 | 1350 gems\\nSpecial: 500 | 4500 gems\\nLucky: 3000 | 27000 gems\\nSpooky/Halloween: 1 | 10 keys",\
\})\
\
\
\
-- Codes Tab (or add to existing tab)\
local CodesTab = MainSection:Tab(\{\
    Title = "Codes",\
    Icon = "gift"\
\})\
\
-- Variable to hold the user input\
local enteredCode = ""\
\
-- Input box\
CodesTab:Input(\{\
    Title = "Enter Code",\
    Desc = "Type your code below",\
    Placeholder = "Enter your code here...",\
    Callback = function(value)\
        enteredCode = value\
        print("Code entered:", enteredCode)\
    end\
\})\
\
-- Space between elements\
CodesTab:Space()\
\
-- Redeem button\
CodesTab:Button(\{\
    Title = "Redeem Code",\
    Callback = function()\
        if enteredCode == "" then\
            WindUI:Notify(\{\
                Title = "Error",\
                Desc = "Please enter a code before redeeming!",\
                Icon = "x",\
                Duration = 3\
            \})\
            return\
        end\
\
        local args = \{ enteredCode \}\
\
        local success, err = pcall(function()\
            game:GetService("ReplicatedStorage")\
                :WaitForChild("Events")\
                :WaitForChild("Interactions")\
                :WaitForChild("VerifyCode")\
                :FireServer(unpack(args))\
        end)\
\
        if success then\
            WindUI:Notify(\{\
                Title = "Code Redeemed!",\
                Desc = "You successfully redeemed code: " .. enteredCode,\
                Icon = "check",\
                Duration = 3\
            \})\
        else\
            WindUI:Notify(\{\
                Title = "Redeem Failed",\
                Desc = tostring(err),\
                Icon = "x",\
                Duration = 3\
            \})\
        end\
    end\
\})\
\
\
\
local ConfigTab = SettingsSection:Tab(\{\
    Title = "Config",\
    Icon = "Settings"\
\})\
\
local Keybind = ConfigTab:Keybind(\{\
    Title = "Keybind",\
    Desc = "Keybind to open ui",\
    Value = "G",\
    Callback = function(v)\
        Window:SetToggleKey(Enum.KeyCode[v])\
    end\
\})}