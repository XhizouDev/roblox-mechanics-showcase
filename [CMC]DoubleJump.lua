local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local Max_Jumps = 2
local Time_Between_Jumps = 0.2
local numJumps = 0
local canJumpAgain = false

local function onStateChanged(oldState, newState)
	if Enum.HumanoidStateType.Landed == newState then
		numJumps = 0
		canJumpAgain = false
	elseif Enum.HumanoidStateType.Freefall == newState then
		wait(Time_Between_Jumps)
		canJumpAgain = true
	elseif Enum.HumanoidStateType.Jumping == newState then
		canJumpAgain = false
		numJumps += 1
	end
	
end

local function onJumpRequest()
	if canJumpAgain and numJumps < Max_Jumps then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

humanoid.StateChanged:Connect(onStateChanged)
UserInputService.JumpRequest:Connect(onJumpRequest)