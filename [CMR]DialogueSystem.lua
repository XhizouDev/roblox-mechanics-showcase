local players = game:GetService("Players")
local player = players.LocalPlayer
local char = player.Character

local UIS = game:GetService("UserInputService")

local Frame = script.Parent:WaitForChild("BlackLine")

local NPCName = Frame:WaitForChild("NPCName")
local Chat = Frame:WaitForChild("Chat")
local Hint = Frame:WaitForChild("Hint")

local RS = game:GetService("ReplicatedStorage")
local TestRE = RS:WaitForChild("Dialogues").NoobMaster69Test

local DCRE = RS:WaitForChild("DisableControls")
local ECRE = RS:WaitForChild("EnableControls")

local TweenService = game:GetService("TweenService")

local FinishedTalking = false
local Skip = false

local TalkSFX = script:WaitForChild("Talk")
local ContinueSFX = script:WaitForChild("Continue")

UIS.InputBegan:Connect(function(Input)
	
	if Input.KeyCode == Enum.KeyCode.E then
		
		if FinishedTalking == true then
			
			Skip = true
			
		end
		
	end
	
end)

local function ChatEnded()
	
	ECRE:FireServer(player)
	TweenService:Create(Frame, TweenInfo.new(1), {Position = UDim2.new(-0.05, 0, 1.2, 0)}):Play()
	wait(1)
	Frame.Visible = false
	Hint.TextTransparency = 1
	
end

TestRE.OnClientEvent:Connect(function(NPC)
	
	FinishedTalking = false
	
	local NPC = NPC
	local DFolder = NPC:WaitForChild("Dialogues")
	local Lines = DFolder:WaitForChild("Lines")
	
	local ProxPrompt = NPC:WaitForChild("Torso").EToTalk
	
	local Name = DFolder:WaitForChild("Name")
	
	ProxPrompt.Enabled = false
	
	DCRE:FireServer(player)
	
	Frame.Visible = true
	TweenService:Create(Frame, TweenInfo.new(1), {Position = UDim2.new(-0.05, 0, 0.8, 0)}):Play()
	NPCName.Text = Name.Value
	
	Chat.Text = " "
	
	wait(.9)
	
	for i, Line in pairs(Lines:GetChildren()) do
		
		local Text = Line.Value
		
		for i = 1, #Text do
			
			Chat.Text = string.sub(Text, 1, i)
			TalkSFX:Play()
			wait(.035)
			
		end
		
		FinishedTalking = true
		wait(1.5)
		TweenService:Create(Hint, TweenInfo.new(1), {TextTransparency = 0.65}):Play()
		
		repeat wait() until Skip == true 
		
		ContinueSFX:Play()
		
	end
	
	FinishedTalking = false
	Skip = false
	
	print("Chat ended")
	ChatEnded()
	ProxPrompt.Enabled = true
	
end)