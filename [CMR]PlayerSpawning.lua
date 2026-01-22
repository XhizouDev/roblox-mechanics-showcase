local rs = game:GetService("ReplicatedStorage")
local MRE = rs:WaitForChild("BGMusic")

game.Players.PlayerAdded:Connect(function(Player)
	
	local Data = Instance.new("Folder")
	Data.Name = "Data"
	Data.Parent = Player
	local AlreadyPlayed = Instance.new("BoolValue")
	AlreadyPlayed.Name = "AlreadyPlayed"
	AlreadyPlayed.Parent = Data
	local Cruzader = Instance.new("IntValue")
	Cruzader.Name = "Spirit"
	Cruzader.Parent = Data
	
	Player.CharacterAdded:Connect(function(Character)
		
		local Cellshade = Instance.new("Highlight")
		Cellshade.DepthMode = Enum.HighlightDepthMode.Occluded
		Cellshade.FillTransparency = 1
		Cellshade.Name = "Cellshade"
		Cellshade.OutlineColor = Color3.new()
		Cellshade.OutlineTransparency = 0
		
		Cellshade.Parent = Character
		Cellshade.Adornee = Character
		
		task.wait()
		Character.Parent = workspace.Entities
		
		local StatusFolder = Instance.new("Folder")
		StatusFolder.Name = "Status"
		StatusFolder.Parent = Character
		local Stamina = Instance.new("IntValue")
		Stamina.Name = "Stamina"
		Stamina.Parent = StatusFolder
		Stamina.Value = 100
		
		local Folder = Instance.new("Folder")
		Folder.Name = "Action"
		Folder.Parent = Character
		local Stunned = Instance.new("BoolValue")
		Stunned.Name = "Stunned"
		Stunned.Parent = Folder
		local Walking = Instance.new("BoolValue")
		Walking.Name = "Walking"
		Walking.Parent = Folder
		local Sprinting = Instance.new("BoolValue")
		Sprinting.Name = "Sprinting"
		Sprinting.Parent = Folder
		local CMMusic = Instance.new("BoolValue")
		CMMusic.Name = "CMMusic"
		CMMusic.Parent = Folder
		local I = Instance.new("BoolValue")
		I.Name = "Invincibility"
		I.Parent = Folder
		local Blocking = Instance.new("BoolValue")
		Blocking.Name = "Blocking"
		Blocking.Parent = Folder
		local Charging = Instance.new("BoolValue")
		Charging.Name = "Charging"
		Charging.Parent = Folder
		
		if Cruzader.Value == 0 then
			
			local KambitFolder = Instance.new("Folder")
			KambitFolder.Name = "Habilities"
			KambitFolder.Parent = Character
			local CombatMaster = Instance.new("BoolValue")
			CombatMaster.Name = "CombatMaster"
			CombatMaster.Parent = KambitFolder
			
			
		end
		
		MRE:FireClient(Player)
		wait(.35)
		
		Cellshade.Adornee = nil
		
	end)
	
end)