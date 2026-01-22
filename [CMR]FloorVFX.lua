-- Server Script

local rp = game:GetService("ReplicatedStorage")
local RE = rp:WaitForChild("FloorVFX")

local Debris = game:GetService("Debris")

local Module = require(script.Module)

RE.OnServerEvent:Connect(function(Player)
	
	local Character = Player.Character
	local hum = Character.Humanoid
	local Humrp = Character.HumanoidRootPart
	
	local Folder = Instance.new("Folder")
	Folder.Name = Player.Name.."Landing"
	Folder.Parent = workspace
	
	local Model = Instance.new("Model")
	Model.Parent = Folder
	
	spawn(function()
		
		Module.rocks(Folder, Humrp, Model)
		
	end)
	
	Debris:AddItem(Folder, 3.5)
	
end)

-- Module Script

local folder = script.Rock

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Module = {}

function Module.rocks(Folder, Humrp, Model)
	
	local char = Humrp.Parent
	
	local rayOrigin = Humrp.Position
	local rayDirection = Vector3.new(0, -85, 0)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	raycastParams.FilterDescendantsInstances = {char}
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	local angle = 0
	if raycastResult then
		
		local hitPart = raycastResult.Instance
		wait(.115)
		local cfr = Humrp.CFrame * CFrame.new(0,-3, 0)
		local Particles = folder.FloorParticles:Clone()
		Particles.CFrame = cfr
		Particles.Parent = Folder
		Debris:AddItem(Particles, 0.5)
		for i = 1, 15 do
			
			local Size = math.random(2.25, 3.15)
			local Rock = folder.Rock:Clone()
			Rock.Size = Vector3.new(Size, Size, Size)
			Rock.CFrame = cfr * CFrame.fromEulerAnglesXYZ(0, math.rad(angle), 0) * CFrame.new(0,0, -6)
			Rock.Orientation = Vector3.new(math.random(-180, 180),math.random(-180, 180),math.random(-180, 180))
			Rock.Parent = Model
			Rock.Color = hitPart.Color
			Rock.Material = hitPart.Material

			local Cel = Instance.new("Highlight")
			Cel.Name = "Cellshade"
			Cel.FillColor = Color3.new()
			Cel.FillTransparency = 1
			Cel.OutlineColor = Color3.new()
			Cel.DepthMode = Enum.HighlightDepthMode.Occluded
			Cel.Parent = Model
			Cel.Adornee = nil
			Cel.Adornee = Model

			delay(2.5, function()

				TweenService:Create(Rock, TweenInfo.new(.5), {Transparency = 1}):Play()
				TweenService:Create(Cel, TweenInfo.new(.5), {OutlineTransparency = 1}):Play()

			end)

			angle += 24

		end 
		
	end
	
end

return Module
