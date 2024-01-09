--//Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

--//Directories
local Remotes_Folder = ReplicatedStorage:WaitForChild("Remotes")

--//Remotes
local Remotes = {
    RemoteEvent = Remotes_Folder:WaitForChild("TeleportEvent")
}

--//Code
Players.PlayerAdded:Connect(function(Player)
    
    --/Check if player have joined on the game
    if Player then

        --/Get Character player, so we wait for character
        local Character = Player.Character or Player.CharacterAdded:Wait()

        --/Get all parts inside of character player and turn collision "Players" tag
        for _,Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") or Part:IsA("MeshPart") then
                Part.CollisionGroup = "Players"
            end
        end
    end
	

    --/When player finish the dungeon and come to lobby, need work on this later

    --[[TeleportService.LocalPlayerArrivedFromTeleport:Connect(function(loadingGui: ScreenGui, PlayerJoinData: table) 
        if PlayerJoinData ~= nil then
           RemoteEvent:FireClient(player,PlayerJoinData) 
        end
    end)--]]


end)