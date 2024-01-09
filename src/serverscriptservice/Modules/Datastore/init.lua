--//Service
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--//Directories
local Remotes_Folder = ReplicatedStorage:WaitForChild("Remotes")
local Modules_Folder = ReplicatedStorage:WaitForChild("Modules")

--//Assigments
local DataName = "Data_"
local DataVersion = "002"

--//Objects
local GameData = DataStoreService:GetDataStore(DataName..DataVersion)
local PlayerData = script:WaitForChild("PlayerData")

--//Local Function
local function CreatePlayerData(Player)
	
	--/Clone and put inside of player in Players
	local NewData = PlayerData:Clone()
	NewData.Parent = Player
	
	--/return function with DataPlayer
	return NewData
end

--//Functions
local self = {}

function self:LoadData(Player,Data)
	
	--/Assigments
	local CurrentData;
	
	--/Create Data
	local PlayerData = CreatePlayerData(Player)
	
	--/Check if got sucess getting current data
	local sucess, fail = pcall(function()
		CurrentData = GameData:GetAsync(Player.UserId)
	end)
	
	--/confirm if have data or no
	if sucess and CurrentData then
		
		for FolderName,Value in CurrentData do
			local FindFolder = PlayerData:FindFirstChild(FolderName)
			if FindFolder and FindFolder:IsA("Folder") then
				for ValueName,Value in Value do
					if typeof(Value) == "boolean" and not FindFolder:FindFirstChild(ValueName) then
						local NewValue = Instance.new("BoolValue")
						NewValue.Name = ValueName
						NewValue.Value = Value
						NewValue.Parent = FindFolder
					elseif typeof(Value) == "boolean" and FindFolder:FindFirstChild(ValueName) then

						local BoolVal = FindFolder:FindFirstChild(ValueName)
						BoolVal.Value = Value
					end
				end
			elseif FindFolder and FindFolder:IsA("NumberValue") and CurrentData[FolderName] then
				FindFolder.Value = CurrentData[FolderName]
			end
		end
		
		--/Return data
		return CurrentData
	else
		return warn("New Player, creating new datastore")
	end
end

function self:SaveData(Player)
	
	local Data = {}
	
	for DataNumber,DataName in Player:WaitForChild("PlayerData"):GetChildren() do
		if not Data[DataName.Name] then
			
			Data[DataName.Name] = {}

			if DataName:IsA("Folder") and #DataName:GetChildren() > 0 then
				for DataValueNumber,DataValue in DataName:GetChildren() do
					Data[DataName.Name][DataValue.Name] = DataValue.Value
				end
			elseif not DataName:IsA("Folder") then
				Data[DataName.Name] = DataName.Value
			end
		end
	end
	
	if Data then
		print(Data)
		--/Check if got sucess getting current data
		local sucess, fail = pcall(function()
			return GameData:SetAsync(Player.UserId,Data)
		end)

		if sucess then
			return warn("Data saved with sucess")
		else
			return error("Failed to save data player ("..fail..")")
		end
	end
end

function self:CheckData(Player,Data)
	
end

return self
