local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("Asuka-Yen-Save")

game.Players.PlayerAdded:Connect(function(player)
    local Stats = Instance.new("Folder")
    Stats.Name = "Stats"
    Stats.Parent = player

    --// Add / Create new values here

    local Yen = Instance.new("IntValue")
    Yen.Name = "Yen"
    Yen.Value = 0
    Yen.Parent = Stats

    --// Currency Used for Tower Spawning Must always be set at 0
    local Coins = Instance.new("IntValue")
    Coins.Name = "Coins"
    Coins.Value = 0
    Coins.Parent = Stats
    --//Load the Yen
    pcall(function(sucess,error)
        if sucess then
            --// Add More if Neccessary
            Yen.Value = DataStore:GetAsync(player.UserId)
        elseif error then
            warn("Error Getting Player Data or Player Has No Data")
        end
    end)
    game.Players.PlayerRemoving:Connect(function()
        ---// Saves Player Data
        pcall(function(sucess,error)
            if sucess then
                DataStore:SetAsync(player.UserId,Yen.Value)
            elseif error then
                warn("Could Not Save Player Data!")
            end
        end)
    end)
end)