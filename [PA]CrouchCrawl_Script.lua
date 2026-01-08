Player = game.Players.LocalPlayer
repeat
	wait()
until Player.Character
Mouser = Player:GetMouse()
name = Player.Name
char = game.Workspace[Player.Name]

local crouching = false
local crawling = false
local sprinting = false

local debounce = false

Animation = script.Anim
Crawlation = script.Crawl

animtrack = char.Humanoid:LoadAnimation(Animation)
crawler = char.Humanoid:LoadAnimation(Crawlation)

wait(.2)

Mouser.KeyDown:Connect(function(key)
	if key == "c" and crouching == false and crawling == false and sprinting == false then --Begin crouching
	crouching = true
		for i = 1,2 do
			wait()
			char.Humanoid.CameraOffset = Vector3.new(0,-.5,0)
		end
		animtrack:Play()
		animtrack:AdjustSpeed(0)
		char.Humanoid.WalkSpeed = 10
		char.Humanoid.JumpPower = 35
		local Event = char.Humanoid.Running:Connect(function(speed)
    if speed == 0 then
        animtrack:AdjustSpeed(0)
    else
        animtrack:AdjustSpeed(1)
    end
		end)
	else
		if key == "c" and crouching == true and crawling == false and sprinting == false then--Begin crawling
			char.Humanoid.WalkSpeed = 5
			char.Humanoid.JumpPower = 0
			char.HumanoidRootPart.CanCollide = false
			for i = 1,2 do
				wait()
				char.Humanoid.CameraOffset = Vector3.new(0,-2.5,0)
			end
			crawler:Play()
			crawler:AdjustSpeed(0)
			animtrack:Stop()
			crawling = true
			crouching = false
			local Event = char.Humanoid.Running:Connect(function(speed)
			if speed == 0 then
				crawler:AdjustSpeed(0)
			else
				crawler:AdjustSpeed(1)
			end
			end)
		else
			if key == "x" and crouching == true and crawling == false and sprinting == false then --Stop crouching
				crouching = false
				for i = 1,2 do
					wait()
					char.Humanoid.CameraOffset = Vector3.new(0,0,0)
				end
				animtrack:Stop()
				char.Humanoid.WalkSpeed = 16
				char.Humanoid.JumpPower = 50
			else
				if key == "x" and crouching == false and crawling == true and sprinting == false then--Stop crawling
					char.HumanoidRootPart.CanCollide = true
					crouching = true
					crawling = false
					for i = 1,2 do
						wait()
						char.Humanoid.CameraOffset = Vector3.new(0,-0.5,0)
					end
					crawler:Stop()
					animtrack:Play()
					animtrack:AdjustSpeed(0)
					char.Humanoid.WalkSpeed = 10
					char.Humanoid.JumpPower = 35
				end
			end
			end
	end
end)

Mouser.KeyDown:connect(function (key) 
	key = string.lower(key)
	if string.byte(key) == 48 and crawling == false and crouching == false then
		running = true
		local keyConnection = Mouser.KeyUp:connect(function (key)
			if string.byte(key) == 48 then
				running = false
			end
		end)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = 53
		repeat wait () until running == false
		keyConnection:disconnect()
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
			wait()
	end
end)