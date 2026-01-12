-- Local Script

local tool = script.Parent
local event = script.Parent:WaitForChild("RemoteEvent")
local player = game:GetService("Players").localPlayer

tool.Activated:Connect(function()
	event:FireServer()
end)

-- Server Script

local tween = game:GetService("TweenService")
local casting = false
local event = script.Parent.RemoteEvent

event.OnServerEvent:Connect(function(player)
	if casting == true then return end
	casting = true
	
	local iceSpikes = game.ReplicatedStorage.IceSpikes:Clone()
	local attackAnim = player.Character.Humanoid:LoadAnimation(game.Teams.Freize.FreizeBasic.Attack)
	attackAnim:Play()

	iceSpikes:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
	iceSpikes.Parent = workspace
	local endPositions = {Position = {}, Orientation = {}}
	for i,v in pairs(iceSpikes.Spikes:GetChildren()) do
		endPositions["Position"][i] = v.Position
		endPositions["Orientation"][i] = v.Orientation
		v.CFrame = CFrame.new(iceSpikes.Origin.Position)
	end
	
	wait(0.2)
	for i,v in pairs(iceSpikes.Spikes:GetChildren()) do
		v.Orientation = endPositions["Orientation"][i]
		tween:Create(v, TweenInfo.new(0.2), {Position = endPositions["Position"][i]}):Play()
	end
	
	for i,v in pairs(iceSpikes.Spikes:GetChildren()) do
		v.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChild("Humanoid") and not hit.Parent:FindFirstChild("AlreadyHit") and not hit:IsDescendantOf(player.Character) then
				local enemyHumanoid = hit.Parent:FindFirstChild("Humanoid")
				local alreadyHit = Instance.new("BoolValue")
				alreadyHit.Parent = hit.Parent
				alreadyHit.Name = "AlreadyHit"
				enemyHumanoid:TakeDamage(25)
				spawn(function()
					wait(0)
					alreadyHit:Destroy()
				end)
			end
		end)
	end
	wait(1)
	iceSpikes:Destroy()
	wait(3)
	casting = false
end)