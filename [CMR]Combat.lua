-- Local Script

local players = game:GetService("Players")
local Player = players.LocalPlayer
local DataFolder = Player:WaitForChild("Data")

local entities = workspace:WaitForChild("Entities")
local char = entities:WaitForChild(Player.Name)

local OnCutscene = Player.PlayerScripts:WaitForChild("Values").OnCutscene

local Cruzader = DataFolder:WaitForChild("Spirit")

local rp = game:GetService("ReplicatedStorage")
local Combat = rp:WaitForChild("Combat")

local HeavyRE = rp:WaitForChild("HeavyPunch")

local UIS = game:GetService("UserInputService")
local debounce = false
local heavyCD = false
local cds = {
	
	0,
	1
	
}

local sequence = ""
local curr = 0
local prev = 0

local Blocking = char:WaitForChild("Action").Blocking

UIS.InputBegan:Connect(function(input, isTyping)
	
	if not isTyping then
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 and Blocking.Value == false then
			
			if debounce == false then
				
				if Cruzader.Value == 0 then
					
					if OnCutscene.Value == false then
						
						local SFXFolder = script:WaitForChild("SFX")
						local ThrowSFX = SFXFolder:WaitForChild("Throw")

						debounce = true
						ThrowSFX:Play()
						curr = os.clock()

						local PT = curr - prev
						if PT < 1 then

							sequence = sequence.."L"
							if string.len(sequence) > 4 then

								sequence = "L"

							end

						else

							sequence = "L"

						end

						Combat:FireServer(sequence)
						
					end
					
				end
				
			end
			
		end
		
	end
	
end)

UIS.InputBegan:Connect(function(input, isTyping)
	
	if not isTyping then
		
		if input.UserInputType == Enum.UserInputType.MouseButton2 and Blocking.Value == false then
			
			if debounce == false and heavyCD == false then
				
				if Cruzader.Value == 0 then
					
					if OnCutscene.Value == false then
						
						local SFXFolder = script:WaitForChild("SFX")
						local ThrowSFX = SFXFolder:WaitForChild("Throw")
						
						heavyCD = true
						debounce = true
						ThrowSFX:Play()
						
						HeavyRE:FireServer(Player)
						
					end
					
				end
				
			end
			
		end
		
	end
	
end)

HeavyRE.OnClientEvent:Connect(function()
	
	wait(1)
	
	debounce = false
	
	wait(3.5)
	
	heavyCD = false
	
end)

Combat.OnClientEvent:Connect(function(bool)
	
	prev = curr
	
	if bool then
		
		wait(cds[2])
		debounce = false
		
	else
		
		debounce = false
		
	end
	
end)

-- Main Server Script

local rp = game:GetService("ReplicatedStorage")
local Combat = rp:WaitForChild("Combat")

local VFX = rp:WaitForChild("CombatVFX")

local Animations = script.Combat_Handler:WaitForChild("Animations")
local Meshes = script.Combat_Handler:WaitForChild("Meshes")
local Particles = script.Combat_Handler:WaitForChild("Particles")

local Debris = game:GetService("Debris")
local Heavy = rp:WaitForChild("HeavyPunch")

local Combat_Handler = require(script.Combat_Handler)

local HeavyPunchAnim = script.Combat_Handler:WaitForChild("Animations").HeavyHit

local SSS = game:GetService("ServerScriptService")
local DictionaryHandler = require(SSS:WaitForChild("DictionaryHandler"))

Combat.OnServerEvent:Connect(function(Player, sequence)
	
	local Character = Player.Character
	local Humanoid = Character.Humanoid
	local Humrp = Character.HumanoidRootPart
	
	if not DictionaryHandler.find(Character, "Stunned") then
		
		local Action, Length = Combat_Handler.getAnimation(Humanoid, sequence)
		Action:Play()

		Action:GetMarkerReachedSignal("Hitbox"):Connect(function()

			Combat_Handler.create(Player, Character, Humrp, Length, sequence)

		end)

		wait(Length)

		if string.len(sequence) < 4 then

			Combat:FireClient(Player, false)

		else

			Combat:FireClient(Player, true)

		end
		
	else
		
		Combat:FireClient(Player, false)
		
		
	end
	
end)

Heavy.OnServerEvent:Connect(function(Player)
	
	local Character = Player.Character
	local Humanoid = Character.Humanoid
	local Humrp = Character.HumanoidRootPart
	
	local lHeavyPunchAnim = Humanoid:LoadAnimation(HeavyPunchAnim)
	lHeavyPunchAnim:Play()
	
	lHeavyPunchAnim:GetMarkerReachedSignal("Hitbox"):Connect(function()
		
		Combat_Handler.heavy(Player, Character, Humrp)
		
	end)
	
	wait(2)

	Heavy:FireClient(Player)
		
end)

-- Main Module Server Script

local Animations = script.Animations
local Meshes = script.Meshes
local Particles = script.Particles

local rp = game:GetService("ReplicatedStorage")
local VFX = rp:WaitForChild("CombatVFX")

local KeyProvider = game:GetService("KeyframeSequenceProvider")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local SSS = game:GetService("ServerScriptService")
local DictionaryHandler = require(SSS:WaitForChild("DictionaryHandler"))

local BBRE = rp:WaitForChild("BrokenBlock")

local Entities = workspace.Entities

local Combat_Handler = 
	{
		
		MeleeAnims = 
		{
			
			["L"] = Animations.Melee1,
			["LL"] = Animations.Melee2,
			["LLL"] = Animations.Melee3,
			["LLLL"] = Animations.Melee4,
			
		},
		
		plrsInCombat = {},
		plrStunTime = {}, 
		
	}

function Combat_Handler.getAnimation(Humanoid, sequence)
	
	local length = 0
	
	local keysequence = KeyProvider:GetKeyframeSequenceAsync(Combat_Handler.MeleeAnims[sequence].AnimationId)
	local keyframes = keysequence:GetKeyframes()
	
	for i = 1, #keyframes do
		
		local Time = keyframes[i].Time
		if Time > length then
			
			length = Time
			
		end
		
	end
	
	return Humanoid.Animator:LoadAnimation(Combat_Handler.MeleeAnims[sequence]), length
	
end

function Combat_Handler.create(Player, Character, Humrp, Length, sequence)
	
	local Folder = Instance.new("Folder")
	Folder.Name = Player.name.."Combat"
	Folder.Parent = workspace
	Debris:AddItem(Folder, .25)
	
	local Hitbox = Meshes.Hitbox:Clone()
	Hitbox.CFrame = Humrp.CFrame * CFrame.new(0, 0, -4)
	Hitbox.Parent = Folder
	
	local Weld = Instance.new("ManualWeld")
	Weld.Part0 = Hitbox
	Weld.Part1 = Humrp
	Weld.C0 = Weld.Part0.CFrame:ToObjectSpace(Weld.Part1.CFrame)
	Weld.Parent = Weld.Part0
	
	local connection
	connection = Hitbox.Touched:Connect(function()end)
	
	local results = Hitbox:GetTouchingParts()
	
	coroutine.wrap(function()
		
		for i, obj in pairs(results) do
			
			if not results[i]:IsDescendantOf(Character) then
				
				local ehumanoid = results[i].Parent:FindFirstChild("Humanoid")
				local ehumrp = results[i].Parent:FindFirstChild("HumanoidRootPart")
				if ehumanoid and ehumanoid.Health > 0 then
					Hitbox:Destroy()
					
					if connection then

						connection:Disconnect()

					end
					
					if Combat_Handler.plrsInCombat[Character] or DictionaryHandler.find(Character, "Stunned") then
						
						return 
						
					end
					
					local Attach = Particles:WaitForChild("HitParticle"):Clone()
					Attach.Parent = ehumrp
					Attach.CFrame = ehumrp.CFrame
					local eChar = ehumrp.Parent
					Attach.ParticleAttach.Particle:Emit(1)
					Debris:AddItem(Attach, .5)
					
					local HitAnim = nil
					local KnockbackAnim = nil
					
					local CombatMasterBool = Character:WaitForChild("Habilities").CombatMaster
					local eBlocking = eChar:WaitForChild("Action").Blocking
					
					local ePlayer = Players:FindFirstChild(eChar.Name)
					
					if ePlayer then

						print("It's a Player")

						if CombatMasterBool.Value == true then

							if eChar:WaitForChild("Action").Invincibility.Value == false then
								
								if eBlocking.Value == false then
									
									ehumanoid:TakeDamage(20)
									HitAnim = Animations:WaitForChild("Hit")
									KnockbackAnim = Animations:WaitForChild("Knockback")
									
								elseif eBlocking.Value == true then
									
									ehumanoid:TakeDamage(1)
									HitAnim = Animations:WaitForChild("HitBlock")
									KnockbackAnim = Animations:WaitForChild("HitBlock")
									
								end

							end

						elseif CombatMasterBool.Value == false then

							if eChar:WaitForChild("Action").Invincibility.Value == false then
								
								if eBlocking.Value == false then

									ehumanoid:TakeDamage(10)
									HitAnim = Animations:WaitForChild("Hit")
									KnockbackAnim = Animations:WaitForChild("Knockback")
									
									
								elseif eBlocking.Value == true then
									
									HitAnim = Animations:WaitForChild("HitBlock")
									KnockbackAnim = Animations:WaitForChild("HitBlock")
									
								end
								
							end

						end


					else

						print("It's a NPC")
						if CombatMasterBool.Value == true then
							
							ehumanoid:TakeDamage(20)
							HitAnim = Animations:WaitForChild("Hit")
							KnockbackAnim = Animations:WaitForChild("Knockback")

						elseif CombatMasterBool.Value == false then
							
							ehumanoid:TakeDamage(10)
							HitAnim = Animations:WaitForChild("Hit")
							KnockbackAnim = Animations:WaitForChild("Knockback")

						end
					end
					
					coroutine.wrap(function()
						
						for _, plr in pairs(game.Players:GetChildren()) do
							
							VFX:FireClient(plr, "CombatVFX", "vfx", ehumrp)
							
						end
						
					end)()
					
					local lHitAnim = ehumanoid:LoadAnimation(HitAnim)
					local lKnockbackAnim = ehumanoid:LoadAnimation(KnockbackAnim)
					
					local duration 
					if string.len(sequence) < 4 then
						
						lHitAnim:Play()
						duration = Length * 2
						
					else
						
						lKnockbackAnim:Play()
						duration = Length * 3
						
						local Speed = 60
						local Force = 80000

						local TotalForce = Force

						local KnockBack = Instance.new("BodyVelocity")
						KnockBack.Parent = ehumrp

						KnockBack.MaxForce = Vector3.new(TotalForce,TotalForce,TotalForce)
						KnockBack.Velocity = Humrp.CFrame.LookVector * Speed
						
						if eBlocking.Value == false then
							
							Debris:AddItem(KnockBack, .25)
							
						else
							
							Debris:AddItem(KnockBack, .07)
							
						end
						
					end
					
					local StunnedBool = ehumanoid.Parent:WaitForChild("Action").Stunned
					
					if eBlocking.Value == false then
						
						if not Combat_Handler.plrsInCombat[ehumanoid.Parent] then

							Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
							Combat_Handler.plrStunTime[ehumanoid.Parent] = duration
							DictionaryHandler.add(ehumanoid.Parent, "Stunned")

							ehumanoid.WalkSpeed = 4
							ehumanoid.JumpPower = 0
							StunnedBool.Value = true

						else

							Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
							Combat_Handler.plrStunTime[ehumanoid.Parent] = duration

							ehumanoid.WalkSpeed = 4
							ehumanoid.JumpPower = 0
							StunnedBool.Value = true

						end
						
					end
					
					break
					
				end
				
			end
			
		end
		
	end)()
	
	task.delay(.25, function()
		
		if connection then
			
			connection:Disconnect()
			
		end
		
	end)
	
end

function Combat_Handler.heavy(Player, Character, Humrp)
	
	local Folder = Instance.new("Folder")
	Folder.Name = Player.name.."Heavy"
	Folder.Parent = workspace
	Debris:AddItem(Folder, .25)

	local Hitbox = Meshes.Hitbox:Clone()
	Hitbox.CFrame = Humrp.CFrame * CFrame.new(0, 0, -4)
	Hitbox.Parent = Folder

	local Weld = Instance.new("ManualWeld")
	Weld.Part0 = Hitbox
	Weld.Part1 = Humrp
	Weld.C0 = Weld.Part0.CFrame:ToObjectSpace(Weld.Part1.CFrame)
	Weld.Parent = Weld.Part0

	local connection
	connection = Hitbox.Touched:Connect(function()end)

	local results = Hitbox:GetTouchingParts()

	coroutine.wrap(function()

		for i, obj in pairs(results) do

			if not results[i]:IsDescendantOf(Character) then

				local ehumanoid = results[i].Parent:FindFirstChild("Humanoid")
				local ehumrp = results[i].Parent:FindFirstChild("HumanoidRootPart")
				local eChar = ehumrp.Parent
				if ehumanoid and ehumanoid.Health > 0 then
					Hitbox:Destroy()

					if connection then

						connection:Disconnect()

					end

					if Combat_Handler.plrsInCombat[Character] or DictionaryHandler.find(Character, "Stunned") then

						return 

					end

					local Attach = Particles:WaitForChild("HitParticle"):Clone()
					Attach.Parent = ehumrp
					Attach.CFrame = ehumrp.CFrame
					local eChar = ehumrp.Parent
					Attach.ParticleAttach.Particle:Emit(1)
					Debris:AddItem(Attach, .5)

					local HitAnim = Animations:WaitForChild("Knockback")
					local BrokenBlockAnim = Animations:WaitForChild("BrokenBlock")

					local CombatMasterBool = Character:WaitForChild("Habilities").CombatMaster
					local eBlocking = eChar:WaitForChild("Action").Blocking
					
					local ePlayer = Players:FindFirstChild(eChar.Name)

					if eBlocking.Value == true then
						
						BBRE:FireClient(ePlayer)
						ehumanoid:LoadAnimation(BrokenBlockAnim):Play()
						eBlocking.Value = false

					elseif eBlocking.Value == false then

						if CombatMasterBool.Value == true then

							ehumanoid:TakeDamage(45)
							ehumanoid:LoadAnimation(HitAnim):Play()

						elseif CombatMasterBool.Value == false then

							ehumanoid:TakeDamage(25)
							ehumanoid:LoadAnimation(HitAnim):Play()

						end

					end

					coroutine.wrap(function()

						for _, plr in pairs(game.Players:GetChildren()) do

							VFX:FireClient(plr, "CombatVFX", "vfx", ehumrp)

						end

					end)()

					local StunnedBool = ehumanoid.Parent:WaitForChild("Action").Stunned

					if not Combat_Handler.plrsInCombat[ehumanoid.Parent] then

						Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
						Combat_Handler.plrStunTime[ehumanoid.Parent] = 1.5
						DictionaryHandler.add(ehumanoid.Parent, "Stunned")

						ehumanoid.WalkSpeed = 4
						ehumanoid.JumpPower = 0
						StunnedBool.Value = true

					else

						Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
						Combat_Handler.plrStunTime[ehumanoid.Parent] = 1.5

						ehumanoid.WalkSpeed = 4
						ehumanoid.JumpPower = 0
						StunnedBool.Value = true

					end
					
					local Speed = 60
					local Force = 80000

					local TotalForce = Force

					local KnockBack = Instance.new("BodyVelocity")
					KnockBack.Parent = ehumrp

					KnockBack.MaxForce = Vector3.new(TotalForce,TotalForce,TotalForce)
					KnockBack.Velocity = Humrp.CFrame.LookVector * Speed
					
					Debris:AddItem(KnockBack, .125)

					break

				end

			end

		end

	end)()

	task.delay(.25, function()

		if connection then

			connection:Disconnect()

		end

	end)
	
end

RunService.Heartbeat:Connect(function()
	
	for _, plr in pairs(Entities:GetChildren()) do
		
		if Combat_Handler.plrsInCombat[plr] then
			
			local currTime = Combat_Handler.plrsInCombat[plr]
			local stunTime = Combat_Handler.plrStunTime[plr]
			if os.clock() - currTime >= stunTime then
				
				Combat_Handler.plrsInCombat[plr] = nil
				Combat_Handler.plrStunTime[plr] = nil
				
				plr.Humanoid.WalkSpeed = 16
				plr.Humanoid.JumpPower = 50
				
				local StunnedBool = plr:WaitForChild("Action").Stunned
				StunnedBool.Value = false
				
				DictionaryHandler.remove(plr, "Stunned")
				
			end
			
		end
		
	end
	
end)

return Combat_Handler

-- Secondary Module Server Script

local Animations = script.Animations
local Meshes = script.Meshes
local Particles = script.Particles

local rp = game:GetService("ReplicatedStorage")
local VFX = rp:WaitForChild("CombatVFX")

local Debris = game:GetService("Debris")

local HeavyHit = {}

function HeavyHit.heavy(Player, Character, Humrp)

	local Folder = Instance.new("Folder")
	Folder.Name = Player.name.."Heavy"
	Folder.Parent = workspace
	Debris:AddItem(Folder, .25)

	local Hitbox = Meshes.Hitbox:Clone()
	Hitbox.CFrame = Humrp.CFrame * CFrame.new(0, 0, -4)
	Hitbox.Parent = Folder

	local Weld = Instance.new("ManualWeld")
	Weld.Part0 = Hitbox
	Weld.Part1 = Humrp
	Weld.C0 = Weld.Part0.CFrame:ToObjectSpace(Weld.Part1.CFrame)
	Weld.Parent = Weld.Part0

	local connection
	connection = Hitbox.Touched:Connect(function()end)

	local results = Hitbox:GetTouchingParts()

	coroutine.wrap(function()

		for i, obj in pairs(results) do

			if not results[i]:IsDescendantOf(Character) then

				local ehumanoid = results[i].Parent:FindFirstChild("Humanoid")
				local ehumrp = results[i].Parent:FindFirstChild("HumanoidRootPart")
				local eChar = ehumrp.Parent
				if ehumanoid and ehumanoid.Health > 0 then
					Hitbox:Destroy()

					if connection then

						connection:Disconnect()

					end

					if Combat_Handler.plrsInCombat[Character] or DictionaryHandler.find(Character, "Stunned") then

						return 

					end

					local Attach = Particles:WaitForChild("HitParticle"):Clone()
					Attach.Parent = ehumrp
					Attach.CFrame = ehumrp.CFrame
					local eChar = ehumrp.Parent
					Attach.ParticleAttach.Particle:Emit(1)
					Debris:AddItem(Attach, .5)

					local HitAnim = Animations:WaitForChild("Hit")
					local BrokenBlockAnim = Animations:WaitForChild("BrokenBlock")

					local CombatMasterBool = Character:WaitForChild("Habilities").CombatMaster
					local eBlocking = eChar:WaitForChild("Action").Blocking

					print(eChar.Name)

					if eBlocking.Value == true then

						ehumanoid:LoadAnimation(BrokenBlockAnim):Play()

					elseif eBlocking.Value == false then

						if CombatMasterBool.Value == true then

							ehumanoid:TakeDamage(65)
							ehumanoid:LoadAnimation(HitAnim):Play()

						elseif CombatMasterBool.Value == false then

							ehumanoid:TakeDamage(40)
							ehumanoid:LoadAnimation(HitAnim):Play()

						end

					end

					coroutine.wrap(function()

						for _, plr in pairs(game.Players:GetChildren()) do

							VFX:FireClient(plr, "CombatVFX", "vfx", ehumrp)

						end

					end)()

					local StunnedBool = ehumanoid.Parent:WaitForChild("Action").Stunned

					if not Combat_Handler.plrsInCombat[ehumanoid.Parent] then

					Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
					Combat_Handler.plrStunTime[ehumanoid.Parent] = 1.5
					DictionaryHandler.add(ehumanoid.Parent, "Stunned")

					ehumanoid.WalkSpeed = 4
					ehumanoid.JumpPower = 0
					StunnedBool.Value = true

					else

					Combat_Handler.plrsInCombat[ehumanoid.Parent] = os.clock()
					Combat_Handler.plrStunTime[ehumanoid.Parent] = 1.5

					ehumanoid.WalkSpeed = 4
					ehumanoid.JumpPower = 0
					StunnedBool.Value = true

					end

					break

				end

			end

		end

	end)()

	task.delay(.25, function()

		if connection then

			connection:Disconnect()

		end

	end)

end

return HeavyHit

-- VFX Local Script

local rp = game:GetService("ReplicatedStorage")
local VFX = rp:WaitForChild("CombatVFX")

VFX.OnClientEvent:Connect(function(...)
	
	local arg = {...}
	
	local Module = require(script:FindFirstChild(arg[1]))
	Module[arg[2]](arg)
	
end)

-- VFX Module Local Script

local Meshes = script.Meshes

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local CombatVFX = {}

function CombatVFX.vfx(arg)
	
	local Folder = Instance.new("Folder")
	Folder.Name = "CombatVFX"
	Folder.Parent = workspace
	Debris:AddItem(Folder, 1)
	
	coroutine.wrap(function()
		
		for i = 1, 12 do
			
			local Sphere = Meshes.Sphere1:Clone()
			Sphere.Size = Vector3.new(.1, .1, .1)
			Sphere.CFrame = arg[3].CFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180))) * CFrame.new(0, 0, -.5)
			Sphere.Parent = Folder
			Debris:AddItem(Sphere, .25)
			
			TweenService:Create(Sphere, TweenInfo.new(.25), {CFrame = Sphere.CFrame * CFrame.new(0, 0, -8.5)}):Play() -- -10
			TweenService:Create(Sphere, TweenInfo.new(.125), {Size = Vector3.new(.2, .2, 3.5)}):Play()
			task.delay(.125, function()
				
				TweenService:Create(Sphere, TweenInfo.new(.125), {Size = Vector3.new(.1, .1, .1), Transparency = 1}):Play()
				
			end)
			
		end
		
	end)()
	
end

return CombatVFX
