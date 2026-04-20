local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer

while true do
	local character = player.Character or player.CharacterAdded:Wait()
	local charType = character:GetAttribute("Character")

	if charType == "Silver" or charType == "Fleetway" then
		CollectionService:AddTag(character, "Kill")
		task.wait()
		CollectionService:RemoveTag(character, "Kill")
	end

	task.wait()
end
