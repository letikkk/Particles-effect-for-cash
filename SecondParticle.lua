local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Particle = {}
local Player = game.Players.LocalPlayer

type Properties = {
	Shape : Enum.PartType;
	Material : Enum.Material;
	Color : Color3;
	Size : Vector3;
	Speed : number;
}

function Particle.new(Start : vector, Property : Properties)
	local HumanoidRootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then return end
	
	for i = 1, math.random(10, 50) do
		local Part = Instance.new("Part")
		Part.Anchored = true
		Part.CanCollide = false
		Part.Shape = Property.Shape
		Part.Size = Property.Size
		Part.Color = Property.Color
		Part.Material = Property.Material
		Part.Position = Start + vector.create(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
		Part.Parent = workspace
		
		local MidPos = Part.Position + vector.create(math.random(-5, 5), math.random(-2, 10), math.random(-5, 5))
		
		local Tween = TweenService:Create(Part, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = MidPos})
		Tween:Play()
		
		Tween.Completed:Connect(function()
			local Speed = math.max(Property.Speed, 1)
			
			local Connection
			
			Connection = RunService.PreRender:Connect(function(dt)
				if not Part.Parent or not Player.Character or not HumanoidRootPart then
					Connection:Disconnect()
					return
				end
				
				local Goal = HumanoidRootPart.Position
				local Dir = (Goal - Part.Position).Unit
				local Distance = (Goal - Part.Position).Magnitude
				
				local MoreSpeed = Speed^2
				
				Part.Position = Part.Position + (Dir * dt * MoreSpeed)
				
				if Distance < 1 then
					Connection:Disconnect()

					local Position = Part.Position + vector.create(Part.Position.X, math.random(10,25), Part.Position.Z)
					local Tween = TweenService:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = Position, Transparency = 1})
					Tween:Play()
					
					Tween.Completed:Connect(function()
						Part:Destroy()
					end)	
				end
			end)
			
		end)
		
	end
end

return Particle
