local RPS = game:GetService("ReplicatedStorage")
local RewardsHandler = require(RPS.module.RewardsHandler)
local EnemySpawnModule = require(RPS.EnemySpawnModule)

local Rewards = {
	Normal = 150,
	Corruption = 250,
	Nightmare = 500,
	AllStar = 800,
}

local waves = {
    {waveNumber = 1, enemies = {{enemyType = "Zakena", quantity = 5}}, totalHP = 25},
    {waveNumber = 2, enemies = {{enemyType = "Zakena", quantity = 6}}, totalHP = 30},
    {waveNumber = 3, enemies = {{enemyType = "Zakena", quantity = 8}}, totalHP = 40},
    {waveNumber = 4, enemies = {{enemyType = "Fast Zakena", quantity = 5}}, totalHP = 40},
    {waveNumber = 5, enemies = {{enemyType = "Fast Zakena", quantity = 6}}, totalHP = 55},
    {waveNumber = 6, enemies = {{enemyType = "Fast Zakena", quantity = 3}, {enemyType = "Buffed Zakena", quantity = 3}}, totalHP = 105},
    {waveNumber = 7, enemies = {{enemyType = "Buffed Zakena", quantity = 5}, {enemyType = "Zakena", quantity = 4}}, totalHP = 170},
    {waveNumber = 8, enemies = {
        {enemyType = "Uzaina", quantity = 4},
        {enemyType = "Zakena", quantity = 4},
        {enemyType = "Buffed Zakena", quantity = 4},
        {enemyType = "Fast Zakena", quantity = 3}
    }, totalHP = 235},
    {waveNumber = 9, enemies = {{enemyType = "Uzaina", quantity = 6}, {enemyType = "Circada", quantity = 1}}, totalHP = 200},
    {waveNumber = 10, enemies = {{enemyType = "Uzaina", quantity = 7}, {enemyType = "Circada", quantity = 1}}, totalHP = 220},
    {waveNumber = 11, enemies = {{enemyType = "Fast Zakena", quantity = 4}, {enemyType = "Circada", quantity = 4}}, totalHP = 320},
    {waveNumber = 12, enemies = {{enemyType = "Uzaina", quantity = 10}, {enemyType = "Circada", quantity = 3}}, totalHP = 440},
    {waveNumber = 13, enemies = {{enemyType = "Uzaina", quantity = 10}, {enemyType = "Circada", quantity = 4}}, totalHP = 520},
    {waveNumber = 14, enemies = {{enemyType = "Kowaina", quantity = 3}, {enemyType = "Circada", quantity = 3}, {enemyType = "Uzaina", quantity = 5}}, totalHP = 490},
    {waveNumber = 15, enemies = {{enemyType = "Hoshina", quantity = 5}, {enemyType = "Kowaina", quantity = 3}}, totalHP = 600},
    {waveNumber = 16, enemies = {{enemyType = "Hoshina", quantity = 6}, {enemyType = "Kowaina", quantity = 3}}, totalHP = 700},
    {waveNumber = 17, enemies = {{enemyType = "Bench Kowaina", quantity = 4}}, totalHP = 800},
    {waveNumber = 18, enemies = {{enemyType = "Kowaina", quantity = 3}, {enemyType = "Bench Kowaina", quantity = 5}}, totalHP = 1150},
    {waveNumber = 19, enemies = {{enemyType = "Bus Zakena", quantity = 1}}, totalHP = 550},
    {waveNumber = 20, enemies = {{enemyType = "Bus Zakena", quantity = 2}}, totalHP = 3600},
    {waveNumber = 21, enemies = {{enemyType = "Bench Kowaina", quantity = 2}, {enemyType = "Bus Zakena", quantity = 2}}, totalHP = 1500},
    {waveNumber = 22, enemies = {{enemyType = "Bench Kowaina", quantity = 5}, {enemyType = "Bus Zakena", quantity = 2}}, totalHP = 2100},
    {waveNumber = 23, enemies = {{enemyType = "PlaceHolder A", quantity = 5}}, totalHP = 500},
    {waveNumber = 24, enemies = {{enemyType = "PlaceHolder A", quantity = 3}, {enemyType = "PlaceHolder B", quantity = 5}}, totalHP = 2050},
    {waveNumber = 25, enemies = {{enemyType = "PlaceHolder B", quantity = 8}, {enemyType = "Bus Zakena", quantity = 3}}, totalHP = 4450},
    {waveNumber = 26, enemies = {{enemyType = "PlaceHolder B", quantity = 9}, {enemyType = "PlaceA", quantity = 5}, {enemyType = "Bus Zakena", quantity = 2}}, totalHP = 4750},
    {waveNumber = 27, enemies = {{enemyType = "Bus Zakena", quantity = 5}, {enemyType = "Circada", quantity = 10}}, totalHP = 3550},
    {waveNumber = 28, enemies = {{enemyType = "PlaceHolder C", quantity = 1}}, totalHP = 3000},
    {waveNumber = 29, enemies = {{enemyType = "PlaceHolder C", quantity = 2}, {enemyType = "PlaceA", quantity = 3}}, totalHP = 6300},
    {waveNumber = 30, enemies = {{enemyType = "Boss2", quantity = 1}, {enemyType = "PlaceHolder B", quantity = 4}}, totalHP = 11400},
    {waveNumber = 31, enemies = {{enemyType = "PlaceHold C", quantity = 3}, {enemyType = "PlaceHold B", quantity = 2}, {enemyType = "PlaceHold A", quantity = 5}}, totalHP = 10200},
    {waveNumber = 32, enemies = {{enemyType = "PlaceHold D", quantity = 6}}, totalHP = 2400},
    {waveNumber = 33, enemies = {{enemyType = "PlaceHold D", quantity = 10}}, totalHP = 4000},
    {waveNumber = 34, enemies = {{enemyType = "PlaceHold E", quantity = 4}, {enemyType = "PlaceHold D", quantity = 6}}, totalHP = 5400},
    {waveNumber = 35, enemies = {{enemyType = "PlaceHold E", quantity = 5}, {enemyType = "PlaceHold D", quantity = 4}, {enemyType = "PlaceHold A", quantity = 10}}, totalHP = 6350},
    {waveNumber = 36, enemies = {{enemyType = "PlaceHold E", quantity = 10}, {enemyType = "PlaceHold D", quantity = 10}, {enemyType = "PlaceHold A", quantity = 5}}, totalHP = 12000},
    {waveNumber = 37, enemies = {{enemyType = "PlaceHold F", quantity = 5}, {enemyType = "PlaceHold D", quantity = 5}}, totalHP = 3000},
    {waveNumber = 38, enemies = {{enemyType = "PlaceHold F", quantity = 3}, {enemyType = "PlaceHold E", quantity = 5}}, totalHP = 4350},
    {waveNumber = 39, enemies = {{enemyType = "PlaceHold F", quantity = 4}, {enemyType = "PlaceHold E", quantity = 10}, {enemyType = "PlaceHold D", quantity = 10}, {enemyType = "Boss2", quantity = 1}}, totalHP = 22300},
    {waveNumber = 40, enemies = {{enemyType = "FinalBoss", quantity = 1}}, totalHP = 55000},
}

-- Fetch necessary objects and elements
local EnemiesFolder = RPS:WaitForChild("Enemies")
local path = workspace:WaitForChild("Path")
local base = path:WaitForChild("Base")


-- Function to spawn enemies based on wave data
local function spawnWave(waveData)
    if waveData then
        for _, enemyData in ipairs(waveData.enemies) do
            for i = 1, enemyData.quantity do
                -- Spawn the enemy based on the "enemyType"
                local enemy = EnemiesFolder:FindFirstChild(enemyData.enemyType)
                if enemy then
                    -- Spawn enemy using enemy object
                    EnemySpawnModule.SpawnRegular(enemy,waveData.quantity,1,waveData.totalHP)
                    -- Set enemy properties, e.g., position, AI behavior, etc. ( within the module )
                end
            end
        end
    else
        print("Wave data not found!")
    end
end
-- Function to start the wave

local function StartWaves()
	-- Example: Spawning all 40 waves
	for _, waveData in ipairs(waves) do
		spawnWave(waveData)
		task.wait(10) -- Wait 10 seconds before spawning the next wave (adjust as needed)
	end
end

StartWaves()