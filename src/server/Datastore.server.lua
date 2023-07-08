local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Asuka-Coins-Save")

game.Players.PlayerAdded:Connect(function(player)
    local Stats = Instance.new("Folder")
    Stats.Name = "Stats"
    Stats.Parent = player

    --// Add / Create new values here

    local Coins = Instance.new("IntValue")
    Coins.Name = "Coins"
    Coins.Value = 0
    Coins.Parent = Stats

    --//Load the Coins

    pcall(function(sucess,error)
        if sucess then
            --// Add More if Neccessary
            Coins.Value = DataStore:GetAsync(player.UserId)
        elseif error then
            warn("Error Getting Player Data or Player Has No Data")
        end
    end)

    game.Players.PlayerRemoving:Connect(function()
        ---// Saves Player Data
        pcall(function(sucess,error)
            if sucess then
                DataStore:SetAsync(player.UserId,Coins.Value)
            elseif error then
                warn("Could Not Save Player Data!")
            end
        end)
    end)
end)