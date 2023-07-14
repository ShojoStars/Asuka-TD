local RPS = game:GetService("ReplicatedStorage")
local RewardsHandler = require(RPS.module.RewardsHandler)
local EnemySpawnModule = require(RPS.EnemySpawnModule)

local Rewards = {
	Normal = 150,
	Corruption = 250,
	Nightmare = 500,
	AllStar = 800,
}

local Waves = {
	Normal = {
		WaveCount = 40,
		Reward = Rewards.Normal,
		Enemies = {
			"Zakena",
			"Zakena Fast",
			"Zakena Tank",
			"Zakena Big",
			"Zakena Boss",
		},
	},
}

-- Fetch necessary objects and elements
local EnemiesFolder = RPS:WaitForChild("Enemies")
local path = workspace:WaitForChild("Path")
local base = path:WaitForChild("Base")

-- Function to start the wave
local function StartWave(waveType)
	local wave = 1 -- Initialize the wave counter

	while wave <= waveType.WaveCount and base.Health.Value > 0 do
		for i, enemyName in ipairs(waveType.Enemies) do
			-- Find the enemy by name in the EnemiesFolder
			local enemy = EnemiesFolder:FindFirstChild(enemyName, true)
			if enemy then
				-- Spawn the enemy using the EnemySpawnModule
				EnemySpawnModule.SpawnRegular(enemy, 5, 1)
			else
				warn("Enemy not found:", enemyName)
			end
		end

		wave = wave + 1 -- Increment the wave counter
	end

	if base.Health.Value == 0 then
		warn("Game Failed")
	else
		warn("You Beat the Mode!")
	end
end

-- Start the wave for the "Normal" wave type
StartWave(Waves.Normal)
