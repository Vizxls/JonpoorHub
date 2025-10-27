-- Splash Screen
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SplashScreen"
ScreenGui.Parent = PlayerGui

-- Theme Colors
local Theme = {
    Accent = Color3.fromHex("#30FF6A"),
    Dialog = Color3.fromHex("#1a1a1a"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Background = Color3.fromHex("#101010")
}

-- Background Frame
local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0, 500, 0, 250)
SplashFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SplashFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SplashFrame.BackgroundColor3 = Theme.Background
SplashFrame.BorderColor3 = Theme.Outline
SplashFrame.BorderSizePixel = 2
SplashFrame.Parent = ScreenGui
SplashFrame.ClipsDescendants = true
SplashFrame.Name = "SplashFrame"

-- Round corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = SplashFrame

-- Icon
local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 100, 0, 100)
Icon.Position = UDim2.new(0.5, -50, 0, 20)
Icon.Image = "rbxassetid://99908994219665"
Icon.BackgroundTransparency = 1
Icon.Parent = SplashFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 0, 50)
Title.Position = UDim2.new(0.5, -200, 0, 140)
Title.Text = "Stefan Hub"
Title.Font = Enum.Font.Roboto
Title.TextSize = 32
Title.TextColor3 = Theme.Text
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.TextStrokeTransparency = 0.8

-- Gradient for title text
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180))
}
titleGradient.Rotation = 90
titleGradient.Parent = Title

Title.Parent = SplashFrame

-- Loading Bar Background
local LoadingBG = Instance.new("Frame")
LoadingBG.Size = UDim2.new(0, 400, 0, 20)
LoadingBG.Position = UDim2.new(0.5, -200, 0, 200)
LoadingBG.BackgroundColor3 = Theme.Dialog -- grayish background
LoadingBG.BorderColor3 = Theme.Outline
LoadingBG.BorderSizePixel = 2
LoadingBG.Parent = SplashFrame

-- Round corners for loading bar background
local UICornerBG = Instance.new("UICorner")
UICornerBG.CornerRadius = UDim.new(0, 10)
UICornerBG.Parent = LoadingBG

-- Loading Bar (fill)
local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
LoadingBar.Position = UDim2.new(0, 0, 0, 0)
LoadingBar.BackgroundColor3 = Theme.Accent -- blue accent
LoadingBar.BorderSizePixel = 0
LoadingBar.Parent = LoadingBG

-- Gradient for LoadingBar
local loadingGradient = Instance.new("UIGradient")
loadingGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,255)) -- darker blue
}
loadingGradient.Rotation = 90
loadingGradient.Parent = LoadingBar

-- Smoothly fill loading bar
coroutine.wrap(function()
    for i = 0, 1, 0.005 do
        LoadingBar.Size = UDim2.new(i, 0, 1, 0)
        task.wait(0.01)
    end
    task.wait(0.5) -- wait before starting loader script

    -- Destroy splash screen after loading
    ScreenGui:Destroy()

-- cloneref fallback (preserve behavior if cloneref/clonereference is available)
local cloneref = cloneref or clonereference or function(instance)
    return instance
end

-- Services (cloneref-wrapped)
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

local LocalPlayer = Players.LocalPlayer

-- wait until the game is loaded and the local player's character exists
repeat
    task.wait()
    LocalPlayer = Players.LocalPlayer
until game:IsLoaded() and LocalPlayer and LocalPlayer.Character

-- Anti-AFK: try to disable connections to the Idled event if the executor provides getconnections
if typeof(getconnections) == "function" then
    local success, err = pcall(function()
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            if typeof(conn.Disable) == "function" then
                conn:Disable()
            elseif typeof(conn.disconnect) == "function" then
                conn:disconnect()
            end
        end
    end)
    if not success then
        warn("❌ Anti-AFK: failed to disable idle connections:", err)
    end
else
    warn("❌ Anti-AFK not available (getconnections not provided by executor)")
end

-- Loader table
local Loader = {}

-- Repository base URLs (authors -> raw GitHub base)
Loader.Repositories = {
    tgh = "https://raw.githubusercontent.com/Vizxls/StefanHub/main/",
}

-- Files mapping (FriendlyName -> metadata)
Loader.Files = {
    ["Mythical Tower Defense"] = { Author = "tgh", File = "MythicalTD/main.lua", CreatorId = 996742446 },
    ["Debug"] = { Author = "tgh", File = "DebugHub/main.lua", CreatorId = 5687644470 },
    ["The Strongest Battleground"] = { Author = "tgh", File = "TSB/main.lua", CreatorId = 12013007 },
    ["Steal a Brainrot"] = { Author = "tgh", File = "StealBrainrot/main.lua", CreatorId = 35815907 },
    ["test"] = { Author = "tgh", File = "testing/main.lua", CreatorId = 5687644470 }
}

-- Safe HTTP GET wrapper: tries syn.request, http.request, then game:HttpGet
local function safeHttpGet(url, timeout)
    timeout = timeout or 10
    if type(url) ~= "string" then
        return nil, "url must be a string"
    end

    -- prefer syn.request if present (many executors)
    if type(syn) == "table" and type(syn.request) == "function" then
        local ok, res = pcall(function()
            return syn.request({ Url = url, Method = "GET", Timeout = timeout })
        end)
        if ok and res and (res.Body ~= nil) then
            return res.Body, nil
        elseif ok and res and res.Body == nil then
            return nil, ("syn.request returned no body (StatusCode=%s)"):format(tostring(res.StatusCode))
        end
    end

    -- try http.request (some environments)
    if type(http) == "table" and type(http.request) == "function" then
        local ok, res = pcall(function()
            return http.request({ Url = url, Method = "GET", Timeout = timeout })
        end)
        if ok and res and res.Body then
            return res.Body, nil
        elseif ok and res and res.Body == nil then
            return nil, ("http.request returned no body (Status=%s)"):format(tostring(res.Status))
        end
    end

    -- fallback to game:HttpGet (may be blocked in some contexts)
    local ok, bodyOrErr = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok then
        return bodyOrErr, nil
    else
        return nil, ("game:HttpGet failed: %s"):format(tostring(bodyOrErr))
    end
end

-- Safely load + execute Lua code string
local function safeLoadAndExecute(code, sourceName)
    if type(code) ~= "string" then
        return false, "code must be a string"
    end

    local fn, err = loadstring(code, sourceName or "remote")
    if not fn then
        return false, ("compile error: %s"):format(tostring(err))
    end

    local ok, result = pcall(fn)
    if not ok then
        return false, ("runtime error: %s"):format(tostring(result))
    end

    return true, result
end

-- Load by CreatorId (main public function)
-- returns (true, message) on success; (false, error) on failure
function Loader:LoadByCreatorId(CreatorId)
    CreatorId = tonumber(CreatorId)
    if not CreatorId then
        return false, "CreatorId must be a number"
    end

    for gameName, data in pairs(self.Files) do
        if tonumber(data.CreatorId) == CreatorId then
            local base = self.Repositories[data.Author]
            if not base then
                local msg = ("Repository for author '%s' not found"):format(tostring(data.Author))
                warn("❌ Loader:", msg)
                return false, msg
            end

            local url = base .. data.File
            print(("➡ Attempting to load %q from %s"):format(gameName, url))

            local scriptText, httpErr = safeHttpGet(url)
            if not scriptText then
                local msg = ("HTTP error while fetching %q: %s"):format(gameName, tostring(httpErr))
                warn("❌ Loader:", msg)
                return false, msg
            end

            local ok, execRes = safeLoadAndExecute(scriptText, url)
            if ok then
                print(("✅ Loaded: %s (by @%s)"):format(gameName, data.Author))
                return true, ("Loaded "..tostring(gameName))
            else
                local msg = ("Execution error for %q: %s"):format(gameName, tostring(execRes))
                warn("❌ Loader:", msg)
                return false, msg
            end
        end
    end

    -- No matching CreatorId found — print ASCII art + unsupported message
    warn([[
-----------------------------------------------------------------------------------------
 ____ _____ _____ _____ _    _   _   _   _ _   _ ____             
/ ___|_   _| ____|  ___/ \  | \ | | | | | | | | | __ )            
\___ \ | | |  _| | |_ / _ \ |  \| | | |_| | | | |  _ \            
 ___) || | | |___|  _/ ___ \| |\  | |  _  | |_| | |_) |           
|____/ |_| |_____|_|/_/_ _\_\_|_\_| |_|_|_|\___/|____/_____ ____  
| | | | \ | / ___|| | | |  _ \|  _ \ / _ \|  _ \_   _| ____|  _ \ 
| | | |  \| \___ \| | | | |_) | |_) | | | | |_) || | |  _| | | | |
| |_| | |\  |___) | |_| |  __/|  __/| |_| |  _ < | | | |___| |_| |
 \___/|_| \_|____/ \___/|_|   |_|    \___/|_| \_\|_| |_____|____/ 

    UNSUPPORTED GAME - AUSTISM DETECTED
    ]])
    return false, "unsupported creator id"
end

-- Convenience: run loader for this game's creator id immediately
local ok, msg = Loader:LoadByCreatorId(game.CreatorId)
if ok then
    -- loaded successfully
else
    -- Not loaded — already warned inside function. If you want, handle fallback here.
end

return Loader
end)()
