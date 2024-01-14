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
local PlayButtonConnection = {}

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

function GetPlayerThumbnail(UserId)
	local Thumbnail, IsReady = Players:GetUserThumbnailAsync(UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size352x352)

	if IsReady then
		return Thumbnail
	end
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

						local DisplayBoard = Tables[Table.Name]:FindFirstChild("DisplayBoard")
						local Board_PlayerList = DisplayBoard:FindFirstChild("PlayerList")

						--/When Owners Join first
						if Table_Index[Table.Name] and Table_Index[Table.Name]["Owner"] == "" then
							Table_Index[Table.Name]["Owner"] = seat.Occupant.Parent.Name

							local FindSeat = Board_PlayerList:FindFirstChild(seat.Name)

							if Board_PlayerList and FindSeat then
								FindSeat.Image = GetPlayerThumbnail(Players[Table_Index[Table.Name]["Owner"]].UserId)
								FindSeat.Visible = true
								FindSeat:WaitForChild("Crown").Visible = true
							end

							--/Show Ui
							local PlayerGui = Players:WaitForChild(Table_Index[Table.Name]["Owner"]):WaitForChild("PlayerGui")
							local FindMatchGui = PlayerGui:WaitForChild("ScreenGuis"):WaitForChild("MatchMaking")
							
							if FindMatchGui then
								FindMatchGui.Enabled = true

								--/When Press to Join
								local PlayButton = FindMatchGui:WaitForChild("BookBG"):WaitForChild("PlayButton")
								
								PlayButtonConnection[Table_Index[Table.Name]["Owner"]] = PlayButton.MouseButton1Down:Connect(function()
									FindMatchGui.Enabled = false
									if Table_Index[Table.Name]["Owner"] ~= "" then
										Tables[Table.Name]:WaitForChild("DisplayBoard")["Timer"].Visible = true
									end

									--/Create Courotine that use a repeat function for Timer
									coroutine.resume(coroutine.create(function()
										local Timer = 60
										
										repeat
											DisplayBoard:FindFirstChild("Timer").Text = Timer.."<font size='5'>seconds</font>"
											Timer -= 1
											task.wait(1)
										until Timer == 0 or Table_Index[Table.Name]["Owner"] == ""

										DisplayBoard:FindFirstChild("Timer").Text = Timer.."<font size='5'>seconds</font>"

										--/Check if owner still seated in seat and teleport all 
										if Table_Index[Table.Name]["Owner"] ~= "" then
											local PlayersToTeleport = {}
	
											for _, player in Table_Index[Table.Name]["Seats"] do
												if player ~= "" then
													table.insert(PlayersToTeleport,Players[player])
												end
											end
	
											CreatePrivateServer(nil,PlayersToTeleport)
										end
									end))

									PlayButtonConnection[Table_Index[Table.Name]["Owner"]]:Disconnect()
								end)
							end
						end

						--/When Player Join
						if Table_Index[Table.Name]["Seats"][seat.Name] then
							Table_Index[Table.Name]["Seats"][seat.Name] = seat.Occupant.Parent.Name
						
							local FindSeat = Board_PlayerList:FindFirstChild(seat.Name)

							if Board_PlayerList and FindSeat then
								FindSeat.Image = GetPlayerThumbnail(Players[Table_Index[Table.Name]["Seats"][seat.Name]].UserId)
								FindSeat.Visible = true
							end
						end

					else

						--/Objects
						local DisplayBoard = Tables[Table.Name]:FindFirstChild("DisplayBoard")
						local Board_PlayerList = DisplayBoard:FindFirstChild("PlayerList")
						local Board_Timer = DisplayBoard:FindFirstChild("Timer")

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
									PlayButtonConnection[Table_Index[Table.Name]["Owner"]]:Disconnect()
								end
							end
							
							--/Force Player Jump
							JumpEveryone(Table_Index[Table.Name]["Seats"])

							local FindSeat = Board_PlayerList:FindFirstChild(seat.Name)

							for _, player in Table_Index[Table.Name]["Seats"] do
								if Board_PlayerList and FindSeat then
									FindSeat.Image = ""
									FindSeat.Visible = false
									FindSeat:WaitForChild("Crown").Visible = false
								end
							end

							Board_Timer.Visible = false
							

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

							local FindSeat = Board_PlayerList:FindFirstChild(seat.Name)

							if Board_PlayerList and FindSeat then
								FindSeat.Image = ""
								FindSeat.Visible = false
								FindSeat:WaitForChild("Crown").Visible = false
							end

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

