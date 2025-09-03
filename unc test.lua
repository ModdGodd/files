--// Crash-Proof Extended UNC Test
-- Checks executor functions by existence only (no risky calls).
-- Outputs ✔️ and ❌ plus a final percentage score.

local total, passed = 0, 0

local function test(name, fn)
    total = total + 1
    local ok = pcall(function()
        if type(fn) == "function" then return true end
        if fn ~= nil then return true end
        return false
    end)
    local result = ok and (fn ~= nil)
    if result then
        passed = passed + 1
        print("✔️ " .. name)
    else
        print("❌ " .. name)
    end
end

print("----- Extended UNC Test Started -----")

--// Environments
test("getgenv", getgenv)
test("getrenv", getrenv)
test("getfenv", getfenv)
test("setfenv", setfenv)
test("getgc", getgc)
test("getinstances", getinstances)
test("getnilinstances", getnilinstances)
test("getreg", getreg)
test("getrenv", getrenv)

--// Metamethod / Hooking
test("hookfunction", hookfunction)
test("newcclosure", newcclosure)
test("isourclosure", isourclosure)
test("iscclosure", iscclosure)
test("checkcaller", checkcaller)
test("getcallingscript", getcallingscript)

--// Debug Library
test("debug.getinfo", debug and debug.getinfo)
test("debug.getupvalue", debug and debug.getupvalue)
test("debug.setupvalue", debug and debug.setupvalue)
test("debug.getmetatable", debug and debug.getmetatable)
test("debug.setmetatable", debug and debug.setmetatable)

--// File System
test("writefile", writefile)
test("readfile", readfile)
test("appendfile", appendfile)
test("delfile", delfile)
test("isfile", isfile)
test("isfolder", isfolder)
test("listfiles", listfiles)
test("makefolder", makefolder)

--// HTTP
local req = (syn and syn.request) or request or http_request
test("http_request", req)
test("syn.request", syn and syn.request)

--// Clipboard
test("setclipboard", setclipboard)

--// Cryptography
test("crypt.encrypt", crypt and crypt.encrypt)
test("crypt.decrypt", crypt and crypt.decrypt)
test("crypt.hash", crypt and crypt.hash)
test("crypt.generatekey", crypt and crypt.generatekey)

--// Identity & Executor Info
test("getidentity", getidentity)
test("setidentity", setidentity)
test("getexecutorname", getexecutorname)
test("identifyexecutor", identifyexecutor)

--// Drawing API (safe check only)
test("Drawing.new", Drawing and Drawing.new)
test("Drawing.clear", Drawing and Drawing.clear)

--// Input / Mouse
test("mouse1click", mouse1click)
test("mouse1press", mouse1press)
test("mouse1release", mouse1release)
test("mouse2click", mouse2click)

--// Roblox Services (safe pcall on GetService)
local services = {
    "Players", "RunService", "TweenService", "UserInputService",
    "HttpService", "SoundService", "MarketplaceService",
    "TeleportService", "PathfindingService", "BadgeService",
}
for _, svc in ipairs(services) do
    total = total + 1
    local ok = pcall(function() return game:GetService(svc) end)
    if ok then
        passed = passed + 1
        print("✔️ " .. svc)
    else
        print("❌ " .. svc)
    end
end

--// Math & Utility
test("math.pi", math and math.pi)
test("math.huge", math and math.huge)
test("task.spawn", task and task.spawn)
test("task.wait", task and task.wait)

--// Final Score
local percent = math.floor((passed / total) * 100)
print("----- Extended UNC Test Completed -----")
print(string.format("Passed %d/%d checks (%d%%)", passed, total, percent))
