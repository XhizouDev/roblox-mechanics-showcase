local UserInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer
local character
local humanoid

local canDoubleJump = false
local hasDoubleJumped = false
local oldPower
local TIME_BETWEEN_JUMPS = 0.2

local animthingy = script:WaitForChild("DoubleJumpAnim")

function onJumpRequest()
	if not character or not humanoid or not character:IsDescendantOf(workspace) or
		humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	if canDoubleJump and not hasDoubleJumped then
		hasDoubleJumped = true
		local anim = humanoid:LoadAnimation(animthingy)
		humanoid.JumpPower = humanoid.JumpPower * 2
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		anim:Play()
	end
end

local function characterAdded(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	hasDoubleJumped = false
	canDoubleJump = false
	oldPower = humanoid.JumpPower

	humanoid.StateChanged:connect(function(old, new)
		if new == Enum.HumanoidStateType.Landed then
			canDoubleJump = false
			hasDoubleJumped = false
			humanoid.JumpPower = oldPower
		elseif new == Enum.HumanoidStateType.Freefall then
			wait(TIME_BETWEEN_JUMPS)
			canDoubleJump = true
		end
	end)
end

if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

localPlayer.CharacterAdded:connect(characterAdded)
UserInputService.JumpRequest:connect(onJumpRequest)