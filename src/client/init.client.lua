local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("coreShared")
local getShare = sharedFolder:FindFirstChild("controllers"):GetChildren()

-- Loop through the shared folder and treat its children as services1 
for _, module in ipairs(getShare) do
    if module:IsA("ModuleScript") then
        print("Loading controller: " .. module.Name)
        local success, controller = pcall(require, module)
        if success and type(controller) == "table" and type(controller.init) == "function" then
            controller:init()
        else
            warn("Failed to load or initialize controller:", module.Name)
        end
    end
end

