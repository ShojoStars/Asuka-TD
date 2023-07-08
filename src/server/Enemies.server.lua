wait(5)

local RS = game:GetService("ReplicatedStorage")

local enemies = RS:WaitForChild("Enemies")
local modules = RS:WaitForChild("Shared")

local spawnModule = require(modules:WaitForChild("EnemySpawn"))

spawnModule.SpawnRegular(enemies:WaitForChild("TestingDummy"), 3, 5)