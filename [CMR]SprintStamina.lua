-- Local Script

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")

local lastTick = tick()
local debounce = false
local running = false

local Camera = workspace.CurrentCamera

local anim = script:WaitForChild("RunAnim")

local PLAYER = Players.LocalPlayer
local char = PLAYER.Character
local hum = char:WaitForChild("Humanoid")
local runanim = hum:LoadAnimation(anim)

local OnCutscene = PLAYER.PlayerScripts:WaitForChild("Values").OnCutscene
local Stunned = char:WaitForChild("Action").Stunned

local stamina = 100

local RunRefresh = 20
local SpeedDiff = 6
local DrainRate = 8

local Exhausted = false
local Sprinting = false
local SprintHeld = false

local onCharge = false

local DCRE = RS:WaitForChild("DisableControls")
local ECRE = RS:WaitForChild("EnableControls")

local MAX_DOUBLE_DURATION = .2
local DEBOUNCE_DURATION = .5

local CSRE = RS:WaitForChild("ChargingVFX")
local CSREOff = RS:WaitForChild("ChargingVFXEnds")

local folder = char:WaitForChild("Status")
local Stamina = folder:WaitForChild("Stamina")

local RESprint = RS:WaitForChild("SprintingVFX")
local RESprintEnd = RS:WaitForChild("SprintingVFXOff")

local Spirit = PLAYER:WaitForChild("Data").Spirit
local KambitSCAnim = script:WaitForChild("StaminaChargeKambit")
local KambitLSCAnim = hum:LoadAnimation(KambitSCAnim)

local ChargingBool = char:WaitForChild("Action").Charging
local Blocking = char:WaitForChild("Action").Blocking

function getCharacter()
	return PLAYER.Character or PLAYER.CharacterAdded:Wait()
end

function changeSpeed(speed)
	local character = getCharacter()
	local humanoid = character:FindFirstChild("Humanoid")
	if OnCutscene.Value == false and Stunned.Value == false then
		
		humanoid.WalkSpeed = speed
		TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 70}):Play()
		runanim:Stop()
		
	end
end

local function ShakeCam()
	
	repeat
		
		local x = math.random(-30,30)/100
		local y = math.random(-30,30)/100
		local z = math.random(-30,30)/100
		hum.CameraOffset = Vector3.new(x, y, z)
		wait(.01)
		
	until onCharge == false
	
	hum.CameraOffset = Vector3.new(0, 0, 0)
	
end

function activate()
	if debounce == false and OnCutscene.Value == false and Stunned.Value == false then
		if stamina > 0 then
			if not Exhausted then
				local NORM_SPEED = hum.WalkSpeed
				local RUN_SPEED = NORM_SPEED * 2
				RESprint:FireServer(PLAYER)
				Sprinting = true
				debounce = true
				running = true
				changeSpeed(RUN_SPEED)
				TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 85}):Play()
				runanim:Play()

			end

		end
	end
end

local function sprint(active)
	if Exhausted then return end
	if active then
		hum.WalkSpeed = hum.WalkSpeed
	else
		hum.WalkSpeed = hum.WalkSpeed
	end
	Sprinting = active
end

UserInputService.InputBegan:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.Z and Blocking.Value == false then
		if running and not onCharge then
			SprintHeld = false
			sprint(SprintHeld)
			local NORM_SPEED = hum.WalkSpeed / 2
			RESprintEnd:FireServer(PLAYER)
			Sprinting = false
			running = false
			changeSpeed(NORM_SPEED)
			wait(DEBOUNCE_DURATION)
			debounce = false
			
		elseif not running and not onCharge then
			
			local NORM_SPEED = hum.WalkSpeed
			local RUN_SPEED = NORM_SPEED * 2
			SprintHeld = true
			sprint(SprintHeld)
			activate()
			
		end	
	end
end)

UserInputService.InputBegan:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.H and Blocking.Value == false then
		if onCharge == false then
			
			ChargingBool.Value = true
			onCharge = true
			DCRE:FireServer(PLAYER)
			DrainRate = 32
			
			CSRE:FireServer(PLAYER)
			
			SprintHeld = false
			sprint(SprintHeld)
			if running then
				
				local NORM_SPEED = hum.WalkSpeed / 2
				changeSpeed(NORM_SPEED)
				
			else
				
				local NORM_SPEED = hum.WalkSpeed
				changeSpeed(NORM_SPEED)
				
			end
			RESprintEnd:FireServer(PLAYER)
			Sprinting = false
			running = false
			wait(DEBOUNCE_DURATION)
			debounce = false
			
			spawn(ShakeCam)
			
			if Spirit.Value == 0 then
				
				KambitLSCAnim:Play()
				
			end
		elseif onCharge == true then
			
			ChargingBool.Value = false
			onCharge = false
			ECRE:FireServer(PLAYER)
			DrainRate = 8
			
			CSREOff:FireServer(PLAYER)
			
			if Spirit.Value == 0 then
				
				KambitLSCAnim:Stop()

			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input,gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.G and Blocking.Value == false then
		
		if running then

			local NORM_SPEED = hum.WalkSpeed / 2
			hum.WalkSpeed = NORM_SPEED
			TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 70}):Play()
			runanim:Stop()

		else

			local NORM_SPEED = hum.WalkSpeed
			hum.WalkSpeed = NORM_SPEED
			TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 70}):Play()
			runanim:Stop()

		end
		
		SprintHeld = false
		sprint(SprintHeld)
		Sprinting = false
		running = false
		
		if onCharge == true then
			
			CSREOff:FireServer(PLAYER)
			KambitLSCAnim:Stop()
			DrainRate = 8
			onCharge = false
			
		end
		
		wait(DEBOUNCE_DURATION)
		debounce = false
		
	end
	
end)

RunService.Heartbeat:Connect(function(DeltaTime)
	if Sprinting then
		Stamina.Value = math.floor(stamina + 0.5)
		if stamina > 0 then
			stamina = stamina - (DrainRate/2) * DeltaTime
		else
			Exhausted = true
			if Exhausted and SprintHeld then
				local NORM_SPEED = hum.WalkSpeed / 2
				SprintHeld = false
				Sprinting = false
				running = false
				changeSpeed(NORM_SPEED)
				RESprintEnd:FireServer(PLAYER)
				TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 55}):Play()
				wait(DEBOUNCE_DURATION)
				debounce = false
				TweenService:Create(Camera, TweenInfo.new(.5), {FieldOfView = 70}):Play()
				
			end
		end
	elseif stamina < 100 then
		Stamina.Value = math.floor(stamina + 0.5)
		stamina = stamina + (DrainRate/4) * DeltaTime
		if stamina > RunRefresh then
			Exhausted = false
			if SprintHeld then
				sprint(SprintHeld)
			end
		end
	end
end)

-- SFX Local Script

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local ChargingRE = RS:WaitForChild("ChargingSFX")
local ChargingOffRE = RS:WaitForChild("ChargingSFXOff")
local ExplosionRE = RS:WaitForChild("ChargingSFXExplosion")

local ECRE = RS:WaitForChild("EnableControls")

local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild("Humanoid")

ExplosionRE.OnClientEvent:Connect(function()
	
	local ExplosionSFX = script:WaitForChild("Explosion")
	ExplosionSFX:Play()
	
end)

ChargingRE.OnClientEvent:Connect(function()
	
	local ChargingSFX = script:WaitForChild("Charging")
	ChargingSFX:Play()
	TweenService:Create(ChargingSFX, TweenInfo.new(.65), {Volume = 2.5}):Play()
	print("Aura playing")
	
end)

ChargingOffRE.OnClientEvent:Connect(function()
	
	local ChargingSFX = script:WaitForChild("Charging")
	TweenService:Create(ChargingSFX, TweenInfo.new(.65), {Volume = 0}):Play()
	wait(.75)
	ChargingSFX:Stop()
	print("Aura Stopped")
	
end)

hum.Died:Connect(function()
	
	ECRE:FireServer(player)
	
end)

-- VFX Server Script

local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local CircleRE = RS:WaitForChild("ChargingVFX")
local CircleREOff = RS:WaitForChild("ChargingVFXEnds")

local Circle = script:WaitForChild("Circle")
local Energy = script:WaitForChild("Energy")

local rotating = false
local localPlayer = nil
local VFXFolder = nil

local function ExplosionSFX()

	local maxDistance = 80

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then

			local SFXRE = RS:WaitForChild("ChargingSFXExplosion")
			SFXRE:FireClient(player)

		end

	end

end

local function ChargingSFX()

	local maxDistance = 56

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then

			local SFXRE = RS:WaitForChild("ChargingSFX")
			if player:FindFirstChild("Playing") then
				
				local Playing = player:WaitForChild("Playing")
				if Playing.Value == false then

					Playing.Value = true
					SFXRE:FireClient(player)
					Playing:Destroy()

				end
				
			else
				
				local Playing = Instance.new("BoolValue")
				Playing.Name = "Playing"
				Playing.Parent = player
				
				if Playing.Value == false then
					
					Playing.Value = true
					SFXRE:FireClient(player)
					
				end
				
			end
			
		else
			
			local SFXRE = RS:WaitForChild("ChargingSFXOff")
			if player:FindFirstChild("Playing") then
				
				local Playing = player:WaitForChild("Playing")
				if Playing.Value == true then

					Playing.Value = false
					SFXRE:FireClient(player)
					Playing:Destroy()

				end
				
			else

				local Playing = Instance.new("BoolValue")
				Playing.Name = "Playing"
				Playing.Parent = player

				if Playing.Value == true then

					Playing.Value = false
					SFXRE:FireClient(player)
					Playing:Destroy()

				end

			end
			
		end

	end

end

local function ChargingSFXOff()
	
	local maxDistance = 56

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then

			local SFXRE = RS:WaitForChild("ChargingSFXOff")
			if player:FindFirstChild("Playing") then
				
				local Playing = player:WaitForChild("Playing")
				if Playing.Value == true then

					Playing.Value = false
					SFXRE:FireClient(player)
					Playing:Destroy()

				end
				
			else

				local Playing = Instance.new("BoolValue")
				Playing.Name = "Playing"
				Playing.Parent = player

				if Playing.Value == true then

					Playing.Value = false
					SFXRE:FireClient(player)
					Playing:Destroy()

				end

			end

		end

	end
	
end

local function CircleRotate()
	
	local char = localPlayer.Character
	local hum = char:WaitForChild("Humanoid")
	wait(.5)
	local Folder = Instance.new("Folder")
	Folder.Name = localPlayer.Name.."Charging"
	Folder.Parent = workspace
	local CircleVFX = Circle:Clone()
	CircleVFX.Parent = Folder
	CircleVFX.CFrame = char:WaitForChild("HumanoidRootPart").CFrame
	local WC = Instance.new("WeldConstraint")
	WC.Parent = CircleVFX
	WC.Part0 = CircleVFX
	WC.Part1 = char:WaitForChild("HumanoidRootPart")
	
	TweenService:Create(CircleVFX, TweenInfo.new(.75), {Transparency = 0.9}):Play()
	
	repeat
		
		TweenService:Create(CircleVFX, TweenInfo.new(2), {Orientation = CircleVFX.Orientation + Vector3.new(0, 720, 0)}):Play()
		TweenService:Create(CircleVFX, TweenInfo.new(.5), {Transparency = 0.975}):Play()
		TweenService:Create(CircleVFX, TweenInfo.new(.5), {Transparency = 0.9}):Play()
		wait(.5)
		
		hum.Died:Connect(function()
			
			rotating = false
			
		end)
		
	until not rotating
	
	TweenService:Create(CircleVFX, TweenInfo.new(.35), {Transparency = 1}):Play()
	TweenService:Create(CircleVFX, TweenInfo.new(.35), {Size = CircleVFX.Size + Vector3.new(15, 0, 15)}):Play()
	wait(1)
	Folder:Destroy()
	
end

local function EnergyFlow()
	
	local char = localPlayer.Character
	local hum = char:WaitForChild("Humanoid")
	wait(.85)
	local Folder = workspace:WaitForChild(localPlayer.Name.."Charging")
	local angle = 0
	
	repeat
		
		local radrandom = math.random(-360, 360)
		local random = math.random(-20, -8)
		local EnergyVFX = Energy:Clone()
		EnergyVFX.Parent = Folder
		EnergyVFX.CFrame = char:WaitForChild("HumanoidRootPart").CFrame * CFrame.fromEulerAnglesXYZ(math.rad(radrandom), math.rad(angle), math.rad(angle)) * CFrame.new(0,0, random)
		EnergyVFX.Orientation = Vector3.new(angle, angle, angle)
		
		TweenService:Create(EnergyVFX, TweenInfo.new(1), {Position = char:WaitForChild("HumanoidRootPart").Position}):Play()
		TweenService:Create(EnergyVFX, TweenInfo.new(.75), {Transparency = 1}):Play()
		
		spawn(ChargingSFX)
		
		hum.Died:Connect(function()

			rotating = false

		end)
		
		angle += 105
		wait(.05)
		
	until not rotating
	
	spawn(ChargingSFXOff)
	
end

CircleRE.OnServerEvent:Connect(function(player)
	
	rotating = true
	localPlayer = player
	spawn(CircleRotate)
	spawn(EnergyFlow)
	
end)

CircleREOff.OnServerEvent:Connect(function(player)
	
	rotating = false
	ExplosionSFX()
	
end)