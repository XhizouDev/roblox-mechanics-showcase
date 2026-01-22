-- Local Script

local players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild("Humanoid")

local humrp = char:WaitForChild("HumanoidRootPart")

local head = char:WaitForChild("Head")
local Torso = char:WaitForChild("Torso")

local Camera = workspace.CurrentCamera

local TEnabledRE = RS:WaitForChild("KambitHabilities").CombatMaster
local TSFXRE = RS:WaitForChild("KambitHabilities").CombatMasterSFX
local TSFXRE1 = RS:WaitForChild("KambitHabilities").CombatMasterSFX1

local TOSTOn = RS:WaitForChild("KambitHabilities").CombatMasterMusicOn
local TOSTOff = RS:WaitForChild("KambitHabilities").CombatMasterMusicOff

local DCRE = RS:WaitForChild("DisableControls")
local ECRE = RS:WaitForChild("EnableControls")

local stamina = char:WaitForChild("Status").Stamina
local cruzader = player:WaitForChild("Data").Spirit

local Blocking = char:WaitForChild("Action").Blocking

local debounce = false

local function onInputBegan(input, gameProcessed)

	if input.KeyCode == Enum.KeyCode.G and Blocking.Value == false then

		if hum.Health <= 40 and hum.Health > 0 then
			
			if cruzader.Value == 0 then
				
				if not debounce then
					
					debounce = true
					
					Torso.Anchored = true
					
					print("CombatMaster Activated")
					DCRE:FireServer(player)

					wait(.25)

					TEnabledRE:FireServer(player)

					local Folder = game.Workspace:WaitForChild(player.Name.."CombatMaster")
					local cam = Folder:WaitForChild("Transformation Camera")

					Camera.CameraType = Enum.CameraType.Scriptable

					TweenService:Create(Camera, TweenInfo.new(0.85), {CFrame = cam.CFrame}):Play()
					TweenService:Create(Camera, TweenInfo.new(0.85), {Focus = cam.CFrame}):Play()
					TweenService:Create(Camera, TweenInfo.new(0.85), {FieldOfView = 55}):Play()

					wait(.465)

					local anim = script:WaitForChild("Transform")
					local lanim = hum:LoadAnimation(anim)
					lanim:Play()

					TweenService:Create(Camera, TweenInfo.new(1.55), {FieldOfView = 22.5}):Play()

					lanim:GetMarkerReachedSignal("Release"):Connect(function()

						TweenService:Create(Camera, TweenInfo.new(0.5), {FieldOfView = 100}):Play()

						wait(.5)
						ECRE:FireServer(player)
						TweenService:Create(Camera, TweenInfo.new(0.45), {CFrame = humrp.CFrame}):Play()
						TweenService:Create(Camera, TweenInfo.new(0.45), {Focus = humrp.CFrame}):Play()
						TweenService:Create(Camera, TweenInfo.new(0.45), {FieldOfView = 70}):Play()
						wait(.5)
						Camera.CameraType = Enum.CameraType.Custom


					end)
					
					wait(2)
					Torso.Anchored = false
					
				end
				
			end
			
			wait(75)
			debounce = false
			
		end

	end

end

TSFXRE.OnClientEvent:Connect(function(player)
	
	local ExplosionSFX = script:WaitForChild("Explosion")
	ExplosionSFX.Looped = false
	ExplosionSFX:Play()
	print("SFX Played")
	
end)

TSFXRE1.OnClientEvent:Connect(function(player)

	local PowerUp = script:WaitForChild("PowerUp")
	PowerUp.Looped = false
	PowerUp:Play()
	print("SFX Played")

end)

TOSTOn.OnClientEvent:Connect(function()
	
	print("Ost On")
	local GOST = player.PlayerScripts:WaitForChild("BGMusic").Music.FightThroughAdversity
	local OST = script:WaitForChild("Music")
	TweenService:Create(GOST, TweenInfo.new(1), {Volume = 0}):Play()
	wait(1)
	TweenService:Create(OST, TweenInfo.new(1), {Volume = 0.35}):Play()
	OST:Play()
	print("Ost Started")
	
	hum.Died:Connect(function()
		
		print("Ost Off")
		local GOST = player.PlayerScripts:WaitForChild("BGMusic").Music.FightThroughAdversity
		local OST = script:WaitForChild("Music")
		OST:Stop()
		GOST.Volume = 0.035
		print("Ost Stopped")
		
	end)
	
end)

TOSTOff.OnClientEvent:Connect(function()
	
	print("Ost Off")
	local GOST = player.PlayerScripts:WaitForChild("BGMusic").Music.FightThroughAdversity
	local OST = script:WaitForChild("Music")
	TweenService:Create(OST, TweenInfo.new(1), {Volume = 0}):Play()
	wait(1)
	OST:Stop()
	TweenService:Create(GOST, TweenInfo.new(1), {Volume = 0.035}):Play()
	print("Ost Stopped")
	
end)

UIS.InputBegan:Connect(onInputBegan)

-- Server Script

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")

local TSRE = RS:WaitForChild("KambitHabilities").CombatMaster

local CSRE = RS:WaitForChild("ChargingVFX")

local localPlayer = nil
local HumRootP = nil
local Character = nil
local ParticlesFolder = nil

local debris = game:GetService("Debris")

local OSTREOff = RS:WaitForChild("KambitHabilities").CombatMasterMusicOff

local function FloatingRocks()
	
	local rayOrigin = HumRootP.Position
	local rayDirection = Vector3.new(0, -4, 0)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	raycastParams.FilterDescendantsInstances = {Character}
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if raycastResult then
		
		local hitPart = raycastResult.Instance
		local cfr = HumRootP.CFrame * CFrame.new(0,-3, 0)
		
		local head = Character:WaitForChild("Head")
		
		local part = script.Part
		local angle = 180
		
		for i = 1, 10 do
			
			local Rock = part:Clone()
			local Size = 1
			Rock.Parent = ParticlesFolder
			Rock.Material = hitPart.Material
			Rock.Color = hitPart.Color
			Rock.Size = Vector3.new(Size, Size, Size)
			Rock.CFrame = cfr * CFrame.fromEulerAnglesXYZ(0, math.rad(angle), 0) * CFrame.new(0,0, -6)
			Rock.Orientation = Vector3.new(math.random(-270, 270),math.random(-270, 270),math.random(-270, 270))
			
			delay(.25, function()
				
				TweenService:Create(Rock, TweenInfo.new(6.5), {CFrame = head.CFrame * CFrame.new(0, 12.5, 0)}):Play()
				TweenService:Create(Rock, TweenInfo.new(2.5), {Transparency = 1}):Play()
				
			end)
			wait(0.15)
			
			angle += math.random(50, 110)
			
		end
		
	end
	
end

local function CircleVFX()
	
	local Circle = script:WaitForChild("Circle")
	local CircleVFX = Circle:Clone()
	CircleVFX.CFrame = HumRootP.CFrame
	CircleVFX.Parent = ParticlesFolder
	
	TweenService:Create(CircleVFX, TweenInfo.new(1.25), {Orientation = CircleVFX.Orientation + Vector3.new(0, 720, 0)}):Play()
	TweenService:Create(CircleVFX, TweenInfo.new(2.85), {Transparency = 1}):Play()
	
	wait(1.15)
	
	TweenService:Create(CircleVFX, TweenInfo.new(1.25), {Orientation = CircleVFX.Orientation + Vector3.new(0, 180, 0)}):Play()
	TweenService:Create(CircleVFX, TweenInfo.new(.5), {Size = CircleVFX.Size + Vector3.new(75, 0, 75)}):Play()
	
end

local function ExplosionSFX()
	
	local maxDistance = 80
	
	for _,player in pairs(game.Players:GetPlayers()) do
			
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then
			

			local SFXRE = RS:WaitForChild("KambitHabilities").CombatMasterSFX
			SFXRE:FireClient(player)

		end
		
	end
	
end

local function PowerUpSFX()
	
	local maxDistance = 80

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then


			local SFXRE = RS:WaitForChild("KambitHabilities").CombatMasterSFX1
			SFXRE:FireClient(player)

		end

	end
	
end

local function Music()
	
	local maxDistance = 36

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")
		
		local MusicBool = character:WaitForChild("Action").CMMusic

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then
			
			local Habilities = character:WaitForChild("Habilities")
			local CombatMasterBool = Habilities:WaitForChild("CombatMaster")
			
			if CombatMasterBool.Value == false then
				
				if MusicBool.Value == false then
					
					MusicBool.Value = true
					local OSTRE = RS:WaitForChild("KambitHabilities").CombatMasterMusicOn
					OSTRE:FireClient(player)
					
				end
				
			end
			
		else
			
			if MusicBool.Value == true then
				
				MusicBool.Value = false
				local OSTRE = RS:WaitForChild("KambitHabilities").CombatMasterMusicOff
				OSTRE:FireClient(player)
				
			end
			
		end

	end
	
end

local function MusicEnd()
	
	local maxDistance = 36

	for _,player in pairs(game.Players:GetPlayers()) do

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local torso = character:WaitForChild("Torso")

		local distance = player:DistanceFromCharacter(localPlayer.Character:WaitForChild("Torso").Position)
		if distance < maxDistance then
			
			local Music = character:WaitForChild("Action").CMMusic
			local CombatMasterBool = localPlayer.Character:WaitForChild("Habilities").CombatMaster
			local Habilities = character:WaitForChild("Habilities")
			local eCombatMasterBool = Habilities:WaitForChild("CombatMaster")
			
			if eCombatMasterBool.Value == false then
				
				CombatMasterBool.Value = false
				Music.Value = false
				local OSTRE = RS:WaitForChild("KambitHabilities").CombatMasterMusicOff
				OSTRE:FireClient(player)
				
			end

		end

	end
	
end

TSRE.OnServerEvent:Connect(function(player)
	
	local Invincibility = player.Character:WaitForChild("Action").Invincibility
	Invincibility.Value = true
	
	local char = player.Character
	local hum = char:WaitForChild("Humanoid")
	local humrp = char:WaitForChild("HumanoidRootPart")
	
	local HabilitiesFolder = char:WaitForChild("Habilities")
	local CombatMasterBool = HabilitiesFolder:WaitForChild("CombatMaster")
	
	local head = char:WaitForChild("Head")
	local larm = char:WaitForChild("Left Arm")
	local rarm = char:WaitForChild("Right Arm")
	local torso = char:WaitForChild("Torso")
	local lleg = char:WaitForChild("Left Leg")
	local rleg = char:WaitForChild("Right Leg")
	
	local Folder = Instance.new("Folder")
	Folder.Name = player.Name.."CombatMaster"
	Folder.Parent = workspace
	local cam = Instance.new("Part")
	cam.Name = "Transformation Camera"
	cam.Anchored = true
	cam.Transparency = 1
	cam.CanCollide = false
	cam.CastShadow = false
	cam.CanTouch = false
	cam.Massless = true
	cam.CFrame = head.CFrame * CFrame.new(0, 0, -9)
	cam.Parent = Folder
	cam.Orientation = cam.Orientation + Vector3.new(0, 180, 0)
	
	HumRootP = humrp
	Character = char
	ParticlesFolder = Folder
	localPlayer = player
	
	spawn(FloatingRocks)
	
	local CellShade = char:WaitForChild("Cellshade")
	
	wait(.525)
	
	spawn(PowerUpSFX)
	TweenService:Create(CellShade, TweenInfo.new(1), {OutlineColor = Color3.new(1, 1, 1)}):Play()
	spawn(CircleVFX)
	local Particles = script:WaitForChild("Small")
	local HParticles = Particles:Clone()
	HParticles.Parent = head
	local LAParticles = Particles:Clone()
	LAParticles.Parent = larm
	local RAParticles = Particles:Clone()
	RAParticles.Parent = rarm
	local TParticles = Particles:Clone()
	TParticles.Parent = torso
	local RLParticles = Particles:Clone()
	RLParticles.Parent = rleg
	local LLParticles = Particles:Clone()
	LLParticles.Parent = lleg
	hum.WalkSpeed = 20
	hum.Health += 35
	CombatMasterBool.Value = true
	
	local OSTRELOn = RS:WaitForChild("KambitHabilities").CombatMasterMusicOn
	OSTRELOn:FireClient(localPlayer)
	
	wait(1.3)
	
	spawn(ExplosionSFX)
	
	wait(0.85)
	
	Folder:Destroy()
	
	Invincibility.Value = false
	
	for i = 25, 1, -1 do
		
		print(player.Name.." CombatMaster ends in.. "..i)
		if hum.Health <= 0 then
			
			print("CombatMaster Died")
			spawn(MusicEnd)
			
		else
			
			spawn(Music)
			wait(1)
			
		end
		
	end
	
	TweenService:Create(CellShade, TweenInfo.new(1), {OutlineColor = Color3.new()}):Play()
	HParticles.Enabled = false
	LAParticles.Enabled = false
	RAParticles.Enabled = false
	TParticles.Enabled = false
	RLParticles.Enabled = false
	LLParticles.Enabled = false
	hum.WalkSpeed = 16
	spawn(MusicEnd)
	local OSTRELOff = RS:WaitForChild("KambitHabilities").CombatMasterMusicOff
	OSTRELOff:FireClient(localPlayer)
	
	wait(1)
	
	HParticles:Destroy()
	LAParticles:Destroy()
	RAParticles:Destroy()
	TParticles:Destroy()
	RLParticles:Destroy()
	LLParticles:Destroy()
	
end)