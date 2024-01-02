--// Initial Game Setup
local DataStoreService = game:GetService("DataStoreService")
local TeleportService = game:GetService("TeleportService")
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Parent = game.ReplicatedStorage.Variables
RemoteEvent.Name = "MatchMakingEvent"
local Data

local PlaceIDS = {
	Apartment = { Id = 14421495807, Name = "Nagis Apartment" },
}

local GameData = {
	EquippedTowers = {"Cure Black","Cure White"},
	OwnedTowers = {},
	MaxTowers = 8,
	Yen = nil,
}

local Towers = {}
--//


--// Few things for the Inventory
script.Enabled = false
--[[local Datastore = DataStoreService:GetDataStore("PlayersOwnedTowers")
game.Players.PlayerAdded:Connect(function(player)
	Data = Datastore:GetAsync(player.UserId)
	if Data then
		GameData.OwnedTowers = Data
		RemoteEvent:FireClient(player, Data)
	else
		--// Attempt to Create Data
		warn("First Time Player Attempting to Create Data")
		table.insert(Towers, { "Cure Black", "Cure White" })
		Datastore:SetAsync(player.UserId, Towers)
		Data = Datastore:GetAsync(player.UserId)
		GameData.OwnedTowers = Data
		RemoteEvent:FireClient(player, Data)
	end
end)
--//

--// Handles Teleporting
RemoteEvent.OnServerEvent:Connect(function(player, Map)
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
end)


--]]
