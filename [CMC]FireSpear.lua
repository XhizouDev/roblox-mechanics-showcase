-- Local Script

local player = game.Players.LocalPlayer
local char = player.Character
local Mouse = player:GetMouse()
local Remote = script.Parent:WaitForChild("FireSpearEvent")
local tool = script.Parent

local debounce = false

tool.Activated:Connect(function()
	
	if not debounce then
		
		print("Event Fired")
		
		debounce = true
		Remote:FireServer(Mouse.Hit)
		
		wait(0.1)
		debounce = false
	end
	
end)

-- Server Script

local ServerStorage = game:GetService("ServerStorage")

local Remote = script.Parent:WaitForChild("FireSpearEvent")
local UnClonedFire = ServerStorage:WaitForChild("FireSpear")

local CoolTable = {}



local function LookAtMouse(Mouse, RootPart)
	
	local BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(0, 5000000, 0)
	BodyGyro.P = 10000
	BodyGyro.CFrame = CFrame.new(RootPart.Position, Mouse.Position)
	BodyGyro.Parent = RootPart
	game.Debris:AddItem(BodyGyro, 1)
	
	
	
end


local function MoveTowardsMouse(Mouse, Main)
	
	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(5000000, 5000000, 5000000)
	BodyVelocity.Velocity = CFrame.new(Main.Position, Mouse.Position).LookVector * 100
	BodyVelocity.Parent = Main
	
	local BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
	BodyGyro.P = 10000
	BodyGyro.CFrame = CFrame.new(Main.Position, Mouse.Position)
	BodyGyro.Parent = Main
	
end


Remote.OnServerEvent:Connect(function(player, Mouse_CFrame)
	
	local char = player.Character
	local data = char:WaitForChild("Data")
	local boolean = data:WaitForChild("LedernHability")
	
	print("Event Recived")
	
	if CoolTable[player.Name] == true then return end
	CoolTable[player.Name] = true
	
	local Character = player.Character
	local RootPart = Character:WaitForChild("HumanoidRootPart")
	local DebrisFolder = workspace:FindFirstChild("DebrisFolder") or Instance.new("Folder", workspace)
	DebrisFolder.Name = "DebrisFolder"
	
	local RightHand = Character:WaitForChild("RightHand")
	
	local FireSpear = UnClonedFire:Clone()
	local Handle = FireSpear:WaitForChild("Handle")
	local HitBox = FireSpear:WaitForChild("Hitbox")
	local Mesh = FireSpear:WaitForChild("Mesh")
	FireSpear:SetPrimaryPartCFrame(RightHand.CFrame)
	FireSpear.Parent = DebrisFolder
	
	local Weld = Instance.new("Motor6D")
	Weld.Parent = Handle
	Weld.Part0 = RightHand
	Weld.Part1 = Handle
	
	HitBox:SetNetworkOwner(nil)
	
	local function MakeStuffHappen()
		spawn(function()
			LookAtMouse(Mouse_CFrame, RootPart)
			wait(.6)
			Weld:Destroy()
			MoveTowardsMouse(Mouse_CFrame, HitBox)
		end)
	end
	
	MakeStuffHappen()
	
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://8981359946"
	local LoadAnimation = Character.Humanoid:LoadAnimation(Animation)
	LoadAnimation:Play()
	game.Debris:AddItem(Animation, 10)
	LoadAnimation = nil
	
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxxassetid://3242522532"
	Sound.Parent = RootPart
	Sound.PlaybackSpeed = 1
	Sound.MaxDistance = 200
	Sound.Volume = 2
	Sound:Play()
	game.Debris:AddItem(Sound, 5)
	
	local function DeleteSpear()
		spawn(function()
			
			wait(8)
			for i = 1,10 do
				Mesh.Transparency = Mesh.Transparency + .1
				wait(.09)
			end
			FireSpear:Destroy()
		end)
	end
	
	DeleteSpear()
	
	local BeenHit = false
	
	HitBox.Touched:Connect(function(hit)
		
		if not hit.Parent:FindFirstChild("Humanoid") then return end
		if hit.Parent.Name ~= Character.Name then
			if BeenHit == true then return end
			BeenHit = true
			if boolean.Value == true then
				
				hit.Parent:FindFirstChild("Humanoid"):TakeDamage(110)
				
			elseif boolean.Value == false then
				
				hit.Parent:FindFirstChild("Humanoid"):TakeDamage(55)
				
			end
			
			local HitSound = Instance.new("Sound")
			HitSound.SoundId = "rbxassetid://3242508461"
			HitSound.Parent = hit
			HitSound.PlaybackSpeed = 1
			HitSound.MaxDistance = 200
			HitSound.Volume = 2
			HitSound:Play()
			game.Debris:AddItem(HitSound, 5)
			
			local Rotation2 = HitBox.Orientation
			HitBox:WaitForChild("BodyGyro"):Destroy()
			HitBox:WaitForChild("BodyVelocity"):Destroy()
			HitBox.Position = hit.Position
			HitBox.Orientation = Rotation2
			local Weld = Instance.new("Motor6D")
			Weld.Part0 = hit
			Weld.Part1 = HitBox
			Weld.C0 = hit.CFrame:Inverse()
			Weld.C1 = HitBox.CFrame:Inverse()
			Weld.Parent = HitBox
			
		end
		
	end)
	
	wait(8)
	CoolTable[player.Name] = false
	
end)