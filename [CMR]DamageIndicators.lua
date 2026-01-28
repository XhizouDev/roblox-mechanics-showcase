local tweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local part = script:WaitForChild("Part")

game.Players.PlayerAdded:Connect(function(plr)

	plr.CharacterAdded:Connect(function(char)

		local humanoid = char:WaitForChild("Humanoid")
		local currentHealth = humanoid.Health

		humanoid.HealthChanged:Connect(function(health)
			
			if currentHealth > health and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
				
				print("It's a health loss")
				local healthLost = math.floor(currentHealth - health)
				
				if healthLost == 9 then
					
					healthLost = 10
					
				end
				
				local damageIndicatorGui = Instance.new("BillboardGui")
				damageIndicatorGui.AlwaysOnTop = true

				damageIndicatorGui.Size = UDim2.new(1.5, 0, 1.5, 0)

				local offsetX = math.random(-10, 10)/10
				local offsetY = math.random(-10, 10)/10
				local offsetZ = math.random(-10, 10)/10
				damageIndicatorGui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)

				local damageIndicatorLabel = Instance.new("TextLabel")

				damageIndicatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				damageIndicatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

				damageIndicatorLabel.TextScaled = true
				damageIndicatorLabel.BackgroundTransparency = 1
				damageIndicatorLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				damageIndicatorLabel.TextStrokeTransparency = 0
				damageIndicatorLabel.Font = Enum.Font.Highway
				damageIndicatorLabel.Text = "- "..healthLost
				damageIndicatorLabel.Size = UDim2.new(0, 0, 0, 0)
				damageIndicatorLabel.TextColor3 = Color3.new(1, 1, 1)
				damageIndicatorLabel.Parent = damageIndicatorGui
				damageIndicatorGui.Parent = char.HumanoidRootPart
				
				local Highlight = char:WaitForChild("Cellshade")
				Highlight.FillColor = Color3.new(1, 0, 0)
				tweenService:Create(Highlight, TweenInfo.new(.1), {FillTransparency = .65}):Play()
				
				local UIGradient = script:WaitForChild("UIGradientLoss")
				local UIGradientLabel = UIGradient:Clone()
				UIGradientLabel.Parent = damageIndicatorLabel

				damageIndicatorLabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)
				
				wait(.1)
				
				tweenService:Create(Highlight, TweenInfo.new(.3), {FillTransparency = 1}):Play()
				
				wait(0.2)

				local guiUpTween = tweenService:Create(damageIndicatorGui, tweenInfo, {StudsOffset = damageIndicatorGui.StudsOffset + Vector3.new(0, 1, 0)})
				local textFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextTransparency = 1})
				local textStrokeFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextStrokeTransparency = 1})

				guiUpTween:Play()
				textFadeTween:Play()
				textStrokeFadeTween:Play()

				game:GetService("Debris"):AddItem(damageIndicatorGui, 0.3)
				
			elseif currentHealth < health and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
				
				print("It's a health gain")
				local healthGain = math.floor(health - currentHealth)
				
				if healthGain > 1 then
					
					local damageIndicatorGui = Instance.new("BillboardGui")
					damageIndicatorGui.AlwaysOnTop = true

					damageIndicatorGui.Size = UDim2.new(1.5, 0, 1.5, 0)

					local offsetX = math.random(-10, 10)/10
					local offsetY = math.random(-10, 10)/10
					local offsetZ = math.random(-10, 10)/10
					damageIndicatorGui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)

					local damageIndicatorLabel = Instance.new("TextLabel")

					damageIndicatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
					damageIndicatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

					damageIndicatorLabel.TextScaled = true
					damageIndicatorLabel.BackgroundTransparency = 1
					damageIndicatorLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
					damageIndicatorLabel.TextStrokeTransparency = 0
					damageIndicatorLabel.Font = Enum.Font.Highway
					damageIndicatorLabel.Text = "+ "..healthGain
					damageIndicatorLabel.Size = UDim2.new(0, 0, 0, 0)
					damageIndicatorLabel.TextColor3 = Color3.new(1, 1, 1)
					damageIndicatorLabel.Parent = damageIndicatorGui
					damageIndicatorGui.Parent = char.HumanoidRootPart

					local Highlight = char:WaitForChild("Cellshade")
					Highlight.FillColor = Color3.new(0, 1, 0)
					tweenService:Create(Highlight, TweenInfo.new(.1), {FillTransparency = .65}):Play()

					local UIGradient = script:WaitForChild("UIGradientGain")
					local UIGradientLabel = UIGradient:Clone()
					UIGradientLabel.Parent = damageIndicatorLabel

					damageIndicatorLabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)

					wait(.1)

					tweenService:Create(Highlight, TweenInfo.new(.3), {FillTransparency = 1}):Play()

					wait(0.2)

					local guiUpTween = tweenService:Create(damageIndicatorGui, tweenInfo, {StudsOffset = damageIndicatorGui.StudsOffset + Vector3.new(0, 1, 0)})
					local textFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextTransparency = 1})
					local textStrokeFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextStrokeTransparency = 1})

					guiUpTween:Play()
					textFadeTween:Play()
					textStrokeFadeTween:Play()

					game:GetService("Debris"):AddItem(damageIndicatorGui, 0.3)
					
				end
				
			end
			
			currentHealth = humanoid.Health
			
		end)
		
		humanoid.Died:Connect(function()
			
			local Folder = Instance.new("Folder")
			Folder.Name = plr.Name.."DiedIndicator"
			Folder.Parent = workspace

			local anchor = part:Clone()
			anchor.Parent = Folder
			anchor.CFrame = char.HumanoidRootPart.CFrame
			
			print("Died")

			local damageIndicatorGui = Instance.new("BillboardGui")
			damageIndicatorGui.AlwaysOnTop = true

			damageIndicatorGui.Size = UDim2.new(2.5, 0, 2.5, 0)

			local offsetX = math.random(-10, 10)/10
			local offsetY = math.random(-10, 10)/10
			local offsetZ = math.random(-10, 10)/10
			damageIndicatorGui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)

			local damageIndicatorLabel = Instance.new("TextLabel")
			
			local Message = math.random(1, 4)
			
			damageIndicatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			damageIndicatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

			damageIndicatorLabel.TextScaled = true
			damageIndicatorLabel.BackgroundTransparency = 1
			damageIndicatorLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			damageIndicatorLabel.TextStrokeTransparency = 0
			damageIndicatorLabel.Font = Enum.Font.Highway
			
			local Highlight = char:WaitForChild("Cellshade")
			Highlight.FillColor = Color3.new(1, 0, 0)
			tweenService:Create(Highlight, TweenInfo.new(.1), {FillTransparency = .35}):Play()
			
			if Message == 1 then
				
				damageIndicatorLabel.Text = "K.O.!"
				
			elseif Message == 2 then
				
				damageIndicatorLabel.Text = "Oops.."
				
			elseif Message == 3 then
				
				damageIndicatorLabel.Text = "99999+"
				
			elseif Message == 4 then
				
				damageIndicatorLabel.Text = "Died!"
				
			end
			damageIndicatorLabel.Size = UDim2.new(0, 0, 0, 0)
			damageIndicatorLabel.TextColor3 = Color3.new(1, 1, 1)
			damageIndicatorLabel.Parent = damageIndicatorGui
			damageIndicatorGui.Parent = anchor

			local UIGradient = script:WaitForChild("UIGradientDied")
			local UIGradientLabel = UIGradient:Clone()
			UIGradientLabel.Parent = damageIndicatorLabel

			damageIndicatorLabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)
			
			wait(.1)

			tweenService:Create(Highlight, TweenInfo.new(.3), {FillTransparency = 1}):Play()

			wait(0.6)

			local guiUpTween = tweenService:Create(damageIndicatorGui, tweenInfo, {StudsOffset = damageIndicatorGui.StudsOffset + Vector3.new(0, 1, 0)})
			local textFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextTransparency = 1})
			local textStrokeFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextStrokeTransparency = 1})

			guiUpTween:Play()
			textFadeTween:Play()
			textStrokeFadeTween:Play()

			game:GetService("Debris"):AddItem(damageIndicatorGui, 0.3)
			game:GetService("Debris"):AddItem(Folder, 0.3)
			
		end)
		
	end)
	
end)
