--// Dependencies for the Client

local Player = game.Players.LocalPlayer
local Char = Player.Character

PlayerGui = Player:WaitForChild("PlayerGui")
local Toolbar = PlayerGui:WaitForChild("Toolbar")


WaveText = PlayerGui:WaitForChild("Toolbar").Stroke

local RPS = game.ReplicatedStorage
local Variables = RPS.Variables
local TowerEvent = Variables.TowerEvent
local Enemies = RPS.Enemies
local Towers = RPS.Towers
local ViewportModel = require(RPS.Shared.Viewports)
--//
--// Handles Tower Viewports
local function SetupViewPorts(ViewportFrame)
	for index, model in pairs(Towers:GetChildren()) do
		model = model:Clone()

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

		game:GetService("RunService").RenderStepped:Connect(function(dt)
			theta = theta + math.rad(20 * dt)
			orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), theta, 0)
			camera.CFrame = CFrame.new(cf.Position) * orientation * CFrame.new(0, 0, distance)
		end)
	end
end

for i,v in pairs(Toolbar:GetDescendants()) do
    if v:IsA("ViewportFrame") then
        SetupViewPorts(v)
    end
end

