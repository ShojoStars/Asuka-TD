local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local enemies = workspace:WaitForChild("Enemies")
local Towers = ReplicatedStorage:WaitForChild("Towers")

-- // Testing Tower spawn

function module.SpawnTower(Tower,cframe)
    -- // Tower settings
    local damage = 10
    local cooldown = 0.5
    local range = 10
    Tower = Towers:FindFirstChild(Tower):Clone()
    Tower.PrimaryPart.CFrame = cframe
    Tower.Parent = workspace.Towers
    --// Animation Dependencies
    local Animations = Tower:FindFirstChild("Animations")
    local TowerHumanoid = Tower:FindFirstChild("Humanoid")
    --Handles Collisions

    for i,v in pairs(Tower:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            v.CollisionGroup = "Towers"
        end
    end

    while Tower:WaitForChild("Humanoid").Health > 0 do
        local closestTarget
        local closestDistance = 10000
        local furthestPos = 0
        for _, enemy in pairs(enemies:GetChildren()) do
            if enemy.PrimaryPart and enemy.NextPos then
                -- // Checking if the Tower is in range, and checking which one is the closest to their next waypoint
                if (Tower.PrimaryPart.Position - enemy.PrimaryPart.Position).Magnitude < range and enemy.Humanoid.Health > 0 then
                    if enemy.NextWaypoint.Value >= furthestPos then
                        if enemy.NextWaypoint.Value > furthestPos or (enemy.PrimaryPart.Position - enemy.NextPos.Value).Magnitude < closestDistance then
                            closestDistance = (enemy.PrimaryPart.Position - enemy.NextPos.Value).Magnitude
                            furthestPos = enemy.NextWaypoint.Value
                            closestTarget = enemy
                        end
                    end
                end
            end
        end
        if closestTarget and closestTarget:FindFirstChild("Humanoid") and closestTarget.PrimaryPart then
            local TowerHumanoid = Tower:WaitForChild("Humanoid")
            Tower.PrimaryPart.CFrame = CFrame.lookAt(Tower.PrimaryPart.Position, closestTarget.Head.Position)
            
            local AttackAnimation = TowerHumanoid:LoadAnimation(Animations.Attack)
            AttackAnimation:AdjustSpeed(2)
            AttackAnimation:Play()
            
            AttackAnimation.Stopped:Wait()  -- Wait for the animation to finish
            
            closestTarget.Humanoid.Health -= damage
        end
        task.wait(cooldown)
    end
end

return module