-- Local Script

local RS = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local BlockREStart = RS:WaitForChild("BlockingStart")
local BlockREEnd = RS:WaitForChild("BlockingEnd")

local plr = players.LocalPlayer
local char = plr.Character
local hum = char:WaitForChild("Humanoid")

local Folder = char:WaitForChild("Action")

local Sprinting = Folder:WaitForChild("Sprinting")
local Charging = Folder:WaitForChild("Charging")

local Blocking = script:WaitForChild("Block")
local lBlocking = hum:LoadAnimation(Blocking)

local Blocking = false

local BBRE = RS:WaitForChild("BrokenBlock")

UIS.InputBegan:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.F then
		
		if Sprinting.Value == false and Charging.Value == false then
			
			if Blocking then
				
				Blocking = false
				lBlocking:Stop()
				BlockREEnd:FireServer(plr)
				hum.WalkSpeed = 16
				
			elseif not Blocking then
				
				Blocking = true
				lBlocking:Play()
				BlockREStart:FireServer(plr)
				hum.WalkSpeed = 8
				
			end
			
		end
		
	end
	
end)

BBRE.OnClientEvent:Connect(function(Player)
	
	lBlocking:Stop()
	
end)

-- Server Script

local RS = game:GetService("ReplicatedStorage")

local BlockREStart = RS:WaitForChild("BlockingStart")
local BlockREEnd = RS:WaitForChild("BlockingEnd")

BlockREStart.OnServerEvent:Connect(function(player)
	
	local char = player.Character
	
	local Folder = char:WaitForChild("Action")
	local BlockingBool = Folder:WaitForChild("Blocking")
	
	BlockingBool.Value = true
	
end)

BlockREEnd.OnServerEvent:Connect(function(player)

	local char = player.Character

	local Folder = char:WaitForChild("Action")
	local BlockingBool = Folder:WaitForChild("Blocking")

	BlockingBool.Value = false

end)