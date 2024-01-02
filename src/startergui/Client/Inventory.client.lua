--//Service
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--//Directories
local Remotes_Folder = ReplicatedStorage:WaitForChild("Remotes")
local Modules_Folder = ReplicatedStorage:WaitForChild("Modules")
local Towers_Folder = ReplicatedStorage:WaitForChild("Towers")
local Assets_Folder = ReplicatedStorage:WaitForChild("Assets")

--//Modules
local Modules = {
	TowerDetail = require(Modules_Folder:WaitForChild("TowerDetailHandler"));
};

--//Remotes
local Remotes = {
	InventoryEvent = Remotes_Folder:WaitForChild("InventoryEvent");
	MatchMarkingEvent = Remotes_Folder:WaitForChild("MatchMakingEvent");
};

--//Objects
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerData = LocalPlayer:WaitForChild("PlayerData")
local Towers_PlayerData = PlayerData:WaitForChild("Towers")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TemplateTower = Assets_Folder:WaitForChild("Frames"):WaitForChild("InventoryButton")

local ScreenGuis_Folder = PlayerGui:WaitForChild("ScreenGuis")
local ScreenGui = ScreenGuis_Folder:WaitForChild("Inventory")
local MainBoard = ScreenGui:WaitForChild("MainBoard")
local ListTower = MainBoard:WaitForChild("List")

local TowerDetail = MainBoard:WaitForChild("TowerDetail")
local Equip_TowerDetail = TowerDetail:WaitForChild("Equip")
local Description_TowerDetail = TowerDetail:WaitForChild("Description")
local TowerName_TowerDetail = TowerDetail:WaitForChild("TowerName")

--//Assigments
local ButtonsImages = {
	ButtonEquiped = "rbxassetid://14452535990"; 
	ButtonUnquiped = "rbxassetid://14171553444";
}

local CoolDown = false

--//Functions

--/Create TweenAnimation
function CreateTween(Object,Time,Style,Direction,Repeats,CanBack,DelayTime,EndObject)
	return TweenService:Create(Object,TweenInfo.new(Time,Style,Direction,Repeats,CanBack,DelayTime),EndObject)
end

--/Create Model and Camera and put inside of viewportframe
function CreateViewModel(ModelName,Parent)
	
	--/Check if find Tower name inside of folder "Tower"
	if Towers_Folder:FindFirstChild(ModelName) then
		
		--/Create Model
		local NewModel = Towers_Folder:WaitForChild(ModelName):Clone()
		NewModel.Parent = Parent:WaitForChild("WorldModel")

		--/Create NewCamera
		local NewCamera = Instance.new("Camera")
		NewCamera.CFrame = CFrame.new(0,0,0)
		NewCamera.Parent = Parent
		
		--/Set CurrentCamera of ViewPortFrame
		Parent.CurrentCamera = NewCamera
		
		--/Set Correct Position
		NewModel:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,0,-6),Vector3.new(0,0,0)))
		
		--/Do Rotation Smooth
		CreateTween(NewModel.PrimaryPart,2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,true,1,{CFrame = CFrame.new(Vector3.new(0,0,-6),Vector3.new(360,0,0))}):Play()
	end
end

--//Code

--/Wait for remote from server to client.
Remotes["InventoryEvent"].OnClientEvent:Connect(function(DataFromServer)
	
	--/Confirm if he receive data from server
	if DataFromServer and typeof(DataFromServer) == "table" then
		
		--/extract all inf inside of table
		for Tower,Value in DataFromServer["Towers"] do
			
			--/create the template and put inside of List
			local NewTemplate = TemplateTower:Clone()
			NewTemplate.Parent = ListTower
			NewTemplate.Name = Tower
			
			--/Call function to create effect camera
			CreateViewModel(Tower,NewTemplate:WaitForChild("ViewportFrame"))
			
			--/When press the button then show detail in TowerDetail Frame
			NewTemplate.MouseButton1Down:Connect(function()
				
				--/check if find any model inside of TowerDetail
				local FindModel = TowerDetail:WaitForChild("ViewportFrame"):WaitForChild("WorldModel"):FindFirstChildOfClass("Model")
				
				if FindModel then
					FindModel:Destroy()
				end
				
				--/Create New viewer for tower detail
				CreateViewModel(Tower,TowerDetail:WaitForChild("ViewportFrame"))
				
				--/Configure Information of TowerDetail
				if Modules["TowerDetail"][Tower] then
					
					--/Update Information
					PlayerData = LocalPlayer:WaitForChild("PlayerData")
					Towers_PlayerData = PlayerData:WaitForChild("Towers")
					
					--/Check if find his boolvalue inside of tower folder in PlayerData
					local TowerValue = Towers_PlayerData:FindFirstChild(Tower)
					
					--/confirm if have true or false value and change image by value
					if TowerValue and TowerValue.Value then
						Equip_TowerDetail.Image = ButtonsImages["ButtonUnquiped"]
					elseif TowerValue and not TowerValue.Value then
						Equip_TowerDetail.Image = ButtonsImages["ButtonEquiped"]
					end
					
					--/set texts
					TowerName_TowerDetail.Text = Tower
					Description_TowerDetail.Text = Modules["TowerDetail"][Tower].Description
				end
			end)
		end
	end
end)

--//When Press ButtonEquip
Equip_TowerDetail.MouseButton1Down:Connect(function()
	if Towers_PlayerData:FindFirstChild(TowerName_TowerDetail.Text) then
		Remotes["InventoryEvent"]:FireServer("Equip",TowerName_TowerDetail.Text)
		
		--/Update Information
		PlayerData = LocalPlayer:WaitForChild("PlayerData")
		Towers_PlayerData = PlayerData:WaitForChild("Towers")
		
		--/Check if find his boolvalue inside of tower folder in PlayerData
		local TowerValue = Towers_PlayerData:FindFirstChild(TowerName_TowerDetail.Text)
		
		--/Update ButtonImage
		if TowerValue and TowerValue.Value then
			Equip_TowerDetail.Image = ButtonsImages["ButtonEquiped"]
		elseif TowerValue and not TowerValue.Value then
			Equip_TowerDetail.Image = ButtonsImages["ButtonUnquiped"]
		end
	end
end)


--//Handles the Opening and Closing of the Players Inventory
UserInputService.InputBegan:Connect(function(Key, Event)
	if Event then return end
	
	--/Check key
	if Key.KeyCode == Enum.KeyCode.Z and not ScreenGui.Enabled and not CoolDown then
		
		--/Changing Values
		CoolDown = true
		ScreenGui.Enabled = true
		
		--/Tween Animation
		CreateTween(MainBoard,0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out,0,false,0,{Size = UDim2.new(0.502, 0,0.599, 0)}):Play()
		
		--/Wait X Time for release cooldown
		task.delay(0.29,function()
			CoolDown = false
		end)
		
	elseif Key.KeyCode == Enum.KeyCode.Z and ScreenGui.Enabled then
		
		--/Changing Values
		CoolDown = true
		ScreenGui.Enabled = true
		
		--/Tween Animation
		CreateTween(MainBoard,0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In,0,false,0,{Size = UDim2.new(0.1, 0,0.599, 0)}):Play()
		
		--/Wait X Time for release cooldown
		task.delay(0.25,function()
			ScreenGui.Enabled = false
			CoolDown = false
		end)
	end
end)
