local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Event = game.ReplicatedStorage:FindFirstChild("MatchMakingEvent")
local Tables = workspace:WaitForChild("Tables")
local UI = Player.PlayerGui:WaitForChild("MatchMaking")
local Chosen = false

local function ChooseMap()
    for i,v in pairs(UI:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name == "PlayButton" and v.Parent.Parent.Name == "MapButtons" then
            v.MouseButton1Click:Connect(function()
                Event:FireServer(v.Parent.Name)
                Chosen = true
                UI.Enabled = false
            end)
        end
    end
end


Character.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
    if Character.Humanoid.Sit == true then
         for i,v in pairs(Tables:GetDescendants()) do
            if v:IsA("Seat") then
                UI.Enabled = true
                if Chosen == false then
                    ChooseMap()
                    Chosen = true
                    else
                         return
                end
            end
        end
        else
            UI.Enabled = false
    end
end)
