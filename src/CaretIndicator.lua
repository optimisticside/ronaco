--[[
	Displays a horizontal line in the scrollbar to represent the position of
	the caret in the text.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

type CaretIndicatorProperties = {
	CanvasSize: Fusion.Value<Vector2>,
	CaretPosition: Fusion.Value<Vector2>,
	CharSize: Vector2,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: CaretIndicatorProperties): Frame
	local position = Computed(function()
		local caretPlace = props.CaretPosition:get()
		local canvasSize = props.CanvasSize:get()

		local percent = (caretPlace.Y * props.CharSize.Y) / canvasSize.Y.Offset
		return UDim2.new(0, 0, percent, -1)
	end)

	return New "Frame" {
		BackgroundColor3 = Theme.Text(props.Theme),
		BackgroundTransparency = 1 - 179/255,
		BorderSizePixel = 0,
		Position = position,
		Size = UDim2.new(1, 0, 0, 2),
		ZIndex = 2,
	}
end