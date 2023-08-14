local TeleportService = game:GetService("TeleportService")
--// Initial Game Setup

local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Parent = game.ReplicatedStorage
RemoteEvent.Name = "MatchMakingEvent"

local PlaceIDS = 
{
    Apartment = {Id = 14421495807,Name = "Nagis Apartment"},
}

--//

RemoteEvent.OnServerEvent:Connect(function(player,Map)
    if player and Map ~= nil then
        for index, Place in PlaceIDS do
            if Place.Name == Map then
                TeleportService:Teleport(Place.Id,player)
            end
        end
    end
end)