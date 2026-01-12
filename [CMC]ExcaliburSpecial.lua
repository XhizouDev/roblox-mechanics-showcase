local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Saber_Folder = ReplicatedStorage:WaitForChild("Saber_Folder")

local MainModule = require(ReplicatedStorage:WaitForChild("MainModule"))

local Tool = script.Parent
local Sword = Tool.Sword
local Blade = Sword.Blade
local Handle = Sword.Handle

local Animation = Tool.Animation

local function SwapBlades(B1,B2,Speed)
	TweenService:Create(B1,TweenInfo.new(Speed),{Transparency = 0}):Play()
	TweenService:Create(B2,TweenInfo.new(Speed),{Transparency = 1}):Play()
end

local function GlowingSword(Action,Speed) 
	local GB
	if Action == "Create" then
		GB = Blade:Clone()
		GB.Transparency = 1
		GB.TextureID = ""
		GB.Material = "Neon"
		GB.Color = Color3.fromRGB(244, 255, 114)
		GB.Name = "GlowingBlade"
		GB.Parent = Sword
		MainModule.WeldItem(Blade,GB)
		SwapBlades(GB,Blade,Speed)
		return GB
	else
		local FoundOne = false
		for _,v in pairs(Sword:GetChildren()) do
			if v.Name == "GlowingBlade" then
				if not FoundOne  then
					FoundOne = true
					GB = v
					SwapBlades(Blade,GB,Speed)
					Debris:AddItem(GB,Speed+0.5)
				else
					v:Destroy()
				end
			end
		end
	end
end

local function Excalibur_Damage(char,Hit,AN,AD,DL,KB_Speed,KB_Length)
	local DidHit,En,E_Hm,E_rp = MainModule.NormalAttack(Hit,char,AN,AD,DL)
	if DidHit then
		E_rp.CFrame = CFrame.new(E_rp.Position,char.PrimaryPart.Position)
		MainModule.KnockBack(E_rp,-KB_Speed,KB_Length)
	end
end

Tool.Equipped:Connect(function()
	if not Sword.PrimaryPart:FindFirstChild("MainWeapon_Weld") then
		local hand = Tool.Parent.RightHand
		Sword:SetPrimaryPartCFrame(hand.CFrame)
		local weld = MainModule.WeldItem(hand,Handle)
		weld.Name = "MainWeapon_Weld"
	end
end)

Tool.Activated:Connect(function()
	
	local char = Tool.Parent
	local Hm = char.Humanoid
	local rp = char.PrimaryPart
	
	local bool = char:WaitForChild("Data").WurdigSpecial
	
	local Attack_Name = "Excalibur"
	local Attack_Damage = 50
	local Damage_Length = 0.8
	local Attack_Length = 0.5
	local CoolDown_Length = 5
	local EndLag = 0.5
	local KB_Speed = 90
	local KB_Length = 0.2
	
	local Track = Hm:LoadAnimation(Animation)
	
	local CA,CI,AttackStatus,Stunned,EQ = MainModule.CanAttack(char,Attack_Name)
	if CA and Track ~= nil then
		
		bool.Value = true
		
		AttackStatus.Value = 2
		local Blade_PA = Saber_Folder.Sword_PBox.Blade_PA:Clone()
		local SwordEffect_Active = true
		local Excalibur_Attack = Saber_Folder.Excalibur_Attack:Clone()
		local Beam = Excalibur_Attack.Beam
		local Sw = Excalibur_Attack.Sw
		local HitBox =  Excalibur_Attack.HitBox	

		Track:GetMarkerReachedSignal("GlowSword"):Connect(function()
			MainModule.StopPlayer(char,true,true)
			GlowingSword("Create",0.5)
		end)
		
		Track:GetMarkerReachedSignal("Charge"):Connect(function()
			Track:AdjustSpeed(0)
			for _,v in pairs(Blade_PA:GetChildren()) do
				v.Enabled = true
				if v.Name == "Blade_P1" then
					spawn(function()
						while SwordEffect_Active and Hm.Health > 0 do
							v:Emit(3)
							wait()
						end
						print("Giant Glow Particles are done")
					end)
				end
			end

			wait(0.5)
			Track:AdjustSpeed(1)
		end)
		
		Track:GetMarkerReachedSignal("Fire"):Connect(function()
			MainModule.StopPlayer(char,true,false)
			Track:AdjustSpeed(0)
			Excalibur_Attack:SetPrimaryPartCFrame(rp.CFrame * CFrame.new(0,0,-3))
			local Attack_Tween_Goals = {
				["Beam"] = {
					[1] = {Size = Beam.Size,Transparency = Beam.Transparency,CFrame = Beam.CFrame};
					[2] = {Size = Vector3.new(20.465, 27.663, 32.824),Transparency = 1,CFrame = Beam.CFrame * CFrame.new(0,0,-Beam.Size.Z/2)};
				};
				
				["Sw"] = {
					[1] = {Size = Sw.Size,Transparency = Sw.Transparency,CFrame = Sw.CFrame};
					[2] = {Size = Vector3.new(94.256, 11.81, 126.548),Transparency = 1,CFrame = Sw.CFrame};
				};
				
				["HitBox"] = {
					[1] = {Size = Beam.Size*1.2,Transparency = 1,CFrame = Beam.CFrame};
					[2] = {Size = Vector3.new(20.465, 27.663, 32.824)*1.2,Transparency = 1,CFrame = Beam.CFrame * CFrame.new(0,0,-Beam.Size.Z/2)};
				};
			}
			
			for _,v in pairs(Excalibur_Attack:GetChildren()) do
				if v.Name ~= "MP" then
					v.Size = Vector3.new(0,0,0)
					v.CFrame = Excalibur_Attack.PrimaryPart.CFrame
					v.Transparency = 1
				end
			end
			
			Excalibur_Attack.Parent = workspace
			--	Damage --
			HitBox.Touched:Connect(function(Hit)
				Excalibur_Damage(char,Hit,Attack_Name,Attack_Damage,Damage_Length,KB_Speed,KB_Length)
			end)

			spawn(function()
				for i=1,10 do
					if AttackStatus.Value == 1 then break end
					for _,Hit in pairs(HitBox:GetTouchingParts()) do
						Excalibur_Damage(char,Hit,Attack_Name,Attack_Damage,Damage_Length,KB_Speed,KB_Length)
					end
					wait(0.1)
				end
			end)
			
			for _,v in pairs(Excalibur_Attack:GetChildren()) do
				if Attack_Tween_Goals[v.Name] ~= nil then
					print("Found one")
					TweenService:Create(v,TweenInfo.new(Attack_Length/2),Attack_Tween_Goals[v.Name][1]):Play()
				end
			end

			Blade_PA:Destroy()
			SwordEffect_Active = false
			wait(Attack_Length/2)
			for _,v in pairs(Excalibur_Attack:GetChildren()) do
				if Attack_Tween_Goals[v.Name] ~= nil then
					TweenService:Create(v,TweenInfo.new(Attack_Length/2),Attack_Tween_Goals[v.Name][2]):Play()
					Debris:AddItem(v,Attack_Length/2)
				end
			end
			wait(Attack_Length/2)
			GlowingSword(nil,0.5)			
			wait(0.5)
			Track:AdjustSpeed(1)
		end)
		

		Track:GetMarkerReachedSignal("Attack End"):Connect(function()
			Excalibur_Attack:Destroy()
			wait(EndLag)
			MainModule.CreateAttackCoolDown(char,Attack_Name,CoolDown_Length)
			MainModule.StopPlayer(char,false,true)
			AttackStatus.Value = 1
			
			bool.Value = false
			
		end)
		Blade_PA.Parent = Handle
		Track:Play()
	end
end)