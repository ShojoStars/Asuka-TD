task.wait(5)

local RS = game:GetService("ReplicatedStorage")

local enemies = RS:WaitForChild("Enemies")
local modules = RS:WaitForChild("Shared")

local spawnModule = require(modules:WaitForChild("EnemySpawn"))
local towerModule = require(modules:WaitForChild("Towers"))

spawnModule.SpawnRegular(enemies:WaitForChild("TestingDummy"), 10, 0.5)
towerModule.SpawnTest(654.278, -1.127, -55.85, 0, 170, 0)