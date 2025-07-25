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
    self:Start()
end

function serverListService:Start()
    -- Starting
end

return serverListService