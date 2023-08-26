--// Variables
local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerGui = Player:WaitForChild("PlayerGui")
Opened = false --// For the Inventory
local InventoryButtonToClone = game.ReplicatedStorage.Variables.InventoryButton
local RemoteEvent = game.ReplicatedStorage.Variables:FindFirstChild("MatchMakingEvent")
local Data = nil
local ViewportModel = require(game.ReplicatedStorage.Shared.Viewports)
local Inventory = PlayerGui:WaitForChild("Inventory")
local EquipID = " rbxassetid://14452535990"
local UnEquipID = "rbxassetid://14171553444"

--//

--// Tables
local EquippedTowers = {}
--//

--// Functions
local function SetupViewPort(ViewportFrame: Instance, TowerName: string, ChangeName: boolean)
	local model = game.ReplicatedStorage.Towers:FindFirstChild(TowerName):Clone()
	if ChangeName then
		ViewportFrame.Parent.Name = model.Name
	end

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
--//

--// Get the Data from the Server.
RemoteEvent.OnClientEvent:Connect(function(DataFromServer)
	Data = DataFromServer[1] -- Extract the sub-table from the main data
	-- Add the Players Owned Towers to the Inventory
	for _, TowerName in pairs(Data) do
		local NewTower = InventoryButtonToClone:Clone()
		NewTower.Parent = Inventory.ScrollingFrame
		NewTower.Name = TowerName
		SetupViewPort(NewTower.ViewportFrame, TowerName, true)
		local Equipped = Instance.new("BoolValue")
		Equipped.Name = "Equipped"
		Equipped.Value = false
		Equipped.Parent = NewTower

		NewTower.MouseButton1Click:Connect(function()
			local itemView = Inventory:WaitForChild("ItemView")
			SetupViewPort(itemView.Display, TowerName, false)
			itemView.TowerName.Text = TowerName
			itemView.Description.Text = TowerName

			Inventory.ItemView.UnEquip.MouseButton1Click:Connect(function()
				if Equipped.Value == false then
					table.insert(EquippedTowers, TowerName)
					Equipped.Value = true
					Inventory.ItemView.UnEquip.Image = UnEquipID -- Set the image to the "Unequip" image
				else
					local ValToRemove = table.find(EquippedTowers, TowerName)
					table.remove(EquippedTowers, ValToRemove)
					Equipped.Value = false
					Inventory.ItemView.UnEquip.Image = EquipID -- Set the image back to the "Equip" image
				end
			end)
		end)
	end
end)
--//

--// Handles the Opening and Closing of the Players Inventory
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	if input.KeyCode == Enum.KeyCode.Z then
		if Opened == false then
			Inventory.Enabled = true
			Opened = true
		else
			Inventory.Enabled = false
			Opened = false
		end
	end
end)
--//
