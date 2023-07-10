--/// Following Module Handles the Distribution of Rewards to Players

local RewardsHandler = {}

--// Add Coins to Specified user/users
function RewardsHandler.AddCoins(Player: Player,Amount: NumberValue) --// Types are Good to help other Programmers Understand your Code.
    if Player and Amount ~= nil then
        local CoinsValue = Player.Stats.Coins
        CoinsValue.Value = CoinsValue.Value + Amount
    end
end

--// Room to add more Rewards-Based Functions
return RewardsHandler