--// Adds Players to Said Collision Groups

game.Players.PlayerAdded:Connect(function(player)
    if player then
        local Character = player.Character or player.CharacterAdded:Wait()
        for i,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                v.CollisionGroup = "Players" --// Handles the Changing of Collision Groups
            end
        end
    end
end)

--// Adds Players to Collision Group ("Players")