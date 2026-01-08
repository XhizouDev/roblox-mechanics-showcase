local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")



local DetectedNPC = nil
local Detected = false
local Chatting = false
local Skip = false
local Exit = false



local Player = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

local Gui = script.Parent
local Sounds = Gui.Sounds
local PromptLabel = Gui.PromptLabel
local LineLabel = Gui.LineLabel



local Character = Player.Character or Player.CharacterAdded:Wait()
local CharHMR = Character:WaitForChild("HumanoidRootPart")



local NPCS = game.Workspace:WaitForChild("NPCS")



UIS.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.X then
		if Chatting == true then
			Skip = true
			Sounds.Click:Play()
		end
	end
end)

UIS.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.Z then
		if Chatting == true then
			Exit = true
			Sounds.Click:Play()
		end
	end
end)

UIS.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.E then
		
		
		if Detected == true then
			local Lines = DetectedNPC:FindFirstChild("Lines")
			
			if Lines then
				Sounds.Click:Play()
				
				Chatting = true
				Detected = false
				
				LineLabel.Text = " "
				
				PromptLabel:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
				LineLabel:TweenPosition(UDim2.new(0, 0, 0.8, 0), "In", "Linear", 0.2)
				
				wait(0.5)
				
				for i, Line in pairs(Lines:GetChildren()) do
					local Text = Line.Value
					
					for i = 1, #Text do
						LineLabel.Text = string.sub(Text, 1, i)
						Sounds.Talk:Play()
						if Skip == true then
							Skip = false
							LineLabel.Text = Text
							break
						end
						if Exit == true then
							break
						end
						wait(0.07)
					end
					if Exit == true then
						Exit = false
						break
					end
					repeat wait() until Skip == true or Exit == true
					Skip = false
				end
				
				Exit = false
				Skip = false
				
				PromptLabel:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
				LineLabel:TweenPosition(UDim2.new(0, 0, 1.2, 0), "Out", "Linear", 0.2)
				
				wait(0.5)
				
				Chatting = false
				Detected = false
			end
		end		
	end
end)



RunService.RenderStepped:Connect(function()
	
	if Detected == false and Chatting == false then
		for i, NPC in pairs(NPCS:GetChildren()) do
			local Humanoid = NPC:FindFirstChild("Humanoid")
			local HMR = NPC:FindFirstChild("HumanoidRootPart")
			
			if Humanoid and HMR then
				if (HMR.Position - CharHMR.Position).magnitude < 15 then
					Detected = true
					DetectedNPC = NPC
					PromptLabel:TweenSize(UDim2.new(0, 60, 0, 60), "In", "Linear", 0.2)
					print(DetectedNPC.Name)
				end
			end
			
		end
	end
	
	if Detected == true and Chatting == false then
		local Humanoid = DetectedNPC:FindFirstChild("Humanoid")
		local HMR = DetectedNPC:FindFirstChild("HumanoidRootPart")
		
		if Humanoid and HMR then
			if (HMR.Position - CharHMR.Position).magnitude > 15 then
				Detected = false
				DetectedNPC = nil
				PromptLabel:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
				print("No Longer Detected NPC")
			else
				local WSTP = Camera:WorldToScreenPoint(HMR.Position)
				PromptLabel.Position = UDim2.new(0, WSTP.X, 0, WSTP.Y)
			end
		end
	end
	
	if Chatting == true then
		local Humanoid = DetectedNPC:FindFirstChild("Humanoid")
		local HMR = DetectedNPC:FindFirstChild("HumanoidRootPart")
		
		if Humanoid and HMR then
			Camera.CameraType = Enum.CameraType.Scriptable
			Camera.CFrame = Camera.CFrame:Lerp(HMR.CFrame * CFrame.new(-4, 4, -7) * CFrame.fromOrientation(math.rad(-20), math.rad(215), 0), 0.07)
		end
	else
		Camera.CameraType = Enum.CameraType.Custom
	end
	
end)