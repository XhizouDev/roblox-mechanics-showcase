local Runservice = game:GetService("RunService")
local char = script.Parent
local Humanoid = char:WaitForChild("Humanoid")

function Effect()
	local Time = tick()
	if Humanoid.MoveDirection.Magnitude > 0 then
		local X = math.cos(Time * 10) * 0.35
		local Y = math.abs(math.sin(Time * 10)) * 0.35
		local Shake = Vector3.new(X,Y,0)
		Humanoid.CameraOffset = Humanoid.CameraOffset:lerp(Shake,0.25)
	else
		Humanoid.CameraOffset = Humanoid.CameraOffset *  0.75
	end
end

Runservice.RenderStepped:Connect(Effect)