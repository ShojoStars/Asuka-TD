local module = {}

local PhysicsService = game:GetService("PhysicsService")
local DebrisService = game:GetService("Debris")

	function module.SpawnRegular(mob, amount, spawnInterval,HealthPoints)
		if not amount then amount = 1 end

		for i = 1, amount, 1 do
		local char = mob:Clone()
		char.Humanoid.MaxHealth = HealthPoints

		--// Removes Dead Chunks from the Map!
		char.Humanoid.Died:Connect(function()
			DebrisService:AddItem(char, 1)
		end)
		--//
		
		char:WaitForChild("HumanoidRootPart").CFrame = workspace.Path.Spawn.CFrame
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("MeshPart") then
				part.CollisionGroup = "Enemies"
			end
		end

		char.Parent = workspace.Enemies
		char.HumanoidRootPart:SetNetworkOwner()
		task.spawn(function()
			for i = 1, #workspace.Path.NormalWaypoints:GetChildren(), 1 do
				for _, waypoint in pairs(workspace.Path.NormalWaypoints:GetChildren()) do
					if waypoint.Waypoint.Value == i and i ~= 1 then
						char:WaitForChild("Humanoid"):MoveTo(waypoint.Position)
						char.NextPos.Value = waypoint.Position
						char.NextWaypoint.Value = i
						char.Humanoid.MoveToFinished:Wait()
					end
				end
			end
		end)
		if spawnInterval then task.wait(spawnInterval) end
	end
	end

return module