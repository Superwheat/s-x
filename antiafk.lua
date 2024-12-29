local vu = cloneref(game:GetService("VirtualUser"))
local plr = game:GetService("Players").LocalPlayer

plr.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

queue_on_teleport([[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Superwheat/s-x/refs/heads/main/antiafk.lua"))()
]])
