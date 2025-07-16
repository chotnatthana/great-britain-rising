local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("coreShared")
local getShare = sharedFolder:FindFirstChild("controllers"):GetChildren()

-- Loop through the shared folder and treat its children as services1 
for _, module in ipairs(getShare) do
    if module:IsA("ModuleScript") then
        print("Loading controller: " .. module.Name)
        local contoller = require(module)
        contoller:init()
    end
end

