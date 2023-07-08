local module = {}

function module.SpawnRegular(mob, amount, spawnInterval)
    if not amount then amount = 1 end

    for i = 1, amount, 1 do
        local char = mob:Clone()
        char:WaitForChild("HumanoidRootPart").CFrame = workspace.Path.NormalWaypoints.First.CFrame
        char.Parent = workspace.Enemies
        task.spawn(function()
            for i = 1, #workspace.Path.NormalWaypoints:GetChildren(), 1 do
                for _, waypoint in pairs(workspace.Path.NormalWaypoints:GetChildren()) do
                    if waypoint.Waypoint.Value == i and i ~= 1 then
                        char:WaitForChild("Humanoid"):MoveTo(waypoint.Position)
                        char.Humanoid.MoveToFinished:Wait()
                    end
                end
            end
        end)
        if spawnInterval then task.wait(spawnInterval) end
    end
end

return module