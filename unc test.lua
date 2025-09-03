--[[
  Very Safe Extended UNC Probe
  - Only checks presence/types of APIs, never calls risky operations.
  - Each check uses pcall to avoid crashing bad executors.
  - Prints ✔️ / ❌ and a final percentage.
--]]

local total, passed = 0, 0

local function safeCheck(name, probe)
    total = total + 1
    local ok, res = pcall(function()
        return probe()
    end)
    local avail = ok and (res ~= nil and res ~= false)
    if avail then
        passed = passed + 1
        print("✔️ " .. name)
    else
        print("❌ " .. name .. (ok and "" or (" (error: " .. tostring(res) .. ")")))
    end
    return avail
end

local function existsGlobal(gname)
    return safeCheck(gname, function() return _G[gname] ~= nil end)
end

local function isCallable(v)
    return type(v) == "function" or type(v) == "table"
end

print("----- Very Safe Extended UNC Probe Started -----")

-- ===== BASIC LUA / LUAU FUNCTIONS =====
safeCheck("print", function() return type(print) == "function" end)
safeCheck("warn", function() return type(warn) == "function" end)
safeCheck("type", function() return type(type) == "function" end)
safeCheck("load or loadstring", function() return type(load) == "function" or type(loadstring) == "function" end)
safeCheck("assert", function() return type(assert) == "function" end)
safeCheck("error", function() return type(error) == "function" end)
safeCheck("coroutine.create", function() return type(coroutine) == "table" and type(coroutine.create) == "function" end)
safeCheck("table.insert", function() return type(table) == "table" and type(table.insert) == "function" end)
safeCheck("math.floor", function() return type(math) == "table" and type(math.floor) == "function" end)
safeCheck("string.sub", function() return type(string) == "table" and type(string.sub) == "function" end)

-- ===== ROBLOX BASICS (safe reads only) =====
safeCheck("game global", function() return type(game) == "Instance" or type(game) == "table" end)
safeCheck("workspace global", function() return workspace ~= nil end)
safeCheck("script global", function() return script ~= nil end)
safeCheck("Players service (GetService)", function() local ok, s = pcall(function() return game:GetService("Players") end) return ok and s ~= nil end)
safeCheck("RunService (GetService)", function() local ok, s = pcall(function() return game:GetService("RunService") end) return ok and s ~= nil end)
safeCheck("HttpService (GetService)", function() local ok, s = pcall(function() return game:GetService("HttpService") end) return ok and s ~= nil end)

-- ===== EXECUTOR / ENVIRONMENT =====
safeCheck("getgenv", function() return type(getgenv) == "function" end)
safeCheck("getrenv", function() return type(getrenv) == "function" end)
safeCheck("getsenv", function() return type(getsenv) == "function" end)
safeCheck("getfenv", function() return type(getfenv) == "function" end)
safeCheck("setfenv", function() return type(setfenv) == "function" end)
safeCheck("checkcaller", function() return type(checkcaller) == "function" end)
safeCheck("getcallingscript", function() return type(getcallingscript) == "function" end)
safeCheck("getexecutorname / identifyexecutor", function() return type(getexecutorname) == "function" or type(identifyexecutor) == "function" end)
safeCheck("getthreadidentity / getidentity", function() return type(getidentity) == "function" or type(getthreadidentity) == "function" end)
safeCheck("setidentity / setthreadidentity", function() return type(setidentity) == "function" or type(setthreadidentity) == "function" end)

-- ===== METAMETHOD / HOOKING PRESENCE (do NOT call hooks) =====
safeCheck("hookfunction (exists)", function() return type(hookfunction) == "function" end)
safeCheck("hookmetamethod (exists)", function() return type(hookmetamethod) == "function" end)
safeCheck("unhookmetamethod (exists)", function() return type(unhookmetamethod) == "function" end)
safeCheck("getrawmetatable (exists)", function() return type(getrawmetatable) == "function" end)
safeCheck("setrawmetatable (exists)", function() return type(setrawmetatable) == "function" end)
safeCheck("newcclosure (exists)", function() return type(newcclosure) == "function" end)
safeCheck("islclosure / iscclosure variants", function() return type(islclosure) == "function" or type(iscclosure) == "function" end)

-- ===== MEMORY / REGISTRY / GC (do NOT enumerate) =====
safeCheck("getgc (safe existence)", function() return type(getgc) == "function" end)
safeCheck("getregistry (safe existence)", function() return type(getreg) == "function" or type(getregistry) == "function" end)
safeCheck("getupvalues (safe existence)", function() return type(debug) == "table" and type(debug.getupvalue) == "function" end)

-- ===== DEBUG LIBRARY (safe existence) =====
safeCheck("debug.getinfo", function() return type(debug) == "table" and type(debug.getinfo) == "function" end)
safeCheck("debug.getlocal", function() return type(debug) == "table" and type(debug.getlocal) == "function" end)
safeCheck("debug.setlocal", function() return type(debug) == "table" and type(debug.setlocal) == "function" end)
safeCheck("debug.getmetatable", function() return type(debug) == "table" and type(debug.getmetatable) == "function" end)
safeCheck("debug.setmetatable", function() return type(debug) == "table" and type(debug.setmetatable) == "function" end)
safeCheck("debug.getprotos or getproto", function() return type(debug.getprotos) == "function" or type(getproto) == "function" end)

-- ===== FILESYSTEM (safe probes only) =====
safeCheck("writefile", function() return type(writefile) == "function" end)
safeCheck("readfile", function() return type(readfile) == "function" end)
safeCheck("isfile", function() return type(isfile) == "function" end)
safeCheck("delfile", function() return type(delfile) == "function" end)
safeCheck("appendfile", function() return type(appendfile) == "function" end)
safeCheck("write/read protected (no-op)", function() return (type(writefile) ~= "function") or true end) -- always safe

-- ===== HTTP / NETWORK (existence only, no request) =====
safeCheck("http request (syn.request/request/http_request)", function() return (syn and type(syn.request) == "function") or type(request) == "function" or type(http_request) == "function" end)
safeCheck("websocket (exists)", function() return type(syn) == "table" and (type(syn.websocket) == "function" or type(syn.websocket) == "table") or type(WebSocket) == "table" end)
safeCheck("queue_on_teleport (syn.queue_on_teleport)", function() return type(syn) == "table" and type(syn.queue_on_teleport) == "function" end)

-- ===== CRYPTO / CLIPBOARD / UTIL =====
safeCheck("crypt (exists)", function() return type(crypt) == "table" or type(syn and syn.crypt) ~= "nil" end)
safeCheck("setclipboard", function() return type(setclipboard) == "function" end)
safeCheck("getclipboard", function() return type(getclipboard) == "function" end)
safeCheck("rconsole functions", function() return type(rconsoleprint) == "function" or type(rconsolewarn) == "function" end)

-- ===== DRAWING / UI (safe probes only) =====
safeCheck("Drawing.new exists", function() return type(Drawing) == "table" and type(Drawing.new) == "function" end)
safeCheck("Drawing types accessible", function() return type(Drawing) == "table" end)
safeCheck("Instance.new exists", function() return type(Instance) == "table" and type(Instance.new) == "function" end)
safeCheck("UserInputService (exists)", function() return pcall(function() return game:GetService("UserInputService") end) end)

-- ===== MOUSE / INPUT (existence) =====
safeCheck("mouse1click / mouse1press etc", function() return type(mouse1click) == "function" or type(mouse1press) == "function" or type(mouse1release) == "function" end)

-- ===== ROBLOX TYPES & UTILITIES =====
safeCheck("Vector2/Vector3/CFrame available", function() return type(Vector2) == "table" and type(Vector3) == "table" and type(CFrame) == "table" end)
safeCheck("UDim/UDim2", function() return type(UDim) == "table" and type(UDim2) == "table" end)
safeCheck("Color3 / BrickColor", function() return type(Color3) == "table" and type(BrickColor) == "table" end)
safeCheck("TweenInfo type", function() return type(TweenInfo) == "table" end)

-- ===== ADVANCED API NAMES (existence only) =====
local adv = {
    "getrawmetatable","setreadonly","setrawmetatable","getconstants",
    "getprotos","getprotos","getloadedmodules","getloadedmodules",
    "identifyexecutor","isfolder","isfile","makefolder","listfiles","listfolders",
    "hookfunction","hookmetamethod","unhookmetamethod","clonefunction","newcclosure",
    "sethiddenproperty","gethiddenproperty","firesignal","fireclickdetector","firetouchinterest",
    "fireproximityprompt","getnamecallmethod","setnamecallmethod"
}
for _, name in ipairs(adv) do
    safeCheck(name, function() return type(_G[name]) ~= "nil" end)
end

-- ===== DEBUG / STACK / PROBE NAMES =====
safeCheck("debug.getstack (exists)", function() return type(debug.getstack) == "function" or type(debug.getinfo) == "function" end)
safeCheck("debug.getupvalue", function() return type(debug.getupvalue) == "function" end)
safeCheck("debug.setupvalue", function() return type(debug.setupvalue) == "function" end)
safeCheck("debug.getlocal", function() return type(debug.getlocal) == "function" end)
safeCheck("debug.setlocal", function() return type(debug.setlocal) == "function" end)

-- ===== SERVICES SAFE CHECK LIST (pcall each) =====
local services = {
    "Players","RunService","TweenService","UserInputService","HttpService","SoundService",
    "MarketplaceService","TeleportService","PathfindingService","BadgeService","DataStoreService",
    "CollectionService","Debris","ContextActionService","GuiService","ReplicatedStorage","ServerScriptService"
}
for _, svc in ipairs(services) do
    total = total + 1
    local ok, inst = pcall(function() return game:GetService(svc) end)
    if ok and inst then
        passed = passed + 1
        print("✔️ " .. svc)
    else
        print("❌ " .. svc)
    end
end

-- ===== SUMMARY =====
local percent = 0
if total > 0 then percent = math.floor((passed / total) * 100) end
print("----- Very Safe Extended UNC Probe Completed -----")
print(string.format("Passed %d/%d checks (%d%%)", passed, total, percent))
