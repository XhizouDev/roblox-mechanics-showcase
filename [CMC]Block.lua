-- Local Script

local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local IsBlocking = Character:WaitForChild("Data").IsBlocking.Value
local BlockAnimation = Character.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Block)

local function Speed(Value, NextValue)
	Character.Humanoid.WalkSpeed = Value
	Character.Humanoid.JumpPower = NextValue
end

UIS.InputBegan:Connect(function(Input, IsTyping)
	if IsTyping then return end
	if Input.KeyCode == Enum.KeyCode.F then
		Speed(0,0)
		BlockAnimation:Play()
		RS.Block:FireServer("On")
	end
end)

UIS.InputEnded:Connect(function(Input, IsTyping)
	if IsTyping then return end
	if Input.KeyCode == Enum.KeyCode.F then
		Speed(10,13.5)
		BlockAnimation:Stop()
		RS.Block:FireServer("Off")
	end
end)

-- Server Script

local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Shield = RS.Shield

local InfoTween = TweenInfo.new(1, Enum.EasingStyle.Sine)
local v1 = {}

local cooldown = false

RS.Block.OnServerEvent:Connect(function(Player, Statement)	
	local Character = Player.Character
	local Humanoid = Character.Humanoid

	if Statement == "On" and not v1[Player] and cooldown == false then
		Character:WaitForChild("Data").IsBlocking.Value = true
		cooldown = true
		local NewShield = Shield:Clone()

		local WeldCon = Instance.new("WeldConstraint", NewShield)
		NewShield.Parent = game.Workspace
		v1[Player] = NewShield

		NewShield.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
		WeldCon.Part0 = Character.HumanoidRootPart
		WeldCon.Part1 = NewShield
		TweenService:Create(NewShield,InfoTween, {Transparency = 0, Color = Color3.fromRGB(99, 99, 99);}):Play()
		
		local force = Instance.new("ForceField")
		force.Parent = Humanoid.Parent
		wait(3.5)
		force:Destroy()

	elseif Statement == "Off" and v1[Player] then
		Character:WaitForChild("Data").IsBlocking.Value = false
		TweenService:Create(v1[Player],InfoTween, {Transparency = 1,Color = Color3.fromRGB(255, 255, 255);}):Play()
		wait(1)
		v1[Player]:Destroy()
		v1[Player] = nil
		wait(7.5)
		cooldown = false
	end

end)