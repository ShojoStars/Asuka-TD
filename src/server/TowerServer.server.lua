--//Handles Tower Spawning on the Server.

local Event = game.ReplicatedStorage.Variables.TowerEvent
local TowersModule = require(script.Towers)
Event.OnServerEvent:Connect(function(Player,Tower,Position)
    if Tower then
        TowersModule.SpawnTower(Tower,Position)
    end
end)