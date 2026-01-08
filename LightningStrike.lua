-- Local Script

local Tool = script.Parent

local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()

local RS = game:GetService("ReplicatedStorage")
local LightningStrike = RS:WaitForChild("LightningStrikeEvent")

local debounce = false

Tool.Activated:Connect(function()
	if not debounce then
		debounce = true
		
		LightningStrike:FireServer(Mouse.Hit)
		print("Lightning Fired")
		
		wait(5)
		debounce = false
	end
end)

-- Server Script

local RS = game:GetService("ReplicatedStorage")
local LightningStrike = RS:WaitForChild("LightningStrikeEvent")

local Range = 500

local bolt = Instance.new("Part")
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "Electrode"
bolt.Transparency = .5
bolt.Material = Enum.Material.Neon
bolt.Size = Vector3.new(.4,.4,0)
bolt.BrickColor = BrickColor.new("Cool yellow")

local DebrisFolder = game.Workspace:FindFirstChild("DebrisFolder") or Instance.new("Folder")
DebrisFolder.Name = "DebrisFolder"
DebrisFolder.Parent = game.Workspace

local function ShootElectrode(from,too)
	local lastPos = from
	local Step = 8
	local off = 16
	
	local distance = (from-too).magnitude
	
	local debounce = false
	
	for i = 0,distance,Step do
		local newfrom = lastPos
		local offset = Vector3.new(math.random(-off,off),math.random(-off,off),math.random(-off,off))/10
		local newtoo = newfrom+-(from-too).unit*Step + offset
		
		local part = bolt:Clone()
		part.Size = Vector3.new(part.Size.X,part.Size.Y,(newfrom-newtoo).magnitude)
		part.CFrame = CFrame.new(newfrom:Lerp(newtoo,.5),newtoo)
		part.Parent = DebrisFolder
		
		game.Debris:AddItem(part,.5)
		
		lastPos = newtoo
		
		part.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChild("Humanoid") then
				if not debounce then
					debounce = true
					hit.Parent.Humanoid:TakeDamage(50)
				end
			end
		end)
		
	end
end

LightningStrike.OnServerEvent:Connect(function(Player,Mouse)
	if Player:DistanceFromCharacter(Mouse.p) > Range then
		print("Too Far")
	else
		for i = 1,5 do
			for _ = 1,5 do
				ShootElectrode(Mouse.p+Vector3.new(0,500,0),Mouse.p)
				wait()
			end
		end
	end
end)