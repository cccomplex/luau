--// Drag script for UIs
return function(Frame, Speed)
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local Dragging;
	local DragStart;
	local FrameStart;
	local DragInput;
	local DragSpeed = Speed
	
	local function Update(Input)
		local Delta = Input.Position - DragStart
		local NewPosition = UDim2.new(FrameStart.X.Scale, FrameStart.X.Offset + Delta.X, FrameStart.Y.Scale, FrameStart.Y.Offset + Delta.Y)
		
		TweenService:Create(Frame, TweenInfo.new(DragSpeed, Enum.EasingStyle["Quint"], Enum.EasingDirection["Out"]), {Position = NewPosition}):Play()
	end
	
	Frame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType["MouseButton1"] then
			Dragging = true
			DragStart = Input.Position
			FrameStart = Frame.Position
			
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState["End"] then
					Dragging = false
				end
			end)
		end
	end)
	
	Frame.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType["MouseMovement"] then
			DragInput = Input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			Update(Input)
		end
	end)
end
