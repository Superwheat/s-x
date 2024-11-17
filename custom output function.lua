local RunService = cloneref(game:GetService("RunService"))
local LogService = cloneref(game:GetService("LogService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local listedInfoMsgs = {}
local split = string.split

local function escapePattern(str)
    return str:gsub("([%-%[%]%(%)%^%.%$%%%.%+%*%?])", "%%%1") -- idk what this is :skull:
end

local function findInTable(msg)
    for id, _ in pairs(listedInfoMsgs) do
        local escapedID = escapePattern(id)
        if string.find(msg, escapedID) then
            return id
        end
    end
end

local function splitMessage(input)
    local delimiterIndex = string.find(input, "%-%-")
    if delimiterIndex then
        return string.sub(input, 1, delimiterIndex - 1), string.sub(input, delimiterIndex + 2)
    end
end

local function generateRandomID(length)
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?`~"
    local randomString = ""

    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        randomString = randomString .. characters:sub(randomIndex, randomIndex)
    end

    return randomString
end

local function getConsoleUI(returnDevConsoleUI)
    local DevConsoleMaster = CoreGui:FindFirstChild("DevConsoleMaster")
    local DevConsoleWindow = DevConsoleMaster and DevConsoleMaster:FindFirstChild("DevConsoleWindow")
    local DevConsoleUI = DevConsoleWindow and DevConsoleWindow:FindFirstChild("DevConsoleUI")
    local MainView = DevConsoleUI and DevConsoleUI:FindFirstChild("MainView")
    local ClientLog = MainView and MainView:FindFirstChild("ClientLog")
    
    return ClientLog
end

local listeningTo = {}
local first;

local connections = {}

CoreGui.DescendantAdded:Connect(function(m)
    if m.Name == "msg" then
        local parentName = m.Parent.Name
        
        local start, msg = splitMessage(m.Text)
        local id = findInTable(msg)
        
        if id then
            msg = split(msg, id)[2]
        
            if msg then
                m.Text = `{start}-- {msg}`
                m.TextColor3 = Color3.fromRGB(0, 255, 0) 
            end
        end
        
        connections[parentName] = m:GetPropertyChangedSignal("Text"):Connect(function()
            local start, msg = splitMessage(m.Text)
            local id = findInTable(msg)
            
            if not id then
                if m.Parent.image.Image == "" then
                    m.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                return;
            end
            
            msg = split(msg, id)[2]
        
            if not msg then return; end
            
            m.Text = `{start}-- {msg}`
            m.TextColor3 = Color3.fromRGB(0, 255, 0)
        end)
        m:GetPropertyChangedSignal("Parent"):Connect(function()
            if connections[parentName] then connections[parentName]:Disconnect() connections[parentName] = nil end
        end)
    end
end)

local function createConnection(msg, randomID)
    listedInfoMsgs[randomID] = msg
end

getgenv().info = function(msg)
    local randomID = generateRandomID(5)
    task.spawn(createConnection, msg, randomID)
    print(`{randomID}{msg}`)
end
