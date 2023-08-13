local RunService = game:GetService("RunService")
--// Dependencies for the Client
local Player = game.Players.LocalPlayer
local Char = Player.Character
PlayerGui = Player:WaitForChild("PlayerGui")
local Toolbar = PlayerGui:WaitForChild("Toolbar")
WaveText = PlayerGui:WaitForChild("Toolbar").Stroke
local RPS = game.ReplicatedStorage
local Variables = RPS.Variables
local TowerEvent = Variables.TowerEvent
local ViewportModel =  require(RPS.Shared:WaitForChild("Viewports"))
local Enemies = RPS.Enemies
local Towers = RPS.Towers
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
PlaceHolderTower = nil
CanPlace = false
Rotation = 0
--//

--// Gets Mouse Raycasts
local function MouseRaycast(Blacklist)
	local MousePosition = UserInputService:GetMouseLocation()
	local mouseRay = Camera:ViewportPointToRay(MousePosition.X,MousePosition.Y)
	local RaycastParams = RaycastParams.new()

	RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	RaycastParams.FilterDescendantsInstances = Blacklist
	local RaycastResult = Workspace:Raycast(mouseRay.Origin,mouseRay.Direction * 1000, RaycastParams)
	return RaycastResult
end

--// Handles Tower Placements
local function PlaceTower(Tower)
	if Tower then
		Tower = Tower:Clone()
		Tower.Parent = workspace.Towers
		PlaceHolderTower = Tower
		for i,v in pairs(PlaceHolderTower:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				v.CollisionGroup = "Enemies"
				v.Material = Enum.Material.ForceField
			end
		end
	end
end

local function ColorTower(Color)
	for i, v in pairs(PlaceHolderTower:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.Color = Color
		end
	end
end

--// Handles Tower Viewports
local function SetupViewPorts(ViewportFrame)
	for index, model in pairs(Towers:GetChildren()) do
		model = model:Clone()
		ViewportFrame.Parent.Name = model.Name
		local camera = Instance.new("Camera")
		camera.FieldOfView = 60
		camera.Parent = ViewportFrame

		model.Parent = ViewportFrame
		ViewportFrame.CurrentCamera = camera

		local vpfModel = ViewportModel.new(ViewportFrame, camera)
		local cf, size = model:GetBoundingBox()

		vpfModel:SetModel(model)

		local theta = 0
		local orientation = CFrame.new()
		local distance = vpfModel:GetFitDistance(cf.Position)

		--// Controls the UI

		ViewportFrame.Parent.Activated:Connect(function() --// Handles Error With Button Spamming
			if PlaceHolderTower == nil then
				PlaceTower(model)
			else
				return
			end
		end)

		game:GetService("RunService").RenderStepped:Connect(function(dt)
			theta = theta + math.rad(20 * dt)
			orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), theta, 0)
			camera.CFrame = CFrame.new(cf.Position) * orientation * CFrame.new(0, 0, distance)
		end)
	end
end

--// Setups Viewports with Enemies
for i,v in pairs(Toolbar:GetDescendants()) do
    if v:IsA("ViewportFrame") then
        SetupViewPorts(v)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if PlaceHolderTower then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if CanPlace then
				TowerEvent:FireServer(PlaceHolderTower.Name, PlaceHolderTower.PrimaryPart.CFrame)
				PlaceHolderTower:Destroy()
				PlaceHolderTower = nil
				Rotation = 0
			end
		elseif input.KeyCode == Enum.KeyCode.R then
			Rotation += 90
		end
	end
end)

RunService.RenderStepped:Connect(function(deltaTime)
	if PlaceHolderTower ~= nil then
		local result = MouseRaycast({PlaceHolderTower,Player.Character})
		if result and result.Instance then
			if result.Instance.Parent.Name == "TowerArea" then
				CanPlace = true
				ColorTower(Color3.new(0,1,0))
				else
					CanPlace = false
					ColorTower(Color3.new(1,0,0))
			end
			local Positions = 
			{
				x = result.Position.X,
				y = result.Position.Y + 3,
				z = result.Position.Z
			}

			local cframe = CFrame.new(Positions.x,Positions.y,Positions.z) * CFrame.Angles(0,math.rad(Rotation),0)
			PlaceHolderTower:SetPrimaryPartCFrame(cframe)
		end
	end
end)