--//Service
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")

--//Directories
local Remotes_Folder = ReplicatedStorage:WaitForChild("Remotes")
local Modules_Folder = ServerScriptService:WaitForChild("Modules")

--//Modules
local Modules = {
	DataHandler = require(Modules_Folder:WaitForChild("Datastore"));
}

--//Remotes
local Remotes = {
	InventoryEvent = Remotes_Folder:WaitForChild("InventoryEvent");
	MatchMarkingEvent = Remotes_Folder:WaitForChild("MatchMakingEvent");
};

--//Objects
local PlaceIDS = {
	Apartment = { Id = 14421495807, Name = "Nagis Apartment" },
}


--/When player join the game give him data assets
Players.PlayerAdded:Connect(function(player)
	
	local Data = Modules["DataHandler"]:LoadData(player)
	
	Remotes["InventoryEvent"]:FireClient(player, Data)
end)

Remotes["InventoryEvent"].OnServerEvent:Connect(function(player,Type,Tower)
	
	if Type and Type == "Equip" then
		
		--//Objects
		local PlayerData = player:WaitForChild("PlayerData")
		local FindTower = PlayerData:WaitForChild("Towers"):FindFirstChild(Tower)
		
		--//Code
		if FindTower then
			FindTower.Value = not FindTower.Value
		end
	end
end)

--/When player leaves save him data on datastore
Players.PlayerRemoving:Connect(function(player)
	Modules["DataHandler"]:SaveData(player)
end)

game:BindToClose(function()
	for _,player in Players:GetPlayers() do
		Modules["DataHandler"]:SaveData(player)
	end
end)--]]

--// Handles Teleporting
--[[RemoteEvent.OnServerEvent:Connect(function(player, Map)
	if player and Map ~= nil then
		for index, Place in PlaceIDS do
			if Place.Name == Map then
				if Data then
					TeleportService:Teleport(Place.Id,player,Data)
				else
					TeleportService:Teleport(Place.Id,player)
				end
			end
		end
	end
end)--]]
--//
