--[[ 
    Roblox UNC Test Suite
    Safely checks major executor APIs, filesystem, HTTP, and Drawing.
    Each test is wrapped in pcall to prevent crashing.
]]

local function log(name, ok, result)
    print(string.format("[UNC Test] %-20s | %s | %s", name, tostring(ok), tostring(result)))
end

local function test(name, fn)
    local ok, result = pcall(fn)
    log(name, ok, result)
    return ok, result
end

print("----- UNC Test Started -----")

--// Environment Checks
test("getgenv", function() return type(getgenv()) end)
test("getrenv", function() return type(getrenv()) end)
test("getgc", function() return type(getgc()) .. " (" .. tostring(#getgc()) .. ")" end)
test("getloadedmodules", function() return #getloadedmodules() end)
test("getinstances", function() return #getinstances() end)
test("getnilinstances", function() return #getnilinstances() end)
test("getconnections", function() 
    return #getconnections(game:GetService("RunService").Heartbeat) 
end)
test("hookfunction", function()
    local old
    old = hookfunction(print, function(...) return old(...) end)
    return type(old)
end)
test("debug.getinfo", function()
    return debug.getinfo(print).name or "ok"
end)

--// File System
test("writefile/readfile", function()
    writefile("UNC_Test.txt", "UNC Works")
    local r = readfile("UNC_Test.txt")
    return r
end)
test("appendfile", function()
    appendfile("UNC_Test.txt", "\nAppendCheck")
    return string.find(readfile("UNC_Test.txt"), "AppendCheck") ~= nil
end)
test("delfile", function()
    delfile("UNC_Test.txt")
    return not isfile("UNC_Test.txt")
end)
test("listfiles", function()
    return #listfiles(".")
end)

--// HTTP
if syn and syn.request then
    test("syn.request", function()
        local r = syn.request({Url="http://httpbin.org/get", Method="GET"})
        return r.StatusCode
    end)
elseif request then
    test("request", function()
        local r = request({Url="http://httpbin.org/get", Method="GET"})
        return r.StatusCode
    end)
else
    log("Http Request", false, "Not available")
end

--// Clipboard
if setclipboard then
    test("setclipboard", function()
        setclipboard("UNC Test")
        return "ok"
    end)
end

--// Drawing API
if Drawing then
    test("Drawing.new", function()
        local obj = Drawing.new("Circle")
        obj.Visible = true
        obj.Radius = 10
        obj.Position = Vector2.new(100,100)
        obj.Color = Color3.new(1,0,0)
        obj:Remove()
        return "Circle OK"
    end)
    test("Drawing Text", function()
        local t = Drawing.new("Text")
        t.Text = "UNC Test"
        t.Size = 16
        t.Visible = true
        t.Position = Vector2.new(200,200)
        t.Color = Color3.new(0,1,0)
        t:Remove()
        return "Text OK"
    end)
end

--// Roblox API
test("Instance.new", function()
    local p = Instance.new("Part")
    p.Parent = workspace
    return p:IsA("Part")
end)
test("TweenService", function()
    local ts = game:GetService("TweenService")
    local part = Instance.new("Part", workspace)
    local tween = ts:Create(part, TweenInfo.new(0.1), {Transparency=1})
    tween:Play()
    return tween.PlaybackState
end)
test("WorldPivot", function()
    local p = Instance.new("Part", workspace)
    local cf = CFrame.new(1,2,3)
    p:PivotTo(cf)
    return tostring(p:GetPivot())
end)

print("----- UNC Test Completed -----")
