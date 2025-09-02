-- BackgroundMusicManager.lua

local SoundService = game:GetService("SoundService")

local BackgroundMusicManager = {}
BackgroundMusicManager.MusicFolder = SoundService:WaitForChild("MusicBackground")

local currentMusic = nil
local running = false

function BackgroundMusicManager:init()
	print("[".. script.Parent.Name .. "][".. script.Name .. "] Initializing...")
	self:playRandomLoop()
end

function BackgroundMusicManager:getRandomTrack()
	local sounds = self.MusicFolder:GetChildren()
	local validSounds = {}

	for _, sound in ipairs(sounds) do
		if sound:IsA("Sound") then
			table.insert(validSounds, sound)
		end
	end

	if #validSounds == 0 then
		warn("No valid sounds found in BackgroundMusic folder.")
		return nil
	end

	return validSounds[math.random(1, #validSounds)]
end

function BackgroundMusicManager:playRandomLoop()
	print("[".. script.Parent.Name .. "][".. script.Name .. "] Started")
	if running then return end
	running = true

	while running do
		currentMusic = self:getRandomTrack()
		if currentMusic then
			currentMusic:Play()
			currentMusic.Ended:Wait()
		else
			task.wait(5)
		end
	end
end

function BackgroundMusicManager:stopMusic()
	if currentMusic then
		currentMusic:Stop()
	end
	running = false
end

return BackgroundMusicManager
