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

--// Functions for the Client
Variables.WaveNumber:GetPropertyChangedSignal("Value"):Connect(function()
	WaveText.Text = Variables.WaveNumber.Value
end)
