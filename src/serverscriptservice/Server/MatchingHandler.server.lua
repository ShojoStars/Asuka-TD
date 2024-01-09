--//Service
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
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

function CreatePrivateServer(PlaceName,Table)
	local ReservePlace = TeleportService:ReserveServer(14421495807)
	TeleportService:TeleportToPrivateServer(14421495807,ReservePlace,Table)
end

function MatchTable(GetTables)
    for _, Table in Tables:GetChildren() do


		Table_Index[Table.Name] = {
			Owner = "";
			["Seats"] = {
				["Seat1"] = "";
				["Seat2"] = "";
				["Seat3"] = "";
				["Seat4"] = "";
			}
		}

		for _, seat in Table:GetChildren() do
			if seat:IsA("Seat") then
				seat:GetPropertyChangedSignal("Occupant"):Connect(function(...)
					
					--/When Player Seat
					if seat.Occupant ~= nil then

						--/When Owners Join first
						if Table_Index[Table.Name] and Table_Index[Table.Name]["Owner"] == "" then
							Table_Index[Table.Name]["Owner"] = seat.Occupant.Parent.Name

							--/Show Ui
							local PlayerGui = Players:WaitForChild(Table_Index[Table.Name]["Owner"]):WaitForChild("PlayerGui")
							local FindMatchGui = PlayerGui:WaitForChild("ScreenGuis"):WaitForChild("MatchMaking")
							
							if FindMatchGui then
								FindMatchGui.Enabled = true

								--/When Press to Join
								local PlayButton = FindMatchGui:WaitForChild("BookBG"):WaitForChild("PlayButton")
								
								PlayButton.MouseButton1Down:Connect(function()
									print("Teleporting all Players")

									local PlayersToTeleport = {}
									for _, player in Table_Index[Table.Name]["Seats"] do
										if player ~= "" then
											print(_,player)
										table.insert(PlayersToTeleport,Players[player])
										end
									end
									print(PlayersToTeleport)
									CreatePrivateServer(nil,PlayersToTeleport)
								end)
							end
						end

						--/When Player Join
						if Table_Index[Table.Name]["Seats"][seat.Name] then
							Table_Index[Table.Name]["Seats"][seat.Name] = seat.Occupant.Parent.Name
						end

					else

						--/When player leave from seat, check if his name is same of owner Name, if is all players jump from seat
						if Table_Index[Table.Name] and Table_Index[Table.Name]["Seats"][seat.Name] ~= "" and Table_Index[Table.Name]["Seats"][seat.Name] == Table_Index[Table.Name]["Owner"] then
							
							--/Check if find the player in Players
							local FindPlayer = Players:FindFirstChild(Table_Index[Table.Name]["Owner"]) 
							
							if FindPlayer then
								--/Disable Ui
								local PlayerGui = FindPlayer:WaitForChild("PlayerGui")
								local FindMatchGui = PlayerGui:WaitForChild("ScreenGuis"):WaitForChild("MatchMaking")

								if FindMatchGui then
									FindMatchGui.Enabled = false
								end
							end
							--/Force Player Jump
							JumpEveryone(Table_Index[Table.Name]["Seats"])

							--/Reset Table
							Table_Index[Table.Name] = {
								Owner = "";
								["Seats"] = {
									["Seat1"] = "";
									["Seat2"] = "";
									["Seat3"] = "";
									["Seat4"] = "";
								}
							};

							--/if someone leave from chair and is not the owner, remove player from table
						elseif Table_Index[Table.Name] and Table_Index[Table.Name]["Seats"][seat.Name] then
							Table_Index[Table.Name]["Seats"][seat.Name] = "";
						end
					end
				end)
			end
		end
    end
end

--//Code
MatchTable(Tables)

