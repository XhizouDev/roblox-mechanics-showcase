-- Local Script

local debris = game:GetService("Debris")
local ts = game:GetService("TweenService")
local rs = game:GetService("ReplicatedStorage")

local debounce = false

local player = game.Players.LocalPlayer
local playerName = player.Name
local character = workspace:WaitForChild(playerName)
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()
local hrp = character:WaitForChild("HumanoidRootPart")

local tool = script.Parent

local remote = rs.Attacks.Fire.Remotes.Attacks.Fire
local resources = rs.Attacks.Fire
local anims = resources.Animations
local fx = resources.FX

local camera = workspace.CurrentCamera
local CameraShaker = require(rs.Attacks.Fire.Modules.CameraShaker)

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	
	camera.CFrame = camera.CFrame * shakeCFrame
	
end)
camShake:Start()

local function rayCast(startPosition, endPosition, filter, length, obj)
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.IgnoreWater = true
	params.FilterDescendantsInstances = filter
	
	local result = workspace:Raycast(obj.Position, (endPosition - startPosition).Unit * length, params)
	if result then
		obj.Position = result.Position
		return false
	else
		obj.Position = (endPosition - startPosition).Unit * length + startPosition
		return true
	end
	
end

local function fireCharge(data)
	local c = data.c
	local h = c.Humanoid
	local root = c.HumanoidRootPart
	local fireball = fx.Fireball:Clone()
	fireball.Parent = workspace.Fx
	
	local handFire = fireball.Attach.Fire:Clone()
	handFire.Parent = c.RightHand.RightGripAttachment
	handFire.Enabled = true
	
	local bodyPos = Instance.new("BodyPosition", root)
	bodyPos.Position = root.Position
	bodyPos.MaxForce = Vector3.new(999999, 999999, 999999)
	bodyPos.P = 1200
	bodyPos.D = 400
	h.JumpHeight = 0
	
	local floorFire = fx.Fireball:Clone()
	floorFire.CFrame = root.CFrame * CFrame.new(0,-3,0)
	floorFire.RingAttach.Orientation = Vector3.new(0,0,0)
	floorFire.RingAttach.Ring.Enabled = true
	floorFire.Parent = workspace.Fx
	
	for i = 1, 13 do
		local circleMesh = fx.Circle:Clone()
		circleMesh.Parent = workspace.Fx
		circleMesh.CFrame = c.RightHand.CFrame * CFrame.Angles(math.rad(math.random(0, 100)), math.rad(math.random(0,100)), math.rad(math.random(0,100)))
		debris:AddItem(circleMesh, .5)
		ts:Create(circleMesh, TweenInfo.new(.5), {Transparency = 1, Size = Vector3.new(0,0,0)}):Play()
		wait(.1)
	end
	
	fireball.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(1.5,0,-5)
	handFire.Enabled = false
	handFire:Destroy()
	
	local ring = fireball:Clone()
	ring.Parent = workspace.Fx
	ring.CFrame = fireball.CFrame
	ring.RingAttach.Ring:Emit(50)
	
	h.JumpHeight = 13.5
	bodyPos:Destroy()
	
	fireball:Destroy()
	floorFire.RingAttach.Ring.Enabled = false
	debris:AddItem(floorFire, 1)
	
end

local function fireBall(data)
	
	local c = data.c
	local h = c.Humanoid
	local root = c.HumanoidRootPart
	
	local fireball = fx.Fireball:Clone()
	fireball.Parent = workspace.Fx
	fireball.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(1.5,0,-5)
	fireball.Attach.Fire.Enabled = true
	
	camShake:ShakeOnce(2,5,.2,.4)
	
	local connection
	local count = 0
	
	connection = game:GetService("RunService").RenderStepped:Connect(function(dt)
		
		if count > 5 then
			
			connection:Disconnect()
			fireball.Attach.Fire.Enabled = false
			wait(1)
			fireball:Destroy()
			return
		elseif rayCast(fireball.Position, data.endpoint, {c, workspace.Fx}, 100 * dt, fireball) == false then
			for i = 0, 15 do
				local part = Instance.new("Part", workspace.Fx)
				part.Size = Vector3.new(4, math.random(15,25)/10, math.random(15,25)/10)
				part.Anchored = true
				part.CFrame = CFrame.new(fireball.Position) * CFrame.Angles(0, math.rad(i * 24), 0) * CFrame.new(0,0,-8) * CFrame.Angles(math.rad(35),0,0)
				part.CanQuery = false
				part.CanCollide = false
				part.CanTouch = false
				
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Blacklist
				params.IgnoreWater = true
				params.FilterDescendantsInstances = {c, workspace.Fx}
				
				local result = workspace:Raycast(part.Position + Vector3.new(0,2,0), Vector3.new(0,-10,0), params)
				if result then
					part.Position = result.Position
					part.Material = result.Material
					part.Color = result.Instance.Color
				end
				
				if i / 3 < 2 then
					
					local fire = fx.Fireball:Clone()
					fire.Size = Vector3.new(math.random(10,20)/10,math.random(10,20)/10,math.random(10,20)/10)
					fire.Position = result.Position + Vector3.new(0,3,0)
					fire.Material = result.Material
					fire.Color = result.Instance.Color
					fire.Attach.Fire.Enabled = true
					fire.Attach.Fire.LockedToPart = false
					fire.Anchored = false
					fire.CanCollide = true
					
					local bv = Instance.new("BodyVelocity", fire)
					bv.Velocity = Vector3.new(math.random(-40,40), 30, math.random(-40,40))
					bv.MaxForce = Vector3.new(999999,999999,999999)
					bv.Name = "Velocity"
					
					game.Debris:AddItem(bv, .1)
					game.Debris:AddItem(fire, 4)
					
					spawn(function()
						
						wait(2)
						fire.Attach.Fire.Enabled = false
						ts:Create(fire, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1}):Play()
						
					end)
					
					fire.Transparency = 0
					
				end
				
				part.Position = part.Position - Vector3.new(0,4,0)
				ts:Create(part, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Position = part.Position + Vector3.new(0,4,0)}):Play()
				
				spawn(function()
					
					game.Debris:AddItem(part,4)
					wait(3)
					ts:Create(part, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Position = part.Position - Vector3.new(0,4,0)}):Play()
					
				end)
				
			end
			
			fireball.Attach.Fire.Enabled = false
			fireball.Attach.Explosion:Emit(100)
			
			camShake:ShakeOnce(2,5,.2,.4)
			connection:Disconnect()
			if data.client == true then
				data.endpoint = fireball.Position
				remote:FireServer("FireballHit", data)
			end
			
			wait(1)
			fireball:Destroy()
			return
			
		end
		
	end)
	
end

tool.Activated:Connect(function()
	
	print("tool activated")

	if not debounce then
		debounce = true
		local data = {client = true, c = character}
		local load = humanoid:LoadAnimation(anims.Fireball)
		load:Play()
		debris:AddItem(load, load.Length)
		remote:FireServer("FireCharge", data)
		fireCharge(data)
		data.endpoint = mouse.Hit.Position
		remote:FireServer("Fireball", data)
		fireBall(data)
		wait(6)
		debounce = false
	end

end)

-- Server Script

local rs = game:GetService("ReplicatedStorage")
local remote = rs.Attacks.Fire.Remotes.Attacks.Fire

remote.OnServerEvent:Connect(function(player, attack, data)
	
	local char = player.Character
	local datafolder = char:WaitForChild("Data")
	local boolean = datafolder:WaitForChild("LedernHability")
	
	if attack == "Fireball" then
		for i,v in pairs(game.Players:GetChildren()) do
			if v ~= player then
				data.client = false
				data.Attack = "Fireball"
				remote:FireClient(v, data)
			end
		end
	elseif attack == "FireCharge" then
		for i,v in pairs(game.Players:GetChildren()) do
			if v ~= player then
				data.client = false
				data.Attack = "FireCharge"
				remote:FireClient(v,data)
			end
				
		end
	elseif attack == "FireballHit" then
		local hb = Instance.new("Part", workspace.Fx)
		hb.Size = Vector3.new(16, 16, 16)
		hb.Position = data.endpoint
		hb.Anchored = true
		hb.CanCollide = false
		hb.Transparency = 1
		hb.Name = "hb"
		hb.Material = Enum.Material.ForceField
		hb.CanQuery = false
		
		local con
		con = hb.Touched:Connect(function()
			
			con:Disconnect()
			
		end)
		
		local hits = {}
		
		for i,v in pairs(hb:GetTouchingParts()) do
			if v:IsDescendantOf(data.c) == false then
				if v.Parent:FindFirstChildWhichIsA("Humanoid") and table.find(hits, v.Parent) == nil and (data.endpoint - v.Position).Magnitude < 16 then
					table.insert(hits, v.Parent)
					if boolean.Value == false then
						
						v.Parent.Humanoid.Health -= 35
						
					elseif boolean.Value == true then
						
						v.Parent.Humanoid.Health -= 70
						
					end
				end
			end
		end
		hb:Destroy()
	end
	
end)