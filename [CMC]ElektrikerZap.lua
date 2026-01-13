-- Local Script

wait(1)

local RE = script.Parent:WaitForChild("ZapEvent")
local tool = script.Parent

local player = game.Players.LocalPlayer
local Char = player.Character
local Mouse = player:GetMouse()
local RootPart = Char:WaitForChild("HumanoidRootPart")

local debounce = false

local function LookTowards(RootPart, KillTime)
	
	local Gyro = Instance.new("BodyGyro")
	Gyro.MaxTorque = Vector3.new(7000000, 7000000, 7000000)
	Gyro.P = 20000
	Gyro.CFrame = CFrame.new(RootPart.Position, Mouse.Hit.Position)
	Gyro.Parent = RootPart
	local Pos = Instance.new("BodyPosition")
	Pos.MaxForce = Vector3.new(5000000, 5000000, 5000000)
	Pos.P = 10000
	Pos.Position = RootPart.Position
	
	spawn(function()
		for i = 1,50 do
			
			Gyro.CFrame = CFrame.new(RootPart.Position, Mouse.Hit.Position)
			wait(KillTime/50)
			
		end
		
		Pos:Destroy()
		Gyro:Destroy()
		
		print("Function Worked")
		
	end)
	
end

tool.Activated:Connect(function()
	
	if not debounce then
		
		debounce = true
		
		print("Event Fired")
		
		RE:FireServer(true, Mouse.Hit)
		LookTowards(RootPart, 2)
		wait(1.32)
		RE:FireServer(false, Mouse.Hit)
		
		wait(10)
		
		debounce = false
		
	end
	
end)

-- Server Script

local RE = script.Parent.ZapEvent

local bolt = Instance.new("Part")
bolt.Size = Vector3.new(.1, .1, .1)
bolt.BrickColor = BrickColor.new("Pastel blue-green")
bolt.CanCollide = false
bolt.Anchored = true
bolt.Material = "Neon"

local function ShootElectrode(from, too)
	
	local lastpos = from
	local step = 2
	local off = 2
	local range = 100
	
	local distance = (from-too).magnitude
	
	if distance > range then distance = range end
	
	for i = 0, distance, step do
		
		local from = lastpos
		
		local offset = Vector3.new(
			
			math.random(-off, off),
			math.random(-off, off),
			math.random(-off, off)
			
		)/10
		
		local too = from +- (from-too).unit * step + offset
		
		local p = bolt:Clone()
		
		local DebrisFolder = workspace:FindFirstChild("DebrisFolder") or Instance.new("Folder", workspace)
		DebrisFolder.Name = "DebrisFolder"
		p.Parent = DebrisFolder
		p.Size = Vector3.new(p.Size.x, p.Size.y, (from-too).magnitude)
		p.CFrame = CFrame.new(from:Lerp(too, 0.5), too)
		
		game.Debris:AddItem(p, 0.1)
		lastpos = too
		
	end
	
end

local function ContinueScale(Part)
	
	local TweenService = game:GetService("TweenService")
	local TweenInform = TweenInfo.new(
		
		.2,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
		
	)
	
	local Propeties = {
		
		Size = Vector3.new(2.901, 2.722, 35)
		
	}
	
	local Tween = TweenService:Create(Part, TweenInform, Propeties)
	Tween:Play()
	
end

RE.OnServerEvent:Connect(function(Player, Aim, MousePos)
	
	print("Event Recived")
	
	local Character = Player.Character
	local RootPart = Character:WaitForChild("HumanoidRootPart")
	local RightHand = Character:WaitForChild("RightHand")
	local Humanoid = Character:WaitForChild("Humanoid")
	
	if Aim then
		
		local DebrisFolder = workspace:FindFirstChild("DebrisFolder") or Instance.new("Folder", workspace)
		DebrisFolder.Name = "DebrisFolder"
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://8979795226"
		local LoadAnimation = Character.Humanoid:LoadAnimation(Animation)
		LoadAnimation:Play()
		
		local BodPos = Instance.new("BodyPosition")
		BodPos.MaxForce = Vector3.new(5000000, 5000000, 5000000)
		BodPos.P = 50000
		BodPos.Position = RootPart.Position
		BodPos.Parent = RootPart
		
		spawn(function()
			
			wait(3)
			BodPos:Destroy()
			
		end)
		
		local YCFrame = RootPart.Position.Y - Humanoid.Hip.Height
		local CharParts = Character:GetChildren()
	
		
		math.randomseed(tick())
		
		spawn(function()
		
			
			for i = 1,#CharParts do
			
				
				local Current = CharParts[i]
				
				if Current.ClassName == "Part" or Current.ClassName == "MeshPart" then
				
					
					ShootElectrode(Vector3.new(RootPart.Position.X - math.random(-5, 5), YCFrame, RootPart.Position.Z - math.random(-5,5)), Current.Position)
					ShootElectrode(Vector3.new(RootPart.Position.X - math.random(-5, 5), YCFrame, RootPart.Position.Z - math.random(-5,5)), Current.Position)
					wait()
					
				end
				
			end
			
		end)
		
	else
		
		local DebrisFolder = workspace:FindFirstChild("DebrisFolder") or Instance.new("Folder", workspace)
		DebrisFolder.Name = "DebrisFolder"
		local Hitbox = Instance.new("Part")
		Hitbox.Anchored = false
		Hitbox.Transparency = 1
		Hitbox.CanCollide = false
		Hitbox.BrickColor = BrickColor.new("Really red")
		Hitbox.Size = Vector3.new(5, 5, 5)
		Hitbox.Parent = DebrisFolder
		
		spawn(function()
			
			local repeatnum = 22
			for i = 1,repeatnum do
				
				ShootElectrode(RightHand.Position, MousePos.Position)
				ShootElectrode(RightHand.Position, MousePos.Position)
				wait()
				
			end
			
			Hitbox:Destroy()
			
		end)
		
		local Mag = (RightHand.Position - MousePos.Position).magnitude
		if Mag > 100 then
			
			Mag = 100
			
		end
		
		Hitbox.Size = Vector3.new(5, 5, Mag)
		Hitbox.Position = RightHand.Position
		Hitbox.CFrame = CFrame.new(RightHand.Position, MousePos.Position)
		Hitbox.CFrame = Hitbox.CFrame * CFrame.new(0, 0, -Mag/2)
		
		spawn(function()
			
			local Sound = Instance.new("Sound")
			Sound.SoundId = "rbxassetid://3449186924"
			Sound.Parent = RootPart
			Sound.PlaybackSpeed = .8
			Sound.MaxDistance = 300
			Sound.Volume = 7
			Sound:Play()
			
			wait(5)
			Sound:Destroy()
			
		end)
		
		local Hitppl = {}
		local BeenHit 
		
		wait(.05)
		Hitbox.Touched:Connect(function(hit)
			
			if not hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid") then return end
			if hit.Parent.Name ~= Character.Name then
				
				local NewCharacter = hit.Parent
				
				if Hitppl[Player.Name] then return end
				Hitppl[Character.Name] = true
				
				local Animation = Instance.new("Animation")
				Animation.AnimationId = "rbxassetid://8979909021"
				local LoadAnimation = NewCharacter:FindFirstChild("Humanoid"):LoadAnimation(Animation)
				LoadAnimation:Play()
				
				local BodyPos = Instance.new("BodyPosition")
				BodyPos.MaxForce = Vector3.new(5000000, 5000000, 5000000)
				BodyPos.P = 50000
				BodyPos.Position = NewCharacter:FindFirstChild("HumanoidRootPart").Position
				BodyPos.Parent = NewCharacter:FindFirstChild("HumanoidRootPart")
				NewCharacter:FindFirstChild("Humanoid"):TakeDamage(55)
				wait(.1)
				
				if hit.Parent:FindFirstChild("Humanoid").Health <= 0 then
					
					game.Debris:AddItem(BodyPos, .1)
				else
					game.Debris:AddItem(BodyPos, 2)
					
				end
				
				wait(1.75)
				LoadAnimation:Stop()
			end
			
		end)
		
	end

end)