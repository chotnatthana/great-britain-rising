-- OOP
local serverListService = {}
serverListService.__index = serverListService
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coreShared = ReplicatedStorage:WaitForChild("coreShared")
local database = coreShared:WaitForChild("database")
local serverName = require(database:WaitForChild("serverName"))
local HttpService = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local serverListStore = MemoryStoreService:GetSortedMap("serverList")


function serverListService:init()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Initializing...")
    self.serverInformation = {}
    self.randomId = HttpService:GenerateGUID(false)
    self.adjectives = serverName.adjectives[math.random(1, #serverName.adjectives)]
    self.objects = serverName.objects[math.random(1, #serverName.objects)]
    self.serverName = self.adjectives .. " " .. self.objects
    self.region = "N/A"
    self.currentPlayers = #game.Players:GetPlayers()
    self:Start()
end

function serverListService:fetchRegion()
    local URL = "http://ip-api.com/json/"
    local response
    local data

    local success, err = pcall(function()
        response = HttpService:GetAsync(URL)
        data = HttpService:JSONDecode(response)
    end)

    if success then
        self.region = data.regionName
    else
        warn("Failed to fetch region: " .. tostring(err))
        self.region = "N/A"
        task.wait(3) -- Retry after 3 seconds
        self:fetchRegion()
    end

end

function serverListService:Start()
    print("[".. script.Parent.Name .. "][".. script.Name .. "] Started")
    self:fetchRegion()
    self.serverInformation = {
        serverName = self.serverName,
        region = self.region,
        serverId = game.JobId,
        currentPlayers = self.currentPlayers
    }

    if game.VIPServerId == "" then
        serverListStore:SetAsync(self.randomId, self.serverInformation, 345600)
        print("[".. script.Parent.Name .. "][".. script.Name .. "] Log:: ", self.randomId, " To memory store")
        print("[".. script.Parent.Name .. "][".. script.Name .. "] Log:: JobId: ", game.JobId)
    end

    game.Players.PlayerAdded:Connect(function(player)
        if math.abs(self.currentPlayers - #game.Players:GetPlayers()) > 0 then
            self.currentPlayers = #game.Players:GetPlayers()
            self.serverInformation.currentPlayers = self.currentPlayers
            serverListStore:SetAsync(self.randomId, self.serverInformation, 345600)
            print("[".. script.Parent.Name .. "][".. script.Name .. "] Log:: Updated current players: ", self.currentPlayers)
        end
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        if math.abs(self.currentPlayers - #game.Players:GetPlayers()) > 0 then
            self.currentPlayers = #game.Players:GetPlayers()
            self.serverInformation.currentPlayers = self.currentPlayers
            serverListStore:SetAsync(self.randomId, self.serverInformation, 345600)
            print("[".. script.Parent.Name .. "][".. script.Name .. "] Log:: Updated current players: ", self.currentPlayers)
        end
    end)

    game:BindToClose(function()
        if game.VIPServerId == "" then
            serverListStore:RemoveAsync(self.randomId)
            print("[".. script.Parent.Name .. "][".. script.Name .. "] Log:: Removed server information from memory store")
        end
    end)
end

return serverListService