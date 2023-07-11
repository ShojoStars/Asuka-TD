task.wait(5)

local RS = game:GetService("ReplicatedStorage")

local enemies = RS:WaitForChild("Enemies")
local modules = RS:WaitForChild("Shared")

local spawnModule = require(modules:WaitForChild("EnemySpawn"))
local towerModule = require(modules:WaitForChild("Towers"))

spawnModule.SpawnRegular(enemies:WaitForChild("TestingDummy"), 10, 0.5)
towerModule.SpawnTest(CFrame.new(Vector3.new(876.924, 1.541, 7.049), Vector3.new(0, 0, 0)))