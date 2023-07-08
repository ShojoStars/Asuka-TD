local path = workspace:WaitForChild("Path")
local base = path:WaitForChild("Base")

local hits = {}

base.Touched:Connect(function(hit)
    if hit.Parent:FindFirstChild("Humanoid") and not game:GetService("Players"):GetPlayerFromCharacter(hit.Parent) then
        if not table.find(hits, hit.Parent) then
            table.insert(hits, hit.Parent)
            base.Health.Value -= hit.Parent.Humanoid.Health
            if base.Health.Value < 0 then base.Health.Value = 0 end
            hit.Parent:Destroy()
        end
    end
end)