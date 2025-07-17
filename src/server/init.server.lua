local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharedFolder = ReplicatedStorage:WaitForChild("coreShared")
local getShare = sharedFolder:FindFirstChild("services"):GetChildren()
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Function to teleport character to a position
local function teleportToOrigin(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	-- Make sure PrimaryPart is set
	if not character.PrimaryPart then
		character.PrimaryPart = hrp
	end

	local position = Vector3.new(-2.647, 10.3, -59.568)
	local rotation = CFrame.Angles(0, math.rad(25), 0)
	local finalCFrame = CFrame.new(position) * rotation

    local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	character:SetPrimaryPartCFrame(finalCFrame)
end

-- Connect when player joins
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		-- Wait for character parts to load
		task.wait(1)
		teleportToOrigin(player)
	end)
end)


-- Loop through the shared folder and treat its children as services1 
for _, module in ipairs(getShare) do
    if module:IsA("ModuleScript") then
        print("Loading service: " .. module.Name)
        local services = require(module)
        services:init()
    end
end

