local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enemies = workspace:WaitForChild("Enemies")
local towers = ReplicatedStorage:WaitForChild("Towers")

-- // Testing tower spawn

function module.SpawnTest(cframe)
    -- // tower settings
    local damage = 10
    local cooldown = 0.5
    local range = 10

    local tower = towers.TestingTower:Clone()
    tower.PrimaryPart.CFrame = cframe
    tower.Parent = workspace.Towers

    -- // Tower attacks the closest enemy to base that's in range every [cooldown] seconds
    while true do
        local closestTarget
        local closestDistance = 10000
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy.PrimaryPart and enemy.NextPos then
                -- // Checking if the tower is in range, and checking which one is the closest to their next waypoint
                if (tower.PrimaryPart.Position - enemy.PrimaryPart.Position).Magnitude < range and (enemy.PrimaryPart.Position - enemy.NextPos.Value).Magnitude < closestDistance then
                    closestDistance = (tower.PrimaryPart.Position - enemy.PrimaryPart.Position).Magnitude
                    closestTarget = enemy
                end
            end
        end
        if closestTarget and closestTarget:FindFirstChild("Humanoid") and closestTarget.PrimaryPart then
            closestTarget.Humanoid.Health -= damage
            tower.PrimaryPart.CFrame = CFrame.lookAt(tower.PrimaryPart.Position, closestTarget.PrimaryPart.Position)
        end
        task.wait(cooldown)
    end
end

return module