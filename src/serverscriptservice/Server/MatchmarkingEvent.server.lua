--//Service
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

--//Objects
local Tables = Workspace:WaitForChild("Tables")

local Table_Index = {}

--//Functions
function JumpEveryone(PlayersTable)
	for SeatNumber, Getplayer in PlayersTable do
		if Players:FindFirstChild(Getplayer) then
			local Character = Players:WaitForChild(Getplayer).Character
			local Humanoid = Character:WaitForChild("Humanoid")

			Humanoid.Jump = true
		end
	end
end

function MatchTable(GetTables)
    for _, table in Tables:GetChildren() do


		Table_Index[table.Name] = {
			Owner = "";
			["Seats"] = {
				["Seat1"] = "";
				["Seat2"] = "";
				["Seat3"] = "";
				["Seat4"] = "";
			}
		}

		for _, seat in table:GetChildren() do
			if seat:IsA("Seat") then
				seat:GetPropertyChangedSignal("Occupant"):Connect(function(...)
					
					--/When Player Seat
					if seat.Occupant ~= nil then

						--/When Owners Join first
						if Table_Index[table.Name] and Table_Index[table.Name]["Owner"] == "" then
							Table_Index[table.Name]["Owner"] = seat.Occupant.Parent.Name

							--/Show Ui
							local PlayerGui = Players:WaitForChild(Table_Index[table.Name]["Owner"]):WaitForChild("PlayerGui")
							local FindMatchGui = PlayerGui:WaitForChild("ScreenGuis"):WaitForChild("MatchMaking")
							
							if FindMatchGui then
								FindMatchGui.Enabled = true
							end
						end

						--/When Player Join
						if Table_Index[table.Name]["Seats"][seat.Name] then
							Table_Index[table.Name]["Seats"][seat.Name] = seat.Occupant.Parent.Name
						end

					else

						--/When player leave from seat, check if his name is same of owner Name, if is all players jump from seat
						if Table_Index[table.Name] and Table_Index[table.Name]["Seats"][seat.Name] ~= "" and Table_Index[table.Name]["Seats"][seat.Name] == Table_Index[table.Name]["Owner"] then
							print("Owner Leaves")
							
							--/Disable Ui
							local PlayerGui = Players:WaitForChild(Table_Index[table.Name]["Owner"]):WaitForChild("PlayerGui")
							local FindMatchGui = PlayerGui:WaitForChild("ScreenGuis"):WaitForChild("MatchMaking")
							
							if FindMatchGui then
								FindMatchGui.Enabled = false
							end
							
							--/Force Player Jump
							JumpEveryone(Table_Index[table.Name]["Seats"])

							--/Reset Table
							Table_Index[table.Name] = {
								Owner = "";
								["Seats"] = {
									["Seat1"] = "";
									["Seat2"] = "";
									["Seat3"] = "";
									["Seat4"] = "";
								}
							};

						elseif Table_Index[table.Name] and Table_Index[table.Name]["Seats"][seat.Name] then
							Table_Index[table.Name]["Seats"][seat.Name] = "";
							print("Player"..Table_Index[table.Name]["Seats"][seat.Name].." Leave from party!")
						end

						print("Player Leaves")
					end
				end)
			end
		end
    end
end

--//Code
MatchTable(Tables)

--[[local Datastore = DataStoreService:GetDataStore("PlayersOwnedTowers")
game.Players.PlayerAdded:Connect(function(player)
	Data = Datastore:GetAsync(player.UserId)
	if Data then
		GameData.OwnedTowers = Data
		RemoteEvent:FireClient(player, Data)
	else
		--// Attempt to Create Data
		warn("First Time Player Attempting to Create Data")
		table.insert(Towers, { "Cure Black", "Cure White" })
		Datastore:SetAsync(player.UserId, Towers)
		Data = Datastore:GetAsync(player.UserId)
		GameData.OwnedTowers = Data
		RemoteEvent:FireClient(player, Data)
	end
end)
--//

--// Handles Teleporting
RemoteEvent.OnServerEvent:Connect(function(player, Map)
	if player and Map ~= nil then
		for index, Place in PlaceIDS do
			if Place.Name == Map then
				if Data then
					TeleportService:Teleport(Place.Id,player,Data)
					else
						TeleportService:Teleport(Place.Id,player)
				end
			end
		end
	end
end)


--]]
