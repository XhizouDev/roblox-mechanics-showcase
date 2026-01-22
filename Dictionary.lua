-- Parent Module Script

local Dictionary = require(script.Dictionary)

local DictionaryHandler = {}

function DictionaryHandler.find(Player, action)
	
	return Dictionary[action][Player]
	
end

function DictionaryHandler.add(Player, action)
	
	if not Dictionary[action][Player] then
		
		Dictionary[action][Player] = true
		
	end
	
end

function DictionaryHandler.remove(Player, action)
	
	if Dictionary[action][Player] then
		
		Dictionary[action][Player] = nil
		
	end
	
end

return DictionaryHandler

-- Children Module Script

local Dictionary = {
	["Stunned"] = {},
	
}

return Dictionary
