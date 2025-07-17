local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local cam = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local coreAssets = ReplicatedStorage:WaitForChild("coreAssets")
local UIAssets = coreAssets:WaitForChild("UI")
local UIController = {}
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

-- Prevent multiple menus from being cloned
if player.PlayerGui:FindFirstChild("Menu") then
    player.PlayerGui.Menu:Destroy()
end

local menu = UIAssets:WaitForChild("Menu"):Clone()
menu.Parent = player:WaitForChild("PlayerGui")
local rootFrame = menu:WaitForChild("RootFrame")
local tabBar = menu.TabFrame:WaitForChild("TabBar")

repeat wait()
    cam.CameraType = Enum.CameraType.Scriptable
until cam.CameraType == Enum.CameraType.Scriptable
cam.FieldOfView = 35
cam.CFrame = workspace:WaitForChild("CutCam").CFrame
-- Tab buttons (Button under each tab)
local tabButtons = {
    tabBar:WaitForChild("MainFrame"):WaitForChild("Button"),
    tabBar:WaitForChild("ServersFrame"):WaitForChild("Button"),
    tabBar:WaitForChild("CreditFrame"):WaitForChild("Button"),
}
-- Tab labels (TextLabel under each tab)
local tabLabels = {
    tabBar:WaitForChild("MainFrame"):WaitForChild("TextLabel"),
    tabBar:WaitForChild("ServersFrame"):WaitForChild("TextLabel"),
    tabBar:WaitForChild("CreditFrame"):WaitForChild("TextLabel"),
}
-- Corresponding content frames
local contentFrames = {
    rootFrame:WaitForChild("MainFrame"),
    rootFrame:WaitForChild("ServersFrame"),
    rootFrame:WaitForChild("CreditFrame"),
}

local selectedTab = 1
local highlightColor = Color3.fromRGB(231, 180, 13)
local defaultColor = Color3.fromRGB(255, 255, 255)

-- Helper to update tab highlights
local function updateTabHighlights()
    for i, label in ipairs(tabLabels) do
        if i == selectedTab then
            label.TextColor3 = highlightColor
            label.Font = Enum.Font.SourceSansBold
        else
            label.TextColor3 = defaultColor
            label.Font = Enum.Font.SourceSans
        end
    end
end

-- Helper to tween page transitions
local function tweenToTab(newTab)
    if newTab == selectedTab then return end
    local oldTab = selectedTab
    local oldFrame = contentFrames[oldTab]
    local newFrame = contentFrames[newTab]
    local direction = (newTab > oldTab) and 1 or -1
    local width = oldFrame.AbsoluteSize.X

    -- Update highlight immediately
    selectedTab = newTab
    updateTabHighlights()

    -- Prepare new frame offscreen
    newFrame.Position = UDim2.new(direction, 0, 0, 0)
    newFrame.Visible = true
    oldFrame.Visible = true

    -- Tween out old frame, in new frame
    local tweenOut = TweenService:Create(oldFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(-direction, 0, 0, 0)
    })
    local tweenIn = TweenService:Create(newFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    tweenOut:Play()
    tweenIn:Play()
    tweenOut.Completed:Wait()
    oldFrame.Visible = false
    oldFrame.Position = UDim2.new(0, 0, 0, 0)
end

-- Tab click (mobile and PC)
for i, button in ipairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        if i ~= selectedTab then
            tweenToTab(i)
        end
    end)
end

-- Keyboard navigation (PC)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Q then
            local newTab = (selectedTab - 2) % #tabButtons + 1
            if newTab ~= selectedTab then
                tweenToTab(newTab)
            end
        elseif input.KeyCode == Enum.KeyCode.E then
            local newTab = (selectedTab) % #tabButtons + 1
            if newTab ~= selectedTab then
                tweenToTab(newTab)
            end
        end
    end
end)

-- Initialize
for i, frame in ipairs(contentFrames) do
    frame.Visible = (i == selectedTab)
    frame.Position = UDim2.new(0, 0, 0, 0)
end
updateTabHighlights()


return UIController