--// Crash-Proof UNC Test for Roblox Executors
-- Only runs tests proven safe, skips anything risky.

local function log(name, result)
    print(string.format("[UNC Test] %-20s | %s", name, tostring(result)))
end

local function exists(fn)
    return type(fn) == "function"
end

print("----- UNC Test Started -----")

--// Environment Checks
log("getgenv", exists(getgenv))
log("getrenv", exists(getrenv))
log("getgc", exists(getgc)) -- do not call, some executors crash
log("getinstances", exists(getinstances))
log("getnilinstances", exists(getnilinstances))
log("getconnections", exists(getconnections))
log("hookfunction", exists(hookfunction))
log("debug.getinfo", (debug and exists(debug.getinfo)) or false)

--// File System
log("writefile", exists(writefile))
log("readfile", exists(readfile))
log("appendfile", exists(appendfile))
log("delfile", exists(delfile))
log("isfile", exists(isfile))
log("listfiles", exists(listfiles))
log("makefolder", exists(makefolder))

--// HTTP
local req = (syn and syn.request) or request or http_request
log("http_request", exists(req))

--// Clipboard
log("setclipboard", exists(setclipboard))

--// Drawing API (don’t create objects, only check)
log("Drawing API", (Drawing and exists(Drawing.new)) or false)

--// Roblox Instances (don’t create/destroy, only check safe globals)
local safeServices = {
    "Players", "RunService", "TweenService", "UserInputService",
    "HttpService", "SoundService", "MarketplaceService"
}
for _, svc in ipairs(safeServices) do
    local ok = pcall(function() return game:GetService(svc) end)
    log(svc, ok)
end

--// Math + Utility
log("math.pi", math and math.pi ~= nil)
log("math.huge", math and math.huge ~= nil)

print("----- UNC Test Completed (Crash-Proof Mode) -----")
