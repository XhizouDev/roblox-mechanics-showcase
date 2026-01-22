local player = game:GetService("Players").LocalPlayer
local SGui = player:WaitForChild("PlayerGui")

local rs = game:GetService("ReplicatedStorage")

local TweenService = game:GetService("TweenService")

local Camera = workspace.CurrentCamera

local debris = game:GetService("Debris")
local sound = script:WaitForChild("Dash")
local VFXS = script:WaitForChild("EpicBordersVFX")

local VFXC = VFXS:Clone()
VFXC.Parent = SGui

local frame1 = VFXC:WaitForChild("Frame1")
local frame2 = VFXC:WaitForChild("Frame2")
local frame3 = VFXC:WaitForChild("Frame3")
local frame4 = VFXC:WaitForChild("Frame4")
local frame5 = VFXC:WaitForChild("Frame5")
local frame6 = VFXC:WaitForChild("Frame6")
local frame7 = VFXC:WaitForChild("Frame7")
local frame8 = VFXC:WaitForChild("Frame8")

local FORCE = 500000
local VELOCITY = 100
local COOLDOWN = 3

local contextActionService = game:GetService("ContextActionService")
local character = script.Parent
local humanoid = character.Humanoid
local debounce = true

local animDash = script:WaitForChild("AnimDash")

local OnCutscene = player.PlayerScripts:WaitForChild("Values").OnCutscene
local Stunned = character:WaitForChild("Action").Stunned
local Blocking = character:WaitForChild("Action").Blocking

local StatusFolder = character:WaitForChild("Status")
local Stamina = StatusFolder:WaitForChild("Stamina")

function VFX()

	frame1.Visible = true
	wait(.03715)
	frame1.Visible = false
	frame2.Visible = true
	wait(.03715)
	frame2.Visible = false
	frame3.Visible = true
	wait(.03715)
	frame3.Visible = false
	frame4.Visible = true
	wait(.03715)
	frame4.Visible = false
	frame5.Visible = true
	wait(.03715)
	frame5.Visible = false
	frame6.Visible = true
	wait(.03715)
	frame6.Visible = false
	frame7.Visible = true
	wait(.03715)
	frame7.Visible = false
	frame8.Visible = true
	wait(.03715)
	frame8.Visible = false

end

function pressKey(name,state,inputObject)
	if state == Enum.UserInputState.Begin and debounce and OnCutscene.Value == false and Blocking.Value == false then
		
		debounce = false
		
		local trackAnim = humanoid:LoadAnimation(animDash)
		sound:Play()
		trackAnim:Play()
		TweenService:Create(Camera, TweenInfo.new(.2), {FieldOfView = 95}):Play()
		humanoid.PlatformStand = true
		
		local trail = Instance.new("Trail", character:WaitForChild("Right Arm"))
		trail.Lifetime = 0.2
		trail.Attachment0 = character:WaitForChild("Right Arm").RightGripAttachment
		trail.Attachment1 = character:WaitForChild("Right Arm").RightShoulderAttachment
		trail.FaceCamera = true
		trail.Transparency = NumberSequence.new(0.8, 0.8)
		trail.Color = ColorSequence.new(Color3.new(158,158,158))
		trail.LightEmission = 0.5
		trail.Texture = "rbxassetid://2443461141"
		
		local trail2 = Instance.new("Trail", character:WaitForChild("Left Arm"))
		trail2.Lifetime = 0.2
		trail2.Attachment0 = character:WaitForChild("Left Arm").LeftGripAttachment
		trail2.Attachment1 = character:WaitForChild("Left Arm").LeftShoulderAttachment
		trail2.FaceCamera = true
		trail2.Transparency = NumberSequence.new(0.8, 0.8)
		trail2.Color = ColorSequence.new(Color3.new(158,158,158))
		trail2.LightEmission = 0.5
		trail2.Texture = "rbxassetid://2443461141"
		
		local dash = Instance.new("BodyVelocity", character.HumanoidRootPart)
		dash.MaxForce = Vector3.new(FORCE,FORCE,FORCE)
		dash.Velocity = character.HumanoidRootPart.CFrame.LookVector * VELOCITY
		VFX()
		
		delay(0.001, function()
			dash:Destroy()
			trackAnim:Stop()
			trail:Destroy()
			trail2:Destroy()
			TweenService:Create(Camera, TweenInfo.new(.2), {FieldOfView = 70}):Play()
			humanoid.PlatformStand = false
		end)
		
		wait(COOLDOWN)
		debounce = true
		
	end
end

contextActionService:BindAction('Dash', pressKey, true, Enum.KeyCode.Q, Enum.KeyCode.ButtonX )
contextActionService:SetPosition('Dash',UDim2.new(0.6,0,0.1,0))
contextActionService:SetTitle('Dash', 'Dash')