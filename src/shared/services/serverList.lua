local serverList = {}
serverList.__index = serverList

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coreAssets = ReplicatedStorage:WaitForChild("coreAssets")
local MemoryStoreService = game:GetService("MemoryStoreService")
local serverListStore = MemoryStoreService:GetSortedMap("ServerList")
local remoteServerList = coreAssets:WaitForChild("RemoteEvents"):WaitForChild("ServerLists")

function serverList:init()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Initializing...")
    self.Servers = self:GetAllServers()
    remoteServerList:FireAllClients(self.Servers)
    self:Start()
end

function serverList:deepEqual(t1, t2)
    if t1 == t2 then return true end
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end

    for k, v in pairs(t1) do
        if not self:deepEqual(v, t2[k]) then
            return false
        end
    end
    for k, v in pairs(t2) do
        if not self:deepEqual(v, t1[k]) then
            return false
        end
    end
    return true
end

function serverList:GetAllServers()
    local servers = {}
    local success, items = pcall(function()
        return serverListStore:GetSortedAsync(false, 200)
    end)

    if success then
        for _, item in ipairs(items) do
            table.insert(servers, item.value)
        end
    else
        warn("[".. script.Parent.Name .. "][".. script.Name .. "] Failed to retrieve server list: " .. tostring(items))
    end
    return servers
end

function serverList:CheckForChange()
    local newServers = self:GetAllServers()
    if not self:deepEqual(self.Servers, newServers) then    
        self.Servers = newServers
        remoteServerList.FireAllClients(self.Servers)
        print("[".. script.Parent.Name .. "][".. script.Name .. "] Server list updated.")
    end
end

function serverList:Start()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Started")
    while true do
        task.wait(5) -- Check every 5 seconds
        self:CheckForChange()
    end
end

return serverList