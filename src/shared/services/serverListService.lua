-- OOP
local serverListService = {}
serverListService.__index = serverListService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coreShared = ReplicatedStorage:WaitForChild("coreShared")
local database = coreShared:WaitForChild("database")
local serverName = require(database:WaitForChild("serverName"))
local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")


function serverListService:init()
    print("[ServerListService] Initializing...")
    self.servers = {}
    self.region = "N/A"
    self.serverInfo = {
        Name = "",
        JobId = "",
        Region = "",
    }
    self:Start()
end

function serverListService:GetRegion()
    local URL = "http://ip-api.com/json"
    local response = HttpService:GetAsync(URL)
    if response then
        local data = HttpService:JSONDecode(response)
        return data.region
    end
end

function serverListService:Start()
    -- Initialize the service
    print("[ServerListService] Starting...")
    local randomAdjective = serverName.adjectives[math.random(1, #serverName.adjectives)]
    local randomObject = serverName.objects[math.random(1, #serverName.objects)]
    self.serverName = randomAdjective .. " " .. randomObject

    MessagingService:SubscribeAsync("ServerList", function(server)
        self.servers[#self.servers] = server
        task.wait(5)
        table.remove(self.servers, #self.server)
    end)    

    while game.VIPServerId == "" do
        self.serverInfo = {
            Name = self.serverName,
            JobId = game.JobId,
            Region = self:GetRegion(),
        }
        
        task.wait(5)

    end
    
end

return serverListService