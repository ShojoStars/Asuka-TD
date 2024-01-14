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
local Currency_PlayerData = PlayerData:WaitForChild("Currency")
local Towers_PlayerData = PlayerData:WaitForChild("Towers")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--/Hud Stuff
local ScreenGuis_Folder = PlayerGui:WaitForChild("ScreenGuis")
local ScreenGui_Hud = ScreenGuis_Folder:WaitForChild("HUD")
local Frames_Hud = ScreenGui_Hud:WaitForChild("Frames")
local Yen_Hud = Frames_Hud:WaitForChild("Yen")
local Loadout_Hud = ScreenGui_Hud:WaitForChild("Loadout")
local Hotbar_Loadout = Loadout_Hud:WaitForChild("Hotbar")

--//Functions

--/Create TweenAnimation
function CreateTween(Object,Time,Style,Direction,Repeats,CanBack,DelayTime,EndObject)
	return TweenService:Create(Object,TweenInfo.new(Time,Style,Direction,Repeats,CanBack,DelayTime),EndObject)
end

function AbreviateNumber(Number)
    Number = tostring(Number)
    Number = Number:reverse()
    Number = Number:gsub("%d%d%d","%1 ")
    Number = Number:reverse()
    Number = Number:gsub("^ ","")
    return Number
end

function CreateViewModel(ModelName,Parent)
	
	--/Check if find Tower name inside of folder "Tower"
	if Towers_Folder:FindFirstChild(ModelName) and Parent:IsA("ViewportFrame") then
		
		--/Create Model
		local NewModel = Towers_Folder:WaitForChild(ModelName):Clone()
		NewModel.Parent = Parent:WaitForChild("WorldModel")
        NewModel.Name = ModelName

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

        return NewModel
	end
end

--//Code

--/When equip and unequip tower character
for Number, tower in Towers_PlayerData:GetChildren() do
    if tower:IsA("BoolValue") then
       
        --/Assigment
        local AlreadyEquiped = false
       
        --/Load him tower characters
        for _,frame in Hotbar_Loadout:GetChildren() do
            if frame:IsA("Frame") then
                
                local FindViewportFrame = frame:FindFirstChildOfClass("ViewportFrame")
                local FindWorldModel = FindViewportFrame:FindFirstChildOfClass("WorldModel")

                if FindViewportFrame and FindWorldModel and not FindWorldModel:FindFirstChild(tower.Name) and tower.Value then
                  
                    local FindViewportFrame = frame:FindFirstChildOfClass("ViewportFrame")
                   
                    if FindViewportFrame and not FindWorldModel:FindFirstChildOfClass("Model") and not AlreadyEquiped then
                        CreateViewModel(tower.Name,FindViewportFrame)
                        AlreadyEquiped = true
                    end
                end 
            end
        end
       
        --/update bar when unequip and equip tower characters
        tower.Changed:Connect(function()

            local AlreadyEquipedVal = false

            for _,frame in Hotbar_Loadout:GetChildren() do
                if frame:IsA("Frame") then
                  
                    local FindViewportFrame = frame:FindFirstChildOfClass("ViewportFrame")
                    local FindWorldModel = FindViewportFrame:FindFirstChildOfClass("WorldModel")

                    if FindViewportFrame and FindWorldModel and FindWorldModel:FindFirstChild(tower.Name) and not tower.Value then
                       
                        FindWorldModel:FindFirstChildOfClass("Model"):Destroy()
                        FindWorldModel.Parent:FindFirstChildOfClass("Camera"):Destroy()
                        break

                    elseif FindViewportFrame and FindWorldModel and not FindWorldModel:FindFirstChild(tower.Name) and tower.Value then
                        
                        local FindViewportFrame = frame:FindFirstChildOfClass("ViewportFrame")
                       
                        if FindViewportFrame and not FindWorldModel:FindFirstChildOfClass("Model") and not AlreadyEquipedVal then
                            CreateViewModel(tower.Name,FindViewportFrame)
                            AlreadyEquipedVal = true
                        end
                    end 
                end
            end
        end)
    end
end

--/Buttons HUD
for _, Imagelabel in Frames_Hud:GetChildren() do
	if Imagelabel:IsA("ImageLabel") then

		local FindButton = Imagelabel:FindFirstChildOfClass("ImageButton")
		
		if FindButton then
			--/Mouse Over
			FindButton.MouseEnter:Connect(function()
				CreateTween(FindButton,0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0,{Rotation = math.random(-20,20)}):Play()
			end)

			FindButton.MouseLeave:Connect(function()
				CreateTween(FindButton,0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0,{Rotation = 0}):Play()
			end)
		end
	end
end

--/Curreny Effect
local NewNumberValue = Instance.new("NumberValue")
NewNumberValue.Value = 0

Yen_Hud:WaitForChild("Amount").Text = NewNumberValue.Value

Currency_PlayerData.Changed:Connect(function() CreateTween(NewNumberValue,0.6,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0,{Value = Currency_PlayerData.Value}):Play() end)
NewNumberValue.Changed:Connect(function() Yen_Hud:WaitForChild("Amount").Text = AbreviateNumber(math.floor(NewNumberValue.Value)) end)


