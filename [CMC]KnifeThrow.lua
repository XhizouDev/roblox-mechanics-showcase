-- Local Script

local tool = script.Parent
local anim = tool:WaitForChild("KnifeThrowAnimation")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local knifeThrow = game.ReplicatedStorage.KnifeThrow

local cooldown = 2
local debounce = false


tool.Activated:Connect(function()
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		
		if humanoid then
			
			if debounce then return end
			debounce = true
			
			local charge = 1
			
        	local loadedAnim = humanoid:LoadAnimation(anim)
	        loadedAnim:Play()
	
	        loadedAnim:GetMarkerReachedSignal("Charge"):Connect(function(chargeParam)
                charge = chargeParam
	        end)
	
	        local connection = loadedAnim:GetMarkerReachedSignal("PauseAnimation"):Connect(function()
                loadedAnim:AdjustSpeed(0)
			end)
			
			
			tool.Deactivated:Wait()
			
			loadedAnim:AdjustSpeed(-25)
			connection:Disconnect()
			
			knifeThrow:FireServer(mouse.Hit, tool.Handle.Position, charge)
			
			wait(cooldown)
			debounce = false
	   end
	end
end)

-- Server Script

local knifeThrow = game.ReplicatedStorage:WaitForChild("KnifeThrow")
local knifeModel = game.ServerStorage:WaitForChild("Knife")
local tweenService = game:GetService("TweenService")



knifeThrow.OnServerEvent:Connect(function(player, mouseHit, pos, charge)
	local knife = knifeModel:Clone()
	knife.Parent = workspace
	
	knife:SetPrimaryPartCFrame(CFrame.new(pos, mouseHit.p))
	
	knife.Root.Size = knife.Root.Size * charge
	
	local tweenInfo = TweenInfo.new(.1, Enum.EasingStyle.Linear)
	local properties = {CFrame = mouseHit}
	
	local tween = tweenService:Create(knife.Root, tweenInfo, properties)
	tween:Play()
	
	tween.Completed:Wait()
	
	knife.Root.Touched:Connect(function()
		
	end)
	
	for i, part in pairs(knife.Root:GetTouchingParts()) do
		local hitPlayer = game.Players:GetPlayerFromCharacter(part.Parent)
		
		if hitPlayer then
			local humanoid = hitPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:TakeDamage(20)
				knife:Destroy()
			end
		end
	end
	
	game.Debris:AddItem(knife, 3)
end)










