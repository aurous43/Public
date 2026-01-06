local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function fixKnockback(character)
	local rootPart = character:WaitForChild("HumanoidRootPart", 10)
	if not rootPart then return end

	rootPart.ChildAdded:Connect(function(child)
		if child:IsA("BodyVelocity") then
			
			if not child.Parent then return end -- object might be gone (Debris)

			local currentVel = child.Velocity
			-- isolate horizontal velocity (X and Z only)
			local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z)
			local speed = horizontalVel.Magnitude

			-- check if it is 3rd dropdash stun, slight tolerance
			if speed > 89 and speed < 91 then
				
				local lookVector = rootPart.CFrame.LookVector
				local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
				
				-- verify that it's currently moving backwards
				if horizontalVel:Dot(flatLook) < 0 then
					-- apply force in the forward direction instead
					-- calculate new velocity
					child.Velocity = (flatLook * speed) + Vector3.new(0, currentVel.Y, 0)
				end
			end
		end
	end)
end

-- initialize for current character
if LocalPlayer.Character then
	task.spawn(function()
		fixKnockback(LocalPlayer.Character)
	end)
end

-- permanently initialize, remove it if you're gonna use it for a toggle or something
LocalPlayer.CharacterAdded:Connect(fixKnockback)
