--[[
	Displays the position of the cursor in the text being edited.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)

local Computed = Fusion.Computed
local Value = Fusion.Value
local New = Fusion.New

type CaretProperties = {
	Theme: Theme,
	CaretPlace: Fusion.Value<number>,
	CharSize: Vector2;
}

return function(props: CaretProperties): Frame
	local position = Computed(function()
		local caretPlace = props.CaretPlace:get()
		return UDim2.new(0, caretPlace.X * props.CharSize.X, 0, caretPlace.Y * props.CharSize.Y)
	end)

	return New "Frame" {
		BackgroundColor3 = Theme.Text(props.Theme),
		BorderSizePixel = 0,
		Position = position,
		Size = UDim2.new(0, 2, 0, props.CharSize.X),
		ZIndex = 100,
	}
end